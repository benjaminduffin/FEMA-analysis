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
glimpse(tx_cnty) # COUNTYFP
glimpse(ha) # substr of the placeCode
glimpse(pov_snap) # substr of the GEO_ID

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

# so let's see about how many counties had multiple disasters per year 
mult_dis <- census_ha %>%
  filter(!is.na(disasterNumber)) %>%
  group_by(county_code, year) %>%
  summarize(n_disasters = n_distinct(disasterNumber), 
            disasters = paste(unique(disasterNumber), collapse = ", ")) %>%
  filter(n_disasters > 1)


# merge in the geometries 
fin_dat <- merge(census_ha, tx_cnty, 
                 by.x = "county_code", 
                 by.y = "COUNTYFP")

# we could actually make the data a little wider?
# or just make a merged dataset for each disaster 
disaster_geos <- fin_dat %>% 
  group_by(disasterNumber) %>%
  summarize(geometry = st_union(geometry))

plot(disaster_geos$geometry)


# Derive variables --------------------------------------------------------

fin_dat <- fin_dat %>% 
  mutate(pov_rate = S2201_C01_021E / S2201_C01_001E, 
         snap_rate = S2201_C03_001E / S2201_C01_001E, 
         pov_snap_perc_ratio = pov_rate / snap_rate, 
         pov_snap_ratio = S2201_C01_021E / S2201_C03_001E)

hist(fin_dat$pov_rate)
hist(fin_dat$snap_rate)
hist(fin_dat$snap_pov_ratio)

ggplot(data = fin_dat) + 
  geom_boxplot(aes(y = pov_snap_ratio))


ggplot(data = fin_dat[!is.na(fin_dat$disasterNumber), ]) + 
  geom_point(aes(x = pov_rate, y = snap_rate)) +
  geom_abline(aes(intercept = 0, slope = 1), color = 'red')

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





