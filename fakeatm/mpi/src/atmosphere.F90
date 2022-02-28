module atmosphere
  
  use grid
  use variables
  use netcdf

  implicit none

  double precision :: z_level = 10.d0
  character(len=LEN_FNAME), dimension(:,:), allocatable :: climate_fnames

contains

  subroutine check(status)
    integer, intent (in) :: status
    if(status /= nf90_noerr) then 
      print *, trim(nf90_strerror(status))
      stop 2
    end if
  end subroutine check  

  function get_nc_fname(lat, lon) result(fname)

    implicit none

    double precision :: lat, lon
    character(LEN_FNAME) :: fname
    character(1) :: dirlat, dirlon
    character(3) :: intlat, intlon, declat, declon

    if (lat >= 0.d0) then
      dirlat = "N"
    else
      dirlat = "S"
    end if

    if (lon >= 0.d0) then
      dirlon = "E"
    else
      dirlon = "W"
    end if

    write(intlat, '(i0.3)') int(abs(lat))
    write(intlon, '(i0.3)') int(abs(lon))
    write(declat, '(i0.3)') int((abs(lat) - int(abs(lat)))*1000)
    write(declon, '(i0.3)') int((abs(lon) - int(abs(lon)))*1000)

    fname = intlon // declon // dirlon // "_" // intlat // declat // dirlat // ".nc"

  end function get_nc_fname

  subroutine init_atmosphere()

    implicit none

    integer :: i, j

    allocate(climate_fnames(is:ie,js:je))

    do j=js, je
      do i=is, ie
        climate_fnames(i,j) = get_nc_fname(lat(i,j), lon(i,j))
      end do
    end do

  end subroutine init_atmosphere

  subroutine ts_atmosphere()

    implicit none

    integer :: ncid, varid, i, j
    integer, dimension(2) :: start, cnt
    real, dimension(11) :: forcings
    character(LEN_FNAME) :: fname
    
    start = (/ 1, timestep /)
    cnt = (/ 11, 1 /)

    ! Format of climate files: NetCDF4. Each row contains:
    !   SWDOWN PARDIR PARDIF LWDOWN PRECLS PRECCO TAIR UAIR VAIR QAIR PSURF,
    ! where
    !   SWDOWN  -> [W/m2]    Incoming shortwave radiation at the surface
    !   PARDIR  -> [W/m2]    Direct beam photosynthetically active radiation [*]
    !   PARDIF  -> [W/m2]    Diffuse photosynthetically active radiation [*]
    !   LWDOWN  -> [W/m2]    Incoming longwave radiation
    !   PRECLS  -> [kg/m2/s] Large scale precipitation
    !   PRECCO  -> [kg/m2/s] Convective precipitation
    !   TAIR    -> [K]       Air temperature
    !   UAIR    -> [m/s]     Eastward wind speed
    !   VAIR    -> [m/s]     Northward wind speed
    !   QAIR    -> [kg/kg]   Air specific humidity
    !   PSURF   -> [Pa]      Surface pressure

    do j=js, je
      do i=is, ie
        fname = trim(CLIMATE_DATA_PATH) // trim(climate_fnames(i,j))
        call check( nf90_open(trim(fname), nf90_nowrite, ncid) )
        call check( nf90_inq_varid(ncid, "forcing_data", varid) )
        call check( nf90_get_var(ncid, varid, forcings, start, cnt) )
        call check( nf90_close(ncid) )
        swdown(i,j) = forcings(1)
        lwdown(i,j) = forcings(4)
        prec(i,j) = forcings(5) + forcings(6)
        tair(i,j) = forcings(7) - 273.15
        wind_speed(i,j) = sqrt(forcings(8)**2 + forcings(9)**2)
        qair(i,j) = forcings(10)
        psurf(i,j) = forcings(11)
      end do
    end do

  end subroutine ts_atmosphere

end module atmosphere

