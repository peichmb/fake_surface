program dump

  implicit none

  integer, parameter :: NLAT = 4, NLON = 5
  integer, parameter :: size_of_double = 8
  integer, parameter :: NRECORDS = 24*5
  character(100) :: fname = "../output/swup.out"
  integer :: record

  double precision, dimension(NLAT, NLON) :: data_record

  do record=1,NRECORDS
    call read_record(fname, record, data_record)
    call print_record(data_record)
  end do

contains

  subroutine read_record(fname, record, data_record)
    
    integer :: record
    character(100) :: fname
    double precision, dimension(NLAT, NLON) :: data_record

    open(unit=10,               &
         file=trim(fname),      &
         access='direct',       &
         action='read',         &
         form='unformatted',    &
         recl=NLAT*NLON*size_of_double)
    read(10,rec=record) data_record
    close(10)

  end subroutine read_record

  subroutine print_record(data_record)

    integer :: i
    double precision, dimension(NLAT, NLON) :: data_record

    do i=1,NLAT
      print *, data_record(i,:)
    end do
    print *

  end subroutine print_record

end program dump
