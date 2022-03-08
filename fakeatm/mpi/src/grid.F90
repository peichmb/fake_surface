module grid

  use parameters
  use parallel

  implicit none

  integer :: is, ie, js, je ! Local matrix ranges
  integer :: i_domain, j_domain, nlat_local, nlon_local
  double precision, dimension(:,:), allocatable :: lat, lon

  ! MPI-I/O stuff
  integer, parameter :: size_of_int = 4, size_of_double = 8
  integer :: local_in_global
  integer(kind=MPI_OFFSET_KIND) :: write_offset = 0

  ! The following is used to print a global variable from processor 0 to the standard output
  integer, dimension(:), allocatable :: subarray_type
  integer, dimension(:), allocatable :: istarts, jstarts

contains

  subroutine init_grid()

    integer :: i, j, irank
    double precision :: lat0_local, lon0_local
    integer, dimension(NDOM_LAT, NDOM_LON) :: npoints_lat, npoints_lon

    ! Number of points of each domain in latitude and longitude directions
    do j=1,NDOM_LON
      do i=1,NDOM_LAT
        npoints_lat(i,j) = get_npoints(NLAT, NDOM_LAT, i)
        npoints_lon(i,j) = get_npoints(NLON, NDOM_LON, j)
      end do
    end do

    ! Coordinates of local domain in domain space
    call mpirank_to_ijdomain(mpi_rank, i_domain, j_domain)

    ! Local domain index limits
    is = 1
    ie = npoints_lat(i_domain, j_domain)
    js = 1
    je = npoints_lon(i_domain, j_domain)

    nlat_local = npoints_lat(i_domain, j_domain)
    nlon_local = npoints_lon(i_domain, j_domain)

    ! Allocate grid matrices
    allocate(lat(is:ie, js:je))
    allocate(lon(is:ie, js:je))

    lat0_local = LAT0 + sum(npoints_lat(1:i_domain-1,1))*DLAT
    lon0_local = LON0 + sum(npoints_lon(1,1:j_domain-1))*DLON

    do i=is,ie
      lat(i,:) = lat0_local + (i-1)*DLAT
    end do
    do j=js,je
      lon(:,j) = lon0_local + (j-1)*DLON
    end do

    ! Starting position for each of the subarrays in the global array
    allocate(istarts(0:mpi_nproc-1))
    allocate(jstarts(0:mpi_nproc-1))
    do irank=0, mpi_nproc-1
      call mpirank_to_ijdomain(irank, i, j)
      istarts(irank) = sum(npoints_lat(1:i-1,1)) + 1
      jstarts(irank) = sum(npoints_lon(1,1:j-1)) + 1
    end do

    call MPI_Type_create_subarray(2,                                &
                      [NLAT,NLON],                                  &
                      [nlat_local, nlon_local],                     &
                      [istarts(mpi_rank)-1, jstarts(mpi_rank)-1],   & ! Offsets, not positions
                      MPI_ORDER_FORTRAN,                            &
                      MPI_DOUBLE_PRECISION,                         &
                      local_in_global,                              &
                      mpi_errcode)
    call MPI_Type_commit(local_in_global, mpi_errcode)

    ! The following is to gather a distributed variable in processor 0 to output it to the console
    ! (see print_var subroutine in module variables). It is not best practice to gather global info
    ! in a processor for outut purposes, but I don' care too much in this example. References:
    ! https://stackoverflow.com/questions/17508647/sending-2d-arrays-in-fortran-with-mpi-gather
    ! https://www.mpich.org/static/docs/latest/www3/MPI_Type_create_subarray.html
    ! https://stackoverflow.com/questions/5585630/mpi-type-create-subarray-and-mpi-gather
    ! Since local grids have potentially different sizes, I create a new type for each array
    ! I only need to create these types in processor 0, since the types the other processors send
    ! are normal matrices.
    if (mpi_rank == 0) then
      ! Create one type for each process, because they might be different
      allocate(subarray_type(1:mpi_nproc-1))
      do irank=1,mpi_nproc-1
        call mpirank_to_ijdomain(irank, i, j)
        call MPI_Type_create_subarray(2, &
                          [NLAT,NLON], &
                          [npoints_lat(i, j), npoints_lon(i, j)], &
                          [0, 0], &
                          MPI_ORDER_FORTRAN, &
                          MPI_DOUBLE_PRECISION, &
                          subarray_type(irank), &
                          mpi_errcode)
        call MPI_Type_commit(subarray_type(irank), mpi_errcode)
      end do
      ! Starting position for each of the subarrays in the global array
    end if

  end subroutine init_grid

  subroutine mpirank_to_ijdomain(rank, i, j)

    integer :: rank, i, j

    i = rank/NDOM_LON + 1
    j = mod(rank, NDOM_LON) + 1

  end subroutine mpirank_to_ijdomain

  function get_npoints(npoints, nchunks, ichunk) result(npoints_chunk)

    integer :: npoints, nchunks, ichunk, npoints_chunk, npoints_left

    npoints_chunk = npoints/nchunks
    npoints_left = mod(npoints,nchunks)
    if ( npoints_left > 0 .and. ichunk <= npoints_left) then
      npoints_chunk = npoints_chunk + 1
    end if
    
  end function get_npoints

  subroutine print_var(var)

    integer :: irank, dummy_tag=111
    integer, dimension(MPI_STATUS_SIZE) :: mpi_status
    double precision, dimension(nlat_local,nlon_local) :: var
    double precision, dimension(NLAT,NLON) :: var_g
    integer :: i

    var_g = 1.d0

    if (mpi_rank == 0) then
      var_g(1:nlat_local, 1:nlon_local) = var 
      do irank=1,mpi_nproc-1
         call MPI_Recv(var_g(istarts(irank), jstarts(irank)), &
                       1, &
                       subarray_type(irank), &
                       irank, &
                       MPI_ANY_TAG, &
                       MPI_COMM_WORLD, &
                       MPI_STATUS_IGNORE, & ! MPI_STATUS_IGNORE or a status array (the option below)
                       !mpi_status, & ! If I use this option make sure the type is right!!
                                      ! integer, dimension(MPI_STATUS_SIZE) :: status
                                      ! Otherwise -> Undefined behaviour!
                       mpi_errcode)
      end do
    else
      call MPI_Send(var, &
                    nlat_local*nlon_local, &
                    MPI_DOUBLE_PRECISION, &
                    0, &
                    dummy_tag, &
                    MPI_COMM_WORLD, &
                    mpi_errcode)
    end if

    if (mpi_rank == 0) then
      do i=1,NLAT
        print *, var_g(i,:)
      end do
      print *
    end if
  
  end subroutine print_var

  subroutine write_var(fname, var)

    character(100) :: fname
    integer :: mpi_file_handle
    double precision, dimension(nlat_local,nlon_local) :: var

    call MPI_File_open(MPI_COMM_WORLD,                      &
                       trim(fname),                         &
                       MPI_MODE_CREATE + MPI_MODE_WRONLY,   &
                       MPI_INFO_NULL,                       &
                       mpi_file_handle,                     &
                       mpi_errcode)

    call MPI_File_set_view(mpi_file_handle,       &
                           write_offset,          &
                           MPI_DOUBLE_PRECISION,  &
                           local_in_global,       &
                           "native",              &
                           MPI_INFO_NULL,         &
                           mpi_errcode)

    call MPI_File_write_all(mpi_file_handle,          &
                            var,                      &
                            nlat_local*nlon_local,    &
                            MPI_DOUBLE_PRECISION,     &
                            MPI_STATUS_IGNORE,        &
                            mpi_errcode)

    call MPI_File_close(mpi_file_handle, mpi_errcode)

  end subroutine write_var

  subroutine finalize_grid()

    integer :: irank

    if (mpi_rank == 0) then
      do irank=1, mpi_nproc-1
        call MPI_Type_free(subarray_type(irank), mpi_errcode) ! Free commited types
      end do
    end if

    call MPI_Type_free(local_in_global, mpi_errcode) ! Free commited types

  end subroutine finalize_grid

  subroutine fail(message)

    character(len=*) :: message
    call finalize_grid()
    call finalize_parallel()
    if (mpi_rank==0) then
      stop trim(message)
    else
      stop 
    end if

  end subroutine fail

end module grid
