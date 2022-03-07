/* ************ *
 * fake_surface *
 * ************ */

A dummy model of land-surface interactions.

fakelsm: A dummy land surface model
fakeatm: A dummy atmospheric model

The atmosphere "model" reads climate data from files and feeds it to the land surface model.
The land surface "model" uses this information calculate very wrong fluxes of radiation, sensible and latent heat into the atmosphere.
The aim is to experiment with MPI and C++/Fortran interoperability.

Test data generated from the MERRA2 reanalysis (https://gmao.gsfc.nasa.gov/reanalysis/MERRA-2/) is available at https://zenodo.org/record/6308776

Instructions:
-------------

0. PREREQUISITES
  - A working installation of MPI: https://www.mpich.org/
  - A working installation of NetCDF: https://www.unidata.ucar.edu/software/netcdf/
  - The python example (fakeatm/mpi/extras/read_output.py) requires numpy: https://numpy.org

1. Clone this repository to a directory on your computer.

2. Download the test data and save it to a test_data directory on the same level as the fakeatm and fakelsm directories.

3. Build the lsm library:

cd fakelsm
make lib
cd ..

    OR

cd fakelsm
make
cd ..

The first alternative builds the LSM library. The second one builds the library + some sample programs in C, C++ and Fortran.

4. Then build the fake atmosphere:

cd fakeatm/serial
make
cd ../mpi
make

5. Now run the test comparison between the serial and parallel versions:

make compare

The output files produced by the serial and parallel programs should be identical when running both programs with the provided parameter.in files. Examining these should give you an idea of how to use the code.

The MPI version of fakeatm stores output in binary files. Sample programs handling the output can be found in the fakeatm/mpi/extras directory.
