load('DATASETTINGS.gp')

load("./FIT_VALUES/T_wc_a_wc0_".dataname."".datatimerange."".dataregion.".gp")

dataFN1='./GNUPLOTready'.datatimerange.'/bin_'.dataregion.'_T'
#dataFN2='_cwv_num_sumP_sumpsq_numNoP_stderr.dat'
dataFN2='_cwv_num_sumP_sumpsq_numNoP_slp.dat'

# x-axis (CWV) range, default 40-100mm
xmax=100
xmin=40
# y-axis (precip) range, default 0-12mm/h:
ymax=12
ymin=0


set title dataname." ".dataregion." ".dataperiod." ".datatimerange." " font "Helvetica, 20"
set xlabel "CWV (mm)" font "Helvetica, 18"
set ylabel "P (mm/hr)  only including bins with >= ".mincntp1." count \n and fits for critical for P between ".minPs." and ".maxPs."mm/hr \n and x-range of w_c to w_c+5 with minimum of 3 bins" font "Helvetica, 18"
set key top left
unset logscale

# Written out for each temperature (269K-274K) below. 

plot [xmin:xmax] [ymin:ymax]  dataFN1.'269'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 1 t "269"
replot  dataFN1.'270'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 3 t "270"
replot dataFN1.'271'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 5 t "271"
replot dataFN1.'272'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 7  t "272"
replot dataFN1.'273'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 4 t "273"
replot dataFN1.'274'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 2 t "274"

# use gnuplot 'set arrow' to draw line segments
set arrow from wc269Pmin,0 to wc269Pmin,2.5 as 1
set arrow from wc269Pmin,2.5 to wc269Pmax,6.0 as 1
set arrow from wc270Pmin,0 to wc270Pmin,2.5 as 2
set arrow from wc270Pmin,2.5 to wc270Pmax,6.0 as 2
set arrow from wc271Pmin,0 to wc271Pmin,2.5 as 3
set arrow from wc271Pmin,2.5 to wc271Pmax,6.0 as 3
set arrow from wc272Pmin,0 to wc272Pmin,2.5 as 4
set arrow from wc272Pmin,2.5 to wc272Pmax,6.0 as 4
set arrow from wc273Pmin,0 to wc273Pmin,2.5 as 5
set arrow from wc273Pmin,2.5 to wc273Pmax,6.0 as 5
set arrow from wc274Pmin,0 to wc274Pmin,2.5 as 6
set arrow from wc274Pmin,2.5 to wc274Pmax,6.0 as 6

replot

