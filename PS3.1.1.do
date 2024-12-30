******3.1.2******
// Step 1: Define the program to generate a sample and calculate its mean
cap program drop height_us
program define height_us, rclass
    args n  // n represents the size of the sample

    clear  // Clear any existing data in memory
    set obs `n'  // Set the number of observations to n

    // Generate the sample from the normal distribution with mean 177 and std deviation 7
    gen height = rnormal(177, 7)

    // Calculate and return the mean of the sample
    summarize height
    return scalar mean_height = r(mean)  // Store the mean of the sample in a return scalar
end

// Step 2: Use simulate to draw 10,000 samples of size 62 and store results in sim_men
simulate us_mean_height = r(mean_height), reps(10000) nodots: height_us 62

// Step 3: Create an id variable to identify each simulation
gen id = _n

// Step 4: Save the simulation results in a new dataset called sim_men
save us_men, replace

// Step 5: Calculate the critical values for the hypothesis test at 95% confidence level
// For a normal distribution, we use the Z-scores corresponding to a 95% confidence interval.
local z_critical = invnormal(0.975)  // 1.96 for a two-tailed test
summarize us_mean_height  // Summarize the means to get mean and stddev
local mean = r(mean)
local sd = r(sd)
local lower_bound = `mean' - `z_critical' * `sd'
local upper_bound = `mean' + `z_critical' * `sd'

di "mean height of American men is `mean'"
di "lower critical value =`lower_bound'"
di "higher critical value =`upper_bound'"

