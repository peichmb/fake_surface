module surface

  use variables
  use liblsm_f

  implicit none

  integer :: size_world
  double precision, dimension(is:ie,js:je) :: albedo

contains

  subroutine init_surface()

    integer :: i, j, ij
    size_world = NLAT*NLON
    call init_world(size_world)
    do i = is,ie
      do j = js,je
        ij = get_ij(i,j)
        call set_gridcell_albedo(ij, 0.5d0)
        albedo(i,j) = get_gridcell_albedo(ij)
      end do
    end do

  end subroutine init_surface

  subroutine ts_surface()

    integer :: i, j, ij

    do i = is,ie
      do j = js,je
        ij = get_ij(i,j)
        call get_fluxes(ij, swdown(i,j), swup(i,j), shup(i,j), lhup(i,j))
      end do
    end do

  end subroutine ts_surface

end module surface
