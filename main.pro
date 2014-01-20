;;--------------------------------------------------------
;; This program is written in IDL (Interactive Data Language)
;;   see http://www.exelisvis.com/ProductsServices/IDL/Language.aspx
;; This program is provided as-is and WITHOUT ANY WARRANTY;
;; without even the implied warranty of MERCHANTIBILITY or FITNESS
;; FOR A PARTICULAR PURPOSE. You are allowed to redistribute it
;; and/or modify it AT YOUR OWN RISK.
;;
;; Radiative convective equilibrium calculation using entraining plumes
;; Adapted from Entraining plume calculation in
;;  Sahany, S., J. D. Neelin, K. Hales, and R. Neale: 
;;   Temperature-moisture dependence of the deep convective transition as a
;;   constraint on entrainment in climate models. 
;;   J. Atmos. Sci., 69, 1340–1358, doi:10.1175/JAS-D-11-0164.1.
;;   Supported in part by 
;;     National Science Foundation Grant AGS-1102838, 
;;     National Oceanic and Atmospheric Admin. NA11OAR4310099,
;;    & Dept. of Energy Grant DE-SC0006739 (J.D. Neelin, PI)
;;
;; Based on entraining plume calculation in
;;   Holloway, C. E. and J. D. Neelin: 
;;   Moisture vertical structure, column water vapor, and tropical deep
;;   convection.
;;   J. Atmos. Sci., 66, 1665-1683. DOI: 10.1175/2008JAS2806.1
;;  Supported in part by National Science Foundation ATM-0082529,
;;   National Oceanic and Atmospheric Admin. NA05OAR4311134 
;;   (J.D. Neelin, PI)
;;
;; The radiosonde and gauge data is provided by 
;; the U.S. Department of Energy (DOE) as part of the
;; Atmospheric Radiation Measurement (ARM) Climate Research Facility.
;; Stokes, G. M., and S. E. Schwartz, 1994: The Atmospheric 
;; Radiation Measurement (ARM) program: Programmatic background
;; and design of the cloud and radiation testbed. Bull.
;; Amer. Meteor. Soc., 75, 1201–1221.
;; Mather, J. H., T. P. Ackerman, W. E. Clements, F. J. Barnes, M. D.
;; Ivey, L. D. Hatfield, and R. M. Reynolds, 1998: An atmospheric 
;; radiation and cloud station in the tropical western
;; Pacific. Bull. Amer. Meteor. Soc., 79, 627–642.
;;
;; Please follow ARM data sharing policy as per the
;; Data Attribution and Publication section of their
;; Data Sharing and Distribution Policy outlined at
;; http://www.arm.gov/data/docs/policy
;; We gratefully acknowledge the U.S. DOE for 
;; providing the data.
;; Original code: Chris Holloway, June 2007-October 2009
;; Modifications: Sandeep Sahany, October 2009-November 2013
;; Scientific supervision J David Neelin June 2007-November 2013
;; For related publications and research information see 
;;   the Neelin group webpage  http://www.atmos.ucla.edu/~csi/
;;---------------------------------------------------------

;;---------------------------------------------------------
;; Modifications for A. K. Tripati, S. Sahany, D. Pittmann, R. A. Eagle, J. ;; D. Neelin, J. L. Mitchell, L. Beaufort,  
;;  Nature Geosciences, 2013, as noted below
;;---------------------------------------------------------

;;---------------------------------------------------------
;; Reading data from pre-processed radiosonde observations over Nauru
;; an ARM site over the tropical western Pacific
;; for the period Apr 1, 2001 to Aug 16 2006 
;;----------------------------------------------------------

;; Change the path of data_download_dir

data_download_dir = '/home/sandeep/work/ucla_papers/lgm_warm_pool/scripts/'
file = data_download_dir + 'armsonde_20010401-20060816.dat'

restore, file

;; Some pressure levels used in the code

presnum = n_elements(pres)
pr1000 = where(pres eq 1000.)
pr1000 = pr1000(0)

pr800 = where(pres eq 800.)
pr800 = pr800(0)

pr200 = where(pres eq 200.)
pr200 = pr200(0)

;; Most of the variables
;; are defined here

