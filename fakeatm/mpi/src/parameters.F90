module parameters

  implicit none

  ! Parameters
  ! ----------
  ! Domain
  integer :: NLAT, NLON ! Number of latitude/longitude points in the global domain
  integer :: NDOM_LAT, NDOM_LON ! Number of domains in the lat/lon directions
  double precision :: LAT0, LON0 ! Lowest latitude/longitude
  double precision :: DLON, DLAT ! Latitude/longitude increment
  integer :: NDAYS, NTSTEPS_DAY ! Number of days and periods per day
  ! Timing
  integer :: TSTEPS ! Number of time steps
  ! I/O
  logical :: SCREEN_OUTPUT ! Whether to print output to screen
  integer :: TSTEPS_WRITE ! Write output record every TSTEPS_WRITE time steps
  integer, parameter :: LEN_FNAME=1000
  character(LEN_FNAME) :: CLIMATE_DATA_PATH
  character(LEN_FNAME) :: OUTPUT_DATA_PATH

contains

  subroutine init_parameters(mpi_rank)

    implicit none

    character(1000) :: buffer
    character(1000) :: fname
    integer :: mpi_rank, mpi_errcode

    call getarg(1, buffer)

    ! Check that the user specified a parameters file name
    if (len(trim(buffer)) == 0) then
      call MPI_Finalize(mpi_errcode);
      if (mpi_rank==0) then
        stop "Usage: mpirun -n [NPROC] [parameters_file_name]"
      else
        stop 
      end if
    end if

    read(buffer,*) fname

    open(10, file=trim(fname))
    READ(10,*) NLAT
    READ(10,*) NLON
    READ(10,*) NDOM_LAT
    READ(10,*) NDOM_LON
    READ(10,*) LAT0
    READ(10,*) LON0
    READ(10,*) DLAT
    READ(10,*) DLON
    READ(10,*) NDAYS
    READ(10,*) NTSTEPS_DAY
    READ(10,*) TSTEPS_WRITE
    READ(10,*) CLIMATE_DATA_PATH
    READ(10,*) OUTPUT_DATA_PATH
    READ(10,*) SCREEN_OUTPUT
    close(10)

    CLIMATE_DATA_PATH = trim(CLIMATE_DATA_PATH) // "/"
    OUTPUT_DATA_PATH = trim(OUTPUT_DATA_PATH) // "/"

    TSTEPS = NTSTEPS_DAY*NDAYS

  end subroutine init_parameters

end module parameters
