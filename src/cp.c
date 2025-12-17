//cp.c -> Program to identify critical points in discrete
//				functions (compl. to lz.c) for bifurcation diagrams
//
// Created		: 2024/10/03
// Updated		: 2024/10/03	
// Autor			: Matheus <matheuslucasgp@gmail.com>
//----------------------------------------
// Notes:
//
//----------------------------------------
// Example: ./cp.c lz.dat <lines> <radio> <species>
//					open 'lz.dat' and find critical points
//----------------------------------------
// History:
//		V1.0 - Functional program
//		V2.0 - Added bif-r1.dat ... bif-r4.dat
//----------------------------------------

//-----------------------------------------------------
//		Libraries & Keys
//-----------------------------------------------------
#include "../lce.h"

//Keys --> on = 1 | off = 0
#define Kmax 1		//Maximum    points
#define Kmin 0		//Minimum		 points
#define Kinf 0		//Inflection points

int main(int argc, char **argv){

	if(argc != 5){
		printf("Uso: %s <file> <line> <r> <species>\n", argv[0]);
		printf("<file>: Name and extension of file\n");
		printf("<line>: Number of lines in the file\n");
		printf("<r>:    Colect ratio (increase if there's noise)\n");
		printf("<species>: column of species\n");
		printf("Ex.:    %s dat/lz.dat 10000 5 2\n", argv[0]);
		return 1;		
	}

	int i, j, l=0, r=0, max_data= 100, num_data= 0; //Max data for not overflow
	int c_max, c_min, c_inf; 			//c_max (counter of max, min and inflexion)
	double col1, col2, *colx, *coly;	
	
	char name_dat[100], name_bif[100];	
	FILE *arq1, *arq2;
	sprintf(name_dat, "%s", argv[1]);

	int spc_col = atoi(argv[4]);	//spc_col is the specie column
	switch (spc_col){
		case 1:
			sprintf(name_bif, "dat/bif-r1.dat");
			break;
		case 2:
			sprintf(name_bif, "dat/bif-r2.dat");
			break;
		case 4:
			sprintf(name_bif, "dat/bif-r4.dat");
			break;
		default:
			fprintf(stderr, "Valor inválido de spc_col argv[4].\n");
			return 1;
	}

	arq1= fopen(name_dat, "r");
	arq2= fopen(name_bif, "a");
	
	if(arq1 == NULL){
		printf("Erro ao abrir o arquivo %s\n", name_dat);
		return 1;
	}
	
	l= atoi(argv[2]);
	r= atoi(argv[3]);
	
	colx= (double *) calloc((l), sizeof(double));
	coly= (double *) calloc((l), sizeof(double));

	switch (spc_col){
		case 1:
			for(i = 0; i < l; i++){	
				if (fscanf(arq1, "%lf %lf %*f %*f %*f", &col1, &col2) != 2) {
				    fprintf(stderr, "Erro ao ler os dados do arquivo.\n");
				    fclose(arq1);
				    fclose(arq2);
				    return 1;
				}
				colx[i] = col1; 	//colx = column for localizete where is the cp
				coly[i] = col2; 	//coly = column that i want for bif
			}
			break;
		case 2:
			for(i = 0; i < l; i++){	
				if (fscanf(arq1, "%lf %*f %lf %*f %*f", &col1, &col2) != 2) {
				    fprintf(stderr, "Erro ao ler os dados do arquivo.\n");
				    fclose(arq1);
				    fclose(arq2);
				    return 1;
				}
				colx[i] = col1; 	//colx = column for localizete where is the cp
				coly[i] = col2; 	//coly = column that i want for bif
			}
			break;
		case 4:
			for(i = 0; i < l; i++){	
				if (fscanf(arq1, "%lf %*f %*f %lf %*f", &col1, &col2) != 2) {
				    fprintf(stderr, "Erro ao ler os dados do arquivo.\n");
				    fclose(arq1);
				    fclose(arq2);
				    return 1;
				}
				colx[i] = col1; 	//colx = column for localizete where is the cp
				coly[i] = col2; 	//coly = column that i want for bif
			}
			break;
		default:
			fprintf(stderr, "Valor inválido de spc.\n");
			return 1;
	}


	for(i = 2*r-2; i < l; i++){
		c_max= c_min= c_inf= 0;
//-----------------------------------------------------
//	Critical point --> Max
//-----------------------------------------------------
		for(j = i-(r-1); j <= i+(r-1); j++){
			if(coly[i] > coly[j]){
				c_max++;				
			}
		}
//-----------------------------------------------------
//	Critical point --> Min
//-----------------------------------------------------
		for(j = i-(r-1); j <= i+(r-1); j++){
			if(coly[i] < coly[j]){
				c_min++;				
			}
		}
//-----------------------------------------------------
//	Critical point --> Inf
//-----------------------------------------------------
		for(j = i-(r-1); j <= i+(r-1); j++){
			if(coly[i] == coly[j]){
				c_inf++;				
			}
		}
//-----------------------------------------------------
//	Counter analisis
//-----------------------------------------------------
		if(i >= 20000){  //discard first lines because transients
			if(num_data < max_data){
				if(c_max == 2*r-2 && Kmax == 1){
					fprintf(arq2, "%e %e %d\n", colx[i], coly[i], i);			
					num_data++;
				}
				if(c_min == 2*r-2 && Kmin == 1){
					fprintf(arq2, "%e %e %d\n", colx[i], coly[i], i);			
					num_data++;
				}
				if(c_inf == 2*r-1 && Kinf == 1){
					fprintf(arq2, "%e %e %d\n", colx[i], coly[i], i);			
					num_data++;
				}
			}
		}
	}

	fclose(arq1);
	fclose(arq2);
	return 0;
}
