
# Header ------------------------------------------------------------------


# Load libraries ----------------------------------------------------------

library(censusapi) # census api wrapper
library(dotenv) # hide api with .env
library(httr)



## Load .env
load_dot_env(".env")

# Gather data -------------------------------------------------------------



t <- censusapi::listCensusApis()

t_meta <- listCensusMetadata(name = "acs/acs5/subject", 
                              vintage = 2019, 
                              type = "variables", 
                              variable_name = c("GEO_ID", "S2201_C01_021E", "S2201_C01_021EA"))

t1 <- acsmeta[acsmeta$name %in% c("S2201_C04_021E", "S2201_C01_021EA"), ] # percent households receiving SNAP / Poverty status in past 12 months
# Percent households receiving food stamps/SNAP!!Estimate!!HOUSEHOLD TYPE!!No children under 18 years!!Nonfamily households
# also need the total population of each county
year_list <- list()
years <- seq(2015,2020, 1)

for (i in 1:length(years)) {
  
  year_i <- years[i]
  
  x <- getCensus(name = "acs/acs5/subject", 
                 vintage = year_i, 
                 key = Sys.getenv("CENSUS_KEY"),  # NEED KEY 
                 vars = c("GEO_ID", "S2201_C01_021E", "S2201_C01_021EA", "S2201_C03_001E", "S2201_C03_001EA", "S2201_C01_001E", "S2201_C01_001EA"), 
                 region = "county:*",
                 regionin = "state:48",
                 show_call = T)
  
  x$year <- year_i
  
  year_list[[i]] <- x
}

all_years <- do.call(rbind, year_list)

## Total population by county
# also need the total population of each county


# FEMA DATA ---------------------------------------------------------------


# FEMA URL
fema_url <- "https://www.fema.gov/api/open/v1/FemaWebDeclarationAreas.csv"

# send get request using httr::GET to fema url
ha <- GET(fema_url)

ha_data <- content(ha, "parsed") # large data chunk, all together
# take a quick look at missingness 
sumNA(ha_data)

# grab years of interest 
years_sub <- as.character(2015:2020)

# subset the data so it is much smaller 
ha_data_sub <- subset(ha_data, 
                      programTypeCode == "HA" & stateCode == "TX" & 
                        substr(designatedDate, 1, 4) %in% years_sub)

# write file
write.csv(ha_data_sub, here::here("data", paste0("FEMA_HA_Decs_", Sys.Date(), ".csv")))
