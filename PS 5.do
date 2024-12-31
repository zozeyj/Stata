*************************
******PS5 YEJI KIM*******
*************************

//1
. regress foods womsh

//2
. regress foods womsh womed
. regress foods womsh womed nmkids nfkids
. generate totalnkids = nmkids + nfkids
. regress foods womsh womed total
. regress foodsh womsh womed nmkids nfkids lninc\

//3
. regress voteA lexpendA lexpendB prtystrA
. test lexpendA = -lexpendB

//4
. regress lwage educ exper tenure
. gen totalexper = exper + tenure
. regress lwage educ total
