*************************************************************************
*Quant 1 Final Project - Analysis of Nigeria Household Survey
*Group members: Maddie Dimarco, Juan Menendez, Yeji Kim, Amna Kaider
*************************************************************************

clear
use "C:\Users\mdima\OneDrive\Georgetown MIDP - Fall 2023\Quant1-Statistical Methods for Development\Final Group Project\nigeria_lsms_FP_update.dta"

**********************************************************************
**Q1 Describe sample statistics. 
**********************************************************************

**(a)
 histogram hhsize, frequency title("Household Size")
 . sum num_child
 . replace num_children=0 if num_child==0
. replace num_children=1 if num_child<=3
. replace num_children=1 if num_child==1
. replace num_children=2 if num_child==2
. replace num_children=3 if num_child==3
. replace num_children=4 if num_child==4
. replace num_children=5 if num_child>=5
. tab num_children
**(b)
 sum head_age if head_sex==1
 sum head_age if head_sex==2
 table head_sex, statistic(percent)
**(c)
sum total_groups if sector==1
sum total_groups if sector==2
sum total_groups if zone==1 | zone==2 | zone==3
sum total_groups if zone==4 | zone==5 | zone==6
**(d)
. table insurance bank, statistic(percent)
/*                                              |    Household has bank account or access to one  
                                              |              No             Yes            Total
----------------------------------------------+-------------------------------------------------
Household used insurance in the last 6 months |                                                 
  No                                          |           66.63           30.66            97.30
  Yes                                         |            0.30            2.40             2.70
  Total                                       |           66.93           33.07           100.00
*/
**(e)
. tab village_connected dwelling_connected
/*   Village |
 connected |
        to | Dwelling connected to
electricit |      electricity
         y |        No        Yes |     Total
-----------+----------------------+----------
        No |     1,542        168 |     1,710 
       Yes |       265        164 |       429 
-----------+----------------------+----------
     Total |     1,807        332 |     2,139 */
. table village_connected dwelling_connected, statistic(proportion)
/*-------------------------------------------------------------------------
                                 |    Dwelling connected to electricity  
                                 |          No           Yes        Total
---------------------------------+---------------------------------------
Village connected to electricity |                                       
  No                             |       .7209        .07854        .7994
  Yes                            |       .1239        .07667        .2006
  Total                          |       .8448         .1552            1
*/
**(f)
. table fcs_profile, statistic(percent)
/*--------------------------------------
                            |  Percent
----------------------------+---------
Food Consumption Thresholds |         
  Poor                      |     4.49
  Borderline                |    16.05
  Acceptable                |    79.45
  Total                     |   100.00
--------------------------------------*/
**(g)
. sum conflict_household_perpetrator conflict_community_perpetrator

/*    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
conflict_h~r |      4,582    .0360105    .1863365          0          1
conflict_c~r |      5,000        .126    .3318826          0          1 */
**(f)
. sum jobtotal
/*    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
    jobtotal |      4,905    2.458716    1.926562          0         18 */
sum jobtotal if sector==1
sum jobtotal if sector==2
sum jobs_agriculture if sector==1
sum jobs_agriculture if sector==2
sum jobs_manufacturing if sector==1
sum jobs_manufacturing if sector==2
sum jobs_professional if sector==1
sum jobs_professional if sector==2

**************************************************************************
*Question 2
*The Government of Nigeria has identified two consumption-based poverty lines, one defined as "ultra-poor" at 300 Naira per month and the other defined as "poor" at 600 Naira per monthw. Using these definitions and the consumption_index variable, what proportion of households are poor? What proportion is ultra-poor? What proportion of poor households is not ultra-poor?

*************************************************************************

