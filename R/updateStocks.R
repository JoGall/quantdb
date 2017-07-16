# parse arguments from bash
args <- commandArgs(TRUE)
tickers <- as.character(read.table(args[1])$V1)
start_date <- args[2]
quantmod_dir <- args[3]

#----------------------------

# set variables in R

library(quantmod)
source(paste0(quantmod_dir, "/R/getSymbols2.R"))

current_date <- Sys.Date()
latestDates <- read.csv(paste0(quantmod_dir, "/loading/latest_dates.csv"))

# check whether database needs updating
if(strftime(current_date,'%A') == "Sunday") lastMarketDate <- current_date - 2
if(strftime(current_date,'%A') == "Saturday") lastMarketDate <- current_date - 1
latestDates <- subset(latestDates, as.Date(last_date) < lastMarketDate)

# get prices
tickers_update <- tickers[tickers %in% latestDates[,1]]
tickers_new <- tickers[! tickers %in% latestDates[,1]]

if(nrow(latestDates) > 1) {
  mydf <- rbind(
    # update existing tickers
    getSymbolsDF(tickers_update, from = as.Date(latestDates[,2])+1, to = current_date),
    # build new tickers from 'start_date'
    getSymbolsDF(tickers_new, from = start_date, to = current_date)
  )
  
  # get prices
  stocks_df <- getSymbolsDF(symbols, from = start_date, to = current_date)
  
  # if new tickers, update company information csv
  info_df <- stockSymbols() %>%
    filter(Symbol %in% symbols)
  
  # merge together
  combined_df <- merge(stocks_df, info_df, by.x = "symbol", by.y = "Symbol")
  
  # write csv
  filename <- paste0(quantmod_dir, "/loading/stocks_", current_date, ".csv")
  write.csv(mydf, filename, row.names = FALSE)
}