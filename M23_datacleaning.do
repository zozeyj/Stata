**Goal: Import CSV clean into first dataset 

clear all 
import delimited "/Users/yejikim/Documents/2024 Peloria/M23 - Sheet1.csv", varnames(1) 

**month year
gen month_only = word(month, 1)   // Extract the first word (month name)
gen year_only = word(month, 2)    // Extract the second word (year)
list month month_only year_only if _n <= 20  // Verify the results
drop month
rename month_only month
rename year_only year 

gen month_num = .
replace month_num = 1 if month == "Jan" | month == "January"
replace month_num = 2 if month == "Feb" | month == "February"
replace month_num = 3 if month == "Mar" | month == "March"
replace month_num = 4 if month == "Apr" | month == "April"
replace month_num = 5 if month == "May"
replace month_num = 6 if month == "Jun" | month == "June"
replace month_num = 7 if month == "Jul" | month == "July"
replace month_num = 8 if month == "Aug" | month == "August"
replace month_num = 9 if month == "Sep" | month == "September"
replace month_num = 10 if month == "Oct" | month == "October"
replace month_num = 11 if month == "Nov" | month == "November"
replace month_num = 12 if month == "Dec" | month == "December"

list month year month_num if _n <= 20  // Verify the results
drop month 
rename month_num month
destring year, replace

**site_type
gen site_type = ""  // Create a new variable to store cleaned categories
replace site_type = "HC" if inlist(dataset, "HC", "Host Community", "Communauté hôte")
replace site_type = "CM" if inlist(dataset, "CM", "Central Management", "Site CCCM", "Sites sous mécanisme CCCM")
replace site_type = "NCM" if inlist(dataset, "NCM", "Non-Central Management", "Site Non-CCCM", ///
    "Site non-CCCM", "Sites hors mécanisme de gestion")

tab site_type //59,264 obs 100% assigned 
gen site_type_num = .  // Create a new numeric variable

replace site_type_num = 1 if site_type == "CM"   // CM assigned to 1
replace site_type_num = 0 if site_type == "HC"   // HC assigned to 0
replace site_type_num = 2 if site_type == "NCM"  // NCM assigned to 2

// Define value labels
label define site_type_label 0 "HC" 1 "CM" 2 "NCM"

// Assign the labels to the numeric variable
label values site_type_num site_type_label

tab site_type, nolabel
tab site_type
drop site_type
rename site_type_num site_type

**Admin1 Level = Province 
tab provinceadmin1
drop if provinceadmin1 == "Province" | provinceadmin1 == "Province Site"
tab provinceadmin1
gen admin1 =""
replace admin1 = "North-Kivu" if provinceadmin1 ==  "NORD-KIVU" | provinceadmin1 ==  "NORD-KIVU" | provinceadmin1 ==  "NORD-KIVU"
replace admin1 = "South-Kivu" if provinceadmin1 ==  "SUD-KIVU" | provinceadmin1 ==  "Sud-Kivu"
tab admin1  // 92% North and 8% South Kivu 

drop provinceadmin1
rename provincepcode admin1code 
tab admin1code admin1

**Admin2 Level = Territory 
rename territoireadmin2 admin2
rename territoirepcode admin2code 
tab admin2 

replace admin2 = "Butembo" if inlist(admin2, "BUTEMBO", "BUTEMBO (Ville)")
replace admin2 = "Goma" if inlist(admin2, "GOMA", "Goma")
replace admin2 = "Kalehe" if inlist(admin2, "KALEHE", "Kalehe")
replace admin2 = "Karisimbi" if admin2 == "Karisimbi"
replace admin2 = "Lubero" if inlist(admin2, "LUBERO", "Lubero")
replace admin2 = "Masisi" if inlist(admin2, "MASISI", "Masisi")
replace admin2 = "Nyiragongo" if inlist(admin2, "NYIRAGONGO", "Nyiragongo")
replace admin2 = "Rutshuru" if inlist(admin2, "RUTSHURU", "Rusthuru", "Rutshuru")
replace admin2 = "Walikale" if inlist(admin2, "WALIKALE", "Walikale")

