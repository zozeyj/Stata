//PS10 Yeji KIM

//1
. regress work male edun2 edun3 edun4 aged2 aged3 aged4 aged5 aged6 aged7 married chil
> d famsize
. probit work male edun2 edun3 edun4 aged2 aged3 aged4 aged5 aged6 aged7 married child
>  famsize
. logit work male edun2 edun3 edun4 aged2 aged3 aged4 aged5 aged6 aged7 married child 
> famsize

//1.1a
. regress work male edun2 edun3 edun4 aged2 aged3 aged4 aged5 aged6 aged7 married child famsize
. margins, dydx (male married)

//1.1b
. probit work male edun2 edun3 edun4 aged2 aged3 aged4 aged5 aged6 aged7 married child
>  famsize

. margins, dydx (male married)

//1.1c
. logit work male edun2 edun3 edun4 aged2 aged3 aged4 aged5 aged6 aged7 married child famsize
. logit work male edun2 edun3 edun4 aged2 aged3 aged4 aged5 aged6 aged7 married child 
> famsize, or


//1.2a
. probit work male edun2 edun3 edun4 aged2 aged3 aged4 aged5 aged6 aged7 married child
>  famsize
. estimates store A
. probit work male edun2 edun3 edun4 aged2 aged3 aged4 aged5 aged6 aged7 married child
>  famsize

. probit work male edun2 edun3 edun4 aged2 aged3 aged4 aged5 aged6 aged7 married
. estimates store B
. probit work male edun2 edun3 edun4 aged2 aged3 aged4 aged5 aged6 aged7 married

. lrtest A B, stats

//2
. regress approve white
. probit approve white

. probit approve white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mor
> tlat2 vr

. logit approve white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mort
> lat2 vr

//3
. regress approve white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mo
> rtlat2 vr
. regress approve white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 
> mortlat2 vr, robust
