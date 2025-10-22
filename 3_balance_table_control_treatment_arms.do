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

**# Balance Table 

* step 1: subset the full data into three groups (control + two treatment arms)

tab spark // check if key variable exists 

* group 1 = control group, group 2 = treatment with participation, group 3 = treatment without participation
gen group = .
replace group = 0 if spark == "0"
replace group = 1 if spark == "1"
replace group = 2 if spark == "1" & midline_meeting_ind == 1
tab group // obs 3,778

* step 2: Index Compilation
**# Household Data Index Compilation

**# Table 1a

recode Q6_1a_part2 (1/3=0) (4/5=1), gen(maj_dis_janet)
recode Q6_2a_part2 (1/3=1) (4=0), gen(punish_janet)
recode Q6_3a_part2 (1 4 =0) (2 3 =1), gen(rarenever_janet)
recode Q6_1b_part2 (1/3=0) (4/5=1), gen(maj_dis_jean)
recode Q6_2b_part2 (1/3=1) (4=0), gen(punish_jean)
recode Q6_3b_part2 (1 4 =0) (2 3 =1), gen(rarenever_jean)

factor maj_dis_janet punish_janet rarenever_janet maj_dis_jean punish_jean rarenever_jean
predict table1a_index

global table1a "maj_dis_janet punish_janet rarenever_janet maj_dis_jean punish_jean rarenever_jean table1a_index"

**# Table 1b

recode Q6_1c_part2 (1/3=0) (4/5=1), gen(maj_dis_alpho) 
recode Q6_2c_part2 (2/4=1) (1=0), gen(punish_alpho) 
recode Q6_3c_part2 (1 4 =0) (2 3 =1), gen(rarenever_alpho) 

recode Q6_1d_part2 (1/3=0) (4/5=1), gen(maj_dis_bosco) 
recode Q6_2d_part2 (2/4=1) (1=0), gen(punish_bosco) 
recode Q6_3d_part2 (1 4 =0) (2 3 =1), gen(rarenever_bosco) 

factor maj_dis_alpho punish_alpho rarenever_alpho maj_dis_bosco punish_bosco rarenever_bosco
predict table1b_index

global table1b "maj_dis_alpho punish_alpho rarenever_alpho maj_dis_bosco punish_bosco rarenever_bosco table1b_index"

**# Table 2

recode q7_1 (-999/-1=.) (2=0), gen(generalized_trust)

foreach var in q7_2 q7_4{
	recode `var' (1/2=1) (3/5=0), gen(r_`var')
}

foreach var in q7_3 q7_5{
	recode `var' (1/3=0) (4/5=1), gen(r_`var')
}

rename r_q7_2 most_people_trusted
rename r_q7_3 alert_or_advantage
rename r_q7_4 willing_to_help
rename r_q7_5 lending_borrowing

recode q7_6 (1/2=0) (3/4=1), gen(borrow_cash)
recode q7_7 (2/4=0), gen(lookafter_children)

factor generalized_trust most_people_trusted alert_or_advantage willing_to_help lending_borrowing borrow_cash lookafter_children
predict table2_index

global table2 "generalized_trust most_people_trusted alert_or_advantage willing_to_help lending_borrowing borrow_cash lookafter_children table2_index"

**# Table 3a

gen recent_mtg_2weeks = q1_1 == 1

// Cleaning q1_3
tab q1_3
replace q1_3 = 25 if q1_3 == .25
replace q1_3 = 40 if q1_3 == .4
replace q1_3 = 50 if q1_3 == .5
replace q1_3 = -999 if q1_3 == .999

recode q1_3 (-999/-99=.), gen(share_nbrs_mtg)

replace share_nbrs_mtg=share_nbrs_mtg*100 if share_nbrs_mtg<1

recode q1_4 (-999/-99=.)(999=.), gen(recent_mtg_attendance)
winsor recent_mtg_attendance, gen(recent_mtg_attendance_w) p(0.01)
drop recent_mtg_attendance
rename recent_mtg_attendance_w recent_mtg_attendance

recode q1_5 (2/3=0), gen(recent_mtg_discussion)

factor recent_mtg_2weeks share_nbrs_mtg recent_mtg_attendance recent_mtg_discussion
predict table3a_index

global table3a "recent_mtg_2weeks share_nbrs_mtg recent_mtg_attendance recent_mtg_discussion table3a_index"


**# Table 3c