// Step 6: Plot the distribution of the sampling means
twoway (histogram us_mean_height, percent) ///
       , title("Sampling Distribution of US Male Mean Heights") ///
       xlabel(170(1)184) ///
       ytitle("Percent of Simulations") ///
       xtitle("Mean Height") ///
       xline(`lower_bound' `upper_bound', lcolor(red))

*****3.1.3*****
// Step 1: Define the program to generate a sample and calculate its mean
cap program drop height_france
program define height_france, rclass
    args n  // n represents the size of the sample

    clear  // Clear any existing data in memory
    set obs `n'  // Set the number of observations to n

    // Generate the sample from the normal distribution with mean 177 and std deviation 7
    gen height = rnormal(179, 7)

    // Calculate and return the mean of the sample
    summarize height
    return scalar mean_height = r(mean)  // Store the mean of the sample in a return scalar
end

// Step 2: Use simulate to draw 10,000 samples of size 62 and store results in sim_men
simulate france_mean_height = r(mean_height), reps(10000) nodots: height_france 62

// Step 3: Create an id variable to identify each simulation
gen id = _n

// Step 4: Save the simulation results in a new dataset called sim_men
save french_men, replace

// Step 5: Calculate the critical values for the hypothesis test at 95% confidence level
// For a normal distribution, we use the Z-scores corresponding to a 95% confidence interval.
local z_critical = invnormal(0.975)  // 1.96 for a two-tailed test
summarize france_mean_height  // Summarize the means to get mean and stddev
local mean = r(mean)
local sd = r(sd)
local lower_bound = `mean' - `z_critical' * `sd'
local upper_bound = `mean' + `z_critical' * `sd'

di "mean height of French men is `mean'"
di "lower critical value =`lower_bound'"
di "higher critical value =`upper_bound'"

// Step 6: Plot the distribution of the sampling means
twoway (histogram france_mean_height, percent) ///
       , title("Sampling Distribution of French Male Mean Heights") ///
       xlabel(174(1)184) ///
       ytitle("Percent of Simulations") ///
       xtitle("Mean Height") ///
       xline(`lower_bound' `upper_bound', lcolor(red))


*****3.1.4*******
cap program drop hypothesis
program define hypothesis, rclass
    args n  // n represents the size of the sample

    clear  // Clear any existing data in memory
    set obs `n'  // Set the number of observations to n

    // Generate the sample from the normal distribution with mean 179 and std deviation 7
    gen height = rnormal(179, 7)

    // Calculate and return the mean of the sample
    summarize height
    return scalar mean_height = r(mean)  // Store the mean of the sample in a return scalar

    // Calculate the test-z
    local test_z = (r(mean) - 177) / (7 / sqrt(`n'))  // Calculate the z-score
    return scalar test_z = `test_z'  // Store the z-score as a scalar

    // Return whether we fail to reject the null hypothesis
    return scalar fail_to_reject = abs(`test_z') < 1.96
end

// Simulate 1000 samples
simulate fail_to_reject = r(fail_to_reject), reps(1000) nodots: hypothesis 62

// Display the results of the simulations
tabulate fail_to_reject

****3.1.5.a******
// Step 1: Define the program to generate a sample and calculate its mean
cap program drop height_india
program define height_india, rclass
    args n  // n represents the size of the sample

    clear  // Clear any existing data in memory
    set obs `n'  // Set the number of observations to n

    // Generate the sample from the normal distribution with mean 177 and std deviation 7
    gen height = rnormal(165, 7)

    // Calculate and return the mean of the sample
    summarize height
    return scalar mean_height = r(mean)  // Store the mean of the sample in a return scalar
end

// Step 2: Use simulate to draw 10,000 samples of size 62 and store results in sim_men
simulate india_mean_height = r(mean_height), reps(10000) nodots: height_india 62

// Step 3: Create an id variable to identify each simulation
gen id = _n

// Step 4: Save the simulation results in a new dataset called sim_men
save indian_men, replace

// Step 5: Calculate the critical values for the hypothesis test at 95% confidence level
// For a normal distribution, we use the Z-scores corresponding to a 95% confidence interval.
local z_critical = invnormal(0.975)  // 1.96 for a two-tailed test
summarize india_mean_height  // Summarize the means to get mean and stddev
local mean = r(mean)
local sd = r(sd)
local lower_bound = `mean' - `z_critical' * `sd'
local upper_bound = `mean' + `z_critical' * `sd'

di "mean height of Indian men is `mean'"
di "lower critical value =`lower_bound'"
di "higher critical value =`upper_bound'"

// Step 6: Plot the distribution of the sampling means
twoway (histogram india_mean_height, percent) ///
       , title("Sampling Distribution of Indian Male Mean Heights") ///
       xlabel(160(1)170) ///
       ytitle("Percent of Simulations") ///
       xtitle("Mean Height") ///
       xline(`lower_bound' `upper_bound', lcolor(red))

****3.1.5.b******
cap program drop hypothesis2
program define hypothesis2, rclass
    args n  // n represents the size of the sample

    clear  // Clear any existing data in memory
    set obs `n'  // Set the number of observations to n

    // Generate the sample from the normal distribution with mean 179 and std deviation 7
    gen height = rnormal(165, 7)

    // Calculate and return the mean of the sample
    summarize height
    return scalar mean_height = r(mean)  // Store the mean of the sample in a return scalar

    // Calculate the test-z
    local test_z = (r(mean) - 177) / (7 / sqrt(`n'))  // Calculate the z-score
    return scalar test_z = `test_z'  // Store the z-score as a scalar

    // Return whether we fail to reject the null hypothesis
    return scalar fail_to_reject = abs(`test_z') < 1.96
end

// Simulate 1000 samples
simulate fail_to_reject = r(fail_to_reject), reps(1000) nodots: hypothesis2 62
// Display the results of the simulations
tabulate fail_to_reject

****3.1.7******
***France vs US*****
cap program drop literature
program define literature, rclass
    args n  // n represents the size of the sample

    clear  // Clear any existing data in memory
    set obs `n'  // Set the number of observations to n

    // Generate the sample from the normal distribution with mean 179 and std deviation 7
    gen height = rnormal(179, 7)

    // Calculate and return the mean of the sample
    summarize height
    return scalar mean_height = r(mean)  // Store the mean of the sample in a return scalar

    // Calculate the test-z
    local lit_exaggeration = (r(mean) - 177)   // Calculate the z-score
    return scalar lit_exaggeration = `lit_exaggeration'  // Store the z-score as a scalar

end

// Simulate 1000 samples
simulate lit_exaggeration = r(lit_exaggeration), reps(1000) nodots: literature 62

// Display the results of the simulations using a histogram
histogram lit_exaggeration, percent ///
    title("Actual Height Difference Between French and U.S. Males") ///
    ytitle("Percent of Simulations") ///
    xtitle("Mean Difference")

****India vs US ******
	cap program drop literature2
program define literature2, rclass
    args n  // n represents the size of the sample

    clear  // Clear any existing data in memory
    set obs `n'  // Set the number of observations to n

    // Generate the sample from the normal distribution with mean 179 and std deviation 7
    gen height = rnormal(165, 7)

    // Calculate and return the mean of the sample
    summarize height
    return scalar mean_height = r(mean)  // Store the mean of the sample in a return scalar

    // Calculate the test-z
    local lit_exaggeration = (r(mean) - 177)   // Calculate the z-score
    return scalar lit_exaggeration = `lit_exaggeration'  // Store the z-score as a scalar

end

// Simulate 1000 samples
simulate lit_exaggeration = r(lit_exaggeration), reps(1000) nodots: literature2 62

// Display the results of the simulations using a histogram
histogram lit_exaggeration, percent ///
    title("Actual Height Difference Between Indian and U.S. Males") ///
    ytitle("Percent of Simulations") ///
    xtitle("Mean Difference")

