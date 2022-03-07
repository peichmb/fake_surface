module parameters

  implicit none

  ! Domain
  integer :: NLAT, NLON
  double precision :: LAT0, LON0
  double precision :: DLAT, DLON
  integer :: is, ie, js, je
  integer :: NDAYS, NTSTEPS_DAY
  ! Timing
  integer :: TSTEPS
  ! Climate data
  integer, parameter :: LEN_FNAME=1000
  character(LEN_FNAME) :: CLIMATE_DATA_PATH

contains

  subroutine init_parameters()

    implicit none

    character(1000) :: buffer
    character(1000) :: fname
    call getarg(1, buffer)
    read(buffer, *) fname

    open(10, file=trim(fname))
    read(10,*) NLAT
    read(10,*) NLON
    read(10,*) LAT0
    read(10,*) LON0
    read(10,*) DLAT
    read(10,*) DLON
    read(10,*) NDAYS
    read(10,*) NTSTEPS_DAY
    read(10,*) CLIMATE_DATA_PATH
    close(10)

    is=0
    ie=NLAT-1
    js=0
    je=NLON-1
    TSTEPS=NDAYS*NTSTEPS_DAY

    CLIMATE_DATA_PATH = trim(CLIMATE_DATA_PATH) // "/"

  end subroutine init_parameters

end module parameters