recode q1_7 (1/2=0)(3=1)(4=0), gen(recent_mtg_collegial)

recode q1_8 (-999/-1=.)(999=.), gen(mtg_speakers)
recode q1_9 (-99999/-1=.)(999=.), gen(mtg_yng_speakers)
recode q1_10 (-99999/-1=.)(999=.), gen(mtg_fem_speakers)
recode q1_11 (-99999/-1=.)(999=.), gen(mtg_yng_fem_speakers)

factor recent_mtg_collegial mtg_speakers mtg_yng_speakers mtg_fem_speakers mtg_yng_fem_speakers

predict table3c_index

global table3c "recent_mtg_collegial mtg_speakers mtg_yng_speakers mtg_fem_speakers mtg_yng_fem_speakers table3c_index"

**# Table 4a

gen knows_village_head = sample_head_
gen knows_social = sample_welfare_
gen knows_security = sample_security_
gen knows_information = sample_information_
gen knows_development = sample_development_

******generate index for knowledge of village committee*****
factor knows_*
predict table4a_index

global table4a "knows_village_head knows_social knows_security knows_information knows_development table4a_index"

**# Table 4b

recode q2_2 (1/4=1) (5/8=0), gen(met_leader_thisyear) 
recode q2_3 (1=1) (2/7=0) (.=0), gen(met_village_head) 
recode q2_4 (1=0) (2=1) (3/6=0) (.=0), gen(met_disc_welfareprog)
recode q2_5 (1/2=0) (3/4=1) (.=0), gen(met_more15mins)
recode q2_7 (1=1) (2/3=0) (.=0), gen(met_fullyresolved)
recode q2_8 (1/2=1) (3=0) (.=0), gen(met_higherupofficial)

******generate index for interaction with village leadership *****
factor met_*
predict table4b_index
global table4b "met_leader_thisyear met_village_head met_disc_welfareprog met_more15mins met_fullyresolved met_higherupofficial table4b_index"

**# Table 4c

recode q3_3 (-999/-1=.) (0/2=0) (3/20=1), gen(more_than_3progs)
factor q3_4_1 q3_4_2 q3_4_3 q3_4_4 q3_4_5 q3_4_6 q3_4_7 q3_4_8 
predict prog_knowledge_index

factor q3_5_1 q3_5_2 q3_5_3 q3_5_4 q3_5_5 q3_5_6 q3_5_7 q3_5_8 
predict prog_exposure_index

recode q3_6 (1=1) (2/3=0), gen(knows_shisha)

foreach var in q3_6_1_1 q3_6_1_2 q3_6_1_3 q3_6_1_4 q3_6_1_5 q3_6_1_6 q3_6_1_7 q3_6_1_8 {
	replace `var'=0 if `var'==.
}

factor q3_6_1_1 q3_6_1_2 q3_6_1_3 q3_6_1_4 q3_6_1_5 q3_6_1_6 q3_6_1_7 q3_6_1_8
predict sh_knowledge_index1

foreach var in q3_6_2_1 q3_6_2_2 q3_6_2_3 q3_6_2_4 q3_6_2_5 q3_6_2_6 {
	replace `var'=0 if `var'==.
}
factor q3_6_2_1 q3_6_2_2 q3_6_2_3 q3_6_2_4 q3_6_2_5 q3_6_2_6
predict sh_knowledge_index2

**# ** 4c index added
factor prog_knowledge_index prog_exposure_index sh_knowledge_index1 sh_knowledge_index2
predict table4c_index

global table4c "more_than_3progs prog_knowledge_index prog_exposure_index knows_shisha sh_knowledge_index1 sh_knowledge_index2"


**# Table 4d

recode q02_1 (1=1) (2/3=0) (.=0), gen(signed_hh_plan)
recode q02_2 (1=1) (2/3=0) (.=0), gen(shows_hh_plan)

**# ** 4d index added
factor signed_hh_plan shows_hh_plan
predict table4d_index

global table4d "signed_hh_plan shows_hh_plan"

**# Table 5a

factor Q4_3_part2_1 Q4_3_part2_2 Q4_3_part2_3 Q4_3_part2_4 Q4_3_part2_5 Q4_3_part2_6 Q4_3_part2_7 Q4_3_part2_8 Q4_3_part2_9 Q4_3_part2_10 Q4_3_part2_11 Q4_3_part2_12
predict part_index_commserv 

