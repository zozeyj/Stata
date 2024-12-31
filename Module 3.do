** Intro to Data Mgmt
** Spring 2014
** Module 3S

/* 
Agenda
	1. Multiple regression
	2. r(mean), r(sum), predict, e(sample)
	3. R-squared
*/


cd /Users/pct7/Desktop/idm_spring/Datasets/
use statedata2009-2022.dta 

/* 
University of Kentucky, Center for Poverty Research. (2023, Feb.). UKCPR
National Welfare Data, 1980-2021. Lexington, KY.                           */

* Is wealth related to health insurance coverage? 

* More specifically:

********************************************************************************  

*     Are state rates of uninsured residents associated with GSP/capita?     *

********************************************************************************

* Dependent variable? 

* Independent variable? 

* This is the effect we care about (in this illustration). We'll add a couple 
* more variables to create a multiple regression -- but it's the effect of 
* gsp/capita that we are interested in exploring. We'll add the other two 
* variables merely as a way of estimating the coefficient on gsp/capita as
* accurately as possible (free of bias).

* Start with the outcome variable.

lookfor insurance

inspect unins // We're missing 51
list year if unin==. 
* In the year 2020, the Census Bureau wasn't able to get data for this variable
sum unin, detail
histogram unins, freq 
* The previous 2 commands suggest a variable that's clean and ready for analysis

*************************************
** 
** Bivariate (simple) regression
** 
** Start with a continuous variable 
** (the one in our research question)  
**
*************************************

* Our key independent variable.

d gsp
sum gsp, det // 1,000,000s. We'll have to account for that when we create gspcap

gen gspcapita = (gsp/pop)* 1000000

sum gspcap, det // looks right.
histogram gspcap if washdc~=1, freq

* And onto the regression.

reg unins gspcap  if year==2011 

* N?
* R2?
* b1?

* b1 is too tiny to be meaningful. That's because the X variable is measured in
* units of a single dollar, which is way too granular.
* This will mean a lot more to policy makers if we re-scale it to 1,000s.

sum gspcap
replace gspcap = gspcap/1000

* Now it's measured in 1000s.

sum gspcap 

reg unin gspca if year==2011
* b1 = If a state's income per person increases by $1,000, it's predicted share
*      of uninsured residents will decrease by about 0.07 percentage points. 
* p = 0.018
* R2 = 0.1082


*************************************
** 
** MULTIPLE REGRESSION
** 
** Add another variable:  
** In this case, a binary. 
**
*************************************


* Does the political party of the state governor affect uninsurance rates? 
* Does it affect our original beta on GSP/capita (the X we care about)?
* My hypothesis...

lookfor governor

tab govdem if year==2011 

* Before we add dummy variable to the regression, are GSP/capita and Democratic
* governors correlated? 

ttest gspcap, by(washdc)

* Since the correlation is statitiscally significant and moderately sized, 
* we should expect the beta on GSP/capita in the original regression to 
* wiggle at least a little bit. 

reg unin gspcap govd if year==2011

* b1 = -0.055  /   p = 0.053
* b2 = -2.25   /   p = 0.056
* R-squared? 

****************************************
** 
** MORE MULTIPLE REGRESSION...
** 
** This time, add a categorical variable 
**  
****************************************

* What effect does region of the country have on uninsurance rates? 
* In particular, how does region affect the beta on our key X variable, GSP/cap?
* Hypothesis. 

tab region if year==2011 , nolabel

* Before we add region to the regression, is it related to uninsurance rates? 

tabstat unin if year==2011, by(region) statistics (mean min max)

reg unins gspcap govd region if year==2011
* b3 /  p 
* This is meaningless. "A one-unit increase in Region..." that makes no sense.





********************************************************************************
********************************************************************************

*             PAUSE HERE AND PROMISE ME YOU WILL NEVER DO THIS.                * 

*         NEVER PUT A CATEGORICAL VARIABLE AS-IS INTO A REGRESSION.            *

********************************************************************************
********************************************************************************






************************************

** R-squared: the extended dance mix

************************************


*********************************
** But first, 
** predict: quick refresher
** e(sample): quick refresher
** r(mean) r(sum) intro "SCALARS"
*********************************

* How does the share of state legislators who are Democrats affect TANF 
* monthly cash benefits under the TANF program

desc tanfbens4 perclhdem

reg tanfb perclh  if year==2020

* N = 48

* e(sample): 
* a temporary, latent binary variable capturing observations in the regression

count if e(sample)==1 
count if year==2020 & tanfbens4~=. & perclhdem~=.

* use e(sample) to find where the missing states are

