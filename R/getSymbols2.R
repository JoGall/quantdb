# getSymbols wrapper function to return dataframe with 'symbols' column
getSymbolsDF <- function(symbols, from, to) {
  
  result_list <- lapply(1:length(symbols), function(x) {
    # update symbols if multiple 'from' dates supplied
    if(length(from) > 1) {
      tryCatch({
        tmp <- getSymbols(symbols[x], from = from[x], to = to, auto.assign = F)
        data.frame(date = index(tmp), 
                   symbol = symbols[x],
                   open = as.numeric(Op(tmp)), 
                   high = as.numeric(Hi(tmp)), 
                   close = as.numeric(Cl(tmp)),
                   volume = as.numeric(Vo(tmp)),
                   adj = as.numeric(Ad(tmp))
        )
      }, error = function(e) {
        return(NULL)
      })
    } else {
      # build new symbols for new symbols when one 'start_date' supplied
      tryCatch({
        tmp <- getSymbols(symbols[x], from = from, to = to, auto.assign = F)
        data.frame(date = index(tmp), 
                   symbol = symbols[x],
                   open = as.numeric(Op(tmp)), 
                   high = as.numeric(Hi(tmp)), 
                   close = as.numeric(Cl(tmp)),
                   volume = as.numeric(Vo(tmp)),
                   adj = as.numeric(Ad(tmp))
        )
      }, error = function(e) {
        return(NULL)
      })
    }
  })
  
  result_df <- do.call(rbind, result_list)
  return(result_df)
}