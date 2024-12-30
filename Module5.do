**Module 5
cd "C:\Users\yeji\Desktop\R Practice\stata"
use "IDM_SoP45 (1)"
save "Module 5"
br

rename V0001B persid
gen year=2016, a(persid)

//family also incarcetrated?
describe V1172-V1174
summarize V1172-V1174
tab1 V1172-V1174
replace V1172=0 if V1172==2
replace V1173=0 if V1173==2
replace V1174=0 if V1174==2

replace V1172=. if V1172<0
replace V1173=. if V1173<0
replace V1174=. if V1174<0
tab1 V1172-V1174, missing

gen famprison = V1172+V1173+V1174
list persid V1172-V1174 famprison in 1/10

//mental health index
gen mhealthtotal = V1179+V1180+V1181+V1182+V1183+V1184
gen mhealthavg = mhealthtotal/6
br mhea*

lookfor age
rename RV0001 age
sum age
gen agesq = age^2
br a*
gen birthyear = year-age

lookfor race
rename RV0003 race
tab race, missing
gen white =1 if r==1, a(race)
replace white=0 if r!=1
replace white=. if race==.
tab race white, missing

rename RV0051 marital
tab marital, missing
replace marital=. if marital==98
gen married=.
replace married=1 if marital==1
replace married=0 if marital>1 & marital <6
tab ma*, missing

save "Module 5", replace