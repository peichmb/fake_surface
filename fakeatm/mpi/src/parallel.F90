module parallel

  use parameters 

  implicit none

  include "mpif.h"

  integer :: mpi_errcode, mpi_nproc, mpi_rank

contains

  subroutine init_parallel()

    ! Initialize MPI
    call MPI_Init(mpi_errcode);
    call MPI_Comm_size(MPI_COMM_WORLD, mpi_nproc, mpi_errcode)
    call MPI_Comm_rank(MPI_COMM_WORLD, mpi_rank, mpi_errcode)

    if (NDOM_LAT*NDOM_LON /= mpi_nproc) then
      call MPI_Finalize(mpi_errcode);
      if (mpi_rank==0) then
        stop "Number of domains must match number of processors"
      else
        stop 
      end if
    end if

  end subroutine init_parallel

  subroutine finalize_parallel()

    ! Finalize MPI
    call MPI_Finalize(mpi_errcode);

  end subroutine finalize_parallel

end module parallel
