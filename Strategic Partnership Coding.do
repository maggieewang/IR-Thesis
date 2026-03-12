******STRATEGIC PARTNERSHIP CODEBOOK******
gen id = _n
gen sp = .

replace sp = 1 if id >= 99
replace sp = 2 if id < 99 & id >= 76
replace sp = 3 if id < 76 & id >= 68
replace sp = 4 if id < 68 & id >= 31
replace sp = 5 if id < 31 & id >= 8
replace sp = 6 if id < 8 & id >= 2
replace sp = 7 if id == 1

save /Users/maggiewang/Downloads/Year_4/TRN410/TRN410_Data/StratP.dta, replace
