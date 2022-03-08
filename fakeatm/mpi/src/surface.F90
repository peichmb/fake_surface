module surface

  use parameters
  use grid
  use variables
  use liblsm_f

  implicit none

  integer :: size_world
  double precision, dimension(:,:), allocatable :: albedo

contains

  subroutine init_surface()

    select case (LAND_SURFACE_MODEL)

    case ("fakelsm")
      call init_fakelsm()

    !! INSERT CASE + CALL TO LSM INIT SUBROUTINE HERE

    case default
        call fail("Land surface model not found")

    end select

  end subroutine init_surface

  subroutine ts_surface()

    select case (LAND_SURFACE_MODEL)

    case ("fakelsm")
      call ts_fakelsm()

    !! INSERT CASE + CALL TO LSM TIMESTEP SUBROUTINE HERE

    case default
        call fail("Land surface model not found")

    end select

  end subroutine ts_surface

  function get_gridcell_index(i, j) result(ij)
    integer :: i, j, ij
    ij = (i-1)*nlon_local + j - 1
  end function get_gridcell_index


  !!!!!!!!!!!!!!!!!!!!!!
  !! INIT SUBROUTINES !!
  !!!!!!!!!!!!!!!!!!!!!!

  subroutine init_fakelsm()

    integer :: i, j, gc_index

    size_world = nlat_local*nlon_local
    call init_world(size_world)

    allocate(albedo(is:ie,js:je))
    do j = js,je
      do i = is,ie
        gc_index = get_gridcell_index(i,j)
        call set_gridcell_albedo(gc_index, 0.5d0)
        albedo(i,j) = get_gridcell_albedo(gc_index)
      end do
    end do

  end subroutine init_fakelsm

  
  !!!!!!!!!!!!!!!!!!!!!!!!!!
  !! TIMESTEP SUBROUTINES !!
  !!!!!!!!!!!!!!!!!!!!!!!!!!

  subroutine ts_fakelsm()

    ! The surface model (here fakelsm) takes climate data and returns:
    !   swup -> [W/m2] Upwards shortwave radiation
    !   shup -> [W/m2] Upwards sensible heat
    !   lhup -> [W/m2] Upwards latent heat
    integer :: i, j, ij

    do j = js,je
      do i = is,ie
        ij = get_gridcell_index(i,j)
        call get_fluxes(ij, swdown(i,j), swup(i,j), shup(i,j), lhup(i,j))
      end do
    end do

  end subroutine ts_fakelsm


end module surface
