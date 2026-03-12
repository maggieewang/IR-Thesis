**SORTING IDEAL VOTE DATA**
//load data
 use "/Users/maggiewang/Downloads/Year_4/TRN410/TRN410_Data/dataverse_files (2)/IdealpointsJuly2025.dta", clear
 
//organize data
 keep iso3c year idealpointfp
 
//Maintaining compatibility with BRI Partners
replace iso3c = "SRB" if iso3c == "YUG"
 
 //limit timeframe to 2003
 drop if year < 2003
 
 //transpose
 reshape wide idealpointfp, i(iso3c) j(year)
 
 //labels
 ds idealpointf*
foreach v of varlist `r(varlist)' {
    local newname = subinstr("`v'", "idealpointf", "", 1)
    rename `v' `newname'
}


//generate ideal point similarity
foreach y of varlist p* {
    egen china_`y' = max(cond(iso3c=="CHN", `y', .))			//China's ideal point
    gen similarCHN_`y' = abs(`y' - china_`y')*-1						//Voting similarity
}

//drop unnecessary obs
drop china*
drop p*


