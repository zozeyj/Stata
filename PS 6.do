**PS6 Yeji KIM**

**a. Calculate 95% confidence intervals for bp_before and bp_after. 
ci means bp_before
ci means bp_after
**ANS: The 95% confidence intervals for bp_before is [154.3912, 158.5088], The 95% CI for bp_after is [148.7956, 153.921]

**b. Test the null hypothesis that the mean of bp_after is equal to 150. What is the value of the test statistic? What is the p-value of the two-sided test? State your conclusion [For this and all of the "Test the hypothesis" questions that follow below, use this line of reporting: t-stat compared to critical value, p-value, conclusion. Of course, if the questions ask for additional information, be sure to provide that too!]
sum bp_after, detail
ttest bp_after=150
**Ans: the value of test statistics is t = 1.049; the p-value of the two-sided test is 0.2961. With alpha=0.005, critical t-value is 2.201 and test statistics is 1.049. Our test statistics do not fall into rejection area. Also our p-value is 0.2961 > 0.005. Therefore, we cannot reject the null hypothesis. 

**c. Test the hypothesis that bp_before is equal to bp_after (paired test)
ttest bp_after=bp_before
**Ans: Alpha=0.005, two-tail test. Critical p-value 0.005 > Test p-value 0.0011. Falls into rejection area, reject the null hypothesis with 95% Confidence. Critical t-value (df 119) approximately 1.984 (df 100) < critical t-value 3.3372. Same conclusion, reject Ho.  

**d. Test the hypothesis that bp_before is equal to bp_after for males only. Also report the number of degrees of freedom does this test statistic have.
tab sex, nolabel
ttest bp_before=bp_after if sex == 0
**Ans: 59 degress of freedom; when H0=the difference is 0, p-value in a two tailed tast with Alpha=0.05 is 0.1281. Hence, we cannot reject the null hypothesis. 

**e. Test the hypothesis that the mean of bp_before is equal for males and females.
ttest bp_before, by(sex)
**Ans: Alpha=0.05, two-tailed test. Critical p-value 0.005 < Test p-value 0.0062, cannot reject the null hypothesis that mean of bp_before is equal for males and females. Test t-statistic is 2.7848, df=118, and critical t-statistics is relatively 1.984 (df=100). Test statistics > critical statistics. 

**f. Test the hypothesis that the proportion of females in this population is .6
gen female=(sex==1)
prtest female == 0.6
**Ans: with Alpha==0.05, two tailed test, critical z value is +-1.96, and test v-zalue is -2.23 which is smaller than -1.96 so we reject the null hypothesis. Alternatively, the p value for the two tailed test is 0.02 < 0.05 reaching the same conclusion of rejecting null hypothesis that proportion is 0.6