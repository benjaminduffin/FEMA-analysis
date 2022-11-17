library(censusapi) 
t <- censusapi::listCensusApis()

acsmeta <- listCensusMetadata(name = "acs/acs5/subject", 
                              vintage = 2019, 
                              type = "variables", 
                              variable_name = c("GEO_ID", "S2201_C01_021E", "S2201_C01_021EA"))

t1 <- acsmeta[acsmeta$name == "S2201_C04_021E", ] # percent households receiving SNAP / Poverty status in past 12 months
# Percent households receiving food stamps/SNAP!!Estimate!!HOUSEHOLD TYPE!!No children under 18 years!!Nonfamily households

api_key <- "79231b2529669c97bd094b8a123724a692da083a"
year_list <- list()
years <- seq(2015,2020, 1)

for (i in 1:length(years)) {
  
  year_i <- years[i]
  
  x <- getCensus(name = "acs/acs5/subject", 
                 vintage = year_i, 
                 key = api_key,  # NEED KEY 
                 vars = c("GEO_ID", "S2201_C01_021E", "S2201_C01_021E"), 
                 region = "place:*",
                 regionin = "state:48",
                 show_call = T)
  
  x$year <- year_i
  
  year_list[[i]] <- x
}

all_years <- do.call(rbind, year_list)



t2 <- getCensus(name = "acs/acs5/subject", 
                vintage = 2016, 
                key = api_key,  # NEED KEY 
                vars = c("GEO_ID", "S2201_C01_021E", "S2201_C01_021E"), 
                region = "place:*",
                regionin = "state:48",
                show_call = T)



acs_simple <- getCensus(
  key = "79231b2529669c97bd094b8a123724a692da083a",
  name = "acs/acs5",
  vintage = 2020,
  vars = c("NAME", "B01001_001E", "B19013_001E"),
  region = "place:*",
  regionin = "state:01", 
  show_call = T)