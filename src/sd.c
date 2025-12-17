#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <gsl/gsl_statistics.h>

int main(int argc, char **argv){

	if(argc != 4){
		printf("\nplease, type:\n\n %s file n_lines n_columns\n\n", argv[0]);
		exit(0);
	}
	
	int i, j, NL, NC;
	double *avg;
	double **inp;
	FILE *file;
	char name[100];
	
	NL= atoi(argv[2]);
	NC= atoi(argv[3]);
	inp= (double **) calloc(NL, sizeof(double *));
	for(i= 0; i< NL; i++){
		inp[i]= (double *) calloc(NC, sizeof(double));
	}
	avg= (double *) calloc(NL, sizeof(double));

	sprintf(name, "%s", argv[1]);
	if(!(file= fopen(name, "r"))){
		printf("cannot open file %s\n", argv[1]);
		exit(0);
	}
	for(i= 0; i< NL; i++){
		for(j= 0; j< NC; j++){
			if((fscanf(file, "%lf", &inp[i][j]) != 1)){
				printf("cannot read file %s\n", argv[1]);
				exit(0);
			}
		}
	}
	fclose(file);

	for(i= 0; i< NC; i++){
		for(j= 0; j< NL; j++){
			avg[j]= inp[j][i];
		}
		printf("%+e %+e ", gsl_stats_mean(avg, 1, NL), gsl_stats_sd(avg, 1, NL));
	}
	printf("\n");

	for(i= 0; i< NL; i++){
		free(inp[i]);
	}
	free(inp);
	free(avg);
	return 0;
}
