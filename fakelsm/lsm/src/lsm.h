#ifndef LSM_H
#define LSM_H

#include <iostream>

class Gridcell {

public:

	double albedo;

	Gridcell() {
		albedo = 0.3;
	}

	Gridcell(double albedo) : albedo(albedo) {}

	void print() {
		std::cout << albedo << std::endl;
	}

	void set_albedo(double alb) {
		albedo = alb;
	}

	~Gridcell() {}

private:

};


void energy_balance(Gridcell& gc, double sw_down, double* sw_up, double* senh_up, double* lath_up) {

	*sw_up = gc.albedo*sw_down;
	*senh_up = 0.3*(sw_down - *sw_up);
	*lath_up = 0.7*(sw_down - *sw_up);

}

#endif