**There are two types of Beni - be careful!!
replace admin2 = "Beni_Oicha" if inlist(admin2, "BENI (Territoire / Oicha)", "BENI TERRITOIRE (OICHA)")
list if admin2 == "BENI" // code 6109 means its ville 
replace admin2 = "Beni_Village" if inlist(admin2, "BENI", "BENI (Ville)")

**renaming and ordering admin variables
order round admin1 admin1code admin2 admin2code  
rename zonedesanteadmin3 admin3
rename codezonesantesite admin3code
order admin3 admin3code, after(admin2code)
gen admin3_proper = proper(admin3)
replace admin3 = admin3_proper
drop admin3_proper
order collectivite collectivite_code, a(admin3code)

**Demographic Variables 
rename ménages household
replace household = "." if household == "-" //Replace "-" with missing value "."
tab household // 58,591 obs
replace household = subinstr(household, ",", "", .)
destring household, replace 
sum household, detail //  50,802 obs 
tab household, missing // 59,265 obs

rename individus individuals
destring individuals, replace force
rename hommes men
destring men, replace force
rename femmes women
destring women, replace force
rename enfants5ans children
label variable children "children under five"
destring children, replace force 

**Demographic Variables ** returned 
rename populationretournée_ménage household_re
replace household_re = "." if household_re == "NA" | household_re == "-"
destring household_re, replace force

rename populationretournée_individus individuals_re
rename populationretournée_homme men_re
rename populationretournée_femme women_re
rename populationretournée_enfant children_re
destring household_re, replace
destring men_re, replace
destring women_re, replace
destring children_re, replace

order round year month site_type admin1 admin1code admin2 admin2code admin3 admin3code household individuals men women children household_re individuals_re men_re women_re children_re

save M23_clean

*****GOAL: Missing Data
clear all
use M23_clean

******descriptive analysis 
ssc install distinct
distinct admin2 admin3 // 10 admin2 and 41 admin3 
distinct admin2 admin3 if admin1 == "North-Kivu" // 9 admin2 and 37 admin 3
distinct admin2 admin3 if admin1 == "South-Kivu" // 1 admin2 and 4 admin 3 

tab admin2 admin3 if admin1 == "South-Kivu"
/*
                      |          Zone de sante (Admin 3) 
Territoire (Admin 2)  | Bunyakiri     Kalehe    Kalonge     Minova |     Total
----------------------+--------------------------------------------+----------
               Kalehe |     1,380        804        778      1,394 |     4,356 
----------------------+--------------------------------------------+----------
                Total |     1,380        804        778      1,394 |     4,356 

*/

tab admin2 if admin1 == "North-Kivu" 

/*
    Territoire (Admin 2)  |      Freq.     Percent        Cum.
--------------------------+-----------------------------------
               Beni_Oicha |      4,686        9.40        9.40
             Beni_Village |        879        1.76       11.17
                  Butembo |      1,821        3.65       14.82
                     Goma |      5,546       11.13       25.95
                   Lubero |      9,939       19.95       45.90
                   Masisi |     10,081       20.23       66.14
               Nyiragongo |        932        1.87       68.01
                 Rutshuru |     10,224       20.52       88.53
                 Walikale |      5,717       11.47      100.00
--------------------------+-----------------------------------
                    Total |     49,825      100.00

Karisimbi is not in the nationwide admin2 data, according to nationwide data Karisimbi is a admin3 level under Goma  
*/

**Descriptive analysis- what are the missing variables 
tab admin1, missing 
/*

     admin1 |      Freq.     Percent        Cum.
------------+-----------------------------------
            |      5,084        8.58        8.58
 North-Kivu |     49,825       84.07       92.65
 South-Kivu |      4,356        7.35      100.00
------------+-----------------------------------
      Total |     59,265      100.00 */ 