*Generate poor and ultra-poor variable
gen income_poor=1 if income<600
replace income_poor=0 if income_poor==.
gen income_ultrapoor=1 if income<300
replace income_ultrapoor=0 if income_ultrapoor==.
gen income_nonpoor=1 if income>600
replace income_nonpoor=0 if income_nonpoor==.
gen consumption_poor=1 if consumption_index<600
replace consumption_poor=0 if consumption_poor==.
gen consumption_ultrapoor=1 if consumption_index<300
replace consumption_ultrapoor=0 if consumption_ultrapoor==.
gen consumption_nonpoor=1 if consumption_index>600
replace consumption_nonpoor=0 if consumption_nonpoor==.

*Generate welfare variable that shows the three different categories of individuals at once (ultra-poor, poor and non-poor)
gen welfare_status=1 if consumption_ultrapoor==1 
replace welfare_status=2 if consumption_poor==1
replace welfare_status=3 if consumption_nonpoor==1
replace welfare_status=1 if consumption_ultrapoor==1




**************************************************************************
*Question 3
*Describe the poverty gap and the severity of poverty for those below the poverty line. Use the Foster-Greer-Thorbecke measurements with parameters 1 and 2 [i.e., FGT(1) and FGT(2)] and interpret each estimate and explain the usefulness of these statistics. 

*************************************************************************


**********
**FGT1*
**********

*Creating a variable that captures the difference between expenditure and poverty line, only for those under the poverty line
generate upoverty = 600-consumption_index
replace upoverty=0 if consumption_index>600

*Indexing the difference
generate fgt1 = (upoverty/600)

**********
**FGT2*
**********

*Indexing the difference and squaring it 
generate fgt2= (upoverty/600)^2



********************
*Question 4
*Predict household poverty status using household characteristics
********************
generate south=0 if zone==1|zone==2|zone==3
replace south=1 if zone==4|zone==5|zone==6
regress consumption_i south

reg consumption_i bank
*bank has strong correlation (p-value less than .05)
reg consumption_i insurance 
*insurance has strong correlation (p-value less than .05)
reg consumption_i asset_i
*asset_index has strong correlation (p-value less than .05)
reg consumption_i fcs 
*fcs has strong correlation (p-value less than .05)
reg consumption_i hhsize 
*hhsize has strong correlation (p-value less than .05)
reg consumption_i num_child 
*num_child has strong correlation (p-value less than .05)
reg consumption_i income
*income has strong correlation (p-value less than .05)
reg consumption_i farm_pr 
*farm_pr has strong correlation (p-value less than .05)
reg consumption_i house_mob
*house_mobile has strong correlation (p-value less than .05)
reg consumption_i dwelling_connected 
*dwelling_connected has strong correlation (p-value less than .05)
reg consumption_i total_village 
*total_village has strong correlation (p-value less than .10)

reg consumption_i insurance asset_index
*when combined, the variables interact, reducing the effect of the variables on the regression

*Generate final model
reg consumption_i bank insurance fcs hhsize num_child income farm_pr house_mob dwelling_connected total_village south




**************************************************************************
*Question 5
*Generate a predicted value for consumption expenditure for each household based on the parameter estimates on observable characteristics you have included in your model. 
*************************************************************************

*Creating the model
gen predicted_cons= (bank*169.69) + (insurance*320.27) + (fcs*1.145) + (hhsize*34.85) - (num_child*47.015) + (income*.0000371) - (farm_proportion*115.78) + (house_mobile*69.41769) + (dwelling_connected*35.38444) - (total_villageorgs*12.4158) + (south*149.133) + 272.079

*Examining results
//a. How does your distribution of predicted consumption expenditures compare with the distribution of reported consumption expenditures? 
sum predicted_cons, detail
sum consumption_index, detail //means very close (8 Nairas)
sum predicted_cons consumption_index

/*  Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
predicted_~s |      4,403    468.5016     211.755    38.4068   1656.133
consumptio~x |      4,991     475.759    747.7191          0      15105 */ 

