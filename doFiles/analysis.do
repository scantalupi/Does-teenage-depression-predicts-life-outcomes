************************************************************************************
** End of Course Assignment - "Does depression predict life outcomes?", SIMONE CANTALUPI, 0001092400
** This do file covers Part 1 to 3 of the final assignment. Therefore, the purpose of this do file is to carry-out the descriptive statistics, a cross-sectional regressions and a two-way fixed effects regressions
************************************************************************************
clear all 
// This path should be replaced with the parent directory with the add health data (the one containing DS001 etc subfolders)
global datapath  "/Users/simonecantalupi/Desktop/Workshop/Final project/dataSets"
// This path should be replaced with the parent directory with the add health data (the one containing DS001 etc subfolders)
global projectpath "/Users/simonecantalupi/Desktop/Workshop/Final project/replication0001092400"

// copy this statement the lines below
if "${purpose}" == "grading" {
	global datapath  "$cd1"
	global projectpath "$cd2"
}


**************
*** PART 1 ***
**************


use "$projectpath/datasets/wave1dataset.dta", clear

foreach var of varlist * {
	rename `var' `var'_wv1
}

rename AID_wv1 AID
tempfile tempW1
save `tempW1'


use "$projectpath/datasets/wave5dataset.dta"

merge m:1 AID using `tempW1'


gen hispanic = raceCategory == 1 if raceCategory < . 
gen white = raceCategory == 2 if raceCategory < . 
gen black = raceCategory == 3 if raceCategory < . 

keep if householdIncome_wv1 < .
drop if householdIncome_wv1 == .

replace householdIncome = householdIncome/1000
replace householdIncome_wv1 = householdIncome_wv1/1000

label var depressionIndex "Depression Index W5"
label var depressionIndex_wv1 "Depression Index W1"
label var hasCollege "Has College Degree"
label var householdIncome "Household Income W5 ($'000s')"
label var householdIncome_wv1 "Household Income W1 ($'000s)"
label var intelligence_wv1 "Self-Rated Intelligence W1"
label var ageAtSurvey "Age at Survey"
label var ageAtSurvey_wv1 "Age at Survey W1"
label var female "Female W1"
label var householdIncomeCat "Household Income W5 (Categories)"


* Q1 *
eststo drop *
estpost summarize depressionIndex depressionIndex_wv1 hasCollege householdIncomeCat hispanic white black householdIncome_wv1 intelligence_wv1 female_wv1 gpa_wv1 ageAtSurvey_wv1 

esttab using "$projectpath/outputs/summStat.tex" , cells("count (star fmt(2)) mean sd min max") replace label


* Q2 *
#delimit; 
twoway (kdensity depressionIndex) || (kdensity depressionIndex_wv1),
    title("Density of Depression W1 and W5") ///
    xtitle("Depression Index (% Maximum)") ytitle("Density") ///
	legend(order(2 "W1" 1 "W5") position(6))
;
#delimit cr


graph export "$projectpath/outputs/densityDepression.jpg", replace
	

* Q3 *

#delimit;
twoway (lpolyci loghouseholdIncome depressionIndex), 
    title("W5 Depression") ///
	xtitle("Depression Index W5 (% Maximum)") ytitle("Household Income W5") ///
	legend(order(1 "95% CI" 2 "Local Polynomial Smooth")) ///
	name(lplyci1, replace)
;
#delimit cr


#delimit;
twoway (lpolyci loghouseholdIncome_wv1 depressionIndex_wv1), 
	title("W1 Depression") ///
	xtitle("Depression Index W1 (% Maximum)") ytitle("Household Income W1") ///
	legend(order(1 "95% CI" 2 "Local Polynomial Smooth")) ///
	name(lplyci2, replace)
;
#delimit cr


* To combine the graphs using the same legended I used the package grc1leg: net install grc1leg,from(http://www.stata.com/users/vwiggins/)

grc1leg lplyci1 lplyci2, name(combinedlpycil, replace) title("Local Polynomial Fit of Household Income vs Depression Indices") legendfrom(lplyci1)

graph display combinedlpycil, xsize(12) ysize(6)

graph export "$projectpath/outputs/lpoly.jpg", replace



* Q4 *
gen dropOut = _merge<3


eststo drop *
estpost corr depressionIndex depressionIndex_wv1 householdIncome depressionDiagn depressionMed hasCollege dropOut, matrix

eststo correlation 

esttab correlation using "$projectpath/outputs/correlation.tex", unstack compress b(2) replace 



**************
*** PART 2 ***
**************


clear all 

use "$projectpath/datasets/wave1dataset.dta", clear

foreach var of varlist * {
	rename `var' `var'_wv1
}

rename AID_wv1 AID
tempfile tempW1
save `tempW1'


use "$projectpath/datasets/wave5dataset.dta"

merge m:1 AID using `tempW1'


gen hispanic = raceCategory == 1 if raceCategory < . 
gen white = raceCategory == 2 if raceCategory < . 
gen black = raceCategory == 3 if raceCategory < . 

keep if householdIncome_wv1 < .
replace householdIncome = householdIncome/1000
replace householdIncome_wv1 = householdIncome_wv1/1000

label var depressionIndex "Depression Index W5"
label var depressionIndex_wv1 "Depression Index W1"
label var hasCollege "Has College Degree"
label var householdIncome "Household Income W5 ($'000s')"
label var householdIncome_wv1 "Household Income W1 ($'000s)"
label var intelligence_wv1 "Self-Rated Intelligence W1"
label var ageAtSurvey "Age at Survey"
label var ageAtSurvey_wv1 "Age at Survey W1"
label var female "Female W1"
label var loghouseholdIncome "Log Household Income W5"



* Q1 *
eststo drop *
eststo: reg hasCollege depressionIndex_wv1, vce(robust)

eststo: reg hasCollege depressionIndex_wv1 hispanic white black loghouseholdIncome_wv1 intelligence_wv1 female_wv1 ageAtSurvey ageAtSurvey_wv1, vce(robust)

eststo: reg hasCollege depressionIndex_wv1 hispanic white black loghouseholdIncome_wv1 intelligence_wv1 female_wv1 ageAtSurvey ageAtSurvey_wv1 gpa, vce(robust)

eststo: reg loghouseholdIncome depressionIndex_wv1, vce(robust)

eststo: reg loghouseholdIncome depressionIndex_wv1 hispanic white black loghouseholdIncome_wv1 intelligence_wv1 female_wv1 ageAtSurvey ageAtSurvey_wv1,vce(robust)

eststo: reg loghouseholdIncome depressionIndex_wv1 hispanic white black loghouseholdIncome_wv1 intelligence_wv1 female_wv1 ageAtSurvey ageAtSurvey_wv1 gpa, vce(robust)

 
#delimit;
esttab using "$projectpath/outputs/OLSregression.tex", 
	replace 
	modelwidth(6)  
	cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01)
	s(N  r2_a , label("Observations" "Adj-R2") fmt(%9.0f %9.2f)) label
