//YEJI KIM
//(a)	What is the average wage for each race category: white, black, and other. (Solve this using only one line of code)
webuse nlsw88.dta, clear
tab race, summarize(wage)
//ANS: average wage for white is 8.08, for black is 6.84, and other is 8.55.

//(b)	Create an indicator variable called once_married, for people who were once married, but are not currently married. How many people are once_married? 
br married
gen once_married if married= "single"
tab once_married, missing
//ANS: There are 1442 once married individuals

//(c)	Report average wages for never_married and once_married? Which group has higher average wages?
tab never_married, summarize (wage)
tab once_married, summarize (wage)
//ANS: The average for never maried individuals are 8.50 and once married individuals are 7.59. The "never married" groups have higher wages.

//(d)	Create an indicator called tenure20 for people with 20 or more years tenure. How many people have 20 or more years tenure?
gen tenure20 = tenure>=20
tab tenure20 
count if tenure20==1
//ANS: there are 63 people who have more than 20yrs of tenure.

//(e)	Create an indicator called midwage for people whose wage is within $5.00 per hour of the mean. What percentage of people reported hourly wage within $5.00 per hour of the mean? 
gen midwage = (wage<=12.766949 & wage>=2.777949)
tab midwage
//ANS: there are 85.35% of the people within the $5.00 boundaries

//(f)	Create an indicator called occ1 for people in the following occupations: Clerical/unskilled, Laborers, Farm laborers, Household workers. How many people have occ1 equal to zero? How many people have occ1 equal to one?
tab occupation
describe occupation
gen occ1= (occupation == " Clerical/Unskilled" : occlbl| occupation == "Laborers": occlbl | occupation == "Farm laborers": occlbl | occupation == "Household workers": occlbl)
count if occ1==0
count if occ1==1
//ANS: There are 1940 people who have occ1=0, and 306 people who have occ1=1. 

//(g)	Rename the variable grade to class. 
rename grade class
