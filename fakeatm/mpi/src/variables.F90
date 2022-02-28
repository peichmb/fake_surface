module variables

  use parameters
  use grid

  implicit none

  ! Variables
  ! ---------
  integer :: timestep
  double precision, dimension(:, :), allocatable :: &
      swdown, lwdown, prec, tair, wind_speed, qair, psurf, &    ! Forcings
      swup, lwup, shup, lhup                                    ! Output

contains

  subroutine init_variables()

    implicit none

    integer :: i, j, ij

    timestep = 0
    allocate(swdown(is:ie,js:je))
    allocate(lwdown(is:ie,js:je))
    allocate(prec(is:ie,js:je))
    allocate(tair(is:ie,js:je))
    allocate(wind_speed(is:ie,js:je))
    allocate(qair(is:ie,js:je))
    allocate(psurf(is:ie,js:je))
    allocate(swup(is:ie,js:je))
    allocate(lwup(is:ie,js:je))
    allocate(shup(is:ie,js:je))
    allocate(lhup(is:ie,js:je))

  end subroutine init_variables

  subroutine write_output()

    implicit none

    character(100) :: fname

    if (mod(timestep,TSTEPS_WRITE) /= 0) then
      return
    end if

    fname = trim(OUTPUT_DATA_PATH) // "swup.out"
    call write_var(fname, swup)

    fname = trim(OUTPUT_DATA_PATH) // "lwup.out"
    call write_var(fname, lwup)

    fname = trim(OUTPUT_DATA_PATH) // "shup.out"
    call write_var(fname, shup)

    fname = trim(OUTPUT_DATA_PATH) // "lhup.out"
    call write_var(fname, lhup)

    ! Update offset
    write_offset = write_offset + NLAT*NLON*size_of_double

  end subroutine write_output

end module variables
