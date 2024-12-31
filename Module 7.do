** IDM
** MODULE 7

* 1. Logit
* 2. Post-estimation commands (for logit)

* (with a brief side trip to Stata loops)




cd /Users/pct7/Dropbox/1_IDMSpring/Datasets/
use BRFSS.dta



* Is the inability to see a doctor because of cost related to employment status?

* X = employment status
* Y = ability to afford a doctors visit 


* Y variable
tab medcost
replace medcost=. if medcost>2
replace medcost=0 if medcost==2
label define yesno 0 "No" 1 "Yes"
label values medcost yesno


* key X variable

tab employ1
gen empstatus=.
replace empstat=0 if employ1==3 | employ1==4 | employ1==8
replace empsta=1 if employ1<3 | employ1==5
replace empstat=2 if employ1==6 | employ1==7

label define empstV 0 "Unemployed" 1 "Employed" 2 "Retired/Student"
label values empstat empstV
label var empstat "EMPLOYMENT STATUS"


/* Covariates include:
1. whether the individual has asthma
2. whether the invidiual is a veteran of the armed services
3. whether the individual has health insurance
4. whether the individual has gotten a depression diagnosis in the past

5. number of days in the last 30 of poor physical health
6. number of days in the last 30 of poor mental health
7. number of doctors visits in the last year
8. household income 

9. frequency that the individual smokes (3 categories)
10. marital status (6 categories)
11. home status: own, rent, or something else (3)
12. educational attainment (4).                                               */



tab1 asthnow veteran hlthpln addepev
tab1 asthnow veteran hlthpln addepev, nolab
* These should be binary 1/0 variables. But they're not. The have values equal
* to 7 and 9 that need to be changed to missing. 
* Plus the 'no' values are coded as 2. To be a classic, well-behaving dummy
* variable, the 'no' observations have to be 0. 


*********** Change missing values of dummy variables (similar to medcost)

vl create dummies = (asthnow veteran hlthpln addepev)

foreach var of varlist $dummies {
	replace `var'=. if `var'>2
	replace `var'=0 if `var'==2
	label values `var' yesno  
}

*********** Interesting continuous variables also have to be manipulated

vl create cont76 = (phys ment drvis income)

foreach var of varlist $cont76 {
	replace `var'=. if `var'>76
}

*********** And for categorical variables
vl create categorical = (smokday marital renthom educ)

foreach var of varlist $categorical {
	replace `var'=. if `var'>6
}

* Off-line, I double-checked the new coding of all these variables for accuracy. 
* And they're all good. 


****************  LOGIT   *******************


* Logit is the regression option we frequently turn to when our outcome variable
* is binary. 

* An OLS certainly works with a dummy variable as our Y! But it's got a few 
* shortcomings that logit doesn't have. 

* Logit has several properties that we prefer compared to OLS.

tab empstat
tab medcost

tab empstat, nolabel
tab medcost, nolabel


reg medcost i.empstat /// key x variable
male age i.income i.marital veteran i.educ i.renthom /// demographic variables
asthnow phys ment hlthpln addep smokd // health related variables


** For employment status, Stata has automatically chosen the baseline (omitted)
** category:  empstat==0 "Unemployed".
 
** You may want to change the baseline category depending on how you've set up
** your research question. 

** In this case, I want to change the omitted to Retired/Student, which is 2.
** The change I made was converting i.empstat to ib2.empstat... 

reg medcost ib2.empstat /// key x variable
male age i.income i.marital veteran i.educ i.renthom /// demographic variables
asthnow phys ment hlthpln addep smokd // health related variables


* Interpret our variables of interest:
* Holding all things constant, compared to the baseline category of Retirees and
* students, people who are EMPLOYED have, on average, a 5.0 percentage point
* higher probability of not going to the doctor because they can't afford it 
* (statistically significant at 0.001).

* Holding all things constant, compared to the baseline category of Retirees and
* students, people who are UNEMPLOYED have, on average, a 2.6 percentage point
* higher probability of not going to the doctor because they can't afford it 
* (statistically significant at 0.001).

* The probability of being unable to pay for doctors' appointments is actually
* BETTER for unemployed people. They're just 0.026 percentage points more likely
* to skip doctors' appointments compared to retirees and students (statistically
* significantly different from 0 -- but also stat sig different from the effect
* of being employed!...see output from the following code)


* Among the covariates, one interesting outcome is that none of the education 
* variables has a statistically signficantly different effect from the omitted 
* categoy, college graduate. 

* But it's hard to believe that education would NOT be related to ability to 
* pay for Doctor visits.


* BUT are the education levels JOINTLY significant??
* Do "less than HS", "HS grad", and "Assoc/tech/some college" TOGETHER help 
* predict a person's ability to afford doctor's visits? 

test educ  // Doesn't work. 
// Stata doesn't recognize this variable - it's not in the regression,
// Stata didn't control for 'educ' exactly. It controlled for each of the four 
// education category as if they were dummies.

// This line doesn't work either...
test "Less than HS" "HS grad" "Assoc/tech/some college" 

* Instead, this is how you identify an i.categorical variable when you want to 
* conduct  an F-test of joint significance...

test 1.educ 2.educ 3.educ 


* One of the shortcomings of using OLS on a binary Y variables: 

	    * We could end up with predicted Y values that are out-of-range 
		
predict yhat_ols if e(sample)==1, xb

sum yhat_o, detail 

count if yhato<0
di 1269/21787 

// 1,269, almost 6%, have a predicted probability below 0. 
// Yikes! That's completely impossible. 



logit medcost ib2.empstat /// Key X variable
i.male age i.income i.marital veteran i.educ i.renthom /// demographic vars
asthnow phys ment hlthpln addep smokd // health vars

