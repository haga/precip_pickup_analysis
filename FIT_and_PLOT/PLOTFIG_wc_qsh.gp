load('DATASETTINGS.gp')

set title "Saturation and critical values ".dataname." ".dataperiod." ".datatimerange
set xlabel "Tropospheric temperature T (K)" font "Helvetica, 18"
set ylabel "CWV (mm)" font "Helvetica, 18"
set key top left
unset logscale

saturationFN='./GNUPLOTready'.datatimerange.'/QofT_'.dataregion.'CONDq60_T_QSH.dat'
criticalFN='./FIT_VALUES/T_wc_a_wc0_'.dataname.''.datatimerange.''.dataregion.'.dat'

plot [268.1:276] [40:100] saturationFN  u ($1):($2) t  "qsathat"
replot criticalFN  u ($1):($2) t "w_c"


# include if want fit lines:
#initialize
MQ=0
BQ=0
MWC=0
BWC=0

fitQ(x)=MQ*x + BQ
fit [269:274] [40:100] fitQ(x) saturationFN u ($1):($2) via MQ,BQ
replot fitQ(x) t ""
fitWC(x)=MWC*x + BWC
fit [269:274] [40:100] fitWC(x) criticalFN u ($1):($2) via MWC,BWC
replot fitWC(x) t ""
