module variables

  implicit none

  ! Parameters
  ! ----------
  ! Domain
  integer, parameter :: NLAT=4, NLON=5
  double precision, parameter :: LAT0=-7.75d0, LON0=-55.625d0
  double precision, parameter :: DLON=1.875d0, DLAT=2.0d0
  integer, parameter :: is=0, ie=NLAT-1, js=0, je=NLON-1
  integer, parameter :: NDAYS=5, NTSTEPS_DAY=24;
  ! Timing
  integer, parameter :: TSTEPS=NDAYS*NTSTEPS_DAY
  ! Climate data
  integer, parameter :: LEN_FNAME=100
  character(100) :: CLIMATE_DATA_PATH = "../../test_data/" ! Finish with /
  double precision :: z_level = 10.d0

  ! Variables
  ! ---------
  integer :: timestep
  double precision, dimension(is:ie, js:je) :: &
      lat, lon, &                                               ! Domain
      swdown, lwdown, prec, tair, wind_speed, qair, psurf, &    ! Forcings
      swup, lwup, shup, lhup                                    ! Output

contains

  subroutine init_variables()

    implicit none

    integer :: i, j, ij

    timestep = 0

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