tdry_mean = findgen(presnum)*!values.f_nan
qdp_mean = findgen(presnum)*!values.f_nan
rh_mean = findgen(presnum)*!values.f_nan
rh_precip_nauru_mean0_w = findgen(presnum) * !values.f_nan
rh_precip_nauru_mean1_w = findgen(presnum) * !values.f_nan
rh_precip_nauru_mean2_w = findgen(presnum) * !values.f_nan
rh_precip_nauru_mean3_w = findgen(presnum) * !values.f_nan
rh_precip_nauru_w       = findgen(presnum,13) * !values.f_nan
del_z = findgen(presnum)* !values.f_nan
alt_mean = findgen(presnum)*!values.f_nan
entr_per_5hPa = findgen(presnum)* !values.f_nan
entr_per_pa = findgen(presnum)* !values.f_nan
dpres = findgen(presnum)* !values.f_nan

;; Thermodynamic constants

;; Note that the freezing level is set to -10 C instead of 0 C.
;; Freezing process typically occurs over a large depth after ascent
;; past the freezing level. Since all the physics considered here
;; is below the freezing level, formation of ice is simply lagged
;; as complex microphysics are not warranted for our purpose.
;; This has also been done for the moist physics treatment
;; in some versions of the NCAR Community Atmosphere Model
;; Rasch, P. J. and Kristjánsson, J. E. 1998: A Comparison of
;; the CCM3 Model Climate Using Diagnosed and Predicted Condensate
;; Parameterizations.Journal of Climate, vol. 11, Issue 7, pp.1587-1614.
;; If considering processes in the upper troposphere replace this with
;; detailed microphysics.

tmelt = 263.15
es0 = 610.78
grav = 9.81
es02 = 3168.0
t02 = 298.16
CPD = 1005.7
CPV = 1870.0
CL = 4190.0
CPVMCL = 2320.0
RV = 461.5
RD = 287.04
EPS = RD/RV
ALV0 = 2.501E6
LF0 = 0.3337E6
LV0 = 2.501E6

;; get qdp from 1000-200 hPa only:

qdpforpcomp = qdpinttpw

;; get sum of qdpforpcomp for each column
;; excluding missing values

qdpforpcomptotal = total(qdpforpcomp, 1)
qdpforpcompfinind = where(finite(qdpforpcomptotal))
qdpforpcompfin = qdpforpcomp(*,qdpforpcompfinind)

;; Settings for the Altitude of the environment

alt_mean(2) = 13.67
alt_mean(3) = 40.63
alt_mean(4) = 84.30
del_z(3) = alt_mean(3) - alt_mean(2)
del_z(4) = alt_mean(4) - alt_mean(3)

;; Mixing Coefficient

entr_per_pa(0:presnum-1) = 0.00 / 500.
dpres(1:presnum-1) = (pres(0:presnum-2) - pres(1:presnum-1)) * 100.
dpres(0) = dpres(1)
entr_per_5hPa(0:presnum-1) = entr_per_pa(0:presnum-1) * dpres

;; Get sonde arrays excluding the ones with missing values
;; These can be used to produce observed profiles, both
;; unconditioned as well as conditioned on CWV
;; The sonde-data is not needed for RCE computations.
;; They are being used as dummy values for some of the
;; variables that need some value during the first loop.
;; The first loop is an adiabat and hence needs just the
;; temperature and specific humidity at the initiation level

  tdryfin = tdry(*,qdpforpcompfinind)
  rhfin = rh(*,qdpforpcompfinind)
  qdpfin = qdp(*,qdpforpcompfinind)
  qdptpwfin = qdptpw(qdpforpcompfinind)
  dayhrstrfin = dayhrstr(*,qdpforpcompfinind)
  tconvecfin = tconvec(qdpforpcompfinind)
  thatfin = t1000_to_200(qdpforpcompfinind)
  
;; Get top qdptpw bins (set -1 to 65 below, when needed)

  qdptpwfinhiind = where(qdptpwfin gt -1.)
  tdryfin = tdryfin(*,qdptpwfinhiind)
  rhfin = rhfin(*,qdptpwfinhiind)
  qdpfin = qdpfin(*,qdptpwfinhiind)
  qdptpwfin = qdptpwfin(qdptpwfinhiind)
  dayhrstrfin = dayhrstrfin(*,qdptpwfinhiind)
  tconvecfin = tconvecfin(qdptpwfinhiind)
  thatfin = thatfin(qdptpwfinhiind)
  
