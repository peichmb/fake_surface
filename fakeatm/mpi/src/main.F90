program fakeatm

  use parameters
  use parallel, only : init_parallel, finalize_parallel, check_domain, mpi_rank
  use grid, only : init_grid, finalize_grid, print_var
  use variables
  use atmosphere, only : init_atmosphere, ts_atmosphere
  use surface, only : init_surface, ts_surface

  implicit none

  ! INITIALIZATION
  call initialize_all()

  ! MAIN LOOP
  call main_loop()

  ! NORMAL EXIT
  call finalize_all()

contains

  subroutine initialize_all()

    call init_parallel()
    call init_parameters(mpi_rank)
    call check_domain()
    call init_grid()
    call init_variables()
    call init_atmosphere()
    call init_surface()

  end subroutine initialize_all

  subroutine main_loop()

    do timestep=1,TSTEPS
      call ts_atmosphere()
      call ts_surface()
      call print_to_screen()
      call write_output()
    end do

  end subroutine main_loop

  subroutine finalize_all()

    call finalize_grid()
    call finalize_parallel()

  end subroutine finalize_all

  subroutine print_to_screen()

    if (SCREEN_OUTPUT .and. mod(timestep,TSTEPS_WRITE) == 0) then
      call print_var(swup)
    end if

  end subroutine print_to_screen

end program fakeatm
