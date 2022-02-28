#ifndef LIBLSM_H
#define LIBLSM_H

typedef void* lsm_world;

#ifdef __cplusplus
extern "C" {
#endif

lsm_world init_world(int n);
void destroy_world(lsm_world world);
void get_fluxes(lsm_world world, int i, double sw_down, double* sw_up, double* senh_up, double* lath_up);
double get_gridcell_albedo(lsm_world world, int i);
void set_gridcell_albedo(lsm_world world, int i, double albedo);

#ifdef __cplusplus
}
#endif

#endif // LIBLSM_H
