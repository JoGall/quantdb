library(quantmod)
library(dplyr)

# gets symbols of top 50 companies by market cap
symbols <- stockSymbols() %>%
  arrange(desc(MarketCap)) %>%
  head(50) %>%
  select(Symbol)

# write to file
write.table(symbols, file="my_symbols.txt", 
            row.names=FALSE, col.names=FALSE)
