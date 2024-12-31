//PPOL 5100 PS3 Yeji KIM
log using PS3Yeji
//Prework
sysuse nlsw88.dta
*(NLSW, 1988 extract)
describe 

//Question 6a.	What are the means of age and age-squared? 
sum age
/*
    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
         age |      2,246    39.15316    3.060002         34         46

A: The mean of age is 39.15 rounded up to the two decimal points*/

gen agesquared = age^2
sum agesquared 
/* 
   Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
  agesquared |      2,246    1542.329    241.6547       1156       2116

A: The means of age-squared is 1542.33. */

//Question 6b.	Use -wage- and -hours- to calculate average weekly wages for each person. What is the mean of weekly wages?

sum hours
gen weeklywage = wage*hours
*(4 missing values generated)

sum weeklywage
/*
    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
  weeklywage |      2,242    298.9781    255.8266    4.64573   1607.924

  A: The average of weekly waves is 298.98. */ 

//Question 6c.	Create a new variable for the log of weekly wages for each person. What is the mean and standard deviation of log weekly wages?

gen logweeklywages = log(weeklywage)
sum log
/* 

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
logweeklyw~s |      2,242    5.421546    .7780338   1.535949   7.382699

A: The mean for the new variable is 5.42, whereas SD is 0.78 rounded up to the second decimal points */

//Question 6d.	Create histograms for weekly wages and log of weekly wages. Title graphs appropriately. Export graphs as .png file

histogram weekly, percent
*(bin=33, start=4.64573, width=48.584177)

histogram logweekly, percent
*(bin=33, start=1.5359485, width=.17717426)

//Question 6e.	Create a new variable by rounding wage to the nearest dollar. What is the most common hourly wage, after rounding? How many people reported the most common rounded hourly wage?

gen roundedwage = round(wage,1)

/*
roundedwage |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |          5        0.22        0.22
          2 |         51        2.27        2.49
          3 |        264       11.75       14.25
          4 |        302       13.45       27.69
          5 |        286       12.73       40.43
          6 |        263       11.71       52.14
          7 |        208        9.26       61.40
          8 |        167        7.44       68.83
          9 |        130        5.79       74.62
         10 |        151        6.72       81.34
         11 |         91        4.05       85.40
         12 |         89        3.96       89.36
         13 |         52        2.32       91.67
         14 |         26        1.16       92.83
         15 |         36        1.60       94.43
         16 |         12        0.53       94.97
         17 |         19        0.85       95.81
         18 |         12        0.53       96.35
         19 |          8        0.36       96.71
         20 |          4        0.18       96.88
         21 |          5        0.22       97.11
         22 |          2        0.09       97.20
         23 |          4        0.18       97.37
         24 |          2        0.09       97.46
         25 |          5        0.22       97.68
         26 |          3        0.13       97.82
         27 |          1        0.04       97.86
         28 |          3        0.13       98.00
         29 |          1        0.04       98.04
         30 |          3        0.13       98.17
         31 |          3        0.13       98.31
         32 |          3        0.13       98.44
         33 |          1        0.04       98.49
         36 |          6        0.27       98.75
         39 |         11        0.49       99.24
         40 |         16        0.71       99.96
         41 |          1        0.04      100.00
------------+-----------------------------------
      Total |      2,246      100.00

. 
end of do-file 

A: Rounded wage of 4 dollars/hour takes up the most frequency, 13.45% of all respondents and its frequency is 302. */


//Question 6f.	Create a horizontal bar graph showing the average wage for each occupation. Re-label the x-axis, "Average Wage". Title the graph, "Average Wage by Occupation". Export the graph as a .png file

lookfor occupation
/*
Variable      Storage   Display    Value
    name         type    format    label      Variable label
-----------------------------------------------------------------------------
occupation      byte    %22.0g     occlbl     Occupation

. 
end of do-file
*/

tab occu, sum(wage)
/*
            |       Summary of Hourly wage
 Occupation |        Mean   Std. dev.       Freq.
------------+------------------------------------
  Professio |   10.723624   6.3510736         317
  Managers/ |   10.899784   7.5215875         264
      Sales |   7.1544893   5.0427568         726
  Clerical/ |   8.5166856   8.5653995         102
  Craftsmen |    7.152988   3.7629626          53
  Operative |   5.6538061   3.3861932         246
  Transport |   3.2004937   1.3209668          28
   Laborers |   4.9058895   3.6083499         286
    Farmers |   8.0515299           0           1
  Farm labo |   3.0837354   .76638443           9
    Service |   5.9887432   2.1399333          16
  Household |   6.3888881   .31313052           2
      Other |   8.8362936    4.128914         187
------------+------------------------------------
      Total |   7.7779283   5.7613599       2,237

. 
end of do-file */

graph hbar wage, over(occupation) 

//Question 6g.	Create a histogram showing the distribution of outcomes on job tenure. Title the graph, "Distribution of Job Tenure". Export graph as .png file

lookfor tenure

/*
Variable      Storage   Display    Value
    name         type    format    label      Variable label
-----------------------------------------------------------------------------
tenure          float   %9.0g                 Job tenure (years)

. 
end of do-file */

histogram tenure

log close

