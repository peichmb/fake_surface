module liblsm_f

  use, intrinsic :: iso_c_binding, only : c_int, c_ptr, c_null_ptr, c_associated, c_double
  implicit none

  private

  interface

    function init_world_int(n) result(world) bind(C, name="init_world")

      import :: c_int, c_ptr
      implicit none

      integer(c_int), intent(in), value :: n
      type(c_ptr) :: world

    end function init_world_int

    subroutine destroy_world_int(world) bind(C, name="destroy_world")
      
      import :: c_ptr
      implicit none

      type(c_ptr), value :: world

    end subroutine destroy_world_int

    subroutine get_fluxes_int(world, i, sw_down, sw_up, senh_up, lath_up) bind(C, name="get_fluxes")

       import :: c_int, c_double, c_ptr
       implicit none

       type(c_ptr), intent(in), value :: world
       integer(c_int), intent(in), value :: i
       real(c_double), intent(in), value :: sw_down
       real(c_double), intent(out) :: sw_up
       real(c_double), intent(out) :: senh_up
       real(c_double), intent(out) :: lath_up

    end subroutine get_fluxes_int

    function get_gridcell_albedo_int(world, i) result(albedo) bind(C, name="get_gridcell_albedo")

       import :: c_int, c_double, c_ptr
       implicit none

       type(c_ptr), intent(in), value :: world
       integer(c_int), intent(in), value :: i
       real(c_double) :: albedo

    end function get_gridcell_albedo_int

    subroutine set_gridcell_albedo_int(world, i, albedo) bind(C, name="set_gridcell_albedo")

       import :: c_int, c_double, c_ptr
       implicit none

       type(c_ptr), intent(in), value :: world
       integer(c_int), intent(in), value :: i
       real(c_double), intent(in), value :: albedo

    end subroutine set_gridcell_albedo_int

  end interface

  type(c_ptr) :: world

  public :: init_world
  public :: destroy_world
  public :: get_fluxes
  public :: get_gridcell_albedo
  public :: set_gridcell_albedo

contains

  subroutine init_world(n)

    implicit none
    integer :: n

    world = init_world_int(n)

  end subroutine init_world

  subroutine destroy_world()
    
    implicit none
    call destroy_world_int(world)

  end subroutine destroy_world

  subroutine get_fluxes(i, sw_down, sw_up, senh_up, lath_up)

    implicit none
    integer :: i
    double precision :: sw_down, sw_up, senh_up, lath_up

    call get_fluxes_int(world, i, sw_down, sw_up, senh_up, lath_up)

  end subroutine get_fluxes

  function get_gridcell_albedo(i) result(albedo)
    
    implicit none
    integer :: i
    double precision :: albedo

    albedo = get_gridcell_albedo_int(world, i)

  end function get_gridcell_albedo

  subroutine set_gridcell_albedo(i, albedo)

    implicit none
    integer :: i
    double precision :: albedo

    call set_gridcell_albedo_int(world, i, albedo)

  end subroutine set_gridcell_albedo

end module liblsm_f
