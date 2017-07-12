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

getSymbolsDF(tickers, from = last_date, to = current_date)
