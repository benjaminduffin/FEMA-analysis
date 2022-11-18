# Header ------------------------------------------------------------------

# Setting up base mapping utilities for use in analysis tool 

# Load libraries ----------------------------------------------------------

library(leaflet)
library(sf)
library(dplyr)
library(stringr)
library(ggplot2)



# Load data  --------------------------------------------------------------

list.files(here::here("data"))

# tx county .shp
tx_cnty <- st_read(here::here("data", "TX_counties.shp"))
# fema data 
ha <- read.csv(here::here("data", "FEMA_HA_Decs_2022-11-18.csv"), 
               stringsAsFactors = F)
# Census data
pov_snap <- read.csv(here::here("data", "Census_pov_snap_pop_2022-11-18.csv"), 
                     stringsAsFactors = F)

# Funcitons ---------------------------------------------------------------

# Functions are sourced from scripts
source(here::here("functions", "eda_functions.R"))


# Merge Data --------------------------------------------------------------


# quick exploration of merge variables 
head(tx_cnty) # COUNTYFP
head(ha) # substr of the placeCode
head(pov_snap) # substr of the GEO_ID

## prep merge variables 

# declaration data - geography
ha$county_code <- str_sub(ha$placeCode, -3, -1)
# year
ha$year <- str_sub(ha$designatedDate, 1, 4)

# census data 
pov_snap$county_code <- str_sub(pov_snap$GEO_ID, -3, -1)


# merge the FEMA, disasterNumber, designatedDate  by county and year 
census_ha <- merge(pov_snap, 
                   ha[, c("disasterNumber", "placeName", "designatedDate", "county_code", "year")], 
                   by.x = c("county_code", "year"), 
                   by.y = c("county_code", "year"), 
                   all.x = T)


# ended up with some dupes? nope, those are multiple disasters in one year for same county
t <- census_ha[duplicated(census_ha[c("year", "county_code")]) | duplicated(census_ha[, c("year", "county_code")], fromLast = T), ]


# merge in the geometries 
fin_dat <- merge(census_ha, tx_cnty, 
                 by.x = "county_code", 
                 by.y = "COUNTYFP")

# EDA ---------------------------------------------------------------------

ggplot(fin_dat$geometry) + 
  geom_sf(aes(fill = fin_dat$S2201_C01_001E), alpha = 0.5)

# check distinct disasters 
length_unique(ha$disasterNumber)

# looks like this actually stretches across several counties for each disaster
ha %>% 
  group_by(disasterNumber) %>%
  summarize(n_unique_counties = n_distinct(placeCode))

# some in multiple disasters 
ha %>% 
  group_by(placeCode) %>%
  summarize(n_disasters = n_distinct(disasterNumber))

# none duplicated within disaster 
table(duplicated(ha[, c("placeCode", "disasterNumber")]))


# Calculating variables  --------------------------------------------------


