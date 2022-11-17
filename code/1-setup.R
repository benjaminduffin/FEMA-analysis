
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
