** IDM
** Module 4S

* AGENDA

	* 1. categorical (factor) variables in a multiple regression using i.
	* 2. f-tests of joint significance
	* 3. lagged Xs


* Open the dataset with state panel data:
cd /Users/pct7/Desktop/idm_spring/Datasets/
use statedata2009-2022.dta 
	
* Is wealth related to health insurance coverage?

* Specifically:
* Are state rates of uninsured residents associated with GSP/capita?  

* GSP/cap --> rates of uninsurance

* Unit of analysis (or level of analysis) is the state (it's not state-year)
* since in this example we'll continue only looking at one single year, 2011.


gen gspcap = (gsp/pop)*1000

sum gspcap

reg unin gspcap

reg unin gspcap gov region if year==2011 // makes no sense.

* PROBLEM:
* SOLUTION:

* Follow what I'm doing but you don't have to create these new binary variables. 

gen northeast=(region==1)
tab region north if year==2011

* that first generate line is the same as

gen northeast=0
replace northeast=1 if region==1 
tab region north if year==2011

* use this shortcut very carefully. 

gen south=(region==2)
tab region south if year==2011

gen midwest=(region==3)
tab regi mid if year==2011

gen west=(region==4)
tab regi west if year==2011

reg unin gspc gov north south mid wes if year==2011 // need a baseline category


* bsouth = 5.56. 
* Holding gsp and governors' political party constant, states in the south have
* 5.56 percentage points higher rates of uninsurance, on average, compared to 
* states in the northeast (statistically significant at 99.9% conf level)

* bmidwest = 0.87.
* Not statistically significantly different from zero. 

* bwest = 6.43
* Holding gsp and governors' political party constant, western states have
* 6.43 percentage points higher rates of uninsurance, on average, compared to 
* northeastern states (statistically significant at 99.9% conf level)


* We're not able to compare any region to any other region except the northeast
* unless we switch out the omitted category...

reg unin gspc gov north south mid  if year==2011
* bnortheast = -6.43.
* Holding gsp and governors' political party constant, states in the northeast 
* have 6.43 percentage points lower rates of uninsurance, on average, compared 
* to western states (statistically significant at 99.9% conf level).

* Note how this is consistent with our b on west earlier. It doesn't matter 
* which cateogry we decide to omit, we get the same baseline estimates. 


* An easier way of estimating dummy variable effects from a categorical variable:

reg unin gspc gov i.region if year==2011

* Note that everything is the same as above. 

* Which region (category) gets omitted?
* That's Stata's decision. Here, it omitted the first category. 
* You can change it up.

reg unin gspc gov ib4.region if year==2011


/* 



i.race
i.educ
i.marital
i.Likert
i.etcetera


*/


******************************************************************************

** Part 2:

** F-tests of joint significance

** (Another example of a "post-estimation" command)

******************************************************************************

* Let's add more variables that capture the political ideology of each state.

d percuhdem perclhdem // inspect












reg unin gspc gov percuhd perclhd i.region  if year==2011 















* govdem, percuhdem, perclhdem all measure political ideology of a state.
 
 
* (Results not reported): I ran three regressions using only one of each
* of the variables. In all three cases, the variables had significant 
* effects on their own.  

* But when we add all 3 to the regression, none is significant at the 
* alpha = 0.05 level. 

















* That's not suggesting that political ideology has no stat signficant effect.
* Instead, it's more likely the variables overlap a lot. All three represent
* the same concept and are competing with each other for stat significance. 




















pwcorr govdem percuhdem perclhdem, sig

















* Are they statistically significant as a package?
	* Are the "jointly" significant?  
		* Do we get statistically significantly better predictions of Y by 
		* including all 3 compared to a regression without all 3? 

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
* alpha = 0.05

* H0, H1

reg unin gspc govdem percuhd perclhd i.region  if year==2011 

test govdem percuhdem perclhdem












* Compare observed value of F-statistic to the critical, cutoff value of F

* Critical value of F =  2.8327
	* online resources
	* display invFtail(df1, df2, 0.05)

* Observed F-statistic = 4.46

* Fail to reject? Reject? 










/* 

At the 95% confidence level, we reject the null hypothesis and conclude that the
three political ideological variables are jointly statistically signifant.

The three variables together have a stat signficant effect on uninsurance rates
even though each variable on its own is stat insignificant in the multiple reg.  

""
*/ 
reg unin gspc gov north south mid wes if year==2011



















******************************************************************************

** Part 3:

** Lagging the X variable

******************************************************************************

* Let's keep with:
* Y = rates of uninsurance  

* But switch up the X to govdem (whether the state has a democratic governor)

* Democratic governor --> rates of health uninsurance

* We've already checked these variables and determined they don't need cleaning.



* For ease of illustration, I want to focus only on Illinois for a minute.

list fips if state=="Illinois" // fips=

sort fips year
br state year govdem unin if fips==17 

sort fips year
* 1-year lag...
gen govdemlag1 = govdem[_n-1], a(govdem) 

* What just happened? 
br state year govdem* unin if fips==17 

* We can lag by more than one year. The appropriate lag depends on the context. 
* 2-year lag...
gen govdemlag2 = govdem[_n-2], a(govdemlag1)

* 3-year lag...
gen govdemlag3 = govdem[_n-3], a(govdemlag2)

br state year govdem* unin if fips==17 

* Problem: Stata doesn't know that states are our unit. 
* As it's lagging the values / pushing the values down 1/2/3 years, it's pushing
* the later years' values of govdem into the next state, Indiana.

br state year govdem* unin if fips==17 | fips==18

* So we need to run the lag code state-by-state. 

* This should come as no surprise to you, but... 
* We'll use a by statement to instruct Stata to run a line of code
* over-and-over, each time for a different state.

drop govdeml*
sort fips year
by fips: gen govdemlag1 = govdem[_n-1], a(govdem)
by fips: gen govdemlag2 = govdem[_n-2], a(govdemlag1)
by fips: gen govdemlag3 = govdem[_n-3], a(govdemlag2)
br state year govdem* unin if fips==17 | fips==18

* Each state is protected from the previous state creeping into it. 


* But another problem remains: 
* We potentially lose observations for every year that we lag. 
 
qui reg unins govdem i.fips i.year // N = 561

di e(N),  _b[govdem],  _se[govdem]

qui reg unins govdemlag1 i.fips i.year // N = still 561 (that's an anomoly)
 di e(N),  _b[govdem],  _se[govdem]

qui reg unins govdemlag2 i.fips i.year // N = 510
 di e(N),  _b[govdem],  _se[govdem]

qui reg unins govdemlag3 i.fips i.year // N = 459
 di e(N),  _b[govdem],  _se[govdem]

* (Xi,t, Yi,t) no lag:        n = 561, b=-0.27, p=0.83
* (Xi,t-1, Yi,t) 1-year lag:  n = 561, b=-0.30, p=0.043
* (Xi,t-2, Yi,t) 2-year lag:  n = 510, b=-0.35, p=0.017
* (Xi,t-3, Yi,t) 3-year lag:  n = 459, b=-0.40, p=0.003



* Details? No. 
* Generalities? Yes.   

* << END >>








