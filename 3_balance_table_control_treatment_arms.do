********************************************************************************
* Research Assistant Work: CDD Evaluation in Rwanda
* Purpose of Do File: Balance table for control & two treatment arms
* Created by: Yeji Kim
* Created on: 17th October, 2025
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

**# Data Import 
use "$masterdta/SPARK_Household_endline_Survey_full.dta", clear

**# Generate Meeting Indicator Variable
tab midline_meeting 
tab midline_meeting, nolabel
* Regularly attend = 4, all or nearly all FCAP meetings = 5; recode them as 1 

gen midline_meeting_ind = 0 
replace midline_meeting_ind = 1 if midline_meeting == 4 | midline_meeting == 5
tab midline_meeting_ind  
label variable midline_meeting_ind "1 if regulary or attend all the FCAP meetings, 0 otherwise"

/*
**# Visualization

* Visual 1 - Frequency
* label the region based on Huye variable 
label define huye_lbl 0 "North" 1 "Huye"
label values huye huye_lbl

graph bar (count), over(huye) over(midline_meeting_ind) asyvars stack ///
    title("Attendance Level by Region") ///
    ytitle("Number of HHIDs") ///
    legend(label(1 "Lower Attendance") label(2 "Regular & All Attendance"))

* save
graph export "$desoutput/midline_attendance_frequency.png", width(2000) replace


* Visual 2 - Percentage
preserve

* 1) Get counts by Huye × Attendance
contract huye midline_meeting_ind, freq(n)

* 2) Convert to within-Huye percentages
bys huye: egen total = total(n)
gen pct = 100 * n / total

* 3) Reshape to two variables (0 = no attendance, 1 = attendance)
keep huye midline_meeting_ind pct
reshape wide pct, i(huye) j(midline_meeting_ind)

* 4) 100% stacked bar (each Huye bar sums to 100)
graph bar pct0 pct1, over(huye) stack ///
    title("Attendance Share by Region") ///
    ytitle("Percent of HHIDs") ///
    ylabel(0(20)100) yscale(range(0 100)) ///
    legend(order(1 "No Attendance" 2 "Attendance")) ///
    blabel(bar, format(%4.1f))

graph export "$desoutput/midline_attendance_percentage.png", width(2000) replace

restore 

*/

**# Balance Table 

* step 1: subset the full data into three groups (control + two treatment arms)

tab spark // check if key variable exists 

* group 1 = control group, group 2 = treatment with participation, group 3 = treatment without participation
gen group = .
replace group = 0 if spark == "0"
replace group = 1 if spark == "1"
replace group = 2 if spark == "1" & midline_meeting_ind == 1
tab group // obs 3,778

* step 2: create dofile combining all the table index
 do "$do/MA_Endline_Do Files/2_Endline_Descriptive_Analysis/4_tables_index_aggregate.do"

* step 3: 
* ssc install orth_out // download the package if not already

** 3- Method 1: run regression for SPARK 

** 3- Method 2: for each table with household level data, use the index for each table and create summary statistics for control households, participatory spark (who participated meetings regularly), and non-participatory spark (midline_meeting_ind == 0)

* 1. Run estpost to get the summary statistics by group.
* We specify the stats we want (mean, sd, count)
* and tell it to run by(group).
estpost tabstat $compiled_index, by(group) statistics(mean sd count) columns(statistics)

* 2. Use esttab to export the table.
* - 'using "balance_table.rtf"' exports to a Word-readable file.
* - 'replace' will overwrite the file.
* - 'cells(...)' specifies what to display and how to format it.
* - 'label' uses variable labels instead of names.
* - 'collabels(...)' sets your custom column titles.
* - 'title(...)' adds the table title.
* - 'nonumber' removes the (1) (2) (3) model numbers.

esttab using "$output/Balance_Table_Index.csv", replace ///
    unstack noobs nonumber compress ///
    cells("mean(fmt(3)) sd(fmt(3))") ///
    collabels("Mean" "SD") ///
    mtitle("Control" "Treat+Part" "Treat−Part") ///
    label title("Balance Table: Global Table Index by Group")



** output: output is to create one balance table that has three columns for each table index

**# Future implication: if we have IV predicting who are more likely to participate at the SPARK meetings, we can potentially pursue this by using hierchical matching at R, yet not very widely used in academia 

** If IPA wants to differentiate this data to poverty sub-levels, then this command dofile is replicable by substituting the "endline survey full" from "endline survey ubudehe 1" and/or "endline survey ubudehe other"

