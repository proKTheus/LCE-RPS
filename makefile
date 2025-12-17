COMPILER = gcc
FLAGS = -Wall -O3 -mtune=native

LIB = -lgsl -lgslcblas -lm

cp:
	@${COMPILER} ${FLAGS} src/cp.c ${LIB} -o cp.out

lz:
	@${COMPILER} ${FLAGS} src/lz.c ${LIB} -o lz.out

sn:
	@${COMPILER} ${FLAGS} src/sn.c ${LIB} -o sn.out

sd:
	@${COMPILER} ${FLAGS} src/sd.c ${LIB} -o sd.out

clean:
	@rm -rf plt/*
	@rm -rf dat/*
	@rm -f *.out

clean-dat:
	@rm -f dat/*
