load('DATASETTINGS.gp')

dataFN1='./GNUPLOTready'.datatimerange.'/bin_'.dataregion.'_T'
#dataFN2='_cwv_num_sumP_sumpsq_numNoP_stderr.dat'
dataFN2='_cwv_num_sumP_sumpsq_numNoP_slp.dat'

betastr='1'
setbeta=1
beta=1.0
mincnt=9  
mincntp1=mincnt + 1
minP=2.5
minPs='2.5'  #string of minimum precip
maxP=6.0
maxPs='6.0'  #string of maximum precip

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

g(x)=a*(x-w_c)**beta

# Written out for each temperature (269K-274K) below. 

# initialize:
w_c=20.0  #need to give gnuplot an initial w_c for fitting
beta=setbeta
fit [xmin:xmax] [minP:maxP] g(x) dataFN1.'269'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
ix=2.5/a + w_c
fit [ix:ix+5] [minP:maxP] g(x) dataFN1.'269'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
plot [xmin:xmax] [ymin:ymax]  dataFN1.'269'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 1 t "269"
a269=a
wc0269=w_c
wc269Pmin= 2.5/a269 + wc0269
wc269Pmax=6.0/a269 + wc0269
h269(x)=a269*(x-wc0269)**beta

#w_c=55.0
fit [40:100] [minP:maxP] g(x) dataFN1.'270'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
ix=2.5/a + w_c
fit [ix:ix+5] [minP:maxP] g(x) dataFN1.'270'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
replot  dataFN1.'270'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 3 t "270"
a270=a
wc0270=w_c
wc270Pmin= 2.5/a270 + wc0270
wc270Pmax=6.0/a270 + wc0270
h270(x)=a270*(x-wc0270)**beta

# initialize:
#w_c=63.0
fit [40:100] [minP:maxP] g(x) dataFN1.'271'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
ix=2.5/a + w_c
fit [ix:ix+5] [minP:maxP] g(x) dataFN1.'271'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
replot dataFN1.'271'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 5 t "271"
a271=a
wc0271=w_c
wc271Pmin= 2.5/a271 + wc0271
wc271Pmax=6.0/a271 + wc0271
h271(x)=a271*(x-wc0271)**beta

#w_c=66.0
fit [40:100] [minP:maxP] g(x) dataFN1.'272'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
ix=2.5/a + w_c
fit [ix:ix+5] [minP:maxP] g(x) dataFN1.'272'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
replot dataFN1.'272'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 7  t "272"
a272=a
wc0272=w_c
wc272Pmin= 2.5/a272 + wc0272
wc272Pmax=6.0/a272 + wc0272
h272(x)=a272*(x-wc0272)**beta

#w_c=68.0
fit [40:100] [minP:maxP] g(x) dataFN1.'273'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
ix=2.5/a + w_c
fit [ix:ix+5] [minP:maxP] g(x) dataFN1.'273'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
replot dataFN1.'273'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 4 t "273"
a273=a
wc0273=w_c
wc273Pmin= 2.5/a273 + wc0273
wc273Pmax=6.0/a273 + wc0273
h273(x)=a273*(x-wc0273)**beta

#w_c=70.0
fit [40:100] [minP:maxP] g(x) dataFN1.'274'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
ix=2.5/a + w_c
fit [ix:ix+5] [minP:maxP] g(x) dataFN1.'274'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
replot dataFN1.'274'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 2 t "274"
a274=a
wc0274=w_c
wc274Pmin= 2.5/a274 + wc0274
wc274Pmax=6.0/a274 + wc0274
h274(x)=a274*(x-wc0274)**beta

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

#'print_fit_values.gp' writes the calculated wc and a to ascii files for plotting scripts to access.
load('print_fit_values.gp')
