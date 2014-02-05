load('cleanup_wcs.gp')

#for automating writing out wc,etc, standardize:
dataregion='epac'
dataname='TMIERA'
dataperiod='Hist'
datatimerange='121997-082002'
dataspecialcondition='_'

# first fit all three vars: wc a and beta for "nice looking" curves to see
# what betas turn up...
REGION='epac'
reg='EPac'
trange='121997-082002' 
modelN=trange.' TMI-ERA40 '
period ='hist1981_2000'

#  /Users/katrina/WORK/Research/OBS_DATA/ERA_TMI
#  process_v2/GNUPLOT_DATA/epacT270var.dat

dataFN1='../../../ERA_TMI/process_v2/GNUPLOT_DATA/'.REGION.'T' 
dataFN2='.dat'  # or 'var.dat'
# dataFN1='../'.period.'/GNUPLOTready'.trange.'/bin_'.REGION.'_T'
# dataFN2='_cwv_num_sumP_sumpsq_numNoP_slp.dat'

betastr='0.23'
setbeta=0.23
beta=0.23
mincnt=4
mincntp1=mincnt + 1
minP=2.5
minPs='2.5'

set title reg." ".modelN." P(w) with fits for different T-hat, beta=".betastr font "Helvetica, 20"
set xlabel "CWV (mm)" font "Helvetica, 18"
set ylabel "P (mm/hr)" font "Helvetica, 18" #\n only including bins with >= ".mincntp1." count and P>=".minPs."mm/hr"
set key top left
unset logscale

# from the fitting without fixed slope (a) get:
#gnuplot> print a269a
#4.7315390249379
#gnuplot> print a270a
#4.78652505870824
#gnuplot> print a271a
#4.857083313057
#gnuplot> print a272a
#4.88794083153116
#gnuplot> print a273a
#4.74992210175045
#gnuplot> print a274a
#4.47179179199926

# USE T=271,272,273,274
aave=(4.857083313057+4.88794083153116+4.74992210175045+4.47179179199926)/4
a=4.74

g(x)=a*((x-w_c)**beta)


# initialize:
beta=setbeta
w_c=50.0
fit [40:100] [minP:20] g(x) dataFN1.'268'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'268'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'268'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'268'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
ci=w_c
#plot [40:85] [0:20] dataFN1.'268'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) t "268"
plot [45:85] [0:20] dataFN1.'268'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) t "268"
#replot dataFN1.'268'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) t "268"
a268a=a
wc268a=w_c
beta268a=beta
h268(x)=a268a*(x-wc268a)**beta268a
replot h268(x) t "268"


#  NOTE, T269 and T270 are not fitting properly -- shifting wc to TOO HIGH, isolated and re-fit including BY EYE get:
#gnuplot> print wc269a
#58.9619546471854
#gnuplot> print wc270a
#60.9900357478139

# initialize:
beta=setbeta
w_c=50.0
w_c=55.0
fit [40:100] [minP:20] g(x) dataFN1.'269'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'269'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'269'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'269'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
ci=w_c
plot [45:85] [0:20]  dataFN1.'269'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 1 t "269"
a269a=a
wc269a=w_c
wc269a=58.961954647185
beta269a=beta
h269(x)=a269a*(x-wc269a)**beta269a
replot h269(x) lc 1 t ""


w_c=55.0
w_c=61.0
fit [40:100] [minP:20] g(x) dataFN1.'270'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'270'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'270'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'270'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
replot  dataFN1.'270'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 3 t "270"
a270a=a
wc270a=w_c
wc270a=60.990035747813
beta270a=beta
h270(x)=a270a*(x-wc270a)**beta270a
replot h270(x) lc 3 t ""

# initialize:
w_c=63.0
fit [40:100] [minP:20] g(x) dataFN1.'271'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'271'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'271'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'271'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
replot dataFN1.'271'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 5 t "271"
a271a=a
wc271a=w_c
beta271a=beta
h271(x)=a271a*(x-wc271a)**beta271a
replot h271(x) lc 5 t ""

w_c=66.0
fit [40:100] [minP:20] g(x) dataFN1.'272'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'272'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'272'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'272'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
replot dataFN1.'272'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 7 t "272"
a272a=a
wc272a=w_c
beta272a=beta
h272(x)=a272a*(x-wc272a)**beta272a
replot h272(x) lc 7 t ""

w_c=68.0
fit [40:100] [minP:20] g(x) dataFN1.'273'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'273'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'273'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'273'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
replot dataFN1.'273'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 4 t "273"
a273a=a
wc273a=w_c
beta273a=beta
h273(x)=a273a*(x-wc273a)**beta273a
replot h273(x) lc 4 t ""

w_c=70.0
fit [40:100] [minP:20] g(x) dataFN1.'274'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'274'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'274'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
fit [40:100] [minP:20] g(x) dataFN1.'274'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
replot dataFN1.'274'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 2 t "274"
a274a=a
wc274a=w_c
beta274a=beta
h274(x)=a274a*(x-wc274a)**beta274a
replot h274(x) lc 2 t ""

# # initialize:
# beta=setbeta
# w_c=50.0
# fit [40:100] [minP:20] g(x) dataFN1.'269'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
# fit [40:100] [minP:20] g(x) dataFN1.'269'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
# fit [40:100] [minP:20] g(x) dataFN1.'269'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
# fit [40:100] [minP:20] g(x) dataFN1.'269'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
# ci=w_c
# replot  dataFN1.'269'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 1 t "269"
# a269a=a
# wc269a=w_c
# beta269a=beta
# h269(x)=a269a*(x-wc269a)**beta269a
# replot h269(x) lc 1 t ""

