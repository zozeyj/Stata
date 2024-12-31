//PS8

//1.1
. regress lnwage female educ exper married urban if union==1
. regress lnwage female educ exper married urban if union==0

//1.2
. regress lnwage female educ exper married urban
. test union = ufemale = ueduc = uexper = umarried = uurban = 0

//2
. gen educ2 = educ-10
. gen exper2 = exper - 10
. gen edexper2=educ*exper2
. regress lwage educ exper2 edexper2

//3
//re-calibrate
. gen expendAB = expendA*expendB
. regress lwage educ exper2 edexper2

//marginal effects
. reg voteA prtystrA expendA expendB c.expendA#c.expendB
. margins, dydx(expendB) at(expendA=(100(100)300))
. margins, dydx(expendA) at(expendB=(100(100)300))

//4
. regress lbwght npvis npvissq
. count if npvis>22 | npvis == 22
. regress lbwght npvis npvissq magesq





