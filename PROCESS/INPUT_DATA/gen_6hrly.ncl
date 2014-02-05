load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;=========================================
;RBN 25JUL11: OUtput for David Neelin's PRECT analysis.

begin

;;;;;;;;;;;;;;;;;;;;;

;out_names = (/"PRECT","TMQ200","TAV200","TMQS200"/)
;out_names = (/"PRECT"/) 


;run_name = "b40.rcp8_5.1deg.007" 
run_name = "b40.20th.track1.1deg.012"

year0 = 1997
year1 = 2000

hist_num = "h3"
dir_in = "/glade/data01/CMIP5/CCSM/csm/"+run_name+"/atm/hist/"
dir_out = "/glade/data01/CMIP5/rneale/"+run_name+"/"+hist_num+"/"

;Pressure ranges for integrals
pbot   = 110000.  ; arbitrary lower level
ptop   = 20000.    ; upper level

;;;;;;;;;;;;;;;;;;;;;;
linlog = 1
rga = 1./9.807

nyears = year1-year0+1
years = ispan(year0,year1,1)

print("Run_name = "+run_name)


do iy=0,nyears-1

  year = years(iy)
  iday_out0 = 0
  
  print("-year = "+year)
  
  fout = addfile(dir_out+run_name+".6hrly."+year+".nc","c") ; One file per output variable
  
  filedimdef(fout,"time",-1,True) 
  fout@date_written = systemfunc("date")
  
  year_files = tostring(year-1)+"-12"
  year_files = year_files+","+tostring(year)+"-??"
  
  files_in = systemfunc("ls -1 "+dir_in+run_name+".cam2."+hist_num+".{"+year_files+"}-??-?????.nc")
  
  nfiles = dimsizes(files_in)
   
  first_output = True

  fin_frac = addfile(dir_in+run_name+".cam2.h0.2005-12.nc","r")
  
  do ifile=0,nfiles-1
    print("--Processing file "+files_in(ifile))
    fin = addfile(files_in(ifile),"r")
    years_in = cd_calendar(fin->time,0)   
    years_in_file = False
    
    idays = ind(years(iy).eq.years_in(:,0))
    if (any(ismissing(idays))) then
      years_in_file = False
    else
      years_in_file = True
    end if
    
    if (.not.years_in_file) then
      print("-no "+year+" days in this file")      
    else
      ndays_out = dimsizes(idays)
      time = fin->time(idays)
      date = fin->date(idays)
      
      if (ndays_out.eq.1) then
        time_bnds = fin->time_bnds
        ps_in = fin->PS
      else
        time_bnds = fin->time_bnds(idays,:)
        ps_in = fin->PS(idays,:,:)
      end if
      
      
; For interpolation to pressure levels.
      
      hyam = fin->hyam
      hybm = fin->hybm
      lon = fin->lon
      lat = fin->lat
      
      
; Calculate variable and add to output file
      
      iday_out1 = iday_out0+ndays_out-1 ; Last time index for this output file
      
; Var calculations.
; PRECT    
      
      print("-PRECT")
      if (ndays_out.eq.1) then
        var_c = fin->PRECC
        var_l = fin->PRECL
      else
        var_c = fin->PRECC(idays,:,:)
        var_l = fin->PRECL(idays,:,:)
      end if
      PRECT = var_c
      PRECT = (/86400.*1000.*(var_c+var_l)/)
      PRECT@long_name = "Total precipitation rate (liq + ice)" 
      PRECT@units = "mm/day"
      delete(var_c)
      delete(var_l)
; TMQ200
      print("-TMQ200")
      if (ndays_out.eq.1) then
        var_q = fin->Q
      else
        var_q = fin->Q(idays,:,:,:)
      end if
; Pressure levels for inetgrals and averages  (copy meta from var_q)
      pm = var_q
      pm = pres_hybrid_ccm (ps_in, 100000., hyam, hybm)   

      pm_lev = pm(time|:,lat|:,lon|:,lev|::-1)
      
      
      TMQ200 = var_q(time|:,lat|:,lon|:,lev|0) 
      TMQ200 = vibeta (pm_lev, var_q(time|:,lat|:,lon|:,lev|::-1),linlog,ps_in,pbot,ptop)

      TMQ200 = (/TMQ200*rga/)
      TMQ200@long_name = "Vertically integrated specific humidity (surface to 200 mb)"
      TMQ200@units = "kg/m2"
      

      delete(var_q)
      
;    vint = vint/(pbot-ptop)  ; normalize [ original units 
; TAV200
; Vertically avaregd temperature
      print("-TAV200")
      if (ndays_out.eq.1) then
        var_t = fin->T
      else
        var_t = fin->T(idays,:,:,:)
      end if
      TAV200 = var_t(time|:,lat|:,lon|:,lev|0)
      TAV200 = vibeta (pm_lev, var_t(time|:,lat|:,lon|:,lev|::-1),linlog,ps_in,pbot,ptop)

      TAV200 = (/TAV200/(ps_in-ptop)/)  ; normalize [ original units 
      TAV200@long_name = "Vertically averaged temperature (surface to 200 mb)"
      TAV200@units = "K"
      
; TMQS200    
; Vertically integrated saturated humditity
      
      print("-TMQS200")
      rh = var_t
      rh = (/100./)
      qsat = var_t
      pm = (/pm/100./) ;now needed in mb
      qsat = mixhum_ptrh (pm, var_t, rh, 2) 
      delete(rh)
      TMQS200 = var_t(time|:,lat|:,lon|:,lev|0)  
      TMQS200 = vibeta (pm_lev, qsat(time|:,lat|:,lon|:,lev|::-1),linlog,ps_in,pbot,ptop)

      TMQS200 = (/TMQS200*rga/)
      TMQS200@long_name = "Vertically integrated saturated specific humidity (surface to 200 mb)"
      TMQS200@units = "kg/m2"
      
      
      delete(var_t)
      delete(qsat)
      delete(pm)
      delete(pm_lev)
      
      if (first_output) then ; Need meta data for first time write
        fout->time_bnds = time_bnds
        fout->date = date
        fout->LANDFRAC = fin_frac->LANDFRAC(0,:,:)
        fout->OCNFRAC = fin_frac->OCNFRAC(0,:,:)
        
        fout->PRECT = PRECT
        fout->TMQ200 = TMQ200
        fout->TAV200 = TAV200
        fout->TMQS200 = TMQS200
      else
        fout->time(iday_out0:iday_out1) = time
        fout->time_bnds(iday_out0:iday_out1,:) = time_bnds
        fout->date(iday_out0:iday_out1) = date

        fout->PRECT(iday_out0:iday_out1,:,:) = PRECT
        fout->TMQ200(iday_out0:iday_out1,:,:) = TMQ200
        fout->TAV200(iday_out0:iday_out1,:,:) = TAV200
        fout->TMQS200(iday_out0:iday_out1,:,:) = TMQS200
      end if
      
      iday_out0 = iday_out1+1 ; First time index for the next output file
      
      delete(ps_in)
      delete(time)
      delete(time_bnds)
      delete(date)
      
      delete(PRECT)
      delete(TMQ200)
      delete(TAV200)
      delete(TMQS200)
      
      first_output = False
      
    end if

    delete(idays)
    delete(fin)
    delete(years_in)
  end do ; File

  delete(fout)
  delete(files_in)

end do ; Year


end

