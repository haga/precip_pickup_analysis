load('cleanup_wcs.gp')
# for printing, set up settings for drawing lines, colors
load('linesettings.gp')

#for automating writing out wc,etc, standardize:
dataregion='epac'
dataname='CCSM4'
dataperiod='Hist'
datatimerange='1981_2000'
dataspecialcondition='_'

REGION='epac'
reg='EPac'
trange='1981_2000'
modelN=trange.' CCSM4 hist '
period ='hist1981_2000'

dataFN1='../'.period.'/GNUPLOTready'.trange.'/bin_'.REGION.'_T'
dataFN2='_cwv_num_sumP_sumpsq_numNoP_slp.dat'

betastr='1'
setbeta=1
beta=1.0
mincnt=9  
mincntp1=mincnt + 1
minP=2.5
minPs='2.5'
maxP=6.0
maxPs='6.0'

# x-axis (CWV) range, default 40-100mm
xmax=100
xmin=40
# y-axis (precip) range, default 0-12mm/h:
ymax=12
ymin=0

set title reg." Historical CCSM4" font "Helvetica, 20"
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
a269a=a
wc269a=w_c
beta269a=beta
wc269Pmin= 2.5/a269a + wc269a
wc269Pmax=6.0/a269a + wc269a
h269(x)=a269a*(x-wc269a)**beta269a
#replot h269(x) lc 1 t ""

#w_c=55.0
fit [40:100] [minP:maxP] g(x) dataFN1.'270'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
ix=2.5/a + w_c
fit [ix:ix+5] [minP:maxP] g(x) dataFN1.'270'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
replot  dataFN1.'270'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 3 t "270"
a270a=a
wc270a=w_c
beta270a=beta
wc270Pmin= 2.5/a270a + wc270a
wc270Pmax=6.0/a270a + wc270a
h270(x)=a270a*(x-wc270a)**beta270a
#replot h270(x) lc 3 t ""

# initialize:
#w_c=63.0
fit [40:100] [minP:maxP] g(x) dataFN1.'271'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
ix=2.5/a + w_c
fit [ix:ix+5] [minP:maxP] g(x) dataFN1.'271'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
replot dataFN1.'271'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 5 t "271"
a271a=a
wc271a=w_c
beta271a=beta
wc271Pmin= 2.5/a271a + wc271a
wc271Pmax=6.0/a271a + wc271a
h271(x)=a271a*(x-wc271a)**beta271a
#replot h271(x) lc 5 t ""

#w_c=66.0
fit [40:100] [minP:maxP] g(x) dataFN1.'272'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
ix=2.5/a + w_c
fit [ix:ix+5] [minP:maxP] g(x) dataFN1.'272'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
replot dataFN1.'272'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 7  t "272"
a272a=a
wc272a=w_c
beta272a=beta
wc272Pmin= 2.5/a272a + wc272a
wc272Pmax=6.0/a272a + wc272a
h272(x)=a272a*(x-wc272a)**beta272a
#replot h272(x) lc 7 t ""

#w_c=68.0
fit [40:100] [minP:maxP] g(x) dataFN1.'273'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
ix=2.5/a + w_c
fit [ix:ix+5] [minP:maxP] g(x) dataFN1.'273'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
replot dataFN1.'273'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 4 t "273"
a273a=a
wc273a=w_c
beta273a=beta
wc273Pmin= 2.5/a273a + wc273a
wc273Pmax=6.0/a273a + wc273a
h273(x)=a273a*(x-wc273a)**beta273a
#replot h273(x) lc 4 t ""

#w_c=70.0
fit [40:100] [minP:maxP] g(x) dataFN1.'274'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
ix=2.5/a + w_c
fit [ix:ix+5] [minP:maxP] g(x) dataFN1.'274'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c,a
replot dataFN1.'274'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 2 t "274"
a274a=a
wc274a=w_c
beta274a=beta
wc274Pmin= 2.5/a274a + wc274a
wc274Pmax=6.0/a274a + wc274a
h274(x)=a274a*(x-wc274a)**beta274a
#replot h274(x) lc 2 t ""

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