forval i=1/12 {
        recode Q4_4_part2_`i' (1/3=1) (4=0) (.=0), prefix(r_)
        recode Q4_5_part2_`i' (1/2=1) (3/5=0) (.=0), prefix(c_)
        recode Q4_6_part2_`i' (1/3=1) (4/5=0) (.=0), prefix(u_)
        recode Q4_7_part2_`i' (1/2=1) (3/4=0) (.=0), prefix(w_)
}

factor r_Q4_4_part2_1-r_Q4_4_part2_12
predict cont_index_commserv

factor c_Q4_5_part2_1-c_Q4_5_part2_12
predict morehalf_index

factor u_Q4_6_part2_1-u_Q4_6_part2_12
predict umuganda_index


factor w_Q4_7_part2_1-w_Q4_7_part2_12
predict importance_index

**# ** 5a index added
factor part_index_commserv cont_index_commserv morehalf_index umuganda_index importance_index
predict table5a_index

global table5a "part_index_commserv cont_index_commserv morehalf_index umuganda_index importance_index"

**# Table 7a

factor q4_2_1-q4_2_99
predict non_trad_eng_index

//ssc install winsor if winsor is not installed previously

foreach var in q4_3_1 q4_3_2 q4_3_3 q4_3_4 q4_3_5 {
replace `var'=. if `var'<0
replace `var'=0 if `var'==.
winsor `var', gen(`var'_w) p(0.01)
drop `var'
rename `var'_w `var'
}

egen non_trad_hours = rowtotal(q4_3_1 q4_3_2 q4_3_3 q4_3_4 q4_3_5)


foreach var in q4_4_1 q4_4_2 q4_4_3 q4_4_4 q4_4_5 {
	
replace `var'=. if `var'<0
replace `var'=0 if `var'==.
winsor `var', gen(`var'_w) p(0.01) 
drop `var'
rename `var'_w `var'	
}

egen total_income = rowtotal(q4_4_1 q4_4_2 q4_4_3 q4_4_4 q4_4_5)

gen log_income = ln(total_income+1)

******ESTIMATE EXPECTATIONS FOR INCOME GENERATING ACTIVITIES - MISSING =0
foreach var in q4_5_1 q4_5_2 q4_5_3 q4_5_4 q4_5_5{
recode `var' (2/4=0) (.=0), pre(a_)
	
}

factor a_q4_5_1-a_q4_5_5
predict inc_exp_index

**# ** 7a index added
factor non_trad_eng_index non_trad_hours total_income log_income inc_exp_index
predict table7a_index

global table7a "non_trad_eng_index non_trad_hours total_income log_income inc_exp_index"

**# Table 8b 

factor q12_11_1 q12_11_2 q12_11_3 q12_11_4 q12_11_5 q12_11_6 q12_11_7 q12_11_8
predict finserv_index

forval x = 1/8{
	recode q12_11a_`x' (.=0), gen(p_q12_11a_`x')
	recode q12_11b_`x' (.=0), gen(p_q12_11b_`x')
	recode q12_11c_`x' (.=0), gen(p_q12_11c_`x')
	recode q12_11d_`x' (.=0), gen(p_q12_11d_`x')
}
factor p_q12_11a_1 p_q12_11a_2 p_q12_11a_3 p_q12_11a_4 p_q12_11a_5 p_q12_11a_6 p_q12_11a_7 p_q12_11a_8
predict fin_dep_index

factor p_q12_11b_1 p_q12_11b_2 p_q12_11b_3 p_q12_11b_4 p_q12_11b_5 p_q12_11b_6 p_q12_11b_7 p_q12_11b_8
predict fin_withd_index

factor p_q12_11c_1 p_q12_11c_2 p_q12_11c_3 p_q12_11c_4 p_q12_11c_5 p_q12_11c_6 p_q12_11c_7 p_q12_11c_8
predict fin_remit_index

factor p_q12_11d_1 p_q12_11d_2 p_q12_11d_3 p_q12_11d_4 p_q12_11d_5 p_q12_11d_6 p_q12_11d_7 p_q12_11d_8
predict fin_rec_index

*****CALCULATE BALANCES ACROSS ALL ACCOUNTS - missing = 0
foreach var in q12_11e_1 q12_11e_2 q12_11e_3 q12_11e_4 q12_11e_5 q12_11e_6 q12_11e_7 q12_11e_8{
	recode `var' (.=0), gen(p_`var')
}

