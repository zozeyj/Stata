//PS2 Yeji Kim//
clear

**1. Warmup

use "regression-tools.dta", clear
reg y x
return list
matlist r(table)

*0.1.2
local b = _b[x]         // Coefficient of X
local cons = _b[_cons]  // Intercept (constant term)

gen yhat = `cons' + `b' * x // Generate predicted values of Y (Y-hat)
gen residuals = y - yhat   // Generate residuals (E = Y - Yhat)
gen esquare = residuals^2   // Generate squared residuals (E-square)
summarize esquare    // Get sum of squared residuals
local sse = r(sum)   // Store sum of squared residuals

local df = e(df_r)   // Degrees of freedom (residual df)

local rse = sqrt(`sse' / `df')   // Calculate residual standard error (RSE)

di "Residual Standard Error: `rse'"  // Display the RSE
browse y yhat residuals esquare

*0.1.3
regress y x
predict yhat_predict   // Generates predicted Y-hat values using the model
predict residuals_predict, residuals   // Generates residuals (Y - Yhat)
gen esquare_predict = residuals_predict^2   // Squared residuals

br 

regress yhat yhat_predict
regress residuals residuals_predict
regress esquare esquare_predict

gen diff_yhat = yhat - yhat_predict
summarize diff_yhat   // The minimum and maximum should both be 0

gen diff_residuals = residuals - residuals_predict
summarize diff_residuals   // The minimum and maximum should both be 0

scatter yhat yhat_predict   // Compare predicted values
scatter residuals residuals_predict   // Compare residuals

scatter y x, msize(small) || line yhat_predict x, sort lcolor(red)  // Plot data and predictions

**Q1
**a
clear
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

**b
simulate mean_outcome=r(mean_outcome) sd_outcome=r(sd_outcome) tstat_outcome=r(tstat_outcome), reps(10000) nodots: p1 3

**c
// Create a temporary file to store results
tempfile results
save "`results'", emptyok

// Run simulations for different sample sizes
foreach n in 3 5 10 30 100 1000 {
    simulate mean_outcome=r(mean_outcome) sd_outcome=r(sd_outcome) ///
      tstat_outcome=r(tstat_outcome), reps(10000) nodots: p1 `n'
    
    // Add a variable to identify the sample size
    gen samplesize = `n'
    
    // Append the results to the temporary file
    append using "`results'"
    save "`results'", replace
}

sum tstat_outcome if samplesize ==3, detail
sum tstat_outcome if samplesize ==5, detail


// Use the combined results for plotting
use "`results'"

// Loop over the sample sizes and compute summary statistics
foreach n in 3 5 10 30 100 1000 {
    // Summarize tstat_outcome for each sample size
    quietly summarize tstat_outcome if samplesize == `n', detail
    
    // Store summary statistics for each sample size
    display "Sample Size = `n'"
    display "Mean = " %9.3f r(mean)
    display "Variance = " %9.3f r(Var)
    display "Standard Deviation = " %9.3f r(sd)
    display "Skewness = " %9.3f r(skewness)
}

twoway (kdensity tstat_outcome if samplesize==3, lcolor(blue) lpattern(solid)) ///
       (kdensity tstat_outcome if samplesize==5, lcolor(red) lpattern(dash)) ///
       (kdensity tstat_outcome if samplesize==10, lcolor(green) lpattern(dot)) ///
       (kdensity tstat_outcome if samplesize==30, lcolor(orange) lpattern(shortdash)) ///
       (kdensity tstat_outcome if samplesize==100, lcolor(purple) lpattern(longdash)) ///
       (kdensity tstat_outcome if samplesize==1000, lcolor(brown) lpattern(solid)) ///
       ,legend(label(1 "N=3") label(2 "N=5") label(3 "N=10") label(4 "N=30") label(5 "N=100") label(6 "N=1000")) ///
       title("T-Distributions (Normal) for Various Sample Sizes") xtitle("T-Statistic") ytitle("Density")

**d	   
cap prog drop p2
prog define p2, rclass

    args samplesize
    clear
    set obs `samplesize'
    gen outcome = runiform()
    quietly: summarize outcome
    return scalar mean_outcome = r(mean)
    return scalar sd_outcome = r(sd)
    return scalar tstat_outcome = (r(mean) - 0.5) / (r(sd) / sqrt(`samplesize'))

end

// Define a temporary file to store results
tempfile results
save "`results'", emptyok

// Run simulations for different sample sizes
foreach n in 3 5 10 30 100 1000 {
    // Run the simulation for the current sample size
    simulate mean_outcome=r(mean_outcome) sd_outcome=r(sd_outcome) tstat_outcome=r(tstat_outcome), reps(10000) nodots: p2 `n'
    
    // Add a variable to identify the sample size
    gen samplesize = `n'
    
    // Append the results to the temporary file
    append using "`results'"
    save "`results'", replace
}

// Load the combined results for plotting
use "`results'"

// Loop over the sample sizes and compute summary statistics
foreach n in 3 5 10 30 100 1000 {
    // Summarize tstat_outcome for each sample size
    quietly summarize tstat_outcome if samplesize == `n', detail
    
    // Store summary statistics for each sample size
    display "Sample Size = `n'"
    display "Mean = " %9.3f r(mean)
    display "Variance = " %9.3f r(Var)
    display "Standard Deviation = " %9.3f r(sd)
    display "Skewness = " %9.3f r(skewness)
}

twoway (kdensity tstat_outcome if samplesize==3, lcolor(blue) lpattern(solid)) ///
       (kdensity tstat_outcome if samplesize==5, lcolor(red) lpattern(dash)) ///
       (kdensity tstat_outcome if samplesize==10, lcolor(green) lpattern(dot)) ///
       (kdensity tstat_outcome if samplesize==30, lcolor(orange) lpattern(shortdash)) ///
       (kdensity tstat_outcome if samplesize==100, lcolor(purple) lpattern(longdash)) ///
       (kdensity tstat_outcome if samplesize==1000, lcolor(brown) lpattern(solid)) ///
       ,legend(label(1 "N=3") label(2 "N=5") label(3 "N=10") label(4 "N=30") label(5 "N=100") label(6 "N=1000")) ///
       title("T-Distributions (Uniform) for Various Sample Sizes") xtitle("T-Statistic") ytitle("Density")
	   
**e
cap prog drop p3
prog define p3, rclass

    args samplesize
    clear
    set obs `samplesize'
    gen outcome = .
	gen rand = runiform()
    gen outcome = .
    replace outcome = 0.45 if rand < 0.8                     // 80% probability
    replace outcome = 0.538 if rand >= 0.8 & rand < 0.99     // 19% probability
    replace outcome = 15 if rand >= 0.99                     // 1% probability

    quietly: summarize outcome
    return scalar mean_outcome = r(mean)
    return scalar sd_outcome = r(sd)
    return scalar tstat_outcome = (r(mean) - 0.61222) / (r(sd) / sqrt(`samplesize'))

end

// Define a temporary file to store results
tempfile results
save "`results'", emptyok

// Run simulations for different sample sizes
foreach n in 3 5 10 30 100 1000 {
    // Run the simulation for the current sample size
    simulate mean_outcome=r(mean_outcome) sd_outcome=r(sd_outcome) tstat_outcome=r(tstat_outcome), reps(10000) nodots: p2 `n'
    
    // Add a variable to identify the sample size
    gen samplesize = `n'
    
    // Append the results to the temporary file
    append using "`results'"
    save "`results'", replace
}

// Load the combined results for plotting
use "`results'"

// Loop over the sample sizes and compute summary statistics
foreach n in 3 5 10 30 100 1000 {
    // Summarize tstat_outcome for each sample size
    quietly summarize tstat_outcome if samplesize == `n', detail
    
    // Store summary statistics for each sample size
    display "Sample Size = `n'"
    display "Mean = " %9.3f r(mean)
    display "Variance = " %9.3f r(Var)
    display "Standard Deviation = " %9.3f r(sd)
    display "Skewness = " %9.3f r(skewness)
}

twoway (kdensity tstat_outcome if samplesize==3, lcolor(blue) lpattern(solid)) ///
       (kdensity tstat_outcome if samplesize==5, lcolor(red) lpattern(dash)) ///
       (kdensity tstat_outcome if samplesize==10, lcolor(green) lpattern(dot)) ///
       (kdensity tstat_outcome if samplesize==30, lcolor(orange) lpattern(shortdash)) ///
       (kdensity tstat_outcome if samplesize==100, lcolor(purple) lpattern(longdash)) ///
       (kdensity tstat_outcome if samplesize==1000, lcolor(brown) lpattern(solid)) ///
       ,legend(label(1 "N=3") label(2 "N=5") label(3 "N=10") label(4 "N=30") label(5 "N=100") label(6 "N=1000")) ///
       title("T-Distributions (Probability) for Various Sample Sizes") xtitle("T-Statistic") ytitle("Density")

**Q2
**1
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

    // Generate observed wage based on job status
    gen observed_wage = cond(job_status == "senior", senior_wage, junior_wage)

    // Calculate percentile rank in the wage distribution
    egen wage_percentile = rank(observed_wage), field
    replace wage_percentile = wage_percentile / _N

    // Assign marital status
    gen married_prob = 0.25 + 0.15 * completed_college + 0.5 * wage_percentile
    gen married = runiform() < married_prob
    gen marital_status = cond(married, "married", "unmarried")

	// Convert string variables to numeric variables for factor variables
    encode job_status, gen(job_status_num)
    encode marital_status, gen(marital_status_num)

    // college
    regress observed_wage i.completed_college
    return scalar beta_only_college = _b[1.completed_college]  
	
	// college+ability
    reg observed_wage i.completed_college ability
	return scalar beta_with_ability = _b[1.completed_college]

	// college+jobstatus
	reg observed_wage i.completed_college i.job_status_num
	return scalar beta_with_job_status = _b[1.completed_college]

	//college+marital status
	reg observed_wage i.completed_college i.marital_status_num
	return scalar beta_with_marital_status = _b[1.completed_college]

	//college+ability+jobstatus
	reg observed_wage i.completed_college ability i.job_status_num
	return scalar beta_with_ability_job = _b[1.completed_college]

	//college+ability+marital status
	reg observed_wage i.completed_college ability i.marital_status_num
	return scalar beta_with_ability_marital = _b[1.completed_college]
	
	//college+job+marital
	reg observed_wage i.completed_college i.job_status_num i.marital_status_num
	return scalar beta_with_job_marital =  _b[1.completed_college]

	//college+ability+job status+marital status
	reg observed_wage i.completed_college ability i.job_status_num i.marital_status_num
	return scalar beta_with_all_covariates = _b[1.completed_college]

end

simulate beta_only_college=r(beta_only_college) ///
         beta_with_ability=r(beta_with_ability) ///
         beta_with_job_status=r(beta_with_job_status) ///
         beta_with_marital_status=r(beta_with_marital_status) ///
         beta_with_ability_job=r(beta_with_ability_job) ///
         beta_with_ability_marital=r(beta_with_ability_marital) ///
         beta_with_job_marital=r(beta_with_job_marital) ///
         beta_with_all_covariates=r(beta_with_all_covariates), reps(1000) nodots: p4
summarize beta_only_college beta_with_ability beta_with_job_status ///
         beta_with_marital_status beta_with_ability_job beta_with_ability_marital ///
         beta_with_job_marital beta_with_all_covariates

**2

* Set parameters
local true_effect 2500
local alpha 0.05
local reps 1000

* Power calculation for model with all covariates (assumed unbiased)
capture program drop p5
program define p5, rclass
    * Generate simulated data
    drop _all
    set obs 3000
    gen id = _n

    * Recreate variables based on unbiased model structure
    gen ability = runiform()
    gen college_likelihood = 0.5 * ability
    gen completed_college = runiform() < college_likelihood
    gen junior_wage = 25000 + 15000 * ability + rnormal(0, 10000)
    gen senior_wage = 35000 + 15000 * ability + rnormal(0, 10000)
    gen senior_prob = 0.2 + 0.25 * completed_college
    gen senior_job = runiform() < senior_prob
    gen job_status = cond(senior_job, "senior", "junior")
    gen observed_wage = cond(job_status == "senior", senior_wage, junior_wage)
    egen wage_percentile = rank(observed_wage), field
    replace wage_percentile = wage_percentile / _N
    gen married_prob = 0.25 + 0.15 * completed_college + 0.5 * wage_percentile
    gen married = runiform() < married_prob
    gen marital_status = cond(married, "married", "unmarried")

    * Convert string variables to numeric
    encode job_status, gen(job_status_num)
    encode marital_status, gen(marital_status_num)

    * Regress using all covariates (assumed unbiased model)
    reg observed_wage completed_college ability 
    return scalar beta_all_covariates = _b[completed_college]
    return scalar p_value = 2 * (1 - normal(abs(_b[completed_college] / _se[completed_college])))
end

* Run simulations and compute power as proportion of significant results
simulate beta_all_covariates=r(beta_all_covariates) p_value=r(p_value), reps(1000) nodots: p5

. * Define significance level explicitly
. local alpha 0.05

. 
. * Generate an indicator for significant p-values
. gen significant = p_value < 0.05

. 
. * Summarize the significant results to calculate the proportion (i.e., power)
. summarize significant



