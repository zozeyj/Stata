** IDM Spring 2024
** Module 5S

/* AGENDA:
1. interaction terms
2. quadratic terms
3. robust se's for heteroskedasticity
*/


*********************************************
            ***  Part 1  ***
			***  Set-up  ***
	   ***  Multiple Regression  ***		
*********************************************

* Let's look at the effect of different factors on the sales price of a home...

  * How does a home's age -->  sale price? 
  * How does a home's size --> sale price?
  * Do single family homes sell for different prices than other kinds of homes?

  * And how do the effects of those variables interact with each other? 
  * (new this week)
  
  * For example...
  * Does the effect of age on price differ for single-family homes vs. others?
  * Does the effect of size on price change depending on the size? 
  * We've been estimating a beta then interpreting it only once to apply to all
  * the observations. But...
  * ...what if beta on a variable changes depending on that or another variable?

cd /Users/pct7/Dropbox/1_IDMSpring/Datasets/
use homeprice.dta
  
describe pricenom sqft yearsold yearbuilt bldg

* Create an age variable 

tab yearbuilt

gen age=2010-yearbu, a(sqft) 

tab age

* Prices are captured at nominal rates. 
	* Let's convert all prices into 2010 US dollars.

	* https://www.bls.gov/data/inflation_calculator.htm

gen inflation=. 
br pricenom yearsold infl
replace infla=1.0713 if yearsold==2006
replace infla= 1.0466 if years == 2007
replace infla = 0.9911 if years == 2008
replace infla=1.0124 if yearso==2009
replace infla=1 if yearsold==2010

gen price2010=pricenom*inflation, a(pricenom)

* double-check our work
sum pricen price2 if years==2006 //  $35,000 x 1.0713 inflation = $35,495. 
* An alternative check:
tabstat pricen inflation price2, by(years) 
// The 2010 price equals the nominal price times the inflation factor.

* Research question: Home age --> Home price.

reg price2010 age

* Research question: Single-family construction --> Home price.

describe bldg
tab bldg, miss

* Let's create a dummy variable for single-family homes. 


gen singlefam = .

replace singlefam=1 if bldg==  

tab bldg, nolabel
br bldg

* How to fix? We know this well by now:
replace singlefam=1 if bldg=="1Fam"
replace singlefam=0 if bldg~="1Fam" & bldg~=""
 
reg price2 age single 
 
* A secondary question is:
	* Does effect of age differ for single family homes compared to all others?

graph twoway (scatter price2 age if single==1) (scatter price2 age if single==0)

graph twoway (scatter price2 age if single==1) ///
(lfit price2 age if single==1) ///
(scatter price2 age if single==0) ///
(lfit price2 age if single==0)


* A couple things to notice...
* First, prices for single-fam homes may be determined differently than others.
* Second, predicted prices fall at different rates.
	* They seem to fall much faster at first, then more slowly. 
	* They're decreasing but an an decreasing rate (from highly negative to 
	* gradually less negative).
	* The sales price seems to drop more in the first 10 years than later years.
	* A linear regression line doesn't seem to fit the data very well.

	
* Additionally, I think this illustration will be easier if we zoom in and focus
* on a subset of homes. 

graph twoway (scatter price2 age if single==1 & years==2010) ///
(lfit price2 age if single==1 & years==2010) ///
(scatter price2 age if single==0 & years==2010) ///
(lfit price2 age if single==0 & years==2010)

** Me, messing around with the style to better distinguish the lines and dots...

graph twoway ///
(scatter price2 age if single==1 & years==2010, msymbol(diamond) mcolor(eltgreen)) ///
(lfit price2 age if single==1 & years==2010, lwidth(thick) lcolor(navy)) ///
(scatter price2 age if single==0 & years==2010, mcolor(orange)) ///
(lfit price2 age if single==0 & years==2010, lwidth(thick) lcolor(sienna)), ///
legend(off)

* It also looks like there might be heteroskedasticity. 
* We'll have to test that later, and, if true, fix it.


* Let's explore the effect of a second variable on home prices: size of a home.

d sqft
inspect sqft
sum sqft, det 
histogram sqft, freq


* Visualize the relationship between sqft & sales price:

graph twoway (scatter price2 sqft if sing==1 & years==2010 ) ///
(lfit price2 sqft if single==1 & years==2010) ///
 (scatter price2 sqft if single==0 & years==2010) ///
 (lfit price2 sqft if single==0 & years==2010)
 
graph twoway ///
(scatter price2 sqft if sing==1 & years==2010, msymbol(diamond) mcolor(eltgreen)) ///
(lfit price2 sqft if single==1 & years==2010, lwidth(thick) lcolor(navy)) ///
(scatter price2 sqft if single==0 & years==2010,  mcolor(orange)) ///
(lfit price2 sqft if single==0 & years==2010, lwidth(thick) lcolor(sienna)), ///
 legend(off)


* A couple of the same issues as above when age was the X variable.
	* Homoskedasticity?
	* Process for predicting 1-family homes' value is different than others.
	* But, evidence of curve? 
	* the slope (effect of X) doesn't seem to change at different values of X.

reg price2 age sqft singlefam if years==2010

* Interpret coefficients
* Interpret R2.




*********************************************
             ***  Part 2  ***
         ***  Interaction Terms  ***
*********************************************


* First let's examine how the effect of each of the two continuous variables 
* changes for 1-fam homes versus others.
 
* That is: Are the slopes (for age on price and for sqft on price) different
* for single family homes compared to all others?

