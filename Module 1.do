** IDM Spring 2024
** Module 1S

** Agenda
	** Histograms to enhance our analysis
	** Log files

cd /Users/pct7/Desktop/idm_spring/Datasets/
use statedata2009-2022.dta

* Take a few minutes and get to know it...describe, browse. 
* How many observations? 
* What's the level of analysis? 
* What kinds of information is captured in here?
* Where are there gaps in the data?
* How are the variables stored?...
	* numeric (black)?
	* characters (red) ("string")?
	* numeric with character labels (blue)?



********************************************************************************
** 1. Histograms
		** Let's do a mock analysis of state unemployment rates from 2009 onward
		** Steps we might take to begin an analysis. 
********************************************************************************

lookfor unemployment
su une, detail

* No observations??  

br unemp

help destring

destring unemp , ignore("N/A") replace

* or, if you wanted to retain the string version of unemployment...

destring unemp , ignore("N/A") gen(unemp_numeric)

sum unemp, detail

* This doesn't tell much of a story, even with detail

list state year unemp if unemp>=12 & unem~=.

** What about the states where employment held up and unemployment stayed low? 

list state year unemp if unemp<=5.1 & year==2020 
list state year unemp if unemp<=5.1 &  year==2010

list state year unemp if unemp<=5.1 & (year==2010 | year==2020)

* Summarizing by year can help us, too

bysort year: sum(unemp)
tabstat unemp, stats(mean sd min max) by(yea)

* Or drill deeper into a subset or individual unit

tabstat unemp if abb=="NV", by(year)

* But still, sometimes numbers come up short, don't tell the full story. 



* First, let me show you a really complicated histogram.
* Then we can build a simpler histogram piece by piece.

forvalues i=2009/2021 {
	sum unemp if year==`i'
	histogram unemp if year==`i', freq width(0.2) ytitle("") xtitle("") ///
	yscale (range(0 10)) xscale(range(2 14)) ///
	fcolor(khaki) lcolor(brown) ///
	xline(`r(mean)', lcolor(emerald) lwidth(medium)) ///
	title ("Unemployment Rates, `i'") ///
	name ("unemp_`i'")
}

graph combine unemp_2010 unemp_2011 unemp_2012 ///
unemp_2013 unemp_2014 unemp_2015 unemp_2016 unemp_2017 unemp_2018 ///
unemp_2019 unemp_2020 unemp_2021, colfirst col(4)

graph combine unemp_2019 unemp_2020 unemp_2021, col(1)


/*
Here's how we export the results.
 --	Stata saves the most recent graph generated. 
 --	You can choose other formats besides pdf.  
 --	Name it whatever you want
 -- Add a file path or send it to your current directory.  
* */

graph export unemp_2010-2021.pdf

** Let's build something a lot simpler

histogram unemp

histogram unemp, freq width(0.2)

histogram unemp, freq width(0.2) fcolor(khaki) lcolor(brown) ///
 title("Figure 1: Histogram of State Unemployment Rates, 2009-2020", ///
 size(medium) position(7)) ///
 xtitle("") ytitle ("Number of State/Years")

 
* A lot of these changes can be made using a drop-down menu in the upper-right
* hand corner of the graph.


** Schemes!

histogram unemp, freq width(0.2) scheme(s2mono) ///
 title("Figure 1: State Unemployment Rates, 2009-2020", size(medium)) ///
 xtitle("") ytitle("") ///
 xlabel(0 5 10 15, labsize(small)) ylabel(10 20 30 40, labsize(small))

histogram unemp, freq width(0.2) scheme(economist) ///
 title("Figure 1: State Unemployment Rates, 2009-2020", size(medium)) ///
 xtitle("") ytitle("") ///
 xlabel(0 5 10 15, labsize(small)) ylabel(10 20 30 40, labsize(small))

 
 
** Finally, imagine what it would look like to add a by statement...

histogram unemp if year>2018 & year<2022, by(year) width(0.2) freq ///
fcolor(khaki) lcolor(brown)  


********************************************************************************
*** Log files
********************************************************************************

log using Histogram_log, replace

lookfor unemployment
describe unemp
sum unemp
sum unemp, detail
list state year unemp if unemp>=12  & unemp~=.

** Michigan and Nevada had the worst unemployment during recessions.

list state year unemp if unemp<5.1 & (year==2010) 

** Nebraska and the Dakotas had the lowest unemployment during recessions.

histogram unemp if year>2018 & year<2022, by(year) width(0.2) freq ///
fcolor(khaki) lcolor(brown)  

log close
