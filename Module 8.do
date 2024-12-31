** IDM
** Spring, 2024

** MODULE 8S


*******************************************************
	****  AGENDA:
	
		  ****   MULTICOLLINEARITY  
	      ****   PERFECT MULTICOLLINEARITY  
*******************************************************


*******************************************************
          ****    MULTICOLLINEARITY   ****
*******************************************************


/*
In the early stages of the pandemic, were covid infections associated w/income? 



Before we dig start opening datasets and executing with data, let's take a few
steps that we would take in the real world. 

I'm going to think of these as two potentially related concepts, not as varibles
derived from datasets -- that comes later. 

 
It seems likely that they would be associated. I can think of plausible 
channels linking the two. 

For instance, people in low-income service jobs are less likely to be able to
work remotely, take time off to get vaccinated, or take a sick day.

It could be that low-income families live in smaller homes with more people. 

Low-income communities might have less access to health care, including
advances in treating covid, vaccines, and other preventative measures. 


So I hypothesize there's a negative, statistically significant relationship 
between income and infection:
	* Individual unit of analysis: people with lower incomes have a higher
	  likelihood of contracting covid.
	* State unit of analysis: states with lower income levels have higher
	  infection rates. 														  */
	

	
* We ask questions like that and we perform that kind of thinking first.
* Since this is a class on using datasets and Stata to explore research 
* questions and our focus all along has been execution and application, we've 
* tended to skip over that early thinking and its importance. 

* We don't start with the data. We start with ideas about how the world works,
* how concepts are interrelated, then we find the data. 


* The next step is: I have these two concepts that I think are related, and I
* want to know how they're related. So next I looked for, and found, some data. 
	
	
* The data I have is at the state level and all of it is from 2021.

* State unit of analysis. 

* Operationalize the concept of COVID: cumulative infection rate in June, 2021
* Operationalize the concept of income: state median household income, 2021. 

* Citations. 
* This is how I'm defining my main concepts of interest. 

 /Users/pct7/Dropbox/1_IDMSpring/Datasets/
use statedata2021_Module8S.dta	

des totalcases medianinc

reg totalcases medianinc 

gen infectrate=totalcases/pop

label var infec "Covid infection rate, June 2021" 

sum inf med 

reg infectrate medianinc 
* b is very significant and the expected direction. 
* but it's hard to tell what it's saying or understand the scope. 
* get the e notation out of there. 
* Whenever the values of a variable are so big that their coefficients require
* scientific notation or e-notation (either e+ or e-), then we must rescale
* them to something that people can understand. 

replace infect=infect*100 
sum inf

replace medianinc=mediani/1000
sum medianin 


reg infectrate medianinc 
* This is much better. 
* If we compare two states, and one of them has a median income $1000 higher, 
* then we can expect that slightly richer state to have a 0.124 percentage point
* lower covid infection rate.


* But the dataset includes other information that helps us quantify the income
* levels of a state. 

des povrate foodinsecure snaprate tanfrate


* So what if we add them to the regression.

reg infectrate medianinc povrate foodinsecure snaprate tanfrate



* What happened? 
* Income has no effect on covid?


* Lost all signficance not just of median income, but all the variables. 

* If you look at this variable by variable, it looks like income levels in a 
* state have no effect at all on covid infections. 

* So does the concept of income really have no effect on covid?


* Coefficient shifts closer to 0. 
		* It loses a lot of (all?) of its predictive power. The effect of income
		* is being diluted. It's being spread across 5 different variables all
		* capturing the same concept. 
		
* Standard error increases.
		* We lose precision and confidence in our estimate, as measure by the 
		* standard error. Because all of these variables are so entangled and
		* they overlap so much that we can't isolate the effect of any single
		* variable. 
		
* This is multicollinearity.

* Think of how problematic our interpretation is:
		* Holding all things constant, a $1000 increase in median income is...

test medianinc povrate foodinsecure  tanfrate

***********************************************************
          ****   PERFECT MULTICOLLINEARITY   ****
***********************************************************

pwcorr  medianinc povrate foodinsecure snaprate tanfrate, sig

* Very little new information added. 
* Take this further: no new information added. Linear relationships between Xs.

* New question to explore.
* Did political ideology affect COVID infections during the early stages? 

d demmargin demstat
tab demmargin demstat // the 1s and 0s align with demmargin values

* Bivariate regression:
reg infect dems 

* The variable repstate captures the same information, it just flips the values
* of the 1/0 indicators. 
* There's no new info contained in repstate that's not already in demstate.

reg infect demstate repstate

* Other examples:
	* BMI
	* sex (binary)
	* region of the country...


tab region, gen(censusregion)

rename censusregion1 northeast
rename censusregion2 midwest
rename censusregion3 south
rename censusregion4 west

reg infectrate medianinc northeast  south west
* region is mutually exclusive, exhaustive. 
