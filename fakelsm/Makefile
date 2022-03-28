CXX := c++
FC := gfortran
LSM_OBJ := lsm/obj
LSM_INC := lsm/include
LSM_SRC := lsm/src
LSM_LIB := lsm/lib

all: lib main_c.x main_cpp.x main_f.x

lib: $(LSM_LIB)/liblsm.a

$(LSM_LIB)/liblsm.a: $(LSM_OBJ)/liblsm.o $(LSM_OBJ)/liblsm_f.o
	mkdir -p $(LSM_LIB)
	ar rcs $(LSM_LIB)/liblsm.a $(LSM_OBJ)/liblsm.o $(LSM_OBJ)/liblsm_f.o
	cp $(LSM_SRC)/liblsm.h $(LSM_INC)

$(LSM_OBJ)/liblsm.o: $(LSM_SRC)/liblsm.cpp $(LSM_SRC)/lsm.h
	mkdir -p $(LSM_OBJ)
	$(CXX) -o $(LSM_OBJ)/liblsm.o -c $(LSM_SRC)/liblsm.cpp

$(LSM_OBJ)/liblsm_f.o: $(LSM_SRC)/liblsm_f.F90
	mkdir -p $(LSM_OBJ) $(LSM_INC)
	$(FC) -o $(LSM_OBJ)/liblsm_f.o -c $(LSM_SRC)/liblsm_f.F90
	mv liblsm_f.mod $(LSM_INC)

main_c.x: main_c.c $(LSM_LIB)/liblsm.a
	$(CXX) main_c.c -I$(LSM_INC) -L$(LSM_LIB) -llsm -o main_c.x

main_cpp.x: main_cpp.cpp $(LSM_LIB)/liblsm.a
	$(CXX) main_cpp.cpp -I$(LSM_INC) -L$(LSM_LIB) -llsm -o main_cpp.x

main_f.x: main_f.F90 $(LSM_LIB)/liblsm.a
	$(FC) main_f.F90 -I$(LSM_INC) -L$(LSM_LIB) -llsm -lstdc++ -o main_f.x

clean:
	$(RM) $(LSM_INC)/*
	$(RM) $(LSM_LIB)/*
	$(RM) $(LSM_OBJ)/*
	$(RM) *.x

