//PS7 Yeji KIM

//1.a
. generate lnwage=log(wage)

. generate fmarried=female*married

. regress lnwage female edu exper married fmarried

      Source |       SS           df       MS      Number of obs   =    19,948
-------------+----------------------------------   F(5, 19942)     =   1639.75
       Model |  4927.97921         5  985.595843   Prob > F        =    0.0000
    Residual |  11986.4175    19,942  .601063961   R-squared       =    0.2913
-------------+----------------------------------   Adj R-squared   =    0.2912
       Total |  16914.3967    19,947  .847966948   Root MSE        =    .77528

------------------------------------------------------------------------------
      lnwage | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
      female |  -.1198257   .0162644    -7.37   0.000    -.1517052   -.0879462
        educ |   .1468274   .0018145    80.92   0.000     .1432708    .1503839
       exper |   .0115845   .0005966    19.42   0.000     .0104151    .0127539
     married |   .1911581   .0151559    12.61   0.000     .1614512    .2208649
    fmarried |  -.0707193   .0232191    -3.05   0.002    -.1162307   -.0252079
       _cons |    .262764   .0209842    12.52   0.000     .2216333    .3038947
------------------------------------------------------------------------------

. 

//1.b
. generate funion=union*female

. regress lnwage female educ exper union funion

      Source |       SS           df       MS      Number of obs   =    19,948
-------------+----------------------------------   F(5, 19942)     =   1693.29
       Model |  5040.91966         5  1008.18393   Prob > F        =    0.0000
    Residual |  11873.4771    19,942  .595400514   R-squared       =    0.2980
-------------+----------------------------------   Adj R-squared   =    0.2978
       Total |  16914.3967    19,947  .847966948   Root MSE        =    .77162

------------------------------------------------------------------------------
      lnwage | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
      female |  -.1573623   .0137866   -11.41   0.000    -.1843852   -.1303394
        educ |   .1448759   .0017938    80.77   0.000       .14136    .1483919
       exper |   .0137275   .0005411    25.37   0.000     .0126669    .0147881
       union |   .2555831   .0153864    16.61   0.000     .2254245    .2857417
      funion |  -.0415917   .0248234    -1.68   0.094    -.0902476    .0070642
       _cons |   .2582552   .0207847    12.43   0.000     .2175155     .298995
------------------------------------------------------------------------------

//2
. generate feduc=female*educ

. regress lnwage female educ exper feduc

      Source |       SS           df       MS      Number of obs   =    19,948
-------------+----------------------------------   F(4, 19943)     =   1987.29
       Model |  4820.53431         4  1205.13358   Prob > F        =    0.0000
    Residual |  12093.8624    19,943  .606421421   R-squared       =    0.2850
-------------+----------------------------------   Adj R-squared   =    0.2849
       Total |  16914.3967    19,947  .847966948   Root MSE        =    .77873

------------------------------------------------------------------------------
      lnwage | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
      female |  -.2472828   .0251589    -9.83   0.000    -.2965963   -.1979692
        educ |    .150208   .0020571    73.02   0.000      .146176      .15424
       exper |   .0151128   .0005415    27.91   0.000     .0140515    .0161742
       feduc |   .0107683   .0032883     3.27   0.001     .0043229    .0172137
       _cons |   .2694726   .0217713    12.38   0.000      .226799    .3121462
------------------------------------------------------------------------------

. summarize educ, detail

                 highest level of education
-------------------------------------------------------------
      Percentiles      Smallest
 1%            0              0
 5%            0              0
10%            1              0       Obs              19,948
25%            4              0       Sum of wgt.      19,948

50%            7                      Mean            6.38851
                        Largest       Std. dev.      3.617393
75%           10             13
90%           10             13       Variance       13.08553
95%           12             13       Skewness        -.25203
99%           13             13       Kurtosis        2.08923


. ttest educ, by(female)

Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. err.   Std. dev.   [95% conf. interval]
---------+--------------------------------------------------------------------
       0 |  12,756    5.931091    .0323133    3.649548    5.867752     5.99443
       1 |   7,192    7.199805    .0402361    3.412247    7.120931     7.27868
---------+--------------------------------------------------------------------
Combined |  19,948     6.38851    .0256121    3.617393    6.338308    6.438712
---------+--------------------------------------------------------------------
    diff |           -1.268714    .0525807               -1.371777   -1.165652
------------------------------------------------------------------------------
    diff = mean(0) - mean(1)                                      t = -24.1289
H0: diff = 0                                     Degrees of freedom =    19946

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.0000         Pr(|T| > |t|) = 0.0000          Pr(T > t) = 1.0000

.

. ttest feduc, by(female)

Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. err.   Std. dev.   [95% conf. interval]
---------+--------------------------------------------------------------------
       0 |  12,756           0           0           0           0           0
       1 |   7,192    7.199805    .0402361    3.412247    7.120931     7.27868
---------+--------------------------------------------------------------------
Combined |  19,948    2.595799    .0284528    4.018606    2.540029    2.651569
---------+--------------------------------------------------------------------
    diff |           -7.199805    .0302117               -7.259023   -7.140588
------------------------------------------------------------------------------
    diff = mean(0) - mean(1)                                      t = -2.4e+02
H0: diff = 0                                     Degrees of freedom =    19946

    Ha: diff < 0                 Ha: diff != 0                 Ha: diff > 0
 Pr(T < t) = 0.0000         Pr(|T| > |t|) = 0.0000          Pr(T > t) = 1.0000

. 
 
