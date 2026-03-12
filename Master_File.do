******************************************
************MASTER DO FILE****************
******************************************

**SORTING UN VOTING DATA**
run /Users/maggiewang/Downloads/Year_4/TRN410/TRN410_Data/sort_ideal_votes.do

**MERGE UN VOTING/BRI PARTNERSHIP DATASETS**
merge 1:1 iso3c using /Users/maggiewang/Downloads/Year_4/TRN410/TRN410_Data/BRIPartners.dta

**REMOVE NON UNGA MEMBERS**
drop if _merge == 2
drop _merge

//format date variable for manipulation
gen datenum = date(DateJoin, "YMD")
format datenum %td
//
// gen BRIlength = (td(01jan2025)-datenum)/365.25
// replace BRIlength = 0 if BRIlength == .

gen exitnum = date(DateExit, "YMD")
format exitnum %td
// gen timeleft = (td(01jan2025)-exitnum)/365.25
// replace timeleft = 0 if timeleft == .
// replace BRIlength = (BRIlength-timeleft)

**BRI ENTRY DUMMY VAR**
gen BRI_entry = year(datenum)
replace BRI_entry = 0 if BRI_entry == .

//transpose wide --> long
reshape long similarCHN_p, i(iso3c) j(year)
rename similarCHN_p palign

**MERGE STRATEGIC PARTNERSHIPS**
merge m:1 iso3c using /Users/maggiewang/Downloads/Year_4/TRN410/TRN410_Data/StratP.dta
drop if _merge == 2 //remove palestine
drop id
drop _merge

run /Users/maggiewang/Downloads/Year_4/TRN410/replacesp.do 

//country ID for regression
encode iso3c, gen(id)

//lagged dv
xtset id year
gen lpalign = L.palign

//GEN BRI DUMMY VAR
generate BRI = (year >= BRI_entry)

//GEN UPGRADE VAR
generate sp_increase = (sp > L.sp) //year of inc. 
generate upgrade = sp_increase
bys iso3c (year): replace upgrade = 1 if upgrade[_n-1] == 1

**MERGE Controls
merge 1:m iso3c year using /Users/maggiewang/Downloads/Year_4/TRN410/TRN410_Data/abucontrols.dta
drop if _merge == 2
drop _merge
destring gdp, replace ignore (",")

//normalize trade dep
summarize trade_dependency
gen trade_dep = (trade_dependency - 13.15939)/80.07074
drop trade_dependency
rename trade_dep trade_dependency

**MAIN REGRESSION**
//DiD with control: not yet treated
csdid palign sp lpalign upgrade, ivar(id) time(year) gvar(BRI_entry) notyet method(reg)
estat pretrend
estat event

graph set window fontface "Times New Roman"
csdid_plot, xtitle ("Periods to Treatment") ytitle ("ATT") 
graph export /Users/maggiewang/Downloads/Year_4/TRN410/TRN410_Data/DiD.png, replace

// //DiD with control: never treated
// csdid palign, ivar(id) time(year) gvar(BRI_entry) method(reg)
// estat pretrend
// estat event
// csdid_plot

**MECHANISMS**
logit upgrade BRI sp gdp importinthousands exportinthousands trade_dependency confucius_n v2x_polyarchy military_dependency arm_sale usforiegnaid usforeighnaidgdp externalintervention politicalstability neighbourcountries

predict upgradehat

reghdfe palign upgradehat sp gdp importinthousands exportinthousands trade_dependency confucius_n v2x_polyarchy military_dependency arm_sale usforiegnaid usforeighnaidgdp externalintervention politicalstability neighbourcountries, absorb(iso3c)

reghdfe v2x_polyarchy BRI sp gdp importinthousands exportinthousands trade_dependency confucius_n military_dependency arm_sale usforiegnaid usforeighnaidgdp externalintervention politicalstability neighbourcountries, absorb(iso3c)

reghdfe palign demhat upgradehat sp gdp importinthousands exportinthousands trade_dependency confucius_n military_dependency arm_sale usforiegnaid usforeighnaidgdp externalintervention politicalstability neighbourcountries, absorb(iso3c)
