# loads
library(quantmod)

# parse arguments from bash
args <- commandArgs(TRUE)

# processing
tickers <- as.character(read.table(args[1])$V1)
last_date <- args[2]
current_date <- args[3]
loading_dir <- args[4]

# getSymbols wrapper function to return dataframe with 'ticker' column
getSymbolsDF <- function(tickers, from, to) {
  
  result_list <- lapply(tickers, function(x) { 
    tryCatch({
      tmp <- getSymbols(x, from = from, to = to, auto.assign = F)
      data.frame(date = index(tmp), 
                 ticker = x,
                 open = as.numeric(Op(tmp)), 
                 high = as.numeric(Hi(tmp)), 
                 close = as.numeric(Cl(tmp)),
                 volume = as.numeric(Vo(tmp)),
                 adj = as.numeric(Ad(tmp))
      )
    }, error = function(e) {
      return(NULL)
    })
  })

  result_df <- do.call(rbind, result_list)
  return(result_df)
}

# get data
my_df <- getSymbolsDF(tickers, from = last_date, to = current_date)

# write csv
filename <- paste0(loading_dir, "/stocks_", last_date, "_-_", current_date, ".csv")
write.csv(my_df, filename, row.names = FALSE)
