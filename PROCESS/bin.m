%%---------------------------------------------------------
%% Original code: Ole Peters 2008-2009
%% Modifications: Katrina Hales 2009-January 2014
%% Scientific supervision: J David Neelin
%% For related publications and research information see
%%   the Neelin group webpage  http://www.atmos.ucla.edu/~csi/
%%---------------------------------------------------------

%%% Set parameter values: 

%resolution of data
xres=288
yres=192

% Read in regions.  This file specific to the resolution.  
% Tropical ocean basins (20N-20S) 1-Western Pacific, 2-Eastern Pacific, 3-Atlantic, 4-Indian, 0-elsewhere
load('./REGIONS_ccsm4_288x86.mat' )
region=zeros(288,192);
region(:,54:139)=regionLowRes;
number_regions=4;

% Set Range of Temperature bins: (We used range of 260 to 280 for both historical and end-of-century analysis)
% If doing the analysis over land, or LGM or other condition where need to check different temperature range, 
% adjust here.
% Temperature bins are 1K.
That_min=260;
That_max=280;
Toffset = That_min - 1;
number_T_bins = That_max - That_min + 1;

% Default size of cwv bins is 0.5mm
cwv_bin_size=0.5

% Range of column water vapor is 0 to 100mm.
% Number of water vapor bins is 100 (mm, default range) divided by bin size:
number_cwv_bins=100/cwv_bin_size;

% Preallocate storage for the binned precip and saturation
PrecMoments=5;
BIN=zeros(number_regions,number_T_bins,number_cwv_bins,PrecMoments);
QSH=zeros(number_regions,number_T_bins,2);

% The data read in here is preprocessed into annual files, one for each year of each of the variables
% (see script gen_6hrly.ncl from R.Neale for calculation/output of these variables)
% Precip (mm/day)	 	(PRECT - Total precipitation)
% Temperature (K) 		(TAV200 -Average temperature up to 200mb)
% Column water vapor (kg/m2) 	(TMQ200 - Precipitable (vertically integrated) water up to 200mb)
% Column saturation (kg/m2)	(TMQS200 - Vertically integrated saturated water vapor up to 200mb)

