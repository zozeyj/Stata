********************************************************************************
* Research Assistant Work: CDD Evaluation in Rwanda
* Purpose of Do File: Visualize ubudehe 1 for midline and endline for Spark and control group 
* Created by: Yeji Kim
* Created on: 16th October, 2025
* Modified by: 
* Modified on: 
* Draft 1
********************************************************************************
clear all 

**# user set-up
*MacOSX
if "`c(username)'"=="jph35" {
	global user "/Users/jph35/Dropbox/SPARK Evaluation/Midline Survey/Analysis"  
}
else if "`c(username)'"=="yejikim" {
	global user "/Users/yejikim/Dropbox/Rwanda Spark Analysis/Spark MicroGrants Evaluation"
}

*Windows
else if "`c(username)'" == "jameshabyarimana" {
	global user "/Users/jameshabyarimana/Dropbox/SPARK Evaluation/Midline Survey/Analysis" 
	}
else if "`c(username)'" == "Baba-Ali Mwango" {
	global user "C:\Users\Baba-Ali Mwango\Box Sync\IPA_RWA_Project_SPARK\07_Questionnaires & Data\01 Census\02 Questionnaire Development\01_Main_Survey\Data" 
	}	
else if "`c(username)'" == "meenakshialagusundaram" {
	global user "/Users/meenakshialagusundaram/Library/CloudStorage/Box-Box/CDD Evaluation Rwanda"
}

**# global set-up
do "$user/Do Files/Endline_MA/MA_Endline_Do Files/0_set_up_latest.do"

**# check main variables
use "$masterdta/SPARK_Household_endline_Survey_full.dta", clear
* ubudehe 
tab midline_ubudehe endline_ubudehe

**# QQQ how to clean spark 
* spark
tab spark // string variable contains 'eeeeee'
gen spark_clean = 0 
replace spark_clean = 1 if spark == "1"

**# Visualization
*--- Shares (percent) of ubudehe==1 at midline & endline by SPARK
collapse (mean) midline_ubudehe endline_ubudehe, by(spark_clean)
gen share_midline = 100*midline_ubudehe
gen share_endline = 100*endline_ubudehe
drop midline_ubudehe endline_ubudehe

*--- Labels
label define sparklbl 0 "SPARK = 0" 1 "SPARK = 1"
label values spark_clean sparklbl

*--- Two bars per group (midline vs endline) for spark=0 and spark=1
graph bar (asis) share_midline share_endline, over(spark_clean) ///
    title("Ubudehe 1 Share by SPARK Participation Across Time") ///
    ytitle("Percent of Households") ///
    legend(order(1 "Midline" 2 "Endline")) ///
    blabel(bar, format(%4.1f))

* Save 
graph export "$desoutput/ubudehe_share_by_spark.png", width(2000) replace



