load('DATASETTINGS.gp')

dataFN1='./GNUPLOTready'.datatimerange.'/bin_'.dataregion.'_T'
#dataFN2='_cwv_num_sumP_sumpsq_numNoP_stderr.dat'
dataFN2='_cwv_num_sumP_sumpsq_numNoP_slp.dat'


load("./FIT_VALUES/T_wc_a_wc0_".dataname."".datatimerange."".dataregion.".gp")

set title dataname." ".dataregion." ".dataperiod." ".datatimerange." NP with Gaussian fit to +/- 0.05 of peak" font "Helvetica, 20"
set xlabel "CWV/w_c"
set ylabel "N_P"
set key top right
unset logscale


# find maximum counts for each T-bin
plot dataFN1.'269'.dataFN2 u ($2-$5)
Amp269=GPVAL_DATA_Y_MAX
plot dataFN1.'270'.dataFN2 u ($2-$5)
Amp270=GPVAL_DATA_Y_MAX
plot dataFN1.'271'.dataFN2 u ($2-$5)
Amp271=GPVAL_DATA_Y_MAX
plot dataFN1.'272'.dataFN2 u ($2-$5)
Amp272=GPVAL_DATA_Y_MAX
plot dataFN1.'273'.dataFN2 u ($2-$5)
Amp273=GPVAL_DATA_Y_MAX
plot dataFN1.'274'.dataFN2 u ($2-$5)
Amp274=GPVAL_DATA_Y_MAX

set logscale y

#Fit 269K data:
x1=0.9	 	#initialize	
sig1=0.05	#initialize
wc=wc269
A1=Amp269
N_P(x)=A1*exp( -((x-x1)/sig1)**2 )
fit [0.7:1.1] N_P(x) dataFN1.'269'.dataFN2 u ($1/wc):($2-$5) via  x1
xR=x1
fit [xR-0.05:xR+0.05] N_P(x) dataFN1.'269'.dataFN2 u ($1/wc):($2-$5) via  x1
fit [x1-0.05:x1+0.05] N_P(x) dataFN1.'269'.dataFN2 u ($1/wc):($2-$5) via sig1
plot [0.6:1.4] [100:1000000]  dataFN1.'269'.dataFN2 u ($1/wc269):($2-$5) t '269'
sig269=sig1
x269=x1
replot Amp269*exp( -((x-x269)/sig269)**2 ) t ''

#Fit 270:
x1=0.9
sig1=0.05
wc=wc270
A1=Amp270
N_P(x)=A1*exp( -((x-x1)/sig1)**2 )
fit [0.7:1.1] N_P(x) dataFN1.'270'.dataFN2 u ($1/wc):($2-$5) via  x1
xR=x1
fit [xR-0.05:xR+0.05] N_P(x) dataFN1.'270'.dataFN2 u ($1/wc):($2-$5) via  x1
fit [x1-0.05:x1+0.05] N_P(x) dataFN1.'270'.dataFN2 u ($1/wc):($2-$5) via sig1
replot  dataFN1.'270'.dataFN2 u ($1/wc270):($2-$5) t '270'
sig270=sig1
x270=x1
replot Amp270*exp( -((x-x270)/sig270)**2 )  t ''

#Fit 271:
x1=0.9
sig1=0.05
wc=wc271
A1=Amp271
N_P(x)=A1*exp( -((x-x1)/sig1)**2 )
fit [0.7:1.1] N_P(x) dataFN1.'271'.dataFN2 u ($1/wc):($2-$5) via  x1
xR=x1
fit [xR-0.05:xR+0.05] N_P(x) dataFN1.'271'.dataFN2 u ($1/wc):($2-$5) via  x1
fit [x1-0.05:x1+0.05] N_P(x) dataFN1.'271'.dataFN2 u ($1/wc):($2-$5) via sig1
replot  dataFN1.'271'.dataFN2 u ($1/wc271):($2-$5) t '271'
sig271=sig1
x271=x1
replot Amp271*exp( -((x-x271)/sig271)**2 ) t ''

#Fit 272:
x1=0.9
sig1=0.05
wc=wc272
A1=Amp272
N_P(x)=A1*exp( -((x-x1)/sig1)**2 )
fit [0.7:1.1] N_P(x) dataFN1.'272'.dataFN2 u ($1/wc):($2-$5) via  x1
xR=x1
fit [xR-0.05:xR+0.05] N_P(x) dataFN1.'272'.dataFN2 u ($1/wc):($2-$5) via  x1
fit [x1-0.05:x1+0.05] N_P(x) dataFN1.'272'.dataFN2 u ($1/wc):($2-$5) via sig1
replot dataFN1.'272'.dataFN2 u ($1/wc272):($2-$5) t '272'
sig272=sig1
x272=x1
replot Amp272*exp( -((x-x272)/sig272)**2 ) t ''

#Fit 273:
x1=0.9
sig1=0.05
wc=wc273
A1=Amp273
N_P(x)=A1*exp( -((x-x1)/sig1)**2 )
fit [0.7:1.1] N_P(x) dataFN1.'273'.dataFN2 u ($1/wc):($2-$5) via  x1
xR=x1
fit [xR-0.05:xR+0.05] N_P(x) dataFN1.'273'.dataFN2 u ($1/wc):($2-$5) via  x1
fit [x1-0.05:x1+0.05] N_P(x) dataFN1.'273'.dataFN2 u ($1/wc):($2-$5) via sig1
replot  dataFN1.'273'.dataFN2 u ($1/wc273):($2-$5) t '273'
sig273=sig1
x273=x1
replot Amp273*exp( -((x-x273)/sig273)**2 ) t ''

