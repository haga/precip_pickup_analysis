# Set region, name, etc for set of figures:
dataregion='epac'
dataname='CCSM4'
dataperiod='Hist'
datatimerange='1981_2000'
dataspecialcondition='_'

# clears any old values of wc
load('cleanup_wcs.gp')
# for printing, set up settings for drawing lines, colors
load('linesettings.gp')
