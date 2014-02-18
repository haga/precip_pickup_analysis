## 'alternate_fit.gs'  gnuplot script to find critical water vapor values
##
## Included as sample of alternate method of finding critical values, 
## not set up here to run with same settings/parameters/data as 'calculate_fit.gs'
## Before this script run, similar script needs to be run to find fits for parameters 
## (beta and slope (a) and critical watervapor (wc)), then fix 
## beta and a to find fit values of critical water vapor (wc) in this script.
## Details below are an example from ERA40-TMI dataset. 


#for automating writing out wc,etc, standardize:
dataregion='epac'
dataname='TMIERA'
dataperiod='Hist'
datatimerange='121997-082002'
dataspecialcondition='_'

REGION='epac'
reg='EPac'
trange='121997-082002' 
modelN=trange.' TMI-ERA40 '

dataFN1='../../../ERA_TMI/process_v2/GNUPLOT_DATA/'.REGION.'T' 
dataFN2='.dat'  # or 'var.dat'

a=4.74   	 #from previous fitting, find slope(a) average, here set to 4.74
betastr='0.23' 	 #from previous fitting, find beta average, here set to 0.23
setbeta=0.23
beta=0.23
mincnt=4
mincntp1=mincnt + 1
minP=2.5
minPs='2.5'

set title reg." ".modelN." P(w) with fits for different T-hat, beta=".betastr font "Helvetica, 20"
set ylabel "P (mm/hr)" font "Helvetica, 18" #\n only including bins with >= ".mincntp1." count and P>=".minPs."mm/hr"
set key top left
unset logscale

g(x)=a*((x-w_c)**beta)


# initialize:
beta=setbeta
w_c=55.0
fit [40:100] [minP:20] g(x) dataFN1.'269'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
ci=w_c
plot [45:85] [0:20]  dataFN1.'269'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 1 t "269"
a269a=a
wc269a=w_c
wc269a=58.961954647185
beta269a=beta
h269(x)=a269a*(x-wc269a)**beta269a
replot h269(x) lc 1 t ""


# # initialize:
w_c=61.0
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
replot dataFN1.'271'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 5 t "271"
a271a=a
wc271a=w_c
beta271a=beta
h271(x)=a271a*(x-wc271a)**beta271a
replot h271(x) lc 5 t ""

# # initialize:
w_c=66.0
fit [40:100] [minP:20] g(x) dataFN1.'272'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
replot dataFN1.'272'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 7 t "272"
a272a=a
wc272a=w_c
beta272a=beta
h272(x)=a272a*(x-wc272a)**beta272a
replot h272(x) lc 7 t ""

# # initialize:
w_c=68.0
fit [40:100] [minP:20] g(x) dataFN1.'273'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
replot dataFN1.'273'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 4 t "273"
a273a=a
wc273a=w_c
beta273a=beta
h273(x)=a273a*(x-wc273a)**beta273a
replot h273(x) lc 4 t ""

# # initialize:
w_c=70.0
fit [40:100] [minP:20] g(x) dataFN1.'274'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) via w_c
replot dataFN1.'274'.dataFN2 u ($1):($3/$2)*($2-mincnt)/(abs($2-mincnt)) lc 2 t "274"
a274a=a
wc274a=w_c
beta274a=beta
h274(x)=a274a*(x-wc274a)**beta274a
replot h274(x) lc 2 t ""

