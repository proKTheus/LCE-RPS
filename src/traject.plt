set terminal tikz size 8.4cm, 3.2cm fontscale 1.0 fulldoc \
header "\\usepackage{amsmath}"

set output '../plt/traject.tex'

# Species constants
pq= 0.816500000 

# Data file
arq= sprintf("../dat/ps/xyz-%.9f.dat", pq)

set xlabel offset 0.0, 0.8 "$t$"
set ylabel offset 0.8, 0.0 "$\\rho_i$"
set ytics offset 1.0, 0.0 
set xtics offset 0.0, 0.0 

if (pq == 0.815) {
	set key at graph 0.5, 1.12 reverse Left samplen 1 width 2 horizontal center
}

#set xrange [0.82:0.99]
set yrange [-0.02:1.199]
set ytics 0.25
#set ytics ("0.00" 0, "0.25" 0.25, "0.50" 0.5, "0.75" 0.75, "1.00" 1) nomirror 
set ytics ("0.00" 0, "0.25" 0.25, "0.50" 0.5, "0.75" 0.75, "1.00" 1) 
set xtics 200
set mytics 4
set mxtics 4
set label sprintf("$q$ = %.4f", pq) at graph 0.33, 0.90 front font",7" 


#first line
fl=1
#Last line
ll=1000

if (pq == 0.815) {
unset xlabel
set format x""
	plot 	arq every ::fl::ll u 0:2 w l lw 2 lc "#ff8080" t"$\\rho_1$",\
				arq every ::fl::ll u 0:3 w l lw 2 lc "#8080ff" t"$\\rho_2$",\
				arq every ::fl::ll u 0:4 w l lw 2 lc "#1ab31a" t"$\\rho_4$",\
				arq every ::fl::ll u 0:5 w l lw 2 lc "#bbbbbb" t"$\\rho_0$"
	unset output
}else {
	if (pq == 0.998){	
		plot 	arq every ::fl::ll u 0:2 w l lw 2 lc "#ff8080" notitle,\
					arq every ::fl::ll u 0:3 w l lw 2 lc "#8080ff" notitle,\
					arq every ::fl::ll u 0:4 w l lw 2 lc "#1ab31a" notitle,\
					arq every ::fl::ll u 0:5 w l lw 2 lc "#bbbbbb" notitle
		unset output
	}else {
		unset xlabel
		set format x""
		plot 	arq every ::fl::ll u 0:2 w l lw 2 lc "#ff8080" notitle,\
					arq every ::fl::ll u 0:3 w l lw 2 lc "#8080ff" notitle,\
					arq every ::fl::ll u 0:4 w l lw 2 lc "#1ab31a" notitle,\
					arq every ::fl::ll u 0:5 w l lw 2 lc "#bbbbbb" notitle
		unset output
	}
}