predict yhat_logit if e(sample)==1, pr

sum yhat_lo, det // No more predictions below 0.



******************************
** 2. Post-estimation commands
******************************


logit medcost ib2.empstat /// Key X variable
i.male age i.income i.marital veteran i.educ i.renthom /// demographic vars
asthnow phys ment hlthpln addep smokd // health vars


* Earlier, I interpreted the OLS coefficients on Employed and Unemployed as the 
* marginal effect of being in those two categories compared to the omitted
* baseline category. 
* I only interpreted it once because a OLS coefficients represent the effect on
* ALL observations (unless we've introduced a quadratic or interaction term).

* The coefficient from the logit output cannot be interpreted as a marginal 
* effect. We can't say that employed people have a 0.63 higher probability of
* not being able to afford the doctor. 

* This is for two reasons:
	* First, the coefficients are simply not effects. We can't translate the 
	* numbers that way. So from that standpoint, the initial output we get from 
	* a logit is not that helpful.
	* The sign and the statisical significance are reliable -- but we have to 
	* wonder whether we even CARE about the coefficient's statistical 
	* significance if it doens't translate into anything useful.
	
	* Second, the effect of X on Y estimated from a logit model changes for 
	* different observations. At every different level of X (for any of the Xs),
	* the marginal effect changes. We don't have one constant slope any more. 
	* We've got a different slope (effect for all values of X). The regression
	* line is no longer a line -- it's a curve. And the slope of a curve is
	* constantly changing.

* The implication of these two facts is that we have to run more commands to 
* get the effects from the coefficients. And we have to decide which groups of
* observations we want to calculate the effects for. 











** If you do a logit in the future, you'll work with your advisor or supervisor
** to decide what questions you want to explore with post-estimation commands. 

** Here, briefly, are three places to start. 


logit medcost ib2.empstat /// Key X variable
i.male age i.income i.marital veteran i.educ i.renthom /// demographic vars
asthnow phys ment hlthpln addep smokd // health vars


***************************************************************
** The first, most basic step for us to explore after Logit...
***************************************************************

margins 
// This is our first step. It doens't gives us the marginal effect, though.
// It merely tells us the average predicted probability of Y=1, conditional on 
// all the Xs. 

// This is not the effect of X on Y. 
// This is simply the result of 1) Stata predicting the probability of Y=1 for 
// all observations, then 2) taking the average of those predictions. 

// It equals 0.1886905. 
// This is the same average probability as when we summarize our Y-hat predicted
// values...

sum yhat_logit // same number.

*******************************************************************************
** The second step is to add variables we care about to the margins command...
*******************************************************************************


margins empstat // This is the second step for us to explore... how the 
// predicted probability of Y=1 changes among the different groups we care about

* The average predicted probability of not being able to afford a doctors visit 
* among poeple who are employed is: 0.214. 
* Among people who are unemployed, it's: 0.185.
* Among retirees and students, it's the lowest: 0.139. 
* That's generally consistent with the results from the OLS regressions, above. 


margins income
* The probability of being unable to afford a doctor's visit falls at nearly 
* every income level. It's actually lower at incomes below $20K, perhaps because
* those families are most like to have Medicaid. 


margins male
* men have a slightly overall higher rate of Y=1 



*******************************************************************
** Finally the next and best step, AVERAGE MARGINAL EFFECTS
*******************************************************************

* The average marginal effects of each X variable are frequently the statistics
* we find most useful. 

* It's the closes thing we have to an OLS beta coefficient. 


margins, dydx(empstat)  

* This tells us that the average marginal effect of being unemployed among the
* whole dataset is a 4.6 higher percentage point probability of not being able
* to afford a doctor's visit compared to retirees/students. 



* What does that mean??? 

* To understand that number's meaning, 
* it helps to think about how Stata calculated 


* In running the margins, dydx (empstat) code, Stata did this...

  * It assigned literally every person in the dataset to the baseline, omitted 
  * category of RETIREE/STUDENT. The Stata calculated each person's predicted 
  * probability of not going to the doctore because of cost. 
  * Then it and calculated the average of all those probilities.

  * Then it repeated those steps for the unemployed category...
  * Stata assigned "UNEMPLOYED" to literally every observation in the dataset,
  * then calculated everyone's predicted probability of being unable
  * to afford a doctors visit. Then Stata calculated the average probability. 

  * The average marginal effect is the difference between those two averages. 

* If you think that sounds like a strange journey, just for a second imagine 
* the method Stata uses to calcalate the average marginal effect of being male. 
* Yikes. 

* The really, interesting questions, though, come when you get more specific.
* As a researcher, you might be specifically interested in the experiences of
* people with diagnosed depression. And perhaps how that diagnosis interacts
* with age. 

margins, dydx(age) at (addep=(0 1)) post

* All things equal, as people with depressive conditions get older, with each
* year of age, they have a lower likelihood of being able to afford a doctor's 
* visit, and the change with every year is more than the change for people 
* without a depression diagnosis. 
 
* Don't worry about memorizing all of this post-estimation code. 
* The code you ultimately run will vary with your research question.
* Together with your teammates, professor, advisor or supervisor, you'll
* decide which code to run based on which research questions you want to explore
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

*************  Save this, prob don't need it
gen employed=.
replace employed=1 if employ1<3 | employ1==5
replace employed=0 if employ1==3 | employ1==4 | employ1>5
replace employed=. if employ1==9
replace employed=. if employ1==.
label define empV 0 "Unemployed/Retired/Student" 1 "Employed"
label values employed empV

gen unemployed=(employ1==3 | employ1==4 | employ1==8)
replace unemp=. if employ1==9 | employ1==.
label define unempV 0 "Employed/Retired/Student" 1 "Unemployed"
label values unemp unempV