replace admin1 = "North-Kivu" if admin1code == "CD61" | admin1code =="COD61"
replace admin1 = "South-Kivu" if admin1code == "CD62" | admin1code == "COD62"


count if admin1 =="" // 1070 observations missing
tab admin2 admin3 if admin1 =="" // 641 obs
/* 
                      |                Zone de sante (Admin 3) 
Territoire (Admin 2)  |    Lubero     Masisi      Mweso  Nyirago..      Pinga |     Total
----------------------+-------------------------------------------------------+----------
                 Goma |         0          0          0          2          0 |        20 
            Karisimbi |         0          0          0          0          0 |         3 
               Lubero |         1          0          0          0          0 |       106 
               Masisi |         0         61         89          0          9 |       232 
           Nyiragongo |         0          0          0         36          0 |        36 
             Rutshuru |         0          0          0          0          0 |       217 
             Walikale |         0          0          0          0         27 |        27 
----------------------+-------------------------------------------------------+----------
                Total |         1         61         89         38         36 |       641 

*/

replace admin1 = "North-Kivu" if admin2 == "Goma" | admin2 == "Karisimbi" | admin2 == "Lubero" | admin2 == "Masisi" |admin2 == "Nyiragongo"| admin2 == "Rutshuru" | admin2 == "Walikale"
count if admin1 =="" // 2 observations missing

list if admin1 =="" // one is column line wrongly inserted, the other is admin3=="Kayna" which is Lubero, NK
replace admin1 ="North-Kivu" if admin3=="Kayna" 
drop if admin1==""
count // now the total obs is 59,264

*************
**admin2*****
*************

count if admin2 == "" // 1
list if admin2 == ""
replace admin2 = "Lubero" if admin3 == "Kayna" // 16 changes
tab admin1 admin2 // 59264 obs, NK has 10 admin2 but it should be 9 
list if admin2 == "Karisimbi" // should be admin2 == "Goma"
replace admin2 = "Goma" if admin2 == "Karisimbi"
tab admin1 admin2 // NK - 9 admin2, SK - 1 admin2

************
**admin3****
************

count if admin3 == "" //427 missing
tab admin2 admin3 if admin1 == "South-Kivu", missing //Kalehe (admin2), Bunyakiri, Kalehe, Kalonge, Minova (admin3)

tab admin3 if admin1 == "North-Kivu", missing // 427 missing  

//three typos found - goal "Beni (Ville)" should be renamed Beni, Kyana into Kayna, Mwesso into Mweso
replace admin3 = "Beni" if admin3 == "Beni (Ville)"
replace admin3 = "Kayna" if admin3 == "Kyana"
replace admin3 = "Mweso" if admin3 == "Mwesso"

// ???????'Nyanzale' is not in the National Displacement Overview 2 Sep24 
list if admin3 == "Nyanzale" // Rutshuru territory

//Missing values in admin3
destring round, replace 
tab round if admin3 =="" // 28.34% from round 2 and 71.66% from round 3

***********
**summary**
***********

count //59,264 total obs 

tab admin1 // attrition 0, 92.65% NK 7.35% SK
tab admin2 // attrition 0, 9 NK, 1 SK
tab admin3, missing // 35 NK, 4 SK
di (427/59264)*100 // attrition of admin3 = 0.7% all data, 100% attrition of admin 3 from round 2 and 3 data 

tab admin2 if round == 2 | round == 3

/*Territoire	(Admin 2)	Freq.	Percent	Cum.
				
	Goma	1	0.23	0.23
	Lubero	22	5.15	5.39
	Masisi	113	26.46	31.85
	Nyiragongo	169	39.58	71.43
	Rutshuru	118	27.63	99.06
	Walikale	4	0.94	100.00
				
	Total	427	100.00
*/

save M23_clean_v2, replace

**************
**next steps**
**************
// find location of Nyanzale - email
// decided to proceed without round 2, 3 data





