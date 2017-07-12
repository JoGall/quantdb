#!/bin/Rscript

if [ $# -eq 0 ]
  then
    echo -e "ERROR: Please supply a 'symbols.txt' file\n\nUSAGE: $0 [FILE]"
    exit
fi

SYMBOLS=$1
CURRENT_DATE=$2
LAST_DATE=$3
LOADING_DIR="/home/joe/Desktop/quantmod_sql/loading"

Rscript test.R $SYMBOLS $CURRENT_DATE $LAST_DATE $LOADING_DIR

# Rscript --vanilla --slave test.R $SYMBOLS $LAST_DATE $CURRENT_DATE

exit