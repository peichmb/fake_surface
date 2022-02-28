program mainf

  use liblsm_f, only :  init_world, destroy_world, &
                        get_gridcell_albedo, &
                        set_gridcell_albedo, get_fluxes

  implicit none

  integer :: size_world = 5
  double precision, dimension(5) :: sw_down = (/ 400.d0, 500.d0, 100.d0, 600.d0, 700.d0 /)
  double precision, dimension(5) :: sw_up = (/ 0.d0, 0.d0, 0.d0, 0.d0, 0.d0 /)
  double precision, dimension(5) :: senh_up = (/ 0.d0, 0.d0, 0.d0, 0.d0, 0.d0 /)
  double precision, dimension(5) :: lath_up = (/ 0.d0, 0.d0, 0.d0, 0.d0, 0.d0 /)
  integer :: i

  call init_world(size_world)

  !call set_gridcell_albedo_int(world, 2, 0.2d0)
  !print *, get_gridcell_albedo_int(world, 2)
  call set_gridcell_albedo(2, 0.2d0)
  print *, get_gridcell_albedo(2)

  do i=0, size_world-1
    call get_fluxes(i, sw_down(i+1), sw_up(i+1), senh_up(i+1), lath_up(i+1))
  end do

  do i=0, size_world-1
    print *, "Gridcell #", i
    print *, "----------"
    print *, "albedo = ", get_gridcell_albedo(i)
    print *, "sw_down = ", sw_down(i+1)
    print *, "sw_up = ", sw_up(i+1)
    print *, "senh_up = ", senh_up(i+1)
    print *, "lath_up = ", lath_up(i+1)
    print *
  end do

  !call destroy_world()

end program mainf
