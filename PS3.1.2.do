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



