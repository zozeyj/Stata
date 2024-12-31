. regress lnwage union

      Source |       SS           df       MS      Number of obs   =    19,948
-------------+----------------------------------   F(1, 19946)     =   1251.34
       Model |  998.502051         1  998.502051   Prob > F        =    0.0000
    Residual |  15915.8947    19,946  .797949196   R-squared       =    0.0590
-------------+----------------------------------   Adj R-squared   =    0.0590
       Total |  16914.3967    19,947  .847966948   Root MSE        =    .89328

------------------------------------------------------------------------------
      lnwage | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
       union |   .4894298   .0138358    35.37   0.000     .4623106    .5165491
       _cons |   1.356389   .0075456   179.76   0.000     1.341599    1.371179
------------------------------------------------------------------------------


. regress lnwage union educ

      Source |       SS           df       MS      Number of obs   =    19,948
-------------+----------------------------------   F(2, 19945)     =   3624.42
       Model |  4508.73142         2  2254.36571   Prob > F        =    0.0000
    Residual |  12405.6653    19,945  .621993747   R-squared       =    0.2666
-------------+----------------------------------   Adj R-squared   =    0.2665
       Total |  16914.3967    19,947  .847966948   Root MSE        =    .78867

------------------------------------------------------------------------------
      lnwage | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
       union |   .2855498   .0125133    22.82   0.000     .2610227    .3100769
        educ |   .1187943   .0015813    75.12   0.000     .1156948    .1218939
       _cons |   .6581089   .0114359    57.55   0.000     .6356935    .6805242
------------------------------------------------------------------------------

. 

. regress lnwage female

      Source |       SS           df       MS      Number of obs   =    19,948
-------------+----------------------------------   F(1, 19946)     =      2.59
       Model |  2.19262084         1  2.19262084   Prob > F        =    0.1078
    Residual |  16912.2041    19,946  .847899534   R-squared       =    0.0001
-------------+----------------------------------   Adj R-squared   =    0.0001
       Total |  16914.3967    19,947  .847966948   Root MSE        =    .92081

------------------------------------------------------------------------------
      lnwage | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
      female |  -.0218348   .0135781    -1.61   0.108    -.0484491    .0047794
       _cons |   1.509829    .008153   185.19   0.000     1.493849     1.52581
------------------------------------------------------------------------------

. regress lnwage female educ exper

      Source |       SS           df       MS      Number of obs   =    19,948
-------------+----------------------------------   F(3, 19944)     =   2644.85
       Model |  4814.03117         3  1604.67706   Prob > F        =    0.0000
    Residual |  12100.3655    19,944  .606717085   R-squared       =    0.2846
-------------+----------------------------------   Adj R-squared   =    0.2845
       Total |  16914.3967    19,947  .847966948   Root MSE        =    .77892

------------------------------------------------------------------------------
      lnwage | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
      female |  -.1742758   .0116623   -14.94   0.000    -.1971349   -.1514167
        educ |   .1537421   .0017517    87.77   0.000     .1503087    .1571755
       exper |    .015099   .0005416    27.88   0.000     .0140375    .0161606
       _cons |   .2488311    .020844    11.94   0.000     .2079752    .2896871
------------------------------------------------------------------------------



. // Run regression with union as the grouping variable
. reg lnwage union educ

      Source |       SS           df       MS      Number of obs   =    19,948
-------------+----------------------------------   F(2, 19945)     =   3624.42
       Model |  4508.73142         2  2254.36571   Prob > F        =    0.0000
    Residual |  12405.6653    19,945  .621993747   R-squared       =    0.2666
-------------+----------------------------------   Adj R-squared   =    0.2665
       Total |  16914.3967    19,947  .847966948   Root MSE        =    .78867

------------------------------------------------------------------------------
      lnwage | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
       union |   .2855498   .0125133    22.82   0.000     .2610227    .3100769
        educ |   .1187943   .0015813    75.12   0.000     .1156948    .1218939
       _cons |   .6581089   .0114359    57.55   0.000     .6356935    .6805242
------------------------------------------------------------------------------

. // Generate predicted values for each category of union
. predict yhat, xb

. // Create a scatter plot with predicted values and regression lines for each 
> category of union
. twoway (scatter yhat educ if union == 0, msymbol(circle) mcolor(blue)) ///
> (lfit yhat educ if union == 0, lcolor(blue)) ///
> (scatter yhat educ if union == 1, msymbol(circle) mcolor(red)) ///
> (lfit yhat educ if union == 1, lcolor(red)), ///
> title("Predicted Log(Wage) vs Years of Schooling") ///
> xtitle("Years of Schooling") ytitle("Log Wage") ///
> legend(label(1 "Non-unionized") label(2 "Unionized"))

. 

. sum educ

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
        educ |     19,948     6.38851    3.617393          0         13