;; Conditioning tempr. for the high CWV bins
;; so as to choose only the ones conducive
;; for deep convection

  crit_ind = where(qdptpwfin gt 65.)
  len = size(crit_ind)
  len = len(3)
  tdryfin_cr = findgen(presnum,len)* !values.f_nan
  tdryfin_cr = tdryfin(*,crit_ind)
  
  nfin = n_elements(qdptpwfinhiind)
  pres_fin = fltarr(presnum,nfin) * !values.f_nan
 
 
;; May need to change num_iter depending on the number of iterations
;; it takes for convergence of environment temperature profile under
;; RCE, but around 15-20 iterations is typical  

  num_iter = 16
  temp_parcel_all = fltarr(presnum,num_iter) * !values.f_nan
  
  q_env = qdpfin
  temp_env = tdryfin
  
  temp_mean = findgen(presnum) * !values.f_nan
    
  q_env_sat = fltarr(presnum,nfin) * !values.f_nan
  temp_prescribed = fltarr(presnum,num_iter) * !values.f_nan
  temp_prescribed_mean = fltarr(num_iter) * !values.f_nan
  temp_diff = fltarr(num_iter) * !values.f_nan
  rel_hum = fltarr(presnum) * !values.f_nan
 
;; Load the pre-processed file from Nauru data
;; The file contains mean radiosonde RH profiles conditioned
;; on 3-hrly precipitation from rain gauge data
;; The 3-hrly precip. is centered around the sonde launch time
;; The precipitation bins are the same as in Fig. 4a of
;; Holloway and Neelin 2009

file = data_download_dir + 'rh_precip_nauru_3hr.dat'  
restore, file

bin_cnt = [2464, 146, 102, 92, 63, 75, 61, 79, 84, 98, 67, 48, 19] ; 3-hr bin

for i=0L, 12L do begin
  rh_precip_nauru_w(*,i) = rh_precip_nauru_3hr(*,i) * bin_cnt(i)
endfor  

;; Standard case - bins 2:12 (0.005 mm/h - 10.24 mm/hr)

for i=0L, presnum-1L do begin
  rh_precip_nauru_mean0_w(i) = total(rh_precip_nauru_w(i,0:12)) / total(bin_cnt(0:12)) 
  rh_precip_nauru_mean1_w(i) = total(rh_precip_nauru_w(i,2:12)) / total(bin_cnt(2:12)) 
  rh_precip_nauru_mean2_w(i) = total(rh_precip_nauru_w(i,7:12)) / total(bin_cnt(7:12))
  rh_precip_nauru_mean3_w(i) = total(rh_precip_nauru_w(i,8:12)) / total(bin_cnt(8:12))
endfor

;; RH bins for Nauru conditioned on precip

;; To produce the vertical temperature profiles for the LGM
;; similar to that in Fig. 3e, uncomment and make the 
;; corresponding changes to
;; rel_hum(pr800:presnum-1) = rel_hum(pr800:presnum-1) + xx
;; and to t_sfc below
 
    rel_hum(0:1) = rh_precip_nauru_mean1_w(2)/100.
      
    for i= 2L, presnum-1L do begin
     rel_hum(i) = rh_precip_nauru_mean1_w(i)/100.
    endfor
    
    ;rel_hum(pr800:presnum-1) = rel_hum(pr800:presnum-1) + 0.01
      
;; Check RH doesn't exceed 100 %

    for i= 0L, presnum-1L do begin
      if (rel_hum(i) gt 1.) then rel_hum(i) = 1.
    endfor

;; Set initial temperature of the parcel in Kelvin

t_sfc = 28.0 + 273.15

;;-------------------------------------------------------------------
;; End of Data Input Section
;;-------------------------------------------------------------------

;;-------------------------------------------------------------------
;; RCE Iterations Start here
;;-------------------------------------------------------------------

  loop_num    = 0

  for m= 0L, num_iter-1L do begin 
  
    tdryfin_cr(0:pr1000,0) = t_sfc

    if(loop_num eq 0) then temp_env(*,0) = tdryfin_cr(*,0)
    
      for i= 0L, presnum-1L do begin
        q_env_sat(i,0) = qs_calc(pres(i), temp_env(i,0))
      endfor
  
