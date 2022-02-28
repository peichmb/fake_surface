FC := gfortran
LOCAL_INCLUDE := /home/belda-d/local/include
LOCAL_LIB := /home/belda-d/local/lib
LSM_INCLUDE := ../../fakelsm/lsm/include
LSM_LIB := ../../fakelsm/lsm/lib
SRC := src
BLD := bld
OUTPUT := output
SOURCES := $(SRC)/parameters.F90 $(SRC)/parallel.F90 $(SRC)/grid.F90 $(SRC)/variables.F90 $(SRC)/atmosphere.F90 $(SRC)/surface.F90 $(SRC)/main.F90
OBJECTS := $(patsubst $(SRC)/%.F90, $(BLD)/%.o, $(SOURCES))
BIN := fakeatm.x

$(BIN): $(OBJECTS)
	$(FC) -o $@ $^ -Wl,-rpath=$(LOCAL_LIB) -lstdc++ -L$(LOCAL_LIB) -lmpifort -lnetcdff -L$(LSM_LIB) -llsm
	rm *.mod

$(BLD)/%.o: $(SRC)/%.F90
	mkdir -p $(BLD)
	$(FC) -o $@ -c $< -I$(LOCAL_INCLUDE) -I$(LSM_INCLUDE)
	
clean:
	rm $(BLD)/*
	rm $(OUTPUT)/*
	rm $(BIN)
	rm *.txt

compare:
	../serial/fakeatm.x > out_serial.txt
	mpirun -n 6 ./fakeatm.x > out_mpi.txt
	diff out_mpi.txt out_serial.txt
