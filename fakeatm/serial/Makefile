FC := gfortran
LOCAL_INCLUDE := /home/belda-d/local/include
LOCAL_LIB := /home/belda-d/local/lib
LSM_INCLUDE := ../../fakelsm/lsm/include
LSM_LIB := ../../fakelsm/lsm/lib
SRC := src
BLD := bld
SOURCES := $(SRC)/parameters.F90 $(SRC)/variables.F90 $(SRC)/atmosphere.F90 $(SRC)/surface.F90 $(SRC)/main.F90
OBJECTS := $(patsubst $(SRC)/%.F90, $(BLD)/%.o, $(SOURCES))
BIN := fakeatm.x

$(BIN): $(OBJECTS)
	$(FC) -o $@ $^ -Wl,-rpath=$(LOCAL_LIB) -lstdc++ -L$(LOCAL_LIB) -lnetcdff -L$(LSM_LIB) -llsm
	$(RM) *.mod

$(BLD)/%.o: $(SRC)/%.F90
	mkdir -p $(BLD)
	$(FC) -o $@ -c $< -O2 -I$(LOCAL_INCLUDE) -I$(LSM_INCLUDE)

clean:
	$(RM) bld/*
	$(RM) $(BIN)
	
