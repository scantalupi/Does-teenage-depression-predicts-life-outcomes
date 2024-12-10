************************************************************************************
** End of Course Assignment - "Does depression predict life outcomes?", SIMONE CANTALUPI, 0001092400
** This do file covers Part 0 the final assignment. Therefore, the purpose of this do file is to create a dataset by cleaning the orignal ones, and constructing and labelling new variables
************************************************************************************

// cd to working directory, that contains the subfolder detailed in the project

// copy this statement the lines below
if "${purpose}" == "grading" {
	cd  "${cd}"
}	

cd "/Users/simonecantalupi/Desktop/Workshop/lec3&4/dataSets3"


use "DS0001/21600-0001-Data.dta", clear

// IMPORTANT: DO NOT CHANGE THE WORKING DIRECTORY AFTER THIS POINT


*** PART 1 ***

* Biological sex *

gen female = BIO_SEX == 2 if BIO_SEX < 6

replace BIO_SEX = .  if BIO_SEX == 6

label var female "Sex of the individual (0 = male, 1 = female)"


* Race *

gen white = 1 if H1GI6A == 1 & H1GI8 == 7
replace white = 0 if H1GI6A == 0
gen black = 1 if H1GI6B == 1 & H1GI8 == 7
replace black = 0 if H1GI6B == 0 
gen hispanic = 1 if H1GI4  == 1 & H1GI8 == 7
replace hispanic = 0 if H1GI4 == 0 

gen raceCategory = 1 if hispanic == 1 
replace raceCategory = 2 if white == 1 & raceCategory == . 
replace raceCategory = 3 if black == 1 & raceCategory == . 
replace raceCategory = 4 if H1GI6A< = 1 & H1GI6B <= 1 & H1GI6C <= 1 & H1GI6D <= 1 & H1GI6E <= 1  & raceCategory == .

label define raceCategory 1 "Hispanic" 2 "White" 3 "Black" 4 "Other Ethnicity" 
label values raceCategory  raceCategory
label variable raceCategory  "Race in 4 categories, derived from HIGI6A-HIGI6E,H1GI4, H1GI8

label var raceCategory "Race of the individual (1 = Hispanic, 2 = White, 3 = Black, 4 = Other Ethnicity)"






*** PART 2 ***

use "DS0022/21600-0022-Data.dta"






*** PART 3 ***

use "DS0032/21600-0032-Data.dta"











save "/Users/simonecantalupi/Desktop/Workshop/Final project/replication0001092400/datasets", replace 
