set terminal tikz size 8.4cm, 4.0cm fontscale 1.0 fulldoc \
header "\\usepackage{amsmath}"

arq= sprintf("../dat/lce-sort.dat");
set xlabel offset 0.0, 0.0 "$q$"
set ytics offset 1.0, 0.0 
set xtics 0.03 offset 0.0, 0.0 
set xrange [0.815:1]
set xtics ("0.84" 0.84,"0.87" 0.87,"0.90" 0.90,"0.93" 0.93,"0.96" 0.96,"0.99" 0.99,) nomirror
f(x) = 0

#PLOT e1
set output sprintf("../plt/lce-e1.tex");
set ylabel offset 0.5, 0.0 "$10^{-3} \\times e_1$"
set yrange [-0.001:0.006]
set ytics 0.002 (" 0" 0, " 2" 0.002, " 4" 0.004, " 6" 0.006)
plot 	arq u 1:2 w lines lw 2 lc "#8e6dac" notitle,\
			f(x) w l lw 2 dt 4 lc rgb "#101010" notitle

#PLOT e2
set output sprintf("../plt/lce-e2.tex");
set ylabel offset 0.5, 0.0 "$10^{-2} \\times e_2$"
set yrange [-0.1:0.01]
set ytics 0.03 ("-9" -0.09, "-6" -0.06, "-3" -0.03, " 0" 0)
plot 	arq u 1:3 w lines lw 2 lc "#eab557" notitle,\
			f(x) w l lw 2 dt 4 lc rgb "#101010" notitle

#PLOT e3
set output sprintf("../plt/lce-e3.tex");
set ylabel offset 0.5, 0.0 "$10^{-1} \\times e_3$"
set yrange [-0.61:0.1]
set ytics 0.2 ("-6" -0.6, "-4" -0.4, "-2" -0.2, " 0" 0)
plot 	arq u 1:4 w lines lw 2.5 lc "#a2d0b5" notitle,\
			f(x) w l lw 2 dt 4 lc rgb "#101010" notitle

unset output

