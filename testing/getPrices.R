tickers <- as.character(read.table("my_tickers.txt")$V1)
last_date <- "2017-07-05"
current_date <- "2017-07-12"

# create environment to load data into
Data <- new.env()
quantmod::getSymbols(c("^GSPC", tickers[1:2]),
                     from = last_date,
                     to = current_date,
                     env = Data)

# calculate returns, merge, and create data.frame (eapply loops over all
# objects in an environment, applies a function, and returns a list)
Returns <- eapply(Data, function(s) ROC(Ad(s), type="discrete"))
ReturnsDF <- as.data.frame(do.call(merge, Returns))
# adjust column names are re-order columns
colnames(ReturnsDF) <- gsub(".Adjusted","",colnames(ReturnsDF))
ReturnsDF <- ReturnsDF[,c("GSPC", tickers[1:2])]


lapply(tickers[1:2], function(x)
  getSymbols(x, auto.assign=FALSE)
  ) %>%
  lapply(function(x) monthlyReturn(Ad(x)))
