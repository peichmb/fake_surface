module variables

  use parameters

  implicit none

  integer :: timestep
  double precision, dimension(:,:), allocatable :: &
      lat, lon, &                                               ! Domain
      swdown, lwdown, prec, tair, wind_speed, qair, psurf, &    ! Forcings
      swup, lwup, shup, lhup                                    ! Output

contains

  subroutine init_variables()

    implicit none

    integer :: i, j, ij

    timestep = 0

    allocate(lat(is:ie, js:je))
    allocate(lon(is:ie, js:je))
    allocate(swdown(is:ie, js:je))
    allocate(lwdown(is:ie, js:je))
    allocate(prec(is:ie, js:je))
    allocate(tair(is:ie, js:je))
    allocate(wind_speed(is:ie, js:je))
    allocate(qair(is:ie, js:je))
    allocate(psurf(is:ie, js:je))
    allocate(swup(is:ie, js:je))
    allocate(lwup(is:ie, js:je))
    allocate(shup(is:ie, js:je))
    allocate(lhup(is:ie, js:je))

    do j=js, je
        lon(:,j) = LON0 + DLON*j
    end do

    do i=is, ie
        lat(i,:) = LAT0 + DLAT*i
    end do

  end subroutine init_variables

  function get_ij(i, j) result(ij)

    implicit none

    integer :: i, j, ij

    ij = i*NLON + j

  end function get_ij

  subroutine print_var(var)

    implicit none

    integer :: i
    double precision, dimension(is:ie,js:je) :: var
    
    do i=is, ie
      print *, var(i,:)
    end do
    print*
  
  end subroutine

end module variables
