#include <iostream>
#include <vector>
#include "liblsm.h"

int main() {
	
	int size_world = 5;
	lsm_world world;
	world = init_world(size_world);

	// Fake climate data
	std::vector<double> sw_down = {400., 500., 100., 600., 700.};
	std::vector<double> sw_up(size_world,0);
	std::vector<double> senh_up(size_world,0);
	std::vector<double> lath_up(size_world,0);

	
	set_gridcell_albedo(world, 2, 0.2);

	for (int i=0; i<size_world; i++) {
		get_fluxes(world, i, sw_down[i], &sw_up[i], &senh_up[i], &lath_up[i]);
	}

	for (int i=0; i<size_world; i++) {
		std::cout
			<< "Gridcell #" << i << "\n"
			<< "----------\n"
			<< "albedo = " << get_gridcell_albedo(world, i) << "\n"
			<< "sw_down = " << sw_down[i] << "\n"
			<< "sw_up = " << sw_up[i] << "\n"
			<< "senh_up = " << senh_up[i] << "\n"
			<< "lath_up = " << lath_up[i] << "\n"
			<< "\n";
	}
	

	destroy_world(world);

}
