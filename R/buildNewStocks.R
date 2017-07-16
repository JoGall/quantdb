# parse arguments from bash
args <- commandArgs(TRUE)
symbols <- as.character(read.table(args[1])$V1)
start_date <- args[2]
quantmod_dir <- args[3]

#----------------------------

# set variables in R

library(quantmod)
library(dplyr)
source(paste0(quantmod_dir, "/R/getSymbols2.R"))

current_date <- Sys.Date()

#----------------------------

# get prices
stocks_df <- getSymbolsDF(symbols, from = start_date, to = current_date)

# get company information
info_df <- stockSymbols() %>%
  filter(Symbol %in% symbols)

# merge together
combined_df <- merge(stocks_df, info_df, by.x = "symbol", by.y = "Symbol")

#----------------------------

# write to csv
filename1 <- paste0(quantmod_dir, "/loading/stocksPrices_", current_date, ".csv")
filename2 <- paste0(quantmod_dir, "/loading/stocksInfo_", current_date, ".csv")
filename3 <- paste0(quantmod_dir, "/loading/stocksCombined_", current_date, ".csv")

write.csv(stocks_df, filename1, row.names = FALSE)
write.csv(info_df, filename2, row.names = FALSE)
write.csv(combined_df, filename3, row.names = FALSE)
