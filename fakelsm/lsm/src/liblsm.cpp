// To be compiled as a library
//

#include <vector>
#include "lsm.h"

typedef void* lsm_world;

extern "C" {

lsm_world init_world(int n) {

	std::vector<Gridcell>* world_ptr = new std::vector<Gridcell>(n);

	for (int i=0; i<world_ptr->size(); i++) {
		(*world_ptr)[i].set_albedo( 0.1 );
	}

	return (lsm_world)world_ptr;
}

void destroy_world(lsm_world world) {

	std::vector<Gridcell>* world_ptr = (std::vector<Gridcell>*) world;
	delete(world_ptr);
}


void get_fluxes(lsm_world world, int i, double sw_down, double* sw_up, double* senh_up, double* lath_up) {
	
	std::vector<Gridcell>* world_ptr = (std::vector<Gridcell>*) world;
	Gridcell& gc = (*world_ptr)[i];
	energy_balance(gc, sw_down, sw_up, senh_up, lath_up);

	// If END OF DAY
	// DO OTHER STUFF WITH GRIDCELL
	// with functions contained in lsm.h
}


double get_gridcell_albedo(lsm_world world, int i) {

	std::vector<Gridcell>* world_ptr = (std::vector<Gridcell>*) world;
	Gridcell& gc = (*world_ptr)[i];

	return gc.albedo;
}

void set_gridcell_albedo(lsm_world world, int i, double albedo) {

	std::vector<Gridcell>* world_ptr = (std::vector<Gridcell>*) world;
	Gridcell& gc = (*world_ptr)[i];
	gc.set_albedo(albedo);
}

} // extern "C"
