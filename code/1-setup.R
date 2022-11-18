
# Header ------------------------------------------------------------------


# Libraries ---------------------------------------------------------------

library(dotenv)
library(keyring)
library(writexl)
library(readxl)
library(dplyr)
library(here)

# File Structure ----------------------------------------------------------

# set up the file strucutre
dirs <- c("code", "data", "documentation", "output", "functions")

for (i in 1:length(dirs)){
  if(dir.exists(dirs[i]) == FALSE){
    dir.create(dirs[i])
  }
}


# Functions ---------------------------------------------------------------

# Functions are sourced from scripts
source(here::here("functions", "eda_functions.R"))


# {dotenv} setup and secrets ----------------------------------------------

# create a .env file with a value pair for the DB connection string 
# add a line after completed text 

## ADD TO GITIGNORE
# just new lines 
# .env

# load .env
load_dot_env(".env") # then access with Sys.getenv("HMS_EDEALER")