% (Note regarding preprocessing: This script was developed when it was most 
% efficient to preprocess the data. To read the netcdf model output files directly, can use
% ncread and related tools in MATLAB (see eg http://www.mathworks.com/help/matlab/ref/ncread.html).)

% Set startyear and endyear for data range, 
% this starts with 00Z01Jan of startyear and ends 18Z31Dec of endyear
startyear=1981;
endyear=2000;
% create directory for output
!mkdir ../FIT_and_PLOT/GNUPLOTready1981_2000

%%% End set parameter section 


for year=startyear:endyear

% Read in preprocessed data
temp_filename=sprintf('../INPUT_DATA/CCSM_MAT/PREC_%s',num2str(year))
load(temp_filename)  % loads 'prec'  Total precipitation
temp_filename=sprintf('../INPUT_DATA/CCSM_MAT/TEMP_%s',num2str(year))
load(temp_filename)  % loads 'tave'  Column Temperature
temp_filename=sprintf('../INPUT_DATA/CCSM_MAT/CWV_%s',num2str(year))
load(temp_filename)  % loads 'cwv'  Column water vapor
temp_filename=sprintf('../INPUT_DATA/CCSM_MAT/QSAT_%s',num2str(year))
load(temp_filename)  % loads 'qsat'  Column saturation

for day=1:365 %does not account for leap years; the data I have been looking at has 365day years
for hour=1:4
for j=1:yres
for i=1:xres

% assign indecies for region, temperature and water vapor for bins
%REGION
reg=uint16(region(i,j));

%TROPOSPHERIC AVERAGE TEMPERATURE
temp=uint16(tave(i,j,day,hour)-Toffset); 

%COLUMN WATER VAPOR
%no offset and one bin per 0.5 mm is default, adjust 'cwv_bin_size' above to change
vapor_index=uint16(round(cwv(i,j,day,hour)/cwv_bin_size));

%PRECIPITATION
% Units of input precip data are mm/day, so here convert to mm/hour 
rain=prec(i,j,day,hour)/24;

%SATURATION
qhat=qsat(i,j,day,hour);
vapor=cwv(i,j,day,hour);  %need cwv (not the index) in order to apply condition on saturation

% BIN PRECIPITATION
% check if data point is in region, Temp range and valid cwv range:
if((reg>0)&(temp>0)&(temp<=number_T_bins)&(vapor_index>0)&(vapor_index<=number_cwv_bins))

% in first index position, keep count of valid data
BIN(reg,temp,vapor_index,1)=BIN(reg,temp,vapor_index,1) + 1;

% in 2nd and 3rd index positions, sum rain rates 1st and second moments
BIN(reg,temp,vapor_index,2)=BIN(reg,temp,vapor_index,2) + rain;
BIN(reg,temp,vapor_index,3)=BIN(reg,temp,vapor_index,3) + rain*rain;

% in 4th index position, keep count of the number of valid points that are non-precipitating
% the default criteria for non-precipitating is <=0.1mm/h
if(rain<=0.1)  
BIN(reg,temp,vapor_index,4)=BIN(reg,temp,vapor_index,4) + 1;
end  %end if for non-precip points

% Also bin saturation by temperature:
% using a minimum condition of moisture (tmq200=cwv=vapor) to include in calc of qsathat
if(vapor>=0.6*qhat)
%Count in 1st index
QSH(reg,temp,1)=QSH(reg,temp,1) + 1;
%Sum in 2nd index
QSH(reg,temp,2)=QSH(reg,temp,2) + qhat;
end  %end if for 60% wc vapor / or if above temp dependent watervap threshold


end  %end if for valid range of index values

end  %end loop for i
end  %end loop for j
end  %end loop for hour time increment
end  %end loop for day time increment
end  %end loop for year

% save and write out data to column format for plotting with gnuplot
save('./OUTPUT_BINNED_DATA','BIN','QSH');


% To plot with gnuplot need data in column ascii format.  
% In next section, data written out as individual files for plotting and next analysis with gnuplot.

%label regions:
for(reg=1:4)
if(reg==1)
region_name='wpac';
end
if(reg==2)
region_name='epac';
end
if(reg==3)
region_name='atl';
end
if(reg==4)
region_name='ind';
end

% Write out the column ascii files to directory 'GNUPLOTready', labeled by region and temp bins.
% This writes two versions of the precip data.  
% In gnuplot to plot with error bars, need separate file of data in 3 columns, 
% so first file format is to plot with error bars.  Columns are cwv, ave Precip, and standard error.
% Second file format is to do the main set of figures.  Columns are cwv, count, sum Precip, 
% sum of squared Precip,
% number non-precipitating, and standard error.
% Final file written is saturation binned by Temperature (count, sum)

for(Ti=1:number_T_bins)
        Tbin=Ti+Toffset;
% set up file name for plot of P(T,cwv) with error bars:
filename1=sprintf('../FIT_and_PLOT/GNUPLOTready%s_%s/bin_%s_T%s_cwv_P_stderr.dat',num2str(startyear),num2str(endyear),region_name,num2str(Tbin));
save_id1=fopen(filename1,'w');

% set up file name for set of standard plots:
filename2=sprintf('../FIT_and_PLOT/GNUPLOTready%s_%s/bin_%s_T%s_cwv_num_sumP_sumpsq_numNoP_stderr.dat',num2str(startyear),num2str(endyear),region_name,num2str(Tbin));
save_id2=fopen(filename2,'w');

% write two files for each region and Temperature bin:
for(w=1:number_cwv_bins)
if(BIN(reg,Ti,w,1)>0)
        cwv=w*cwv_bin_size;
        num=BIN(reg,Ti,w,1);
        sumP=BIN(reg,Ti,w,2);
        sumPsq=BIN(reg,Ti,w,3);
        numNoP=BIN(reg,Ti,w,4);
        stderr= sqrt(sumPsq/num - (sumP/num)*(sumP/num)) / sqrt(num);
  fprintf(save_id1,'%f %f %f \n',cwv,sumP/num,stderr);
  fprintf(save_id2,'%f %f %f %f %f %f\n',cwv,num,sumP,sumPsq,numNoP,stderr);
end
end
fclose(save_id1);
fclose(save_id2);
end

% saturation data:
filename3=sprintf('../FIT_and_PLOT/GNUPLOTready%s_%s/QofT_%sCONDq60_T_QSH.dat',num2str(startyear),num2str(endyear),region_name);
save_id3=fopen(filename3,'w');

for(Ti=1:number_T_bins)
if(QSH(reg,Ti,1)>0)
Tbin=Ti+Toffset;
  fprintf(save_id3,'%f %f \n',Tbin,QSH(reg,Ti,2)/QSH(reg,Ti,1));
end  %end if test >0
end  %end loop over Tbin
fclose(save_id3);

end  %end loop over regions

% To be more automated, at this point could find the most populous temperature bin and select some range
% around that value.  What seems sensible is to select a range of 2 less than the Temp-bin with the maximum 
% count and 3 above, to have total of 6 temperature bins to plot.
% For historical CCSM4 data, we looked at 6 temperature bins.  For the end of century data (rcp8.5), 
% we tended to look at more temperature bins, with 
% more on the lower end of the range to see overlap with temperature bins analysed in historical data.
