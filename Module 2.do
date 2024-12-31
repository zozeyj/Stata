** IDM Spring 2024
** Module 2s

/*
Agenda:
	Scatterplots
	Regression
	Predicted outcome values
	Predicted error terms
	e(sample)
	Logarithmic transformations (natural logs) */


	
use /Users/pct7/Desktop/idm_spring/Datasets/statedata2009-2022.dta

* Is there a relationship between student-teacher ratio and graduation rates?


lookfor ratio graduation rate
* X? Y?

********************************************************************************
*
* Scatterplots  
* Pearson's r correlation statistic
* Bi-variate regression
*
********************************************************************************

pwcorr acg str, sig
* H0, H1?

* Reject the null. The two are associated. 
* More specifically: the relationship is: 
	* 1) negative, 
	* 2) moderately sized, and
	* 3) highly statistically significant. 
		
* What does a Pearson's r of -0.32 look like? 

graph twoway (scatter ac str) // (lfit ac str)

* Lfit stands for line of best fit.
* Y always comes first in scatterplot code, followed by X. 


graph twoway (scatter ac str) (lfit ac str), ///
legend(off) ytitle("HS Grad Rates") ///
title("Figure 1: High School Graduation Rates")

* I don't like the default colors
* Changing the dots to khaki, changing the line to emerald green.
graph twoway (scatter ac str, mcolor(khaki)) (lfit ac str, lcolor(emerald)), ///
 legend(off) ytitle("HS Grad Rates")


* To get the slope, we have to regress Y on X 

reg acg str
 
* Interpret b0 and b1.
 
* Visualize the magnitude of b1 by looking at the slope
 
graph twoway (scatter ac str, mcolor(gs14)) (lfit ac str, lwidth(medium))


********************************************************************************
*
*  More regression
*  More scatterplot
*  Post-estimation commands
*  e(sample)
*  Predictions  
*
********************************************************************************

* let's limit this to just 1 year. 
* I want to select the year with the beta that's highest in significance & magnitude

reg acg str if year==2010
reg acg str if year==2011
reg acg str if year==2012
* etc... through 2021

* OR...
* run all 11 years of regressions with a by statement. 
bysort year reg acg str

* Interpret b1

* N = 50. Where is the missing observation? 

count if e(sample)==1
count if e(sample)==0 
count if e(sample)==0 & year==2019

br state acg str if year==2019

list state year acgr str  if  year==2019  & e(sample)==0

tab e(sample) // this doesn't work. e(sample) is not a true variable
* The typical way we use e(sample) is by adding it to if statements to continue
* our analysis on only the observations that were included in our regression. 


* Sometimes we want to know the predicted values. 
* That is, we want to know Yhat 

* Yhat = b0 + b1hat* X
* Grad_rates_hat = 98.04 - 0.825*Student_teacher_ratio   


* Sometimes we also want to know the residual values (the error terms)
* residual = Yi - Yhat

graph twoway (scatter ac str) (lfit ac str) if year==2019, ///
legend(off) ytitle("HS Grad Rates")


************************************
* What's the graduation rate for 
* Maryland predicted by this model?

* What's the predicted graduation
* rate for Virginia? 

* What are the residual values? 
* How far did the model miss MD & VA? 

*************************************

reg acg str if year==2019



* To predict Maryland's and Virginia's grad rates, we need their S/T ratios:

list state stratio acgr if year==2019 & (state=="MARYLAND" | state=="VIRGINIA")


* Grad_rates_hat = 98.04 - 0.825*Student_teacher_ratio
* Maryland predicted graduation rate = 98.04 - 0.825*(14.79)
 
display 98.04 - 0.825*14.79 //  = 85.84

* Maryland's actual 2019 HS grad rate = 86.8

* Maryland's residual (error) term = 

di 86.8 - 85.84 // Maryland's error term is 0.96.

*********************************************************

* Virginia predicted graduation rate = 98.04 - 0.825*(14.88)

di 98.04 - 0.825*14.88 // = 85.76

* Virginia's actual 2019 HS grad rate = 88.8

* Virginia's residual (error) term = 

disp 88.8 - 85.76   // = 3.04


* We could do this 48 more times (!), once for each state, find each remaining
* state's student-teacher ratio value, plug it into the regression line, find
* the predicted value, subtract to get the residual. 

* Or, we could ask Stata to do it. 

reg acg str if year==2019

br state acgr stratio if year==2019 
// leave this browse window open and watch Stata populate the next two columns


predict yhat if year==2019, xb        
predict residual if year==2019, resid       

sum residual // All the positive residuals cancel out the negative residuals. 
             // That's a feature of the best-fitting line.
			 // So the mean calculated in the sum output is 0 (rounding error)

** Now let's bring scatterplots back into it.
** We know that all the predicted values lie on a single line. 
** It's a linear relationship between X and Y (s/t ratio & grad rates)

** So what happens when we graph yhats? 

graph twoway (scatter acg str,  mcolor(khaki)) ///
 (scatter yhat str, mcolor(emerald)) if year==2019, ///
legend(off) ytitle("HS Grad Rates") yline(85.332)


graph twoway (scatter acg str if abb=="MD" | abb=="VA",  ///
mlabel (abb) mcolor(khaki)) ///
 (scatter yhat str, mcolor(emerald)) if year==2019, ///
legend(off) ytitle("HS Grad Rates") yline(85.332)

********************************************************************************
*
*  Logarithmic Transformations  
*
********************************************************************************

/* 

Does the number of Republican (conservative) lawmakers in a state's legislative
body affect the monthly, cash TANF benefit for a family of 4? 

*/


* X = number of Republican lawmakers in upper houses of state legislatures
* Y = $$ value of TANF benefits (monthly, family of 4)

desc tanfb numuhr 

* Restrictions: 2017 and 2018 only. This restriction is purely for illustration. 

* Three specifications:
	* 1. Level X / Level Y
	* 2. Log X  / Level Y
	* 3. Log X  / Log Y ... this generates the elasticity.
	
* I already checked the variables to ensure they're ready for analysis.
inspect tanfb numuhr
sum tanfb numuhr, detail
histogram tanfbens4, freq width(25)
histogram  numuhr, freq width(1)


/*******************************
      ORDER OF REGRESSIONS
 
     1. Level X  /  Level Y
       2. Log X  /  Level Y
        3. Log X  /  Log Y

*******************************/


** 1. LEVEL / LEVEL

reg tanfb numuhr if year==2017 | year==2018

* b1 = -9.12
* b0 = 742 (we don't care about this)
* N = 100 Nebraska was dropped, missing its X, doesn't have upper & lower houses

gen lntanf = ln(tanfbens4)
gen lnrepubs = ln(numuhr)

** 2. LOG  /  LEVEL

reg tanfb lnrep if year==2017 | year==2018

* b1 = 172
* N lost 4 observations. Where did they go? 

list state year numuhr if e(sample)==0 & (year==2017 | year==2018) // 


list state year numuhr ///
if (abb=="DC" | abb== "HI") & (year==2017 | year==2018)

* the natural log of 0 or a negative number is undefined. 
* Stata assigned dots to the log of DC's and Hawaii's Republican variable

** 3. LOG  /  LOG   

reg lntanf lnrep if year==2017 | year==2018

* b1 = -0.34. 
* This the elasticity. It's the percentage change in Y from a 1% increase in X. 

* < END >





