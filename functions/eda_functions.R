
# Header ------------------------------------------------------------------

# This provides some custom functions to describe data


# make a named list 
named_list_f <- function(...){
  names <- as.list(substitute(list(...)))[-1L]
  result <- list(...)
  names(result) <- names
  result
}

# a function for printing out how many unique records exist for input data
# takes multiple arguments 
length_unique <- function(...) {
  dat_list <- named_list_f(...)
  cat("Unique lengths for each column: \n")
  lapply(dat_list, function(x) length(unique(x)))
}


