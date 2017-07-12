my_symbols <- as.character(read.table("my_symbols.txt")$V1)

# gets symbols of top 50 companies by market cap
stockData <- stockSymbols() %>%
  filter(Symbol %in% my_symbols)

write.csv(stockData, "stockData.csv", row.names = F)
