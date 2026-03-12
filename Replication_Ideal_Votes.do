*******************************************
*******REPLICATION FOR TRN410**************
*******************************************

***CLEANING DATA***
//import UN voting data
import delimited /Users/maggiewang/Downloads/Year_4/TRN410/TRN410_Data/2025_9_19_ga_voting.csv, clear

//format date variable for manipulation
gen datenum = date(date, "YMD")
format datenum %td
gen timesince = (td(19sep2025)-datenum)/365.25

//drop all observations before September 7, 2013 (start date of BRI)
drop if timesince > 12.03

//transpose matrix
drop ms_name										
reshape wide ms_vote, i(undl_id) j(ms_code, string)

//country labels
do /Users/maggiewang/Downloads/Year_4/TRN410/TRN410_Data/labels.do

***IDEAL POINT ESTIMATION***
//set starting values
gen beta_v = 1 if CHN == "Y"
replace beta_v = -1 if CHN == "N"
replace beta_v = 0 if CHN == "A"
replace beta_v = 0 if beta_v == .

oprobit beta_v
display (.0517768+.0419679)/2 * sqrt(1090)

//draw from inverse CDF
scalar mvote = 0      		  // mean
scalar sdvote = 1.5474976      // sd
scalar lowercut = -1.281552      // lower bound
scalar uppercut =  -.7379407     // upper bound

gen U = runiform()

scalar Fa = normal((lowercut-mvote)/sdvote)		//standardized bounds
scalar Fb = normal((uppercut-mvote)/sdvote)

gen Y = mvote + sdvote * invnormal(Fa + U * (Fb - Fa))		//generate truncated normal using the inverse CDF

drawnorm 
