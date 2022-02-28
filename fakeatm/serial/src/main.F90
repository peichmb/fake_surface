program fakewrf

  use variables
  use atmosphere, only : init_atmosphere, ts_atmosphere
  use surface, only : init_surface, ts_surface, albedo

  implicit none

  ! INITIALIZATION
  call init_variables()
  call init_atmosphere()
  call init_surface()

  ! MAIN LOOP
  do timestep=1,TSTEPS
    call ts_atmosphere()
    call ts_surface()
    call print_var(swup)
  end do

end program fakewrf
