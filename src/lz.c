//lz.c -> Calculate the lyapunov's exponents for RPS System
//				using Pull-back method and Runge-Kutta integrator
//
// Created		: 2024/07/02
// Updated		: 2024/07/31
// Autor			: Matheus <matheuslucasgp@gmail.com>
//----------------------------------------
// Notes:
//
//----------------------------------------
// Example: ./lz.out
//		Execute RPS pestilent System and print LCE's
//----------------------------------------
// Histórico:
//		V1.0 - Execute RPS System
//		V2.0 - Calculate de LCE's
//		V3.0 - Plot model
//----------------------------------------



//-----------------------------------------------------
//		Libraries
//-----------------------------------------------------
#include "../lce.h"

//-----------------------------------------------------
//	Diferential equations for lorenz system
//-----------------------------------------------------
double f(double x, double y, double z, double t){
	double r0= 1.0-x-y-z;
	return pa*r0*x-pb*z*x;
}

double g(double x, double y, double z, double t){
	double r0= 1.0-x-y-z;
	return pa*r0*y-pc*x*y;
}

double h(double x, double y, double z, double t){
	return pb*x*z-(1.0-pb)*z;
}


//-----------------------------------------------------
//	Tangent space (Diferential form of ODE's)
//-----------------------------------------------------
double df(double x, double y, double z, double dx, double dy, double dz, double t){
	return pa*(dx-(2.0*x*dx)-(dx*y+x*dy)-(dx*z+x*dz))-pb*(dz*x+z*dx);
}                                                               
                                                                
double dg(double x, double y, double z, double dx, double dy, double dz, double t){
	return pa*(dy-(x*dy+dx*y)-(2.0*y*dy)-(y*dz+z*dy))-pc*(x*dy+dx*y);
}                                                               
                                                                
double dh(double x, double y, double z, double dx, double dy, double dz, double t){
	return pb*(x*dz+dx*z)-(1.0-pb)*dz;
}


//-----------------------------------------------------
//	Runge-Kutta integrator for Lorenz ODE's
//-----------------------------------------------------
void RK1(double *x, double *y, double *z, double t, double dt){
	double k1, k2, k3, k4;										//x axis
	double l1, l2, l3, l4;										//y axis
	double m1, m2, m3, m4;										//z axis

	k1= f(*x, *y, *z, t);	
	l1= g(*x, *y, *z, t);
	m1= h(*x, *y, *z, t);

	k2= f(*x+0.5*dt*k1, *y+0.5*dt*l1, *z+0.5*dt*m1, t+0.5*dt);
	l2= g(*x+0.5*dt*k1, *y+0.5*dt*l1, *z+0.5*dt*m1, t+0.5*dt);
	m2= h(*x+0.5*dt*k1, *y+0.5*dt*l1, *z+0.5*dt*m1, t+0.5*dt);

	k3= f(*x+0.5*dt*k2, *y+0.5*dt*l2, *z+0.5*dt*m2, t+0.5*dt);
	l3= g(*x+0.5*dt*k2, *y+0.5*dt*l2, *z+0.5*dt*m2, t+0.5*dt);
	m3= h(*x+0.5*dt*k2, *y+0.5*dt*l2, *z+0.5*dt*m2, t+0.5*dt);

	k4= f(*x+dt*k3, *y+dt*l3, *z+dt*m3, t+dt);
	l4= g(*x+dt*k3, *y+dt*l3, *z+dt*m3, t+dt);
	m4= h(*x+dt*k3, *y+dt*l3, *z+dt*m3, t+dt);

	*x+= dt*(k1+2.0*k2+2.0*k3+k4)/6.0;
	*y+= dt*(l1+2.0*l2+2.0*l3+l4)/6.0;
	*z+= dt*(m1+2.0*m2+2.0*m3+m4)/6.0;
}
	

