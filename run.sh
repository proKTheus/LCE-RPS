#!/bin/bash
#
#run.sh - Calculate Lyapunov exponent for RPS system
#
# Created     : 2024/08/30
# Updated			: 2025/02/12
# Autor	      : Matheus <matheuslucasgp@gmail.com>
#----------------------------------------
# Notes:
#
#----------------------------------------
# Example:	./run.sh 0.82 0.99 0.001
#							Calculate Lyapunov exponent 
#							with parameter q varying 
#							0.82 < q < 0.99 with dq=0.01
#----------------------------------------
# Historic:
#		V1.0 - Functional program
#		V2.0 - Key bif & plt
#----------------------------------------


#-------------------------------------
# Variables
#-------------------------------------
PQI=$1
PQF=$2
DPQ=$3


#-------------------------------------
#Keys
#-------------------------------------
LCE=0		
BIF=0
PLT=1

#-------------------------------------
# Verification
#-------------------------------------
if [ $# -ne 3 ]; then
	echo "Uso: $0 <PQI> <PQF> <DPQ>"
	echo "<PQI>: Initial pq"
	echo "<PQF>: Final pq"
	echo "<DPQ>: Interval of pq"
	echo "Example: 0.83 0.99 0.001"
  exit 1
fi

l=$PQI
scale=05			# Define number of decimal places

#-------------------------------------
# Revision
#-------------------------------------
while (( $(echo "$l <= $PQF" | bc -l) )); do
	NUM=$(($NUM+1))
  l=$(echo "$l + $DPQ" | bc -l)					# Incrementa l 
done
echo "----------------------------"
echo "Initial q= $PQI"
echo "Final   q= $PQF"
echo "Variat. q= $DPQ"
echo "num. simu= $NUM"
echo "----------------------------"
echo "Key LCE  = $LCE"
echo "Key BIF  = $BIF"
echo "Key PLT  = $PLT"
echo "----------------------------"
read -p "Continue? (y/n): " confirm
if [[ $confirm != "y" ]]; then
    echo "Operation aborted."
    exit 0
fi


mkdir -p dat/ps
mkdir -p plt/ps


l=$PQI
CONT=1

clear
#-------------------------------------
#							LCE KEY
#-------------------------------------
if [[ $LCE -eq 1 ]]
then
echo "----------------"
echo "Calculing LCE"
echo "----------------"
	while (( $(echo "$l <= $PQF" | bc -l) )); do
		printf "(%d/%d) q = %.9f | " "$CONT" "$NUM" "$l"		# Imprime o valor de l 
			sed -i "s/#define pb [^ ]\+/#define pb $l/g" lce.h
			make lz
			./lz.out
			mv dat/xyz-* dat/ps/
		CONT=$(($CONT+1))
	  l=$(echo "$l + $DPQ" | bc -l)					# Incrementa l 
	done
	linhas=$(wc -l < "dat/lce.dat")
	make sn
	./sn.out "dat/lce.dat" $linhas
fi

#-------------------------------------
#							BIF KEY
#-------------------------------------
if [[ $BIF -eq 1 ]]
then		
echo "-------------"
echo "Calculing BIF"
echo "-------------"
	for SPECIES in 1 2 4
	do
		CONT=1
		> dat/bif-r$SPECIES.dat	
		for file in dat/ps/xyz-*.dat
		do
			make cp	
			linhas=$(wc -l < "$file")
			./cp.out "$file" "$linhas" 2 "$SPECIES"
			printf "(%d/%d) bif species %d file = %s\n" "$CONT" "$NUM" "$SPECIES" "$file"		# Imprime o valor de l 
			CONT=$(($CONT+1))
		done		
	done
	echo "Ploting bifurcation..."	
	cd src/
	gnuplot bif.plt
	cd ../plt/
	lualatex bif.tex > /dev/null 2>&1
	rm *.aux *.log *.tex
	cd ..
fi


#-------------------------------------
#							PLT KEY
#-------------------------------------
if [[ $PLT -eq 1 ]]
then		
echo "-----------"
echo "Ploting ..."
echo "-----------"
	CONT=1
	for file in dat/ps/xyz-*.dat
	do
   l=$(echo "$file" | sed 's|dat/ps/xyz-\(.*\)\.dat|\1|')	
		linhas=$(wc -l < "$file")
		sed -i "s/pq= [^ ]\+/pq= $l/g" src/qtr.plt
		sed -i "s/pq= [^ ]\+/pq= $l/g" src/traject.plt
		sed -i "s/ll= [^ ]\+/ll= $linhas/g" src/qtr.plt
		printf "(%d/%d) q = %.$(($scale))f\n" "$CONT" "$NUM" "$l"		# Imprime o valor de l 
		cd src/
		gnuplot traject.plt
		gnuplot qtr.plt
		cd ../plt
		pdflatex traject.tex > /dev/null 2>&1
		pdflatex ternary.tex > /dev/null 2>&1
		pdfcrop ternary.pdf > /dev/null 2>&1
	 	mv ternary-crop.pdf ternary.pdf
		mv traject.pdf ps/tra-$l.pdf	
	 	mv ternary.pdf ps/ter-$l.pdf	
		cd ../
		CONT=$(($CONT+1))
	done			

	cd src/
	gnuplot lceplot.plt
	cd ../plt/
	pdflatex lce-e1.tex > /dev/null 2>&1
	pdflatex lce-e2.tex > /dev/null 2>&1
	pdflatex lce-e3.tex > /dev/null 2>&1
	rm *.aux *.log *.tex
	cd ..
fi
