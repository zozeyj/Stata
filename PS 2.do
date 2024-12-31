*Yeji KIM
*a. How many regions are included in the dataset? How many countries are in each region?

. sysuse lifeexp

. tabulate region


*ANS: there are three regions included in the dataset. In Europe & C. Asia, there are 44 countries, in North America there are 14 countries and South America there are 10 countries. 

*b. List countries in the largest region*

list country if region == 1

*ANS: from the tabulate function, we have observed the frequency for Europe and Asia is the greatest, and there are 44 countries. In order to have the list of all countries, I used "list" and "if" function. 

*c. Which country has the higest GNP per capita? Which country has the lowest GNP per capita? Use two different methods to answer the above question. 

. summarize
   
    list country if gnppc==370

. list country if gnppc==39980



*ANS: By using summarize function we know what is the minimum and maximum value for gnppc. After we figure out the two numbers, we can use "list" and "If" function to demonstrate what is the country's name according each number. 
*Turns out that Tajikistan has the lowest GNPPC and Switzerland has the highest GNPPC. 

. sort (gnppc)

. list country gnppc

*ANS: the second method is to use sort function to order the data in accordance with gnppc, and use list function to demonstrate the full list of country name and gnppc side by side. Here, we can also figure out that Tajikistan has the lowest gnppc and Switzerland has the highest gnppc.   

*d. what is the difference in GNP per capita between these two countries? 


. summarize gnppc, detail

. di "range of gnppc" r(max) - r(min)

*ANS: 39610

*e. What is your average life expectancy if you live in North America? 

. tabulate region, summarize(lexp)
*ANS: the average life expectancy in North America is 71.214 years.


*f. How many countries have a population growth rate above 2%? Which ones are they?

. list country if popgrowth>2
. 
*ANS: using "list" and "if" we have gathered the list of countries that have population growth rate above 2%, there are 11 countries. 

*g. Are any countries missing data for safe water? If so, how many? What percentage of the total is missing? 
. count if missing(safewater)
 
. 
. display 28/68*100
. 
*ANS: there are 28 missing data for safe water, and given there are 68 total data, the percentage of data missing is 41.17%.

*h. Are there any string variables in this data set? If so, which variables? 

. describe
 
*ANS: the usage of describe function demonstrates the variable name, storage type, display format, value label and variable label for each variable. Here we find that variable 'country' has a storage type of str28, which indicates string. 

*i. Use tabstat to show the maximum and minimum life expectancy for each region.

. tabstat lexp, by (region) statistics (min max)
 
*ANS: the question asks us to provide the table summary of the variable 'lexp = life expectancy at birth', but we need the summary not by each countries but by region. Hence we add by (variable name) function after tabstat lexp, and statistics function to request two information--min and max--that we need. The tabstat is the table demonstrated above. 
