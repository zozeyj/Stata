//Module3
* Step 1: Set the working directory
cd "C:/Users/yeji/Desktop/R Practice/stata"

* Step 2: Load the original data file
use "ElectionsMessy.dta", clear

* Step 3: Save a copy of the dataset with a new name
save "ElectionsClean.dta"

* Step 4: Load the copied dataset to make changes
clear

* Step 5: Describe the data to check the structure
describe

* Now you can proceed with any data cleaning or analysis without altering the original dataset
count

keep if YEARYEAR==2020
keep if party=="Democratic"

count

keep name tvts20082020 legislators land happyX marijuanalegal

rename tvts20082020 totalvotes
rename marijuanalegal mlegal

order total leg la h mle, a(name)

save "ElectionsClean.dta", replace

*what command for characters (in red)?
*tabulate oneway
tabulate land
summarize legislators, detail
*blue letters: stored as numbers displays as characters
tabulate mlegal, nolabel
summarize mlegal, detail
codebook mlegal
d

use "ElectionsMessy.dta", clear
save "Assignment2.dta"
gen pervotes=num/tvts20082020*100
save "Assignment2.dta", replace