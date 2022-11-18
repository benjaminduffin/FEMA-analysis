# Header ------------------------------------------------------------------

# Setting up base mapping utilities for use in analysis tool 

# Load libraries ----------------------------------------------------------

library(leaflet)
library(sf)



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