histogram predicted_cons, xline(`r(mean)') freq
histogram consumption_in, xline(`r(mean)') freq
generate consumptionhist=consumption_in if consumption_in<2000
histogram consumptionhist, xline(`r(mean)') freq

//b. What is the likelihood that households that were identified as "poor" using reported consumption expenditures would be classified as poor using predicted consumption expenditures using your model? 

***FGT1 with predicted consumption***
generate pred_upoverty = 600-predicted_cons
replace pred_upoverty=0 if predicted_cons>600
generate pred_fgt1 = (pred_upoverty/600)

sum pred_fgt1 fgt1

/*    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
   pred_fgt1 |      5,000    .2508721    .2517095          0   .9359887
        fgt1 |      5,000     .561189    .4254193          0          1 */
		


generate povertyline=1 if consumption_index<600
replace povertyline=0 if consumption_index>=600
tab povertyline, mis

/* povertyline |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |      1,396       27.92       27.92
          1 |      3,604       72.08      100.00
------------+-----------------------------------
      Total |      5,000      100.00              */

	  
generate pred_povertyline=1 if predicted_cons<600
replace pred_povertyline=0 if predicted_cons>=600
tab pred_povertyline, mis

/*pred_povert |
      yline |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |      1,747       34.94       34.94
          1 |      3,253       65.06      100.00
------------+-----------------------------------
      Total |      5,000      100.00             */


//Finding the likelihood of identifying poor households with our prediction variable

. tab pred_povertyline povertyline, col

/*+-------------------+
| Key               |
|-------------------|
|     frequency     |
| column percentage |
+-------------------+

pred_pover |      povertyline
    tyline |         0          1 |     Total
-----------+----------------------+----------
         0 |       694      1,053 |     1,747 
           |     49.71      29.22 |     34.94 
-----------+----------------------+----------
         1 |       702      2,551 |     3,253 
           |     50.29      70.78 |     65.06 
-----------+----------------------+----------
     Total |     1,396      3,604 |     5,000 
           |    100.00     100.00 |    100.00 */

		   
prtest povertyline = pred_povertyline
/* Two-sample test of proportions           povertyline: Number of obs =     5000
                                        pred_poverty: Number of obs =     5000
------------------------------------------------------------------------------
    Variable |       Mean   Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
 povertyline |      .7208   .0063442                      .7083655    .7332345
pred_poverty |      .6506   .0067427                      .6373846    .6638154
-------------+----------------------------------------------------------------
        diff |      .0702   .0092582                      .0520544    .0883456
             |  under H0:   .0092847     7.56   0.000
------------------------------------------------------------------------------
        diff = prop(povertyline) - prop(pred_poverty)             z =   7.5608
    H0: diff = 0

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(Z < z) = 1.0000         Pr(|Z| > |z|) = 0.0000          Pr(Z > z) = 0.0000 */


 //c. What proportion of households identified as poor using your model was identified as non-poor using reported consumption expenditures? 
 
 tab povertyline pred_povertyline, column

/* +-------------------+
| Key               |
|-------------------|
|     frequency     |
| column percentage |
+-------------------+

povertylin |   pred_povertyline
         e |         0          1 |     Total
-----------+----------------------+----------
         0 |       694        702 |     1,396 
           |     39.73      21.58 |     27.92 
-----------+----------------------+----------
         1 |     1,053      2,551 |     3,604 
           |     60.27      78.42 |     72.08 
-----------+----------------------+----------
     Total |     1,747      3,253 |     5,000 
           |    100.00     100.00 |    100.00 */


**************************************************************************
*Question 6
*Create a new variable that predicts what consumption expenditure levels will be after the policy is introduced, assuming that households will consume the entire transfer. How does average consumption change as a result of this new policy? 

*************************************************************************

//Dummy for generator
generate generator=1 if electricity_s==3 | electricity_s==4 | electricity_s==5
replace generator=0 if electricity_s==1 | electricity_s==2 | electricity_s==6
tab generator

//a. Create a new variable that predicts what consumption expenditure levels will be after the policy is introduced, assuming that households will consume the entire transfer. How does average consumption change as a result of this new policy? 

//Income after program
gen income_after= consumption_i + 150 if generator==1
replace income_after=consumption_i if generator!=1

//Compare means
sum consumption_i income_after

/*    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
consumptio~x |      4,991     475.759    747.7191          0      15105
income_after |      4,991    483.1823      751.81          0      15105 */

ttest consumption_i = income_after

/*Paired t test
------------------------------------------------------------------------------
Variable |     Obs        Mean    Std. err.   Std. dev.   [95% conf. interval]
---------+--------------------------------------------------------------------
consum~x |   4,991     475.759    10.58387    747.7191    455.0099     496.508
income~r |   4,991    483.1823    10.64178      751.81    462.3198    504.0449
---------+--------------------------------------------------------------------
    diff |   4,991   -7.423362    .4605473    32.53629   -8.326237   -6.520487
------------------------------------------------------------------------------
     mean(diff) = mean(consumption_in~x - income_after)           t = -16.1186
 H0: mean(diff) = 0                              Degrees of freedom =     4990

 Ha: mean(diff) < 0           Ha: mean(diff) != 0           Ha: mean(diff) > 0
 Pr(T < t) = 0.0000         Pr(|T| > |t|) = 0.0000          Pr(T > t) = 1.0000 */
 
//b. What would happen to the poverty headcount ratio as a result of this policy?
gen after_povertyline = 1 if income_after<600
replace after_povertyline = 0 if income_after>=600
sum povertyline after_povertyline

/*    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
 povertyline |      5,000       .7208    .4486509          0          1
after_pove~e |      5,000       .7174    .4503086          0          1 */

ttest povertyline = after_povertyline

/*Paired t test
------------------------------------------------------------------------------
Variable |     Obs        Mean    Std. err.   Std. dev.   [95% conf. interval]
---------+--------------------------------------------------------------------
povert~e |   5,000       .7208    .0063449    .4486509    .7083612    .7332388
after_~e |   5,000       .7174    .0063683    .4503086    .7049153    .7298847
---------+--------------------------------------------------------------------
    diff |   5,000       .0034    .0008233    .0582161     .001786     .005014
------------------------------------------------------------------------------
     mean(diff) = mean(povertyline - after_povertyl~e)            t =   4.1297
 H0: mean(diff) = 0                              Degrees of freedom =     4999

 Ha: mean(diff) < 0           Ha: mean(diff) != 0           Ha: mean(diff) > 0
 Pr(T < t) = 1.0000         Pr(|T| > |t|) = 0.0000          Pr(T > t) = 0.0000 */ 
 
prtest povertyline = after_povertyline

/* Two-sample test of proportions           povertyline: Number of obs =     5000
                                        after_povert: Number of obs =     5000
------------------------------------------------------------------------------
    Variable |       Mean   Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
 povertyline |      .7208   .0063442                      .7083655    .7332345
after_povert |      .7174   .0063677                      .7049196    .7298804
-------------+----------------------------------------------------------------
        diff |      .0034   .0089887                     -.0142175    .0210175
             |  under H0:   .0089888     0.38   0.705
------------------------------------------------------------------------------
        diff = prop(povertyline) - prop(after_povert)             z =   0.3782
    H0: diff = 0

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(Z < z) = 0.6474         Pr(|Z| > |z|) = 0.7052          Pr(Z > z) = 0.3526 */


//c. How does this policy affect the distribution of income in Nigeria? Will the policy benefit all income groups equally or does it benefit some more than others? --> Only 5.65% of people is poor and have a generator. Only 8.33% of the poor people have a generator. This figure drop by nearly 1% after the policy is in place. 

generate after_ultrapoor=1 if income_after<300
replace after_ultrapoor=0 if income_after>=300


tab generator povertyline, col
/*
           |      povertyline
 generator |         0          1 |     Total
-----------+----------------------+----------
         0 |       665      1,497 |     2,162 
           |     85.70      91.67 |     89.75 
-----------+----------------------+----------
         1 |       111        136 |       247 
           |     14.30       8.33 |     10.25 
-----------+----------------------+----------
     Total |       776      1,633 |     2,409 
           |    100.00     100.00 |    100.00 */
		   
 tab generator after_povertyline, col

/* 
           |   after_povertyline
 generator |         0          1 |     Total
-----------+----------------------+----------
         0 |       665      1,497 |     2,162 
           |     83.86      92.64 |     89.75 
-----------+----------------------+----------
         1 |       128        119 |       247 
           |     16.14       7.36 |     10.25 
-----------+----------------------+----------
     Total |       793      1,616 |     2,409 
           |    100.00     100.00 |    100.00 */
		   
tab after_povertyline poverty, col

/*after_pove |      povertyline
   rtyline |         0          1 |     Total
-----------+----------------------+----------
         0 |     1,396         17 |     1,413 
           |    100.00       0.47 |     28.26 
-----------+----------------------+----------
         1 |         0      3,587 |     3,587 
           |      0.00      99.53 |     71.74 
-----------+----------------------+----------
     Total |     1,396      3,604 |     5,000 
           |    100.00     100.00 |    100.00 */
//--> the policy will take 0.47% of households out of the povertyline
		   
prtest after_povertyline = poverty

/* Two-sample test of proportions          after_povert: Number of obs =     5000
                                         povertyline: Number of obs =     5000
------------------------------------------------------------------------------
       Group |       Mean   Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
after_povert |      .7174   .0063677                      .7049196    .7298804
 povertyline |      .7208   .0063442                      .7083655    .7332345
-------------+----------------------------------------------------------------
        diff |     -.0034   .0089887                     -.0210175    .0142175
             |  under H0:   .0089888    -0.38   0.705
------------------------------------------------------------------------------
        diff = prop(after_povert) - prop(povertyline)             z =  -0.3782
    H0: diff = 0

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(Z < z) = 0.3526         Pr(|Z| > |z|) = 0.7052          Pr(Z > z) = 0.6474 */

		   
tab after_povertyline consumption_ultrapoor, col

/* after_pove |       ultrapoor
   rtyline |         0          1 |     Total
-----------+----------------------+----------
         0 |     1,413          0 |     1,413 
           |     64.49       0.00 |     28.26 
-----------+----------------------+----------
         1 |       778      2,809 |     3,587 
           |     35.51     100.00 |     71.74 
-----------+----------------------+----------
     Total |     2,191      2,809 |     5,000 
           |    100.00     100.00 |    100.00 */
//--> the policy will take no one out of the ultra poor poverty line

 prtest after_ultrapoor = consumption_ultrapoor

/*Two-sample test of proportions          after_ultrap: Number of obs =     5000
                                           ultrapoor: Number of obs =     5000
------------------------------------------------------------------------------
       Group |       Mean   Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
after_ultrap |      .5572   .0070246                      .5434319    .5709681
   ultrapoor |      .5618   .0070168                      .5480472    .5755528
-------------+----------------------------------------------------------------
        diff |     -.0046   .0099288                     -.0240602    .0148602
             |  under H0:   .0099289    -0.46   0.643
------------------------------------------------------------------------------
        diff = prop(after_ultrap) - prop(ultrapoor)               z =  -0.4633
    H0: diff = 0

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(Z < z) = 0.3216         Pr(|Z| > |z|) = 0.6432          Pr(Z > z) = 0.6784 */



. ttest consumption_i, by(povertyline)

/*Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. err.   Std. dev.   [95% conf. interval]
---------+--------------------------------------------------------------------
       0 |   1,387    1366.748    24.55256    914.3973    1318.584    1414.913
       1 |   3,604    132.8615    2.858769    171.6214    127.2566    138.4665
---------+--------------------------------------------------------------------
Combined |   4,991     475.759    10.58387    747.7191    455.0099     496.508
---------+--------------------------------------------------------------------
    diff |            1233.887    15.91108                1202.694     1265.08
------------------------------------------------------------------------------
    diff = mean(0) - mean(1)                                      t =  77.5489
H0: diff = 0                                     Degrees of freedom =     4989

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 1.0000         Pr(|T| > |t|) = 0.0000          Pr(T > t) = 0.0000 */

ttest income_after, by(povertyline)

/* Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. err.   Std. dev.   [95% conf. interval]
---------+--------------------------------------------------------------------
       0 |   1,387    1378.753    24.65654      918.27    1330.385    1427.121
       1 |   3,604    138.5219    2.926047    175.6603     132.785    144.2588
---------+--------------------------------------------------------------------
Combined |   4,991    483.1823    10.64178      751.81    462.3198    504.0449
---------+--------------------------------------------------------------------
    diff |            1240.231    16.00445                1208.855    1271.607
------------------------------------------------------------------------------
    diff = mean(0) - mean(1)                                      t =  77.4929
H0: diff = 0                                     Degrees of freedom =     4989

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 1.0000         Pr(|T| > |t|) = 0.0000          Pr(T > t) = 0.0000 */

//---> the policy will benefit those who are not under the poverty line the most


//d. What can you say about the distribution of impact by gender. Will the policy deliver more benefits to male- or female-headed households? 

tab generator head_sex , col

/*+-------------------+
| Key               |
|-------------------|
|     frequency     |
| column percentage |
+-------------------+

           |     Sex, Head of
           |       Household
 generator |   1. MALE  2. FEMALE |     Total
-----------+----------------------+----------
         0 |     1,771        388 |     2,159 
           |     89.17      92.38 |     89.73 
-----------+----------------------+----------
         1 |       215         32 |       247 
           |     10.83       7.62 |     10.27 
-----------+----------------------+----------
     Total |     1,986        420 |     2,406 
           |    100.00     100.00 |    100.00 */
		   
prtest generator, by (head_sex)

/*Two-sample test of proportions               1. MALE: Number of obs =     1986
                                           2. FEMALE: Number of obs =      420
------------------------------------------------------------------------------
       Group |       Mean   Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
     1. MALE |   .1082578    .006972                      .0945929    .1219227
   2. FEMALE |   .0761905   .0129454                      .0508179    .1015631
-------------+----------------------------------------------------------------
        diff |   .0320673   .0147035                      .0032489    .0608857
             |  under H0:   .0163009     1.97   0.049
------------------------------------------------------------------------------
        diff = prop(1. MALE) - prop(2. FEMALE)                    z =   1.9672
    H0: diff = 0

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(Z < z) = 0.9754         Pr(|Z| > |z|) = 0.0492          Pr(Z > z) = 0.0246 */
 //--> The difference in proportions is significant at the 95% confidence level.
 
 ttest income_after, by (head_sex)

/*Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. err.   Std. dev.   [95% conf. interval]
---------+--------------------------------------------------------------------
 1. MALE |   4,172    477.2541    12.00576     775.464    453.7164    500.7918
2. FEMAL |     735    461.0939    22.41427    607.6706    417.0902    505.0976
---------+--------------------------------------------------------------------
Combined |   4,907    474.8335    10.74495    752.6838    453.7686    495.8984
---------+--------------------------------------------------------------------
    diff |             16.1602    30.11177               -42.87235    75.19275
------------------------------------------------------------------------------
    diff = mean(1. MALE) - mean(2. FEMAL)                         t =   0.5367
H0: diff = 0                                     Degrees of freedom =     4905

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.7042         Pr(|T| > |t|) = 0.5915          Pr(T > t) = 0.2958 */

 ttest consumption_index, by (head_sex)

/*Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. err.   Std. dev.   [95% conf. interval]
---------+--------------------------------------------------------------------
 1. MALE |   4,172     469.524    11.93744    771.0513    446.1202    492.9277
2. FEMAL |     735    454.5633    22.30041    604.5838    410.7831    498.3435
---------+--------------------------------------------------------------------
Combined |   4,907    467.2831    10.68441    748.4426    446.3368    488.2293
---------+--------------------------------------------------------------------
    diff |             14.9607    29.94222               -43.73944    73.66085
------------------------------------------------------------------------------
    diff = mean(1. MALE) - mean(2. FEMAL)                         t =   0.4997
H0: diff = 0                                     Degrees of freedom =     4905

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.6913         Pr(|T| > |t|) = 0.6173          Pr(T > t) = 0.3087 */
 
 
//e. Apply the Foster-Greer-Thornbecke measures to discuss how this policy intervention would affect the poverty gap and poverty severity (or the squared poverty gap) in Nigeria.

**********
***FGT1***
**********

*Creating a variable that captures the difference between expenditure and poverty line, only for those under the poverty line
generate upoverty_after = 600-income_after
replace upoverty_after=0 if income_after>=600

*Indexing the difference
generate fgt1_after = (upoverty_after/600)


**********
***FGT2***
**********

*Indexing the difference and squaring it 
generate fgt2_after= (upoverty_after/600)^2

//Comparing FGT1 before and after policy 
sum fgt1 fgt1_after

/*    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
        fgt1 |      5,000     .561189    .4254193          0          1
  fgt1_after |      5,000    .5547453    .4247434          0          1 */
  
ttest fgt1 = fgt1_after

/* Paired t test
------------------------------------------------------------------------------
Variable |     Obs        Mean    Std. err.   Std. dev.   [95% conf. interval]
---------+--------------------------------------------------------------------
    fgt1 |   5,000     .561189    .0060163    .4254193    .5493943    .5729837
fgt1_a~r |   5,000    .5547453    .0060068    .4247434    .5429694    .5665213
---------+--------------------------------------------------------------------
    diff |   5,000    .0064437     .000553    .0391046    .0053595    .0075278
------------------------------------------------------------------------------
     mean(diff) = mean(fgt1 - fgt1_after)                         t =  11.6517
 H0: mean(diff) = 0                              Degrees of freedom =     4999

 Ha: mean(diff) < 0           Ha: mean(diff) != 0           Ha: mean(diff) > 0
 Pr(T < t) = 1.0000         Pr(|T| > |t|) = 0.0000          Pr(T > t) = 0.0000 */
 
 //--> fgt1_after policy is lower than fgt1 at the 95% significance level.
 
 //Comparing FGT2 before and after policy 
 
sum fgt2 fgt2_after
/*  Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
        fgt2 |      5,000    .4958785    .4326045          0          1
  fgt2_after |      5,000    .4881133    .4309246          0          1 */
  

ttest fgt2 = fgt2_after

/* Paired t test
------------------------------------------------------------------------------
Variable |     Obs        Mean    Std. err.   Std. dev.   [95% conf. interval]
---------+--------------------------------------------------------------------
    fgt2 |   5,000    .4958785     .006118    .4326045    .4838846    .5078724
fgt2_a~r |   5,000    .4881133    .0060942    .4309246     .476166    .5000606
---------+--------------------------------------------------------------------
    diff |   5,000    .0077652    .0007434    .0525693    .0063077    .0092227
------------------------------------------------------------------------------
     mean(diff) = mean(fgt2 - fgt2_after)                         t =  10.4450
 H0: mean(diff) = 0                              Degrees of freedom =     4999

 Ha: mean(diff) < 0           Ha: mean(diff) != 0           Ha: mean(diff) > 0
 Pr(T < t) = 1.0000         Pr(|T| > |t|) = 0.0000          Pr(T > t) = 0.0000 */
 
 // --> Fgt2_after policy is lower than fgt2 at the 95% significance level.



