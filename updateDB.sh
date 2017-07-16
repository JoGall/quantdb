#!/bin/bash

# # parse arguments
# if [ $# -eq 0 ]
#   then
#     echo -e "ERROR: Please supply a 'symbols.txt' file\n\nUSAGE: $0 [FILE]"
#     exit
# fi

# set variables
source ./config.sh

# get last dates of each ticker
TICKER_DATES_SQL="${QUANTMOD_DIR}/sql/price-dates-200.sql"
psql -d ${DB} -h ${HOST} -U ${USER} -f $TICKER_DATES_SQL

# call R package quantmod to update stocks
Rscript ./R/updateStocks.R $TICKERS $START_DATE $QUANTMOD_DIR

exit