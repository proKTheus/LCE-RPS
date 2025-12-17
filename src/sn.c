//cp.c -> Program to sort rearranging lines of a dat file
//				in function of the first colum
//
// Created		: 2024/10/11
// Updated		: 2024/10/11	
// Autor			: Matheus <matheuslucasgp@gmail.com>
//----------------------------------------
// Notes:
//
//----------------------------------------
// Example: ./sn.c lce.dat 5000
//					open 'lce.dat'(with 5000 lines) and rearrange
//----------------------------------------
// History:
//		V1.0 - Functional program
//
//----------------------------------------

//-----------------------------------------------------
//		Libraries
//-----------------------------------------------------
#include "../lce.h"

int main(int argc, char **argv){

	if(argc != 3){
		printf("Uso: %s <file> <line>\n", argv[0]);
		printf("<file>: Local, Name and extension of file\n");
		printf("<line>: Number of lines in the file\n");
		printf("Ex.:    %s dat/lz.dat 10000\n", argv[0]);
		return 1;		
	}	

	int i, j, l=0;
	double col1, col2, col3, col4, temp;
	double *vec1, *vec2, *vec3, *vec4;
	
	char name_dat[100], name_srt[100];	
	FILE *arq1, *arq2;
	sprintf(name_dat, "%s", argv[1]);
	sprintf(name_srt, "dat/lce-sort.dat");
	arq1= fopen(name_dat, "r");
	arq2= fopen(name_srt, "w");
	
	if(arq1 == NULL){
		printf("Erro ao abrir o arquivo %s\n", name_dat);
		return 1;
	}
	
	l= atoi(argv[2]);
	
	vec1= (double *) calloc((l), sizeof(double));
	vec2= (double *) calloc((l), sizeof(double));
	vec3= (double *) calloc((l), sizeof(double));
	vec4= (double *) calloc((l), sizeof(double));

	for(i = 0; i < l; i++){	
		if (fscanf(arq1, "%lf %lf %lf %lf", &col1, &col2, &col3, &col4) != 4) {
		    fprintf(stderr, "Erro ao ler os dados do arquivo.\n");
		    fclose(arq1);
		    fclose(arq2);
		    return 1;
		}
		vec1[i]=col1;			
		vec2[i]=col2;
		vec3[i]=col3;
		vec4[i]=col4;
	}

	for(i = 0; i < l; i++){
		for(j = i+1; j < l; j++){ 
			if(vec1[i] > vec1[j]){
		  	temp = vec1[i];
		  	vec1[i] = vec1[j];
		  	vec1[j] = temp;
		
		  	temp = vec2[i];
		  	vec2[i] = vec2[j];
		  	vec2[j] = temp;
		  	
				temp = vec3[i];
		  	vec3[i] = vec3[j];
		  	vec3[j] = temp;
		  	
				temp = vec4[i];
		  	vec4[i] = vec4[j];
		  	vec4[j] = temp;
		  }
		}
	}	

	for(i = 0; i < l; i ++){
		fprintf(arq2, "%.9e %e %e %e\n",  vec1[i], vec2[i], vec3[i], vec4[i]);					
	}

	fclose(arq1);
	fclose(arq2);
	return 0;
}
