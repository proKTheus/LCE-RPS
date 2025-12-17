#---------------------------------------------------------
# qtr.plt - Quaternary diagram plot
#
# Created     : 2024/11/01
# Updated			: 2024/11/04
# Autor	      : Matheus <matheuslucasgp@gmail.com>
#---------------------------------------------------------
# Notes: Plot phase space in 3 dimensions with
#				 4 axys (Eg.: Quaternary diagram for 4 species)
#
#---------------------------------------------------------
# Example: gnuplot qtr.plt
#---------------------------------------------------------
# Historic:
#		V1.0 - Functional program
#---------------------------------------------------------

#---------------------------------------------------------
# Output
#---------------------------------------------------------
set terminal tikz size 12.8cm, 12.8cm fontscale 1.4 standalone \
header "\\usepackage{amsmath}\\usepackage{amssymb}\\usepackage{siunitx}\\usepackage{tikz}"
set output '../plt/ternary.tex'

# Load arquive
pq= 0.998000000
arq= sprintf("../dat/ps/xyz-%.9f.dat", pq)

#---------------------------------------------------------
# Variables
#---------------------------------------------------------
# Vertices of the tetrahedron
V1x = -0.5; V1y = 0.0		; V1z = 0.0   	# Vertex for r1
V2x =  0.0; V2y = 0.8667; V2z = 0.0   	# Vertex for r2
V4x =  0.5; V4y = 0.0		; V4z = 0.0   	# Vertex for r4
V0x =  0.0; V0y = 0.2887; V0z = 0.8165 	# Vertex for r0

# Set view <Elevation_angle>, <Rotation_angle>
#180, 190 ---> estava usando
# 70, 300 ---> isométrica 
v1_elv= 60
v1_rot= 30
v2_elv= 80
v2_rot= 240

# Two colors contour
ll= 30000 		#Last line
l1= ll-1			#Last line-1 for last point
sl= l1-1000		#Split line


#---------------------------------------------------------
# Draw faces of tetrahedron
#---------------------------------------------------------
set object 1 polygon from \
	V0x, V0y, V0z to \
	V1x, V1y, V1z to \
	V4x, V4y, V4z to \
	V0x, V0y, V0z \
    fc rgb "gray" fs transparent solid 0.3 noborder

set object 2 polygon from \
	V0x, V0y, V0z to \
	V4x, V4y, V4z to \
	V2x, V2y, V2z to \
	V0x, V0y, V0z \
    fc rgb "gray" fs transparent solid 0.3 noborder

set object 3 polygon from \
	V1x, V1y, V1z to \
	V2x, V2y, V2z to \
	V0x, V0y, V0z to \
	V1x, V1y, V1z \
    fc rgb "gray" fs transparent solid 0.3 noborder

set object 4 polygon from \
	V1x, V1y, V1z to \
	V2x, V2y, V2z to \
	V4x, V4y, V4z to \
	V1x, V1y, V1z \
    fc rgb "gray" fs transparent solid 0.3 noborder


#---------------------------------------------------------
# 1-st plot
#---------------------------------------------------------
set view v1_elv, v1_rot
set xrange [-0.5:0.5]
set yrange [0:1]     
set zrange [0:1]     
unset xtics  
unset ytics  
unset ztics  
unset border 
unset xlabel 
unset ylabel 
unset zlabel 

# Vertex Labels
set label "$\\rho_1$" at V1x-0.08	, V1y+0.15, V1z center tc rgb "black" 
set label "$\\rho_2$" at V2x+0.00	, V2y+0.08, V2z center tc rgb "black" 
set label "$\\rho_4$" at V4x+0.04	, V4y-0.04, V4z center tc rgb "black" 
set label "$\\rho_0$" at V0x-0.08	, V0y+0.00, V0z center tc rgb "black" 

# Dashed lines for contour 
set arrow from V2x, V2y, V2z to V1x, V1y, V1z nohead lw 1 lc rgb "black" dt 2

# Continuous lines for contour
set arrow from V0x, V0y, V0z to V1x, V1y, V1z nohead lw 2 lc rgb "black"  
set arrow from V0x, V0y, V0z to V2x, V2y, V2z nohead lw 2 lc rgb "black"  
set arrow from V0x, V0y, V0z to V4x, V4y, V4z nohead lw 2 lc rgb "black" front 
set arrow from V4x, V4y, V4z to V1x, V1y, V1z nohead lw 2 lc rgb "black"
set arrow from V4x, V4y, V4z to V2x, V2y, V2z nohead lw 2 lc rgb "black"

#Colors
col1="#f03b20"
col2="#d82b5d"
col3="#c62087"
col4="#a80cd0"
col5="#9500ff"


splot arq every ::0::0 using \
    ($2*V1x + $3*V2x + $4*V4x + $5*V0x): \
    ($2*V1y + $3*V2y + $4*V4y + $5*V0y): \
    ($2*V1z + $3*V2z + $4*V4z + $5*V0z) \
    w points pt 7 ps 1 lc rgb col1 notitle,\
		arq every ::0::2000 using \
    ($2*V1x + $3*V2x + $4*V4x + $5*V0x): \
    ($2*V1y + $3*V2y + $4*V4y + $5*V0y): \
    ($2*V1z + $3*V2z + $4*V4z + $5*V0z):(($0)/100) \
    w lines lc rgb col1 notitle,\
		arq every ::2000::4000 using \
    ($2*V1x + $3*V2x + $4*V4x + $5*V0x): \
    ($2*V1y + $3*V2y + $4*V4y + $5*V0y): \
    ($2*V1z + $3*V2z + $4*V4z + $5*V0z):(($0)/100) \
    w lines lc rgb col2 notitle,\
		arq every ::4000::6000 using \
    ($2*V1x + $3*V2x + $4*V4x + $5*V0x): \
    ($2*V1y + $3*V2y + $4*V4y + $5*V0y): \
    ($2*V1z + $3*V2z + $4*V4z + $5*V0z):(($0)/100) \
    w lines lc rgb col3 notitle,\
		arq every ::6000::8000 using \
    ($2*V1x + $3*V2x + $4*V4x + $5*V0x): \
    ($2*V1y + $3*V2y + $4*V4y + $5*V0y): \
    ($2*V1z + $3*V2z + $4*V4z + $5*V0z):(($0)/100) \
    w lines lc rgb col4 notitle,\
		arq every ::8000::10000 using \
    ($2*V1x + $3*V2x + $4*V4x + $5*V0x): \
    ($2*V1y + $3*V2y + $4*V4y + $5*V0y): \
    ($2*V1z + $3*V2z + $4*V4z + $5*V0z):(($0)/100) \
    w lines lc rgb col5 notitle,\
		arq every ::l1::l1 using \
    ($2*V1x + $3*V2x + $4*V4x + $5*V0x): \
    ($2*V1y + $3*V2y + $4*V4y + $5*V0y): \
    ($2*V1z + $3*V2z + $4*V4z + $5*V0z) \
    w points pt 7 ps 1 lc rgb col5 notitle,\


unset output




