
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

# function that gives number of NA and perc of data of NA
sumNA <- function(...) {
  # data frame logic
  if (is.data.frame(...)) {
    x <- data.frame(colSums(is.na(...)))
    names(x) <- "n_NA"
    l <- nrow(...)
    x$perc_NA <- round(x$n_NA / l, 2)
    print(x)
    
    ###################################################################### - need to work on the second part 
  } else { # multiple vectors 
    #vec_list <- tibble::lst(dlr$SAFIS_DEALER_RPT_ID, dlr$DEALER_TICKET_NO)
    vec_list <- list(...)
    res <- lapply(vec_list, function(x) {
      sum_na <- sum(is.na(x))
      tot_recs <- length(x)
      perc_na <- round(sum_na / tot_recs, 2)
      na_df <- data.frame(t(c(sum_na, perc_na)))
      #names(na_df) <- c("n_NA", "perc_NA")
    })
    
    #bind_rows(res) 
  }
}  

