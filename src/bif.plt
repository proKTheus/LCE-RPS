# Key for tex or png input
out_key = 1  # 1 --> LaTeX, 0 --> PNG


# Escolher o terminal baseado no valor de output_tex
if (out_key==1) {
  set terminal tikz size 8.4cm, 4.0cm fontscale 1.00 fulldoc header "\\usepackage{amsmath}"
  set output sprintf("../plt/bif.tex")
	set xlabel offset -1.5, 0.0 "$q$"
	set y2label offset -2.0, 0.0 "$\\rho_{i_{\\text{(max)}}}$"
	set ylabel "$10^{-3} \\times e_1$" offset 1.0, 0.0

	set lmargin 6
	set rmargin 6
	set tmargin 0
	set bmargin 0


} else {
  set terminal pngcairo size 1680, 800 font 'Latin Modern Roman,34' enhanced
  set output sprintf("../plt/bif.png")
	set xlabel offset 0.0, 0.0 "{q}"
	set y2label offset 0.0, 0.0 "{/Symbol r}_i_{max}"
	set ylabel "e_1 ({x 10^{-3})"
}

# Data files
arq1= sprintf("../dat/bif-r1.dat");
arq2= sprintf("../dat/lce-sort.dat");
arq3= sprintf("../dat/bif-r2.dat");
arq4= sprintf("../dat/bif-r4.dat");

set xrange [0.815:1]
set y2range [-1.015:1.015]
set yrange [-0.001:0.010]

set ytics offset 1.0, 0.0 
set y2tics 0.2 offset -1.0, 0.0 
set ytics (" 0" 0, " 2" 0.002, " 4" 0.004, " 6" 0.006, " 8" 0.008) nomirror
set y2tics (" 0" 0, "0.25" 0.25, "0.50" 0.50,"0.75" 0.75, "1.00" 1) nomirror
set xtics 0.03 offset 0.0, 0.0 nomirror
set xtics ("0.84" 0.84,"0.87" 0.87,"0.90" 0.90,"0.93" 0.93,"0.96" 0.96,"0.99" 0.99,) nomirror


unset key
set key at graph 0.84, 0.7 Left samplen 0.0 center reverse

f(x) = 0

#plot NaN notitle

plot arq1 u 1:2 w points axis x1y2 pt 7 ps 0.001 lc rgb "#ff8080" notitle,\
		 arq3 u 1:2 w points axis x1y2 pt 7 ps 0.001 lc rgb "#8080ff" notitle,\
		 arq4 u 1:2 w points axis x1y2 pt 7 ps 0.001 lc rgb "#80ff80" notitle,\
		 arq1 u 1:2 every ::0::0 w points pt 7 ps 1 lc rgb "#ff8080" t"$\\rho_1$",\
		 arq3 u 1:2 every ::0::0 w points pt 7 ps 1 lc rgb "#8080ff" t"$\\rho_2$",\
		 arq4 u 1:2 every ::0::0 w points pt 7 ps 1 lc rgb "#80ff80" t"$\\rho_4$",\
		 f(x) w l lw 2 dt 4 lc rgb "#101010" notitle,\
	   arq2 u 1:2 w lines lw 1.0 lc "#8e6dac" notitle,\
	   arq2 u 1:2 every ::0::0 w lines lw 3.0 lc "#8e6dac" t"$e_1$"

#		 arq2 u 1:2 w filledcurves y1=0 fc "#a38bbc" fs solid 0.5 t"$e_1$",\

unset output
