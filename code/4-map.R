# Header ------------------------------------------------------------------

# Setting up base mapping utilities for use in analysis tool 

# Load libraries ----------------------------------------------------------

library(leaflet)
library(sf)
library(ggplot2) 
library(plotly)



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

head(fin_dat)

# convert to sf 
fin_datsf <- st_as_sf(fin_dat)

## check out a map fo the discasters 
ggplot() + 
  geom_sf(data = fin_datsf, aes(fill = as.factor(disasterNumber))) + 
  scale_fill_discrete(na.value = "transparent")


# or maybe as merged 
disaster_geos <- st_as_sf(disaster_geos)
disaster_geos <- subset(disaster_geos, !is.na(disasterNumber))

p <- ggplot(disaster_geos) + 
  geom_sf(aes(fill = as.factor(disasterNumber)), alpha = 0.5) +
  scale_fill_discrete(na.value = "transparent")

ggplotly(p)
