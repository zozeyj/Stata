*Module 4
cd "C:\Users\yeji\Desktop\R Practice\stata"
save "Module4.dta"
describe

lookfor exercising write smoking

rename V0001B persid
rename V1254 smoking
rename V1260 exercise
rename V1397 writeups

browse persid smoking 
tab smoking, missing
count
inspect sm // confirms that 17,407 is missing
br sm

//treating missing values 
describe exercise
summarize exercise, detail
histogram exercise, frequency
tab exercise
inspect exercise
replace exercise =. if exercise<0

d write
summarize write
codebook write
histogram write, frequency
inspect write
replace write =. if write ==-1 | write==-2

//useful commands
help destring
summarize exercise if smoking ==1, detail
gen mentalhealthindex = V1179+V1180+V1181, b(V1179)
gen mentalhealthindex2 = V1179+V1180+V1181+V1182+V1183+V1184, b(V1179)
histogram write if write>0, percent
tabulate V1182, plot

//Operators
rename RV0001 age
sum age, detail
graph box age, by(sex)
help graph

rename RV0005 sex
sum sex, detail
tab sex, sum(age) 
bysort sex: sum(age)
//useful to tabulate dummy variable with integer 

rename RV0003 race
tab race, plot
histogram race, percent
*black incarceration is five times higher than white, but in this dataset, white sample is greater than that of black inmates 

tab V1217
tab V1217 if race==2 & sex==1 & age<30
describe V1397

rename V1182 depressionfrequency
tab depress sex, column

save "Module4.dta", replace

*Assignment 3
use "IDM_SoP45"
describe RV0051 
rename RV0051 marital
tab marital
tab V1132
rename V1132 income
replace income =. if income <0
tab marital income, column

lookfor exercis state offense
summarize V1260, detail
rename V1260 exercise
replace exercise=. if exercise<0

summarize exercise if V0772=="HI", detail
histogram exercise if V0772=="HI", frequency
summarize exercise if V0772!="HI", detail

rename RV0005 sex
lookfor sentence
rename V0402 sentencelength
tab sex, sum(sentence) 
tab V0062, sum(sentence)
tab V0062 sex, column

