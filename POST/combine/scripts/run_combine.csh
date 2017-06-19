#! /bin/csh -f
#PBS -N combine.aconc.uncoupled.csh
#PBS -l walltime=10:00:00
#PBS -l nodes=login
#PBS -q singlepe 
#PBS -V
#PBS -m n
#PBS -j oe
#PBS -o ./combine_V51.aconc.uncoupled.log

#> Set location of CMAQ output (can also come from config.cmaq file)
 setenv M3DATA	/work/MOD3DEV/cmaq_bench_data/SE52BENCH/OUTPUT

#> Set location of Met output 
 setenv METDATA /work/MOD3DEV/cmaq_bench_data/SE52BENCH/INPUT/met/mcip

#> Set naming ids of simulation.
 set APPL = v52b
 set MECH = cb6r3_ae6_aq 
 #(EXEC_ID can also come from config.cmaq file)
 set EXEC_ID = CMAQ52b_mpi_SE52BENCH.35.2013ef_13g_s07

#> Timestep run parameters.
 set START_DAY = "2011-07-01"
 set END_DAY   = "2011-07-09"

#> Set location of CMAQ repo.  This will be used to point to the correct species definition files.
 set CMAQ_REPO = /work/MOD3EVAL/fib/CMAQ_Dev
 
#> Set location of species definition files for concentration and deposition species.
 setenv SPEC_CONC $CMAQ_REPO/POST/combine/scripts/spec_def_files/SpecDef_${MECH}.txt
 setenv SPEC_DEP  $CMAQ_REPO/POST/combine/scripts/spec_def_files/SpecDef_Dep_${MECH}.txt

#> Set location where combine file will be written 
 setenv OUTDIR /work/MOD3DEV/cmaq_bench_data/SE52BENCH/POST

#> Set location of combine executable.
 setenv BINDIR /home/css/CMAQ-Tools/scripts/combine

#> Use GENSPEC switch to generate a new specdef file (does not generate output file).
 setenv GENSPEC N

# =====================================================================
# Run combine to yield all desired concentrations (ACONC file)
# =====================================================================

#> Set the species definition file for concentration species.
 setenv SPECIES_DEF $SPEC_CONC
 
 #> Loop through all days between START_DAY and END_DAY
 set CURRENT_DAY = ${START_DAY}
 set STOP_DAY = `date -ud "${END_DAY}+1days" +%Y-%m-%d`
  
 while ($CURRENT_DAY != ${STOP_DAY})

  set YYYY = `date -ud "${CURRENT_DAY}" +%Y`
  set YY = `date -ud "${CURRENT_DAY}" +%y`
  set MM = `date -ud "${CURRENT_DAY}" +%m`
  set DD = `date -ud "${CURRENT_DAY}" +%d`
 #> for files that are indexed with Julian day:
 #  set YYYYJJJ = `date -ud "${CURRENT_DAY}" +%Y%j` 

 #> Define name of output file to save average hourly concentration.
 #> A new file will be created for each month/year.
  setenv OUTFILE ${OUTDIR}/CCTM_${APPL}_${EXEC_ID}_COMBINE_ACONC.CMAQ52-BENCHMARK_$MM$YYYY

 #> Define name of input files needed for combine program.
 #> File [1]: CMAQ conc/aconc file
 #> File [2]: MCIP METCRO3D file
 #> File [3]: CMAQ APMDIAG file
 #> File [4]: MCIP METCRO2D file
  setenv INFILE1 $M3DATA/CCTM_${APPL}.ACONC.${EXEC_ID}_$YYYY$MM$DD
  setenv INFILE2 $METDATA/METCRO3D_$YY$MM$DD
  setenv INFILE3 $M3DATA/CCTM_${APPL}.APMDIAG.${EXEC_ID}_$YYYY$MM$DD
  setenv INFILE4 $METDATA/METCRO2D_$YY$MM$DD

  set CURRENT_DAY = `date -ud "${CURRENT_DAY}+1days" +%Y-%m-%d`

 #> Executable call:
  $BINDIR/combine.exe

 end

 # =====================================================================
# Run combine to yield all desired deposition totals (DEP file)
# =====================================================================

#> Set the species definition file for concentration species.
 setenv SPECIES_DEF $SPEC_DEP
 
 #> Loop through all days between START_DAY and END_DAY
 set CURRENT_DAY = ${START_DAY}
 set STOP_DAY = `date -ud "${END_DAY}+1days" +%Y-%m-%d`
  
 while ($CURRENT_DAY != ${STOP_DAY})

  set YYYY = `date -ud "${CURRENT_DAY}" +%Y`
  set YY = `date -ud "${CURRENT_DAY}" +%y`
  set MM = `date -ud "${CURRENT_DAY}" +%m`
  set DD = `date -ud "${CURRENT_DAY}" +%d`
#> for files that are indexed with Julian day:
#  set YYYYJJJ = `date -ud "${CURRENT_DAY}" +%Y%j` 

 #> Define name of output file to save average hourly concentration.
 #> A new file will be created for each month/year.
  setenv OUTFILE ${OUTDIR}/CCTM_${APPL}_${EXEC_ID}_COMBINE_DEP.CMAQ52-BENCHMARK_$MM$YYYY

 #> Define name of input files needed for combine program.
 #> File [1]: CMAQ DRYDEP file
 #> File [2]: CMAQ WETDEP file
 #> File [3]: MCIP METCRO2D
  setenv INFILE1 $M3DATA/CCTM_${APPL}.DRYDEP.${EXEC_ID}_$YYYY$MM$DD
  setenv INFILE2 $M3DATA/CCTM_${APPL}.WETDEP1.${EXEC_ID}_$YYYY$MM$DD
  setenv INFILE3 $METDATA/METCRO2D_$YY$MM$DD

  set CURRENT_DAY = `date -ud "${CURRENT_DAY}+1days" +%Y-%m-%d`

 #> Executable call:
  $BINDIR/combine.exe

 end
 
 date
 exit()