graph twoway ///
(scatter price2 age if single==1 & years==2010, msymbol(diamond) mcolor(eltgreen)) ///
(lfit price2 age if single==1 & years==2010, lwidth(thick) lcolor(navy)) ///
(scatter price2 age if single==0 & years==2010, mcolor(orange)) ///
(lfit price2 age if single==0 & years==2010, lwidth(thick) lcolor(sienna)), ///
legend(off)

graph twoway ///
(scatter price2 sqft if sing==1 & years==2010, msymbol(diamond) mcolor(eltgreen)) ///
(lfit price2 sqft if single==1 & years==2010, lwidth(thick) lcolor(navy)) ///
(scatter price2 sqft if single==0 & years==2010,  mcolor(orange)) ///
(lfit price2 sqft if single==0 & years==2010, lwidth(thick) lcolor(sienna)), ///
 legend(off)

* Age --> Price

* H0 effect of age on price doesn't differ between single-fam and non-single-fam
	* Another way to think about it: interaction beta = 0. Slopes are the same.
	
* H1 effect of age on price DOES differ between single-fam and non-single-fam
	* That is: the interaction beta ~= 0. The slopes are different. 

	
* Size --> Price
	
* For the test of whether the effect of size on price differs between the two
* types of homes, H0 & H1 follow the same structure for testing. 


gen agesingle = age*singlef
gen sqsingle = sqft*singlef

       /************************************ 

             Each of these interaction terms only 'switches on' 
                          when the single-family 
                          home variable equals 1. 

             This is the 'extra' slope or the slope differential
			  between single-family == 0 and single-family == 1.
                       
						      ***************************************/
							  							  
reg price2 age ages sqft sqs singlefam if years==2010  


* DOES THE EFFECT OF AGE DIFFER BETWEEN THE TWO TYPES OF HOMES?

* FTR the null that the effect of age differs between the 2 categories of homes.
	* Alternatively: FTR the null that the interaction beta = 0.
	* FTR the null that the slopes are different.
	
	* We don't have enough evidence to conclude at any conventional confidence
	* level that single family homes lose value with age at a different rate
	* than non-single family homes. 
	
	
* DOES THE EFFECT OF SQFT DIFFER BETWEEN THE TWO TYPES OF HOMES?	

* Reject the null that the effect of sqft differs between the two categories at
* all conventional confidence levels (t-stat=3.59, way more extreme than 
* critical value of t at 1.96).
* Interpret the betas. 

* We added interaction terms by creating new variables then putting them into
* the regression. 

* There's an easier way to control for interactions that doesn't involve 
* creating new variables (and potentially doing it wrong).

drop agesingle sqsingle // 

reg price2 c.age##i.singl c.sqft##i.singl if yearsold==2010


***********************************************************
                      ***  Part 3  ***
                   *** Quadratic terms ***
***********************************************************

* When we looked at the original scatterplots and lines of best fit, it looked
* like the lines for the age --> price, they looked like they should have had some
* curve to them.

graph twoway ///
(scatter price2 age if single==1 & years==2010, msymbol(diamond) mcolor(eltgreen)) ///
(scatter price2 age if single==0 & years==2010, mcolor(orange)), ///
legend(off)

graph twoway ///
(scatter price2 sqft if sing==1 & years==2010, msymbol(diamond) mcolor(eltgreen)) ///
(scatter price2 sqft if single==0 & years==2010,  mcolor(orange)), ///
 legend(off)
 
* That is, it looked like the effect of age on home price DOES differ 
* depending on the age of the home. 

* Let's test that out. 

* H0: the effect of age on price does not change for different values of age.
    * Another way to think about it: 
		* Quadratic term coeff=0; 
		* Slope is constant across the distribution of age.  

* H1: the effect of age on price does change. 
	* Another way to think about it: 
		* Quadratic term coeff~=0; 
		* Slope changes across the distribution of age.

* Quadratic (squared) term
* A special version of an interaction. 

gen age2=age^2, a(age)
gen sqft2=sqft*sqft, a(sqft)


reg price2 age age2 sqft sqft2 singlefam if years==2010

* AGE --> PRICE
	* Reject the null at 99.9% confidence level.
	* The effect of age on price is different depending on the age. 
	* The slope changes for different levels of age. 
	* (The slope is always negative, but it's grows less negative as age goes up.)
	* (The effect of age is decreasing but at a decreasing rate.)

* Let's re-run the regression without creating any new variables 
* (using the ## trick from before):
drop age2 sqft2 
reg price2 c.age##c.age c.sqft##c.sqft single if years==2010

* Notice similarities between the quadratic hyp test and the interaction?
 
* They're very similar. Because quadratic terms are a subset of interactions. 
* Instead of interacting two variables, we're interacting a single variable
* with itself. 

***********************************************************
                  ***   Part 3   ***
             ***   Heteroskedasticity   ***
***********************************************************

* Let's go back to the first regression with the two interaction terms

reg price2 c.age##i.singlefam c.sqft##i.singlefam if years==2010 

predict residual if e(sample)==1, resid 

twoway scatter resid age, yline(0) // looks like a violation of homosked variances

sort age 
 generate ageord = ceil(5 * _n/_N)
 
tab age ageord

tabstat resid if years==2010, by(ageord) statistics(r v)

* White test for heteroskedasticity. 
* Run this after a regression (so Stata has a regression in its memory).
estat imtest, white

reg price2 c.age##i.singlefam c.sqft##i.singlefam if years==2010
reg price2 c.age##i.singlefam c.sqft##i.singlefam if years==2010 , robust