egen total_fin_bal = rsum(p_q12_11e_1 p_q12_11e_2 p_q12_11e_3 p_q12_11e_4 p_q12_11e_5 p_q12_11e_6 p_q12_11e_7 p_q12_11e_8)


**# 8a index added 

factor finserv_index fin_dep_index fin_withd_index fin_remit_index fin_rec_index total_fin_bal
predict table8a_index

global table8a "finserv_index fin_dep_index fin_withd_index fin_remit_index fin_rec_index total_fin_bal"


**# Table 8b
recode q6_14 (1 2 7 88 99 . = 0) (3/6 = 1), gen(morethan6_kimina)

recode q6_14a (-999/-99=0) (.=0), gen(pot_size)
winsor pot_size, gen (pot_size_w) p(0.01)
drop pot_size
rename pot_size_w pot_size

replace q6_15a=0 if q6_15a == .
gen morethan2_hh = q6_15a > 2
replace morethan2_hh = 0 if morethan2_hh == .

replace q6_15b = 0 if q6_15b == .
recode q6_15b (-99=0), gen(mostimp_contribution)
winsor mostimp_contribution, gen (mostimp_contribution_w) p(0.01)
drop mostimp_contribution
rename mostimp_contribution_w mostimp_contribution

replace q6_15c = 0 if q6_15c == .
recode q6_15c (1=1) (2/4=0), gen(weekly_contribution)

replace q6_16 = 0 if q6_16 == .
recode q6_16 (-999/-99=0), gen(kimina_size)
winsor kimina_size, gen (kimina_size_w) p(0.01)
drop kimina_size
rename kimina_size_w kimina_size

replace q12_14=0 if q12_14==.
recode q12_14 (2=1) (1 3 4 5 6 =0) (99=0) , gen(mutelle_kimina)

**# 8b index added
factor morethan6_kimina pot_size morethan2_hh mostimp_contribution weekly_contribution kimina_size mutelle_kimina
predict table8b_index

global table8b "morethan6_kimina pot_size morethan2_hh mostimp_contribution weekly_contribution kimina_size mutelle_kimina"

**# Table 9a

recode q04_1 (1=1) (2/3=0), gen(indoor_toilet)

recode q04_2 (1 2 3 4 5=1) (6=0) (99=.), gen(non_wood_fuel)

recode q04_3 (1=0) (2/8=1), gen(non_earth_floor) // 7,8 included

recode q04_4 (1 2 3 4 5 6 8 99=0) (7=1), gen(tile_roof) // 4 (wooded) added 

recode q04_5 (1/5=0) (6/8=1) (99=0), gen(brick_wall)


factor q03_1 q03_2 q03_3 q03_4 q03_5 q03_6 q03_7 q03_8 q03_9 indoor_toilet non_wood_fuel non_earth_floor tile_roof brick_wall
predict asset_w_housing 

factor q03_1 q03_2 q03_3 q03_4 q03_5 q03_6 q03_7 q03_8 q03_9
predict asset_wo_housing 

factor q03_10 q03_11 q03_12 q03_13 q03_14 q03_15 q03_16 q03_17
predict livestock_own

foreach var in q03_10a q03_11a q03_12a q03_13a q03_14a q03_15a q03_16a q03_17a {
recode `var' (.=0), gen(r_`var')
}
factor r_q03_10a r_q03_11a r_q03_12a r_q03_13a r_q03_14a r_q03_15a r_q03_16a r_q03_17a
predict livestock_notown

**# 9a index added
factor asset_w_housing asset_wo_housing livestock_own livestock_notown
predict table9a_index

global table9a "asset_w_housing asset_wo_housing livestock_own livestock_notown"

**# Table 9b 

replace q6_11 = 0 if q6_11==.
recode q6_11 (1/2=1) (3/5=0) (88/99=0), gen(raise100k_roof)

foreach var in q6_12_1 q6_12_3 q6_12_4 q6_12_5 {
	replace `var' = 0 if `var' == .
} 

gen raise100k_bank = 1 if q6_12_1 == 1 | q6_12_3 == 1 | q6_12_4 == 1 | q6_12_5 == 1
replace raise100k_bank = 0 if raise100k_bank != 1

replace q6_17 = 0 if q6_17==. 
recode q6_17 (1/2=1) (3/5=0) (88/99=.), gen(raise30k_health)