//-----------------------------------------------------
//	Runge-Kutta integrator for tangent space
//-----------------------------------------------------
void RK2(double x, double y, double z, double *dx, double *dy, double *dz, double t, double dt){
	double k1, k2, k3, k4;										//x axis
	double l1, l2, l3, l4;										//y axis
	double m1, m2, m3, m4;										//z axis

	k1= df(x, y, z, *dx, *dy, *dz, t);	
	l1= dg(x, y, z, *dx, *dy, *dz, t);
	m1= dh(x, y, z, *dx, *dy, *dz, t);

	k2= df(x, y, z, *dx+0.5*dt*k1, *dy+0.5*dt*l1, *dz+0.5*dt*m1, t+0.5*dt);
	l2= dg(x, y, z, *dx+0.5*dt*k1, *dy+0.5*dt*l1, *dz+0.5*dt*m1, t+0.5*dt);
	m2= dh(x, y, z, *dx+0.5*dt*k1, *dy+0.5*dt*l1, *dz+0.5*dt*m1, t+0.5*dt);

	k3= df(x, y, z, *dx+0.5*dt*k2, *dy+0.5*dt*l2, *dz+0.5*dt*m2, t+0.5*dt);
	l3= dg(x, y, z, *dx+0.5*dt*k2, *dy+0.5*dt*l2, *dz+0.5*dt*m2, t+0.5*dt);
	m3= dh(x, y, z, *dx+0.5*dt*k2, *dy+0.5*dt*l2, *dz+0.5*dt*m2, t+0.5*dt);

	k4= df(x, y, z, *dx+dt*k3, *dy+dt*l3, *dz+dt*m3, t+dt);
	l4= dg(x, y, z, *dx+dt*k3, *dy+dt*l3, *dz+dt*m3, t+dt);
	m4= dh(x, y, z, *dx+dt*k3, *dy+dt*l3, *dz+dt*m3, t+dt);

	*dx+= dt*(k1+2.0*k2+2.0*k3+k4)/6.0;
	*dy+= dt*(l1+2.0*l2+2.0*l3+l4)/6.0;
	*dz+= dt*(m1+2.0*m2+2.0*m3+m4)/6.0;
}


//-----------------------------------------------------
//	Function main
//-----------------------------------------------------
int main(int argc, char **argv){

	int i, j, cont=0, data=0, maxd= 30000; 
	double x, y, z, time, d, t=0, dt= 1.0e-2;
	double e1x= 1.0, e1y= 0.0, e1z= 0.0;		//Vectors of LCE1
	double e2x= 0.0, e2y= 1.0, e2z= 0.0;		//Vectors of LCE2
	double e3x= 0.0, e3y= 0.0, e3z= 1.0;		//Vectors of LCE3
	double pbe1e2, pbe1e3, pbe2e3;					//Pull-Back
	double LCE1= 0.0, LCE2= 0.0, LCE3= 0.0; //LCEs

	char name_lce[100];
	char name_xyz[100];

	FILE *arq1, *arq2;
	sprintf(name_lce, "dat/lce.dat");
	sprintf(name_xyz, "dat/xyz-%.9f.dat", pb);
	arq1= fopen(name_lce, "a");
	arq2= fopen(name_xyz, "w");

	x= x0; 
	y= y0; 
	z= z0; 	

	for(i = 0; i < ntr+nit; i++){
		for(j = 0; j < ipb; j++){
			RK1(&x, &y, &z, t, dt);
			
			cont++;
			//if(i > ntr && cont%((int)(1.0/dt))==1 && data < maxd){
			if(cont%((int)(1.0/dt))==1 && data < maxd){
				data++;
				fprintf(arq2, "%e %e %e %e %e\n", pb, x, y, z, 1.0-x-y-z);
			}
			
			RK2(x, y, z, &e1x, &e1y, &e1z, t, dt);
			RK2(x, y, z, &e2x, &e2y, &e2z, t, dt);
			RK2(x, y, z, &e3x, &e3y, &e3z, t, dt);
		}

		//LCE1
		d = sqrt(e1x*e1x + e1y*e1y + e1z*e1z);
		e1x /= d;		
		e1y /= d;		
		e1z /= d;
		if(i >= ntr){
			LCE1 += log(d);			
		}		

		//LCE2
		pbe1e2 = e1x*e2x + e1y*e2y + e1z*e2z;
		e2x -= pbe1e2 * e1x;
		e2y -= pbe1e2 * e1y;
		e2z -= pbe1e2 * e1z;

		d = sqrt(e2x*e2x + e2y*e2y + e2z*e2z);
		e2x /= d;		
		e2y /= d;		
		e2z /= d;		
		if(i >= ntr){
			LCE2 += log(d);			
		}		

		//LCE3
		pbe1e3 = e1x*e3x + e1y*e3y + e1z*e3z;
		pbe2e3 = e2x*e3x + e2y*e3y + e2z*e3z;
		e3x -= pbe1e3 * e1x + pbe2e3 * e2x;
		e3y -= pbe1e3 * e1y + pbe2e3 * e2y;
		e3z -= pbe1e3 * e1z + pbe2e3 * e2z;

		d = sqrt(e3x*e3x + e3y*e3y + e3z*e3z);
		e3x /= d;		
		e3y /= d;		
		e3z /= d;		
		if(i >= ntr){
			LCE3 += log(d);			
		}		
	}
	// Conversion iterations per PB -> per sec
	time= dt*ipb*nit;
	LCE1 = LCE1/time;
	LCE2 = LCE2/time;
	LCE3 = LCE3/time;

	printf("LCEs -->  %.6f  %.6f  %.6f\n", LCE1, LCE2, LCE3);
	fprintf(arq1, "%.9e %e %e %e\n", pb, LCE1, LCE2, LCE3);
	
	fclose(arq1);
	fclose(arq2);
	return 0;
}
