**Manipulations to BRIPartners**
import delimited /Users/maggiewang/Downloads/Year_4/TRN410/TRN410_Data/25_05_BRI-countries-public.csv

drop v1

rename v2 iso3c
rename v3 Region
rename v4 IncomeGroup
rename v5 DateJoin
rename v6 DateExit

drop in 1

drop IncomeGroup

//corrections to data
replace DateJoin = "2021-01-06" if iso3c == "COD" 	//https://eng.yidaiyilu.gov.cn/p/160558.html
replace DateJoin = "2018-01-01" if iso3c == "COG"			//https://www.youtube.com/watch?v=IaP0mJnFOqs&t=46s 
replace  DateJoin = "2021-11-01" if iso3c == "CAF"	//https://greenfdc.org/countries-of-the-belt-and-road-initiative-bri/
replace DateJoin = "2018-08-04" if iso3c == "AUT"		//https://www.ots.at/presseaussendung/OTS_20180408_OTS0036/verkehrsminister-hofer-schliesst-historisches-seidenstrassen-abkommen-mit-china-ab
replace DateJoin = "2018-09-01" if iso3c == "NER"  //https://www.fmprc.gov.cn/eng/gjhdq_665435/2913_665441/3059_664144/#:~:text=Joint%20Statement%20between%20the%20Government,(signed%20in%20September%202024).
replace DateJoin = "2015-05-08" if iso3c == "RUS" //https://www.mfa.gov.cn/eng/zy/jj/2015zt/xjpcxelsjnwgzzsl70znqdbfelshskstbels/202406/t20240606_11381343.html 

save /Users/maggiewang/Downloads/Year_4/TRN410/TRN410_Data/BRIPartners.dta, replace
