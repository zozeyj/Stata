# Stata Code for 2024

This repository contains Stata code for various econometric analyses and simulations conducted by Yeji Kim in 2024. The scripts include basic regression analysis, simulations for understanding t-distributions, and the evaluation of college's effect on wages through multiple regression models.

## Contents

### 1. Basic Regression Analysis
- **Warm-up**: Load data, run regressions, calculate predicted values, residuals, and squared residuals.
- **Model Evaluation**: Compare manually calculated results with Stata's built-in commands to verify accuracy.

```stata
// PS2 Yeji Kim
clear

**1. Warm-up

use "regression-tools.dta", clear
reg y x
return list
matlist r(table)

local b = _b[x]         // Coefficient of X
local cons = _b[_cons]  // Intercept (constant term)

gen yhat = `cons' + `b' * x // Generate predicted values of Y
gen residuals = y - yhat   // Generate residuals
gen esquare = residuals^2   // Squared residuals
summarize esquare    // Sum of squared residuals
local sse = r(sum)   // Store sum of squared residuals

local df = e(df_r)   // Degrees of freedom
local rse = sqrt(`sse' / `df')   // Residual standard error

di "Residual Standard Error: `rse'"
browse y yhat residuals esquare
```

### 2. Simulation Studies
- **Q1: T-Distribution Simulations**
  - **Normal Distribution**: Simulate sample statistics for normally distributed outcomes across various sample sizes.
  - **Uniform Distribution**: Analyze t-statistic behavior for uniformly distributed outcomes.
  - **Probability Distribution**: Simulate skewed data with specified probabilities to examine the t-distribution under non-normal conditions.

```stata
cap prog drop p1
prog define p1, rclass
    args samplesize
    clear
    set obs `samplesize'
    gen outcome = rnormal()
    quietly: summarize outcome
    return scalar mean_outcome = r(mean)
    return scalar sd_outcome = r(sd)
    return scalar tstat_outcome = r(mean) / (r(sd) / sqrt(`samplesize'))
end

simulate mean_outcome=r(mean_outcome) sd_outcome=r(sd_outcome) tstat_outcome=r(tstat_outcome), reps(10000) nodots: p1 3
```

### 3. College Effect on Wages
- Simulate data to evaluate how different covariates affect the estimated impact of college education on wages.

```stata
cap prog drop p4
prog define p4, rclass
    clear
    set obs 3000
    gen id = _n
    gen ability = runiform()
    gen college_likelihood = ability / 2
    gen completed_college = college_likelihood > runiform()

    gen junior_wage = 25000 + 15000 * ability + rnormal(0, 10000)
    gen senior_wage = 35000 + 15000 * ability + rnormal(0, 10000)

    gen senior_probability = 0.2 + 0.25 * completed_college
    gen senior_job = senior_probability > runiform()
    gen job_status = cond(senior_job, "senior", "junior")

    gen observed_wage = cond(job_status == "senior", senior_wage, junior_wage)

    regress observed_wage i.completed_college
    return scalar beta_only_college = _b[1.completed_college]
end

simulate beta_only_college=r(beta_only_college), reps(1000) nodots: p4
```

### 4. Power Analysis
Conduct power simulations to assess the likelihood of detecting significant effects in wage models with all covariates included.

```stata
cap prog drop p5
prog define p5, rclass
    clear
    set obs 3000
    gen ability = runiform()
    gen college_likelihood = 0.5 * ability
    gen completed_college = runiform() < college_likelihood

    gen observed_wage = 25000 + 15000 * ability + 2500 * completed_college + rnormal(0, 10000)

    regress observed_wage completed_college ability
    return scalar beta_all_covariates = _b[completed_college]
    return scalar p_value = 2 * (1 - normal(abs(_b[completed_college] / _se[completed_college])))
end

simulate beta_all_covariates=r(beta_all_covariates) p_value=r(p_value), reps(1000) nodots: p5

gen significant = p_value < 0.05
summarize significant
```

## Visualization
The code includes commands for visualizing predicted values, residuals, and distribution comparisons using `scatter` and `twoway kdensity` plots.

```stata
twoway (kdensity tstat_outcome if samplesize==3, lcolor(blue) lpattern(solid)) \
       (kdensity tstat_outcome if samplesize==5, lcolor(red) lpattern(dash)) \
       (kdensity tstat_outcome if samplesize==10, lcolor(green) lpattern(dot)) \
       (kdensity tstat_outcome if samplesize==30, lcolor(orange) lpattern(shortdash)) \
       (kdensity tstat_outcome if samplesize==100, lcolor(purple) lpattern(longdash)) \
       (kdensity tstat_outcome if samplesize==1000, lcolor(brown) lpattern(solid)), \
       legend(label(1 "N=3") label(2 "N=5") label(3 "N=10") label(4 "N=30") label(5 "N=100") label(6 "N=1000")) \
       title("T-Distributions for Various Sample Sizes") xtitle("T-Statistic") ytitle("Density")
```

For questions or further assistance, please contact Yeji Kim.

---
