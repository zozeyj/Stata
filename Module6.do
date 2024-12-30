**Module 6
cd "C:\Users\yeji\Desktop\R Practice\stata"
use "Assignment2.dta"

//merging data (1) adding rows to existing columns 
// called making dataset 'longer' == appending dataset

//(2) adding new columns to existing rows
// called making dataset 'wider' == merging dataset

//three elements needed to merge
*already opened dataset - master dataset
**second dataset - tucked away on laptop somewhere == using dataset
***one identifier

br
drop if YEAR==2008
drop if party=="Republican"
keep abb pervotes legislators marijuanalegal land

rename perv percdem
sum percdem, detail
rename abb state
rename state abb
list state if percdem<30
list state if percdem>65

save Merge1.dta, replace

use "Merge2.dta"
sort region minwage

merge 1:1 abb using Merge1.dta
save "Merge3.dta"

tabstat urban, by(mari)
tabstat minwage, by(mari)
tabstat uninsu, by(mari)
sum urban minwage uninsu

pwcorr min leg
pwcorr uninsu urban
sum uninsu if percdem>50
sum uninsu if percdem<=50
tab _merge
drop _merge
save "Merge3.dta", replace

**_merge=1 the state was in the master dataset but didnt match the using dataset
**_merge=2 the state was in the using dataset but didn't match in the master
**_merge=3 perfect match 

//many to 1 merge
use IDM_SoP45.dta
lookfor state
br V0772
rename V0772 abb
merge m:1 abb using Merge3.dta
save SoP45_state.dta