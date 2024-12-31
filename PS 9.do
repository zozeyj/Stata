//PS9 Yeji KIM

//1
. regress lbwght npvis npvissq mage magesq
. estat ovtest

. regress bwght npvis npvissq mage magesq
. estat ovtest

//2
. gen rosneg =.
. replace rosneg = 1 if ros<0
. replace rosneg = 0 if rosneg != 1
. regress lsalary lsales roe rosneg

//3
. regress lwage educ exper tenure married black south urban
. gen expersq = exper^2
. gen tenuresq = tenure^2
. regress lwage educ exper expersq tenure tenuresq married black south urban
. test expersq=tenuresq=0

//4
. regress approve white
. regress approve white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr

//5
reg sleep totwrk educ age agesq yngkid male
. predict sleepres, residuals
. gen sleepressq = sleepres^2
. regress sleepressq totwrk educ age agesq yngkid male
. regress sleepressq male

//6
. regress voteA prtystrA democA lexpendA lexpendB
. predict voteAres, residuals
. reg voteAres prtystrA democA lexpendA lexpendB
. gen voteAressq = voteAres^2
. reg voteAressq prtystrA democA lexpendA lexpendB