foreach var in q6_18_1 q6_18_3 q6_18_4 q6_18_5 {
	replace `var' = 0 if `var' == .
}

gen raise30k_bank = 1 if q6_18_1 == 1 | q6_18_3 == 1 | q6_18_4 == 1 | q6_18_5 == 1
replace raise30k_bank = 0 if raise30k_bank != 1


replace q6_8 = 0 if q6_8 == .
recode q6_8 (1/4=1) (5/6=0) (77 88 99 =.), gen(mobile_wallet)

replace q6_9 = 0 if q6_9 == .
recode q6_9 (1/2=1) (3/8=0) (9 77 88 99=.), gen(deposit_6mths)

replace q6_10 = 0 if q6_10 == .
recode q6_10 (1=0) (2/6=1) (77 88 99 = .), gen(nonzero_balance)

**# 9b index added
factor raise100k_roof raise100k_bank raise30k_health raise30k_bank mobile_wallet deposit_6mths nonzero_balance
predict table9b_index

global table9b "raise100k_roof raise100k_bank raise30k_health raise30k_bank mobile_wallet deposit_6mths nonzero_balance"

**# Table 10a

gen worried_food = q05_1

gen you_nofood = q05_2

gen you_fewfood = q05_3

gen you_skipmeal = q05_4

gen you_lessfood = q05_5

gen hh_nofood = q05_6

gen you_noeat = q05_7

gen hh_wholeday = q05_8

factor worried_food you_nofood you_fewfood you_skipmeal you_lessfood hh_nofood you_noeat hh_wholeday
predict table10a_index

global table10a "worried_food you_nofood you_fewfood you_skipmeal you_lessfood hh_nofood you_noeat hh_wholeday table10a_index"

**# Table 11

**** 2-1: log_freq_exp ******
gen transportation_expenditure = IE_20
replace transportation_expenditure = 0 if transportation_expenditure == .

gen clothing_expenditure = IE_22
replace clothing_expenditure = 0 if clothing_expenditure == .

gen leisure_expenditure = IE_23
replace leisure_expenditure = 0 if leisure_expenditure == .

gen water_expenditure = IE_24
replace water_expenditure = 0 if water_expenditure == .

gen electricity_expenditure = IE_25
replace electricity_expenditure = 0 if electricity_expenditure == .

gen cookingfuel_expenditure = IE_26
replace cookingfuel_expenditure = 0 if cookingfuel_expenditure == .

gen sum_freq_expenditure = transportation_expenditure + clothing_expenditure + ///
                           leisure_expenditure + water_expenditure + ///
                           electricity_expenditure + cookingfuel_expenditure

replace sum_freq_expenditure = 0 if sum_freq_expenditure < 0
gen log_freq_exp = log(sum_freq_expenditure)

**** 2-2: log_infreq_exp ******
gen schoolfees_expenditure     = IE_41
replace schoolfees_expenditure = 0 if schoolfees_expenditure == .

gen housing_expenditure        = IE_43
replace housing_expenditure    = 0 if housing_expenditure == .

gen furnishing_expenditure     = IE_45
replace furnishing_expenditure = 0 if furnishing_expenditure == .

gen healthinsurance_expenditure     = IE_47
replace healthinsurance_expenditure = 0 if healthinsurance_expenditure == .

gen otherhealth_expenditure     = IE_49
replace otherhealth_expenditure = 0 if otherhealth_expenditure == .

gen financialinst_expenditure     = IE_51
replace financialinst_expenditure = 0 if financialinst_expenditure == .

gen gifts_monetary_expenditure     = IE_52
replace gifts_monetary_expenditure = 0 if gifts_monetary_expenditure == .

gen gifts_inkind_expenditure     = IE_53
replace gifts_inkind_expenditure = 0 if gifts_inkind_expenditure == .

gen agric_equipment_expenditure     = IE_55
replace agric_equipment_expenditure = 0 if agric_equipment_expenditure == .

gen businessinvest_expenditure     = IE_57
replace businessinvest_expenditure = 0 if businessinvest_expenditure == .

gen livestock_expenditure     = IE_59
replace livestock_expenditure = 0 if livestock_expenditure == .

gen other_inf_expenditure     = IE_61
replace other_inf_expenditure = 0 if other_inf_expenditure == .