;; Compute specific humidity of the environment
    
    for i= 0L, presnum-1L do begin
      q_env(i,0) = q_env_sat(i,0) * rel_hum(i)
    endfor
      
    pres_fin(*,0) = pres
      
;; Get the following variables for the environment
;; theta_il_env - Ice liquid Potential Temp.
;; temp_v_env - Virtual Temperature

      theta_il_env = theta_il_calc(pres_fin, temp_env, q_env, 0., 0.)
      temp_v_env = temp_v_calc(temp_env, q_env, 0.)
      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; do parcel profile computation, 
;;;    including mixing of entrained air
;;;   mixing parameter entr_per_5hPa is being set earlier;
;;;   In the RCE iteration, first pass uses 0 entrainment
;;;   to get adiabatic first approximation to temperature profile
;;;   then iterates with full entrainment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

      theta_il_parcel = pres_fin * !values.f_nan
      qt_parcel = pres_fin * !values.f_nan
      temp_parcel = pres_fin * !values.f_nan
      qs_parcel = pres_fin * !values.f_nan
      q_parcel = pres_fin * !values.f_nan
      ql_parcel = pres_fin * !values.f_nan
      qi_parcel = pres_fin * !values.f_nan

      
;;--------Parcel starts from 1000 hPa with properties same as environment
      
      p_init = where(pres eq 1000.)
      p_init = p_init(0)
      
;; Conserved Variables      
      theta_il_parcel(p_init,*) = theta_il_env(p_init,*)
      qt_parcel(p_init,*) = q_env(p_init,*)
      
;; Other Variables
      temp_parcel(p_init,*) = temp_env(p_init,*)
      q_parcel(p_init,*) = q_env(p_init,*)
      ql_parcel(p_init,*) = 0.0
      
;; Loop through each level

        freeze = 0
        for i = p_init+1, presnum-1 do begin
          theta_il_parcel(i,0) = (theta_il_parcel(i-1,0) * (1.-entr_per_5hPa(i-1))) $
            + (theta_il_env(i-1,0) * entr_per_5hPa(i-1))
          qt_parcel(i,0) = (qt_parcel(i-1,0) * (1.-entr_per_5hPa(i-1))) $
            + (q_env(i-1,0) * entr_per_5hPa(i-1))

          if (finite(theta_il_parcel(i,0)) and finite(qt_parcel(i,0))) then begin

            if (freeze eq 0) then begin

;; Get Parcel Temperature
              temp_parcel(i,0) = temp_calc(pres(i), theta_il_parcel(i,0), qt_parcel(i,0))

;; If temp below tmelt -------------------
;; convert liquid water to ice in one (irreversible) step 
;; (K. Emanuel 1994, Atmospheric Convection, Oxford UP, p. 139):

              if (temp_parcel(i,0) le tmelt) then begin
                qs_fr = qs_calc(pres(i), temp_parcel(i,0))
                q_fr = qt_parcel(i,0) < qs_fr
                ql_fr = qt_parcel(i,0) - q_fr
                rl_fr = ql_fr / 1000. / (1. - (q_fr / 1000.) - (ql_fr / 1000.))
                rs_fr = qs_fr / 1000. / (1. - (qs_fr / 1000.))
                rt_fr = rl_fr + rs_fr
                alpha = 0.009705  ;; linearized e#/e* around 0C (to -1C)
                bet = esi_calc(temp_parcel(i,0)) / es_calc(temp_parcel(i,0))
                a_fr = (LV0 + LF0) * alpha * LV0 * rs_fr / RV / (temp_parcel(i,0))^2
                b_fr = CPD + (CL * rt_fr) + (alpha * (LV0 + LF0) * rs_fr) + $
                  (bet * (LV0 + LF0) * LV0 * rs_fr / RV / (temp_parcel(i,0))^2)
                c_fr = ((-1.) * LV0 * rs_fr) - (LF0 * rt_fr) + (bet * (LV0 + LF0) * rs_fr)
                deltaTplus = (-b_fr + sqrt(b_fr^2 - (4 * a_fr * c_fr))) / (2 * a_fr)
                temp_parcel(i,0) = temp_parcel(i,0) + deltaTplus
                