. sum exper

    Variable |        Obs        Mean    Std. dev.       Min        Max
-------------+---------------------------------------------------------
       exper |     19,948    22.10578    11.61218         -1         53

. regress lnwage

      Source |       SS           df       MS      Number of obs   =    19,948
-------------+----------------------------------   F(0, 19947)     =      0.00
       Model |           0         0           .   Prob > F        =         .
    Residual |  16914.3967    19,947  .847966948   R-squared       =    0.0000
-------------+----------------------------------   Adj R-squared   =    0.0000
       Total |  16914.3967    19,947  .847966948   Root MSE        =    .92085

------------------------------------------------------------------------------
      lnwage | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
       _cons |   1.501957   .0065199   230.37   0.000     1.489177    1.514736
------------------------------------------------------------------------------

. gen some_p = 1 if edu>1 | edu<8

. replace some_p = 0 if some_p =! 1
invalid syntax
r(198);

. replace some_p = 0 if some_p != 1
(0 real changes made)

. replace some_p = 0 if some_p = .
invalid syntax
r(198);

. drop some_p

. gen some_p = 1 if edu>1 & edu<8
(11,477 missing values generated)

. replace some_p = 0 if some_p != 1
(11,477 real changes made)

. gen some_h = 1 if educ > 7 & educ < 11
(13,066 missing values generated)

. replace some_h = 0 of some_h != 1
invalid 'of' 
r(198);

. replace some_h = 0 if some_h != 1
(13,066 real changes made)

. gen some_c = 1 if educ > 10 & educ< 14
(18,145 missing values generated)

. replace some_c = 0 if some_c != 1
(18,145 real changes made)

. regress lnwage some_p some_h some_c

      Source |       SS           df       MS      Number of obs   =    19,948
-------------+----------------------------------   F(3, 19944)     =   1891.73
       Model |  3746.89513         3  1248.96504   Prob > F        =    0.0000
    Residual |  13167.5016    19,944  .660223706   R-squared       =    0.2215
-------------+----------------------------------   Adj R-squared   =    0.2214
       Total |  16914.3967    19,947  .847966948   Root MSE        =    .81254

------------------------------------------------------------------------------
      lnwage | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
      some_p |   .4684235   .0177316    26.42   0.000     .4336681    .5031788
      some_h |   1.049512    .018232    57.56   0.000     1.013775    1.085248
      some_c |   1.475554   .0245489    60.11   0.000     1.427436    1.523672
       _cons |   .8075926   .0153776    52.52   0.000     .7774513    .8377339
------------------------------------------------------------------------------

. test some_p=some_h=some_c

 ( 1)  some_p - some_h = 0
 ( 2)  some_p - some_c = 0

       F(  2, 19944) = 1652.23
            Prob > F =    0.0000

. gen some_pri2 = 1 if edu > 1
(2,792 missing values generated)

. replace some_pri2 = 0 if some_pri2 != 1
(2,792 real changes made)

. gen some_high2 = 1 if edu > 7
(11,263 missing values generated)

. replace some_high2 = 0 if some_high != 1
(11,263 real changes made)

. gen some_coll2 = 1 if edu > 10
(18,145 missing values generated)

. replace some_coll2 = 0 if some_coll2 != 1
(18,145 real changes made)

. regress lnwage some_pri2 some_high2 some_coll2

      Source |       SS           df       MS      Number of obs   =    19,948
-------------+----------------------------------   F(3, 19944)     =   1891.73
       Model |  3746.89513         3  1248.96504   Prob > F        =    0.0000
    Residual |  13167.5016    19,944  .660223706   R-squared       =    0.2215
-------------+----------------------------------   Adj R-squared   =    0.2214
       Total |  16914.3967    19,947  .847966948   Root MSE        =    .81254

------------------------------------------------------------------------------
      lnwage | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
   some_pri2 |   .4684235   .0177316    26.42   0.000     .4336681    .5031788
  some_high2 |   .5810881   .0131861    44.07   0.000     .5552422     .606934
  some_coll2 |   .4260422   .0214969    19.82   0.000     .3839065    .4681779
       _cons |   .8075926   .0153776    52.52   0.000     .7774513    .8377339
------------------------------------------------------------------------------

. test some_pri2 = some_high2 = some_coll2

 ( 1)  some_pri2 - some_high2 = 0
 ( 2)  some_pri2 - some_coll2 = 0

       F(  2, 19944) =   16.79
            Prob > F =    0.0000

. test some_pri2 = some_high2 = some_coll2 = 0

 ( 1)  some_pri2 - some_high2 = 0
 ( 2)  some_pri2 - some_coll2 = 0
 ( 3)  some_pri2 = 0

       F(  3, 19944) = 1891.73
            Prob > F =    0.0000

. 
