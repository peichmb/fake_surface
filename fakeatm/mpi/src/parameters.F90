module parameters

  implicit none

  ! Parameters
  ! ----------
  ! Domain
  integer, parameter :: NLAT=4, NLON=5 ! Number of latitude/longitude points in the global domain
  integer, parameter :: NDOM_LAT=2, NDOM_LON=3 ! Number of domains in the lat/lon directions
  double precision, parameter :: LAT0=-7.75d0, LON0=-55.625d0 ! Lowest latitude/longitude
  double precision, parameter :: DLON=1.875d0, DLAT=2.0d0 ! Latitude/longitude increment
  integer, parameter :: NDAYS=5, NTSTEPS_DAY=24; ! Number of days and periods per day
  ! Timing
  integer, parameter :: TSTEPS=NDAYS*NTSTEPS_DAY ! Number of time steps
  integer, parameter :: TSTEPS_WRITE = 1 !24 ! Write output record every TSTEPS_WRITE time steps
  ! Climate data
  integer, parameter :: LEN_FNAME=100
  character(100) :: CLIMATE_DATA_PATH = "../../test_data/" ! Finish with /
  character(100) :: OUTPUT_DATA_PATH = "./output/" ! Finish with /

contains

  subroutine init_parameters()

    implicit none

  end subroutine init_parameters

end module parameters