;; Recalculate theta_il, other values after
;; liquid to ice conversion
;; CH: Note the above assumes saturation!

                qsi_fr = qsi_calc(pres(i), temp_parcel(i,0))
                qs_parcel(i,0) = qsi_fr                
                q_parcel(i,0) = qt_parcel(i,0) < qsi_fr
                q2_fr = q_parcel(i,0)
                qi_fr = qt_parcel(i,0) - q2_fr
                qi_parcel(i,0) = qi_fr
                theta_il_parcel(i,0) = theta_il_calc(pres(i), temp_parcel(i,0), q2_fr, 0., qi_fr)

                freeze = 1
                
;; end of conversion to ice for temp below tmelt -------------

              endif else begin

;; If temp_parcel gt tmelt
;; Calculate liquid condensate, if any

                qs1 = qs_calc(pres(i), temp_parcel(i,0))
                qs_parcel(i,0) = qs1
                ;qfin = where(finite(qt_parcel(i,j)) and finite(qs1), cnt)
                q_parcel(i,0) = qt_parcel(i,0) < qs1
                q1 = q_parcel(i,0)
                ql1 = qt_parcel(i,0) - q1
                ql_parcel(i,0) = ql1

              endelse
            endif else begin

;; If temp_parcel lt tmelt and all the
;; liquid condensate have already been
;; converted to ice 
;; Continue ascent with all additional condensation as ice

              temp_parcel(i,0) = temp_i_calc(pres(i), theta_il_parcel(i,0), qt_parcel(i,0))
              qsi_fr = qsi_calc(pres(i), temp_parcel(i,0))
              qs_parcel(i,0) = qsi_fr
              q_parcel(i,0) = qt_parcel(i,0) < qsi_fr
              q2_fr = q_parcel(i,0)
              qi_fr = qt_parcel(i,0) - q2_fr
              qi_parcel(i,0) = qi_fr

            endelse
          endif
        endfor
      
      temp_parcel_all(*,m) = temp_parcel(*,0)  

    for i= 0L, presnum-1L do begin
      temp_prescribed(i,m) = temp_env(i,0)
    endfor

;; Checking for convergence of mean tropospheric temperature
;; mean averaged over 1000 to 200 hPa

    temp_prescribed_mean(m) = mean(temp_prescribed(pr1000:pr200,m), /double, /NaN)
    if (loop_num ge 2) then temp_diff(m) = (temp_prescribed_mean(m) - temp_prescribed_mean(m-1))    
    print, 'outer loop - ', loop_num, ' temp_diff - ', temp_diff(m)

;; Height of the environment
;; needed for plotting
    
    for i= 5, presnum-1L do begin
      del_z(i) = (RD*((temp_v_env(i-1)+temp_v_env(i))/2.)*5.)/(((pres(i-1)+pres(i))/2.)*grav)
      alt_mean(i) = alt_mean(i-1) + del_z(i)        
    endfor
    
    loop_num = loop_num + 1
        
;; Prescribing parcel temperature to the environment 
;; and applying radiative cooling
;; of 1.5 C/day and Betts-Miller 0.1 day convective time scale    
    
    if (loop_num eq 1) then $ 
    temp_env(*,0) = temp_parcel(*,0) $
    else temp_env(pr1000+1:presnum-1,0) = temp_parcel(pr1000+1:presnum-1,0) - 0.15
    
;; Entrainment Profile
;; In RCE iteration, 
;;   reset entrainment to full value here after first pass  
    
    ;entr_per_pa(0:presnum-1) = 0.000 / 500. ;; Adiabat
    entr_per_pa(0:presnum-1) = 0.0175 / 500. ;; Entraining Plume
    entr_per_5hPa(0:presnum-1) = entr_per_pa(0:presnum-1) * dpres ;(converting to per 5 hPa)
    
;;--------------- End of RCE Iteration loop--------------------------------
    
  endfor
  
save, temp_prescribed, temp_parcel_all, temp_diff, alt_mean, temp_env, $
      filename = 'fig.3.dat'

print, 'finished'

end