;
#delimit cr



* Q2 *
eststo drop *

eststo: regress hasCollege depressionIndex_wv1 hispanic white black loghouseholdIncome_wv1 intelligence_wv1 female_wv1, robust 

eststo: ivregress 2sls hasCollege (depressionIndex_wv1 = suicide_wv1) hispanic white black loghouseholdIncome_wv1 intelligence_wv1 female_wv1 ageAtSurvey ageAtSurvey_wv1, robust first 
estat first 
estadd scalar Fstat = r(singleresults)[1,4]

eststo: regress loghouseholdIncome depressionIndex_wv1 hispanic white black loghouseholdIncome_wv1 intelligence_wv1 female_wv1, robust 

eststo: ivregress 2sls loghouseholdIncome (depressionIndex_wv1 = suicide_wv1) hispanic white black loghouseholdIncome_wv1 intelligence_wv1 female_wv1 ageAtSurvey ageAtSurvey_wv1, robust first 
estat first 
estadd scalar Fstat = r(singleresults)[1,4]


#delimit;
esttab using "$projectpath/outputs/IVregression.tex", 
	replace 
	modelwidth(6)  
	cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01)
	s(N  r2_a Fstat , label("Observations" "Adj-R2" "First stage F-Stat") fmt(%9.0f %9.2f %9.1f)) label
	order(depressionIndex)
;
#delimit cr



**************
*** PART 3 ***
**************

clear all

use "$projectpath/datasets/wave1dataset.dta", replace
foreach var of varlist * { 
	rename `var' `var'_wv1
}
rename AID_wv1 AID
tempfile tempW1
save `tempW1'
 
 
use "$projectpath/datasets/wave4dataset.dta", clear
append using "$projectpath/datasets/wave5dataset.dta"
merge m:1 AID using `tempW1'


egen ID=group(AID)
xtset ID wave 

keep if householdIncome_wv1 < .

gen wave5 = wave == 5

gen hispanic = raceCategory == 1 if raceCategory < . 
gen white = raceCategory == 2 if raceCategory < . 
gen black = raceCategory == 3 if raceCategory < . 

keep if householdIncome_wv1 < .
replace householdIncome = householdIncome/1000
replace householdIncome_wv1 = householdIncome_wv1/1000

label var depressionIndex "Depression Index"
label var hasCollege "Has College Degree"
label var householdIncome "Household Income ($'000s')"
label var intelligence_wv1 "Self-Rated Intelligence W1"
label var ageAtSurvey "Age at Survey"
label var ageAtSurvey_wv1 "Age at Survey W1"
label var female "Female W1"
label var loghouseholdIncome "Log Household Income W5"
label var loghouseholdIncome_wv1  "Log Hhld Income W1"


eststo drop *
eststo: regress householdIncome depressionIndex, vce(cluster AID)
 estadd local FE = "N" 
eststo: regress householdIncome depressionIndex wave5, vce(cluster AID) 
 estadd local FE = "N"
eststo: regress householdIncome depressionIndex wave5 hispanic_wv1 white_wv1 black_wv1 loghouseholdIncome_wv1 intelligence_wv1 female_wv1 ageAtSurvey ageAtSurvey_wv1, vce(cluster AID) 
 estadd local FE = "N"

eststo: xtreg householdIncome depressionIndex wave5 ageAtSurvey, vce(cluster ID) fe
 estadd local FE = "Y"

#delimit;
esttab using "$projectpath/outputs/feRegression.tex", 
	replace 
	modelwidth(6)  
	cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01)
	s(FE N Individuals r2_a Fstat  , label("Person FE" "Observations" "Individuals" "Adj-R2") fmt(%9.0f %9.2f %9.1f))
	order(depressionIndex hispanic_wv1 white_wv1 black_wv1 loghouseholdIncome_wv1 intelligence_wv1 female_wv1 ageAtSurvey ageAtSurvey_wv1) label 
;
#delimit cr