list state tanfb perclhd if e(sample)==0 & year==2020

** Instruct Stata to generate predicted values of the dependent variable. 

br state year tanfb perclhd if e(sample)==1

predict yhat if year==2020, xb 

predict residual if year==2020, resid


** And a new trick. After you run a sum command, Stata calculates and stores a 
** bunch of statistics you can use. 

sum tanfbens4 if year==2020

display r(mean)
di r(Var)
di r(sum)

* This comes in very handy the more we use Stata. 
* There a lots of applications that will present themselves. 
* Here's one. ..

* How many states had TANF benefits below the mean? 
sum tanfbens4 if year==2020
count if year==2020 & tanfb < r(mean)

sort region state
sum tanfbens4
list state region if year==2020 & tanfb < r(mean)

* We're going to use the r(sum) below. 
* It comes in handy when we calcualte R2 ourselves.


************************
** 
** R-squared 
** 
** The main event
** 
************************


* Are student/teacher ratios and graduation rates associated? 

*                    (X) --> (Y)

* Student/Teacher ratios --> H.S. Graduation Rates 

des acgr stratio

keep if year==2019
keep state abb acgr stra
sort state
br






** TOTAL SUM OF SQUARES
 
** The main ingredient is the total variation in Y values from the Y average. 

** = summation(Yi - Ybar). 

** The distance from each observation to the mean. (We'll square them later.)

sum ac // ybar= 85.332


graph twoway (scatter ac str, mcolor(khaki) mlabel(abb)), yline(85.332)

rename acgr2 Yi

br

gen Ybar=85.332

* or, let's use r(mean)

drop Ybar

br

sum Yi

gen Ybar=r(mean) 

label variable Ybar "Average graduation rate"
label variable Yi "Actual graduation rate"


* Ybar isn't what we need. SST is made up of the variation in Yi's from Ybar.

graph twoway (scatter Yi str, mcolor(khaki) mlabel(abb)), yline(85.332)

gen Yi_Ybar = Yi-Ybar

label var Yi_Yb "Diff between actual and average grad rate"

* Now we just need to Sum up all those differences and get the Total!

br

sum Yi_Ybar
display r(sum) // It's essentially 0. The positives cancel out the negatives.

* So we have to square each difference.

gen Yi_Ybar_sq = (Yi_Ybar)^2

br

sum Yi_Ybar_sq

gen SSTotal = r(sum)

reg Yi str

label variable SSTotal "Sum of Squares Total"



* Now let's split SST into SSExplained and SSResidual.

gen abb2=abb if strpos(abb, "MO")
graph twoway (lfit Yi str, lcolor(emerald)) ///
(scatter Yi str, mcolor(khaki) mlabel(abb2)), ///
legend(off) ytitle("HS Grad Rates") yline(85.332)

gen abb3= abb if strpos(abb, "FL")
graph twoway (lfit Yi str, lcolor(emerald)) ///
(scatter Yi str, mcolor(khaki) mlabel(abb3)), ///
legend(off) ytitle("HS Grad Rates") yline(85.332)








* SUM OF SQUARES EXPLAINED

br state Yi Ybar 
predict Yhat, xb

gen Yhat_Ybar = Yhat-Ybar
label var Yhat_Ybar "Diff between predicted (Yhat) and average (Ybar)"

br state Yi Ybar Yhat Yhat_Ybar 

gen Yhat_Ybar_sq = (Yhat_Ybar)^2


* Now we have to add up all the values of (Yhat-Ybar)squared.


sum Yhat_Ybar_sq // We need to do a sum command to get a scalar like r(sum)

gen SSExplained = r(sum)

reg Yi str












* FINALLY SUM OF SQUARES ERROR

graph twoway (lfit Yi str, lcolor(emerald)) ///
(scatter Yi str, mcolor(khaki) mlabel(abb2)), ///
legend(off) ytitle("HS Grad Rates") yline(85.332)

graph twoway (lfit Yi str, lcolor(emerald)) ///
(scatter Yi str, mcolor(khaki) mlabel(abb3)), ///
legend(off) ytitle("HS Grad Rates") yline(85.332)



** Instruct Stata to generate predicted values of the dependent variable. 

br state Yi Ybar Yhat

* residual (the error -- the part that's not explained by the regresion) is
* equal to how far the actual point lies from the regression line.
* That is, the difference between Yi and Yhat.

reg Yi str

* gen residual = Yi-Yhat

* Or...

predict residual, resid


br state Yi Ybar Yhat residual

gen residual_sq = residual^2

br state Yi Ybar Yhat residual*

sum residual_sq

gen SSResidual = r(sum)

reg Yi str

br SS*

