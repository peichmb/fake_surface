program fakeatm

  use parallel, only : init_parallel, finalize_parallel
  use grid, only : init_grid, finalize_grid, print_var
  use variables
  use atmosphere, only : init_atmosphere, ts_atmosphere
  use surface, only : init_surface, ts_surface

  implicit none

  ! INITIALIZATION
  call init_parallel()
  call init_grid()
  call init_variables()
  call init_atmosphere()
  call init_surface()

  ! MAIN LOOP
  do timestep=1,TSTEPS
    call ts_atmosphere()
    call ts_surface()
    call print_var(swup)
    call write_output()
  end do

  call finalize_grid()
  call finalize_parallel()

end program fakeatm
