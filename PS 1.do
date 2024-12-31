**************************************
****Regression PS1 YEJI KIM***********
**************************************
//Q3 Use the data in CHARITY 
//(1) what is the average gift in the sample of 4,268 people? What percentage of people gave no gift?

. summarize gift, detail

/*                amount of gift, Dutch guilders
-------------------------------------------------------------
      Percentiles      Smallest
 1%            0              0
 5%            0              0
10%            0              0       Obs               4,268
25%            0              0       Sum of wgt.       4,268

50%            0                      Mean            7.44447
                        Largest       Std. dev.      15.06256
75%           10            200
90%           25            250       Variance       226.8807
95%           25            250       Skewness       5.838054
99%           50            250       Kurtosis       66.91839
*/

// ANS: The average givt is 7.44, from the result 50-75% of people have no gift (Q: is there a way to know the exact percentage instead of a range?)

//(2) What is the average mailings per year? What are the minimum and maximum values? 

summarize mailsyear, detail

/*                 number of mailings per year
-------------------------------------------------------------
      Percentiles      Smallest
 1%          .25            .25
 5%          .75            .25
10%            1            .25       Obs               4,268
25%         1.75            .25       Sum of wgt.       4,268

50%            2                      Mean           2.049555
                        Largest       Std. dev.        .66758
75%          2.5            3.5
90%         2.75            3.5       Variance        .445663
95%            3            3.5       Skewness      -.4856134
99%         3.25            3.5       Kurtosis       2.722057 */

// ANS: The average mailings per year is 2.049, the minimum value is 0.25, the maximum value is 3.5

//(3) Estimate the model givt = B0 + B1mailsyear + u by OLS and report the results in the usual way, including the sample size and R-squared. 

. regress gift mailsyear
/*      Source |       SS           df       MS      Number of obs   =     4,268
-------------+----------------------------------   F(1, 4266)      =     59.65
       Model |  13349.7251         1  13349.7251   Prob > F        =    0.0000
    Residual |  954750.114     4,266  223.804528   R-squared       =    0.0138
-------------+----------------------------------   Adj R-squared   =    0.0136
       Total |   968099.84     4,267  226.880675   Root MSE        =     14.96

------------------------------------------------------------------------------
        gift | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
   mailsyear |   2.649546   .3430598     7.72   0.000     1.976971    3.322122
       _cons |    2.01408   .7394696     2.72   0.006     .5643347    3.463825
------------------------------------------------------------------------------
*/

//ANS: The number of observation is 4,268, R-squared 0.0138, and the regression function is gift=2.01 + 2.65mailsyear and  coefficient B0 and B1 is statistically significant with its p values 0.0001 and 0.006 accordingly.     


//(4) Interpret the slope coefficient. If each mailing costs one guilder, is the charity expected to make a net gain on each mailing? Does this mean the charity makes a net gain on every mailing? Explain

//ANS: The slope coefficient 2.65 indictes that one more mails sent each year will increase the number of gifts by 2.65. Therefore even if sending one more mail will cost 1 guilder, the net gain is 1.65 in every additional mail.   

//(5) What is the smallest predicted charitable contribution in the sample? Using this simple regression analysis, can you ever predict zero for gift? 

//ANS: (Q: Actually I don't understand the context of the question very well) the minimum charitable constibution would happen when mailsyear is zero and hence B0. From above our B0 is 2.01, 

regress gift mailsyear, level(99)

/*      Source |       SS           df       MS      Number of obs   =     4,268
-------------+----------------------------------   F(1, 4266)      =     59.65
       Model |  13349.7251         1  13349.7251   Prob > F        =    0.0000
    Residual |  954750.114     4,266  223.804528   R-squared       =    0.0138
-------------+----------------------------------   Adj R-squared   =    0.0136
       Total |   968099.84     4,267  226.880675   Root MSE        =     14.96

------------------------------------------------------------------------------
        gift | Coefficient  Std. err.      t    P>|t|     [99% conf. interval]
-------------+----------------------------------------------------------------
   mailsyear |   2.649546   .3430598     7.72   0.000     1.765487    3.533605
       _cons |    2.01408   .7394696     2.72   0.006     .1084797     3.91968
------------------------------------------------------------------------------*/

//Ans: and minimum contribution would not likely to be zero, as 99% CI of B0 is 0.1084797 to 3.91968. 

//(6) Create a new variable that measures mail in mailspermonth. Confirm that the coefficient you obtain using this new variable is as large as it should be.

generate mailspermonth = mailsyear/12
summarize mailspermonth

/*    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
mailspermo~h |      4,268    .1707962    .0556317   .0208333   .2916667 */

summarize mailspermonth, detail

/*                        mailspermonth
-------------------------------------------------------------
      Percentiles      Smallest
 1%     .0208333       .0208333
 5%        .0625       .0208333
10%     .0833333       .0208333       Obs               4,268
25%     .1458333       .0208333       Sum of wgt.       4,268

50%     .1666667                      Mean           .1707962
                        Largest       Std. dev.      .0556317
75%     .2083333       .2916667
90%     .2291667       .2916667       Variance       .0030949
95%          .25       .2916667       Skewness      -.4856134
99%     .2708333       .2916667       Kurtosis       2.722057 */
//ANS: The smallest value is 0.0208, the largest value is 0.291

regress gift mailspermonth

/* 
      Source |       SS           df       MS      Number of obs   =     4,268
-------------+----------------------------------   F(1, 4266)      =     59.65
       Model |  13349.7258         1  13349.7258   Prob > F        =    0.0000
    Residual |  954750.114     4,266  223.804527   R-squared       =    0.0138
-------------+----------------------------------   Adj R-squared   =    0.0136
       Total |   968099.84     4,267  226.880675   Root MSE        =     14.96

-------------------------------------------------------------------------------
         gift | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
--------------+----------------------------------------------------------------
mailspermonth |   31.79456   4.116717     7.72   0.000     23.72365    39.86547
        _cons |    2.01408   .7394696     2.72   0.006     .5643346    3.463825
-------------------------------------------------------------------------------
*/

//ANS: Coefficient is now gift=2.014 + 31.79456mailspermonth, since 2.65*12=31.8 hence the scale is as large as it should be. 

*Q4 Use data CEOSAL2 
*(1) Estimate a model relating annual salary to firm sales and market value. Make the model of the constant elsticity variety for both independent variables. Write the results out in equation form. 

regress lsalary lsales lmktval

/*
      Source |       SS           df       MS      Number of obs   =       177
-------------+----------------------------------   F(2, 174)       =     37.13
       Model |  19.3365617         2  9.66828083   Prob > F        =    0.0000
    Residual |  45.3096514       174  .260400295   R-squared       =    0.2991
-------------+----------------------------------   Adj R-squared   =    0.2911
       Total |  64.6462131       176  .367308029   Root MSE        =    .51029

------------------------------------------------------------------------------
     lsalary | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
      lsales |   .1621283   .0396703     4.09   0.000     .0838315    .2404252
     lmktval |    .106708    .050124     2.13   0.035     .0077787    .2056372
       _cons |   4.620917   .2544083    18.16   0.000     4.118794    5.123041
------------------------------------------------------------------------------ */

//ANS: Number of Observation 177, R-squared 0.2991 (same for Adjusted R squared), the equation is Lsalary_hat=4.6209+0.1621283Logsales+0.106708logmarketvalues





