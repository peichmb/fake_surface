#include <stdio.h>
#include "liblsm.h"

int main() {

	int size_world = 5;
	lsm_world world;
	world = init_world(size_world);

	// Fake climate data
	double sw_down[5] = {400., 500., 100., 600., 700.};
	double sw_up[5] = {0.};
	double senh_up[5] = {0.};
	double lath_up[5] = {0.};

	for (int i=0; i<size_world; i++) {
		get_fluxes(world, i, sw_down[i], &sw_up[i], &senh_up[i], &lath_up[i]);
	}

	for (int i=0; i<size_world; i++) {
        printf("Gridcell #%d\n", i);
        printf("----------\n");
        printf("albedo = %f\n", get_gridcell_albedo(world, i));
        printf("sw_down = %f\n", sw_down[i]);
        printf("sw_up = %f\n", sw_up[i]);
        printf("senh_up = %f\n", senh_up[i]);
        printf("lath_up = %f\n", lath_up[i]);
        printf("\n");
	}

	destroy_world(world);
}
