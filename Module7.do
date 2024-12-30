**Module7
cd "C:\Users\yeji\Desktop\R Practice\stata"
use "Module 5.dta"
desc pers age mhealth*
label variable mhealthtotal "Mental health index total"
label variable mhealthavg "Mental health index average"

lookfor born
rename V0945 bornUS
tab bornUS
replace bornUS=. if bornUS<0
replace bornUS=0 if bornUS==2
tab born, miss

lookfor education
rename V0935 education
summarize education
replace education=. if education<0
tab bor if educ>=12 & educ<17

lookfor sex
rename V1213 sexorientation
tab sex
replace sex=. if sex<0
tab sex, missing

lookfor marr
tab married, missing
tab sex married, column
count if sexor==1 & mari==1

lookfor exer
rename V1260 exercise
sum exercise
replace exercise =. if exercise<0

lookfor smok
rename V1254 smokenow
tab smokenow, missing
sum exercise if smok==1 | smok==2
sum exercise if smok==3

lookfor offen
tab V0062, missing
rename V0062 offencetype
lookfor state
rename V0772 state
br state
tab offen if state=="AK" | state=="HI", missing

//lecture 
clear
edit
gen year=2010, a(stateabb)
drop state var7
destring urban, replace ignore(",")
replace urban = urban/10
save statedata_2010.dta, replace

clear
edit
gen year=2019, a(stateabb)
drop state var7
destring urban, replace ignore(",")
replace urban = urban/10
save statedata_2019.dta, replace

clear
edit
gen year=2020, a(stateabb)
drop state var7
destring urban, replace ignore(",")
replace urban = urban/10
save statedata_2020.dta, replace

//append option 1
clear
append using statedata_2010 statedata_2019 statedata_2020
count

//append option 2
clear
use statedata_2010.dta
append using statedata_2019
count
append using statedata_2020
count
br

clear 
use statedata_2019
order year gsp region pop, a(statename)
save statedata_2019, replace

use statedata_2010
append using statedata_2019 statedata_2020
sort statename year
save statedata_all.dta

//now some data analysis
reshape wide gsp snapnum urban pop, i(statename) j(year)
gen gspchange = (gsp2020-gsp2010)/gsp2010
sum gspchange, detail
sort gspchange
br statename gspchange
list statename gspchange in 1/5
list statename gspchange in 47/51
gen popgrowth = pop2020-pop2010
list statename popg if popgro<0
pwcorr gspchange popgrowth