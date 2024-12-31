**********************
*****PS4 Yeji KIM*****
**********************

//Q1 
 regress lwage educ looks
 
 //Q2
 . regress lwage stotal
 . regress lwage stotal exper
 . regress lwage stotal exper jc univ
 . regress lwage stotal exper jc univ phsrank
 . regress lwage stotal exper jc univ phsrank randx
 . regress lwage stotal exper jc univ phsrank randx randy
 
 //Q5
 . summarize fsize if fsize==1, detail
 . regress nettf inc age if fsize==1
 . regress nettf inc if fsize==1