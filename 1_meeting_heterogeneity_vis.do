********************************************************************************
* Research Assistant Work: CDD Evaluation in Rwanda
* Purpose of Do File: Visualize heterogeneity in meeting attendance across the Northern and Huye areas
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

**# Merge Huye Indicator Variable 

* goal : show histogram of the share of household separated by Northern, Huye
* need variable that indicates whether they are Northern or Huye 
* for each household, there will be a village and according to village we will match huye indicator (is this one to many merge?)

use "$middta/Community_variables.dta", clear
keep village huye 
destring village, replace force 

merge 1:m village using "$masterdta/SPARK_Household_endline_Survey_full.dta"
tab _merge 
drop _merge 

**# Vis 1 - Histogram 
* histogram of midline_meeting, without cleaning anything nor creating indicator variable 
* goal is to see the distribution of the responds by North and Huye 
tab midline_meeting 
tab midline_meeting, nolabel

* for visibility, recode 99 as missing; this way 1-6 will be next to each other with larger size
replace midline_meeting = . if midline_meeting == 99

twoway ///
    (histogram midline_meeting if huye==0 & midline_meeting!=99, discrete color(navy%60)) ///
    , name(north, replace) ///
    title("North") ///
    xlabel(1(1)6) ylabel(, angle(horizontal)) ///
    xtitle("Meeting frequency") ///
    ytitle("Count")

twoway ///
    (histogram midline_meeting if huye==1 & midline_meeting!=99, discrete color(maroon%60)) ///
    , name(huye, replace) ///
    title("Huye") ///
    xlabel(1(1)6) ylabel(, angle(horizontal)) ///
    xtitle("Meeting frequency") ///
    ytitle("Count")

graph combine north huye, col(2) ///
    title("Midline Meeting Distribution by Region")


graph export "$output/1_meeting_heterogeneity.png", width(2000) replace

** The end