gen sum_infreq_expenditure = schoolfees_expenditure + housing_expenditure + furnishing_expenditure ///
+ healthinsurance_expenditure + otherhealth_expenditure + financialinst_expenditure + gifts_monetary_expenditure ///
+ gifts_inkind_expenditure + agric_equipment_expenditure + businessinvest_expenditure + livestock_expenditure + ///
other_inf_expenditure

replace sum_infreq_expenditure = 0 if sum_infreq_expenditure < 0
gen log_infreq_exp = log(sum_infreq_expenditure)

**** 2-3: consumption_index_ind ******
forvalues i = 1/16 {
    gen days_consumed_food_`i' = FS_02_`i'
    replace days_consumed_food_`i' = 0 if days_consumed_food_`i' == .
}

foreach var of varlist days_consumed_food_* {
        gen ind_`var' = 0
        replace ind_`var' = 1 if `var' > 0
}

factor ind_days_consumed_food_1 ind_days_consumed_food_2 ind_days_consumed_food_3 ind_days_consumed_food_4 ind_days_consumed_food_5 ind_days_consumed_food_6 ind_days_consumed_food_7 ind_days_consumed_food_8 ind_days_consumed_food_9 ind_days_consumed_food_10 ind_days_consumed_food_11 ind_days_consumed_food_12 ind_days_consumed_food_13 ind_days_consumed_food_14 ind_days_consumed_food_15 days_consumed_food_16 
predict consumption_index_ind 

**** 2-4: consumption_index_tot ******
foreach var of varlist days_consumed_food_* {
	winsor `var', gen (tot_`var') p(0.01) 
}

factor tot_days_consumed_food_1 tot_days_consumed_food_2 tot_days_consumed_food_3 tot_days_consumed_food_4 tot_days_consumed_food_5 tot_days_consumed_food_6 tot_days_consumed_food_7 tot_days_consumed_food_8 tot_days_consumed_food_9 tot_days_consumed_food_10 tot_days_consumed_food_11 tot_days_consumed_food_12 tot_days_consumed_food_13 tot_days_consumed_food_14 tot_days_consumed_food_15 tot_days_consumed_food_16
predict consumption_index_tot

**** 2-5: cons_exp_index_tot ******
forvalues i = 1/16 {
	gen expenditure_consumed_food_`i' = FS_03_`i'
	replace expenditure_consumed_food_`i' = 0 if expenditure_consumed_food_`i' == .
}

foreach var of varlist expenditure_consumed_food_* {
	winsor `var', gen (tot_`var') p(0.01) 
}

factor tot_expenditure_consumed_food_1 tot_expenditure_consumed_food_2 tot_expenditure_consumed_food_3 tot_expenditure_consumed_food_4 tot_expenditure_consumed_food_5 tot_expenditure_consumed_food_6 tot_expenditure_consumed_food_7 tot_expenditure_consumed_food_8 tot_expenditure_consumed_food_9 tot_expenditure_consumed_food_10 tot_expenditure_consumed_food_11 tot_expenditure_consumed_food_12 tot_expenditure_consumed_food_13 tot_expenditure_consumed_food_14 tot_expenditure_consumed_food_15 tot_expenditure_consumed_food_16
predict cons_exp_index_tot

**# 11 index added
factor log_freq_exp log_infreq_exp consumption_index_ind consumption_index_tot  cons_exp_index_to
predict table11_index

global table11 "log_freq_exp log_infreq_exp consumption_index_ind consumption_index_tot  cons_exp_index_tot"

*global table11 "log_freq_exp log_infreq_exp consumption_index_ind consumption_index_tot  cons_exp_index_tot haz06 waz06"

**# Aggregated index and label4

global compiled_index "table1a_index table1b_index table2_index table3a_index table3c_index table4a_index table4b_index table4c_index table4d_index table5a_index table7a_index table8b_index table9a_index table10a_index table11_index"

label var table1a_index "table1a_index"
label var table1b_index "table1b_index"
label var table2_index  "table2_index"
label var table3a_index "table3a_index"
label var table3c_index "table3c_index"
label var table4a_index "table4a_index"
label var table4b_index "table4b_index"
label var table4c_index "table4c_index"
label var table4d_index "table4d_index"
label var table5a_index "table5a_index"
label var table7a_index "table7a_index"
label var table8b_index "table8b_index"
label var table9a_index "table9a_index"
label var table10a_index "table10a_index"
label var table11_index "table11_index"


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

