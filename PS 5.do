*************************************
**********Yeji KIM, PS5**************
*************************************
use "C:\Users\yeji\Downloads\UdaipurJPAL.dta" 

//a. Turn the "child_id" variable into a string variable. You may want to create a new variable instead of replacing this one

gen child_idstring=child_id
tostring child_idstring, replace

//b.What was the lowest total score on the written exam? What is the observation number belonging to this child in the dataset (child_id) and their observation number within STATA? Which school did this student attend?  
sum post_total_w
sort post_total_w
browse
list child_id in 1
list schid in 1
list childno in 1

//ANS: The lowest toal score on the written exam is 0.0909, childid 112108, schoolid 1121, and childno 8. 

//c. Construct a 90% confidence interval for Verbal Pretest Math Score 
ci means pre_math_v, level (90)
//ans: [8.566491,8.76429]

*d. Construct a 95% confidence interval for Verbal Pretest Language Score.
ci means pre_lang_v, level (95)
//ans: [5.710203, 6.112926]

*e. On the written tests taken before the experiment, did students do better on the math or language tests? What is the p-value to your findings? 
ttest pre_lang_w == pre_math_w, unpaired unequal

*f. Construct a 99% confidence intervals for the Written Posttest Scores (total, math, language) in one line of code
ci means post_math_w post_lang_w post_total_w, level (99)

*g. Children were given verbal tests if they could not read at the time the test was given. Create a new indicator variable that will equal 1 if and only if a child has been evaluated both times by a written test. This will distinguish children who have been literate the entire time of the experiment. 
tab post_writ pre_writ
gen bothwritten = 0
replace bothwritten = 1 if post_writ == 1 & pre_writ == 1 

*h. How many children were given a verbal test both times? What percentage of students that could not read when the test was first administered could not read at the follow-up (posttest)? 
count if pre_writ == 0 & post_writ == 0
tab2 pre_writ post_writ, cell 
display 745/1509
//ANS: 745 students were given verbal test both times; 49.37% 

*I. Conduct t-tests to find out if the experiment has been successful. Limit your selection to just the students who took written exams. Are the language test scores the same for students in the control group and the treatment group? 
ttest pre_total_w==post_total_w
ttest post_lang_w, by(schooltreated)
//ANS: the language test scores were different for control, treatment group having higher post test scores. 

*J. Consider the students in the control group. For students who took the verbal test, are their total scores the same before and after? 
ttest pre_total_v==post_total_v if schooltreated==0
//ANS: the pre, post test scores are not the same for the control group 

*k. With a histogram, show the Verbal Posttest Math Scores in School # 5131
histogram post_math_w if schid==5131, freq