#!/bin/bash

# set variables
source ./config.sh

# get last dates of each ticker
TICKER_DATES_SQL="${QUANTMOD_DIR}/sql/price-dates-200.sql"
psql -d ${DB} -h ${HOST} -U ${USER} -f $TICKER_DATES_SQL


# retrieve stock prices and company information using quantmod and write to csv
#--------------

Rscript ./R/updateStocks.R $TICKERS $START_DATE $QUANTMOD_DIR

exit

# add stock prices to db
#--------------

# create external table
PRICE_EXT_CT_DDL="${QUANTMOD_DIR}/ddl/price-ext-ct-010.ddl"
psql -d ${DB} -h ${HOST} -U ${USER} -f $PRICE_EXT_CT_DDL

# load csv to external table
STOCKS_CSV="${QUANTMOD_DIR}/loading/stocksPrices*.csv"
PRICE_EXT_INS_SQL="${QUANTMOD_DIR}/sql/price-ext-ins-020.sql"
cat $STOCKS_CSV | psql -d ${DB} -h ${HOST} -U ${USER} -c "$(cat $PRICE_EXT_INS_SQL)"

# create staging table
PRICE_STG_CT_DDL="${QUANTMOD_DIR}/ddl/price-stg-ct-030.ddl"
psql -d ${DB} -h ${HOST} -U ${USER} -f $PRICE_STG_CT_DDL

# load and cast external table into staging table
PRICE_STG_INS_DDL="${QUANTMOD_DIR}/sql/price-stg-ins-040.sql"
psql -d ${DB} -h ${HOST} -U ${USER} -f $PRICE_STG_INS_DDL

# create target table
PRICE_TGT_CT_DDL="${QUANTMOD_DIR}/ddl/price-tgt-ct-050.ddl"
psql -d ${DB} -h ${HOST} -U ${USER} -f $PRICE_TGT_CT_DDL

# load staging table into target table
PRICE_TGT_INS_DDL="${QUANTMOD_DIR}/sql/price-tgt-ins-060.sql"
psql -d ${DB} -h ${HOST} -U ${USER} -f $PRICE_TGT_INS_DDL

# create audit table with row counts of data loaded to target by date
PRICE_ROWS_CT_DDL="${QUANTMOD_DIR}/ddl/price-rows-ct-070.ddl"
psql -d ${DB} -h ${HOST} -U ${USER} -f $PRICE_ROWS_CT_DDL

# insert row counts into audit table
FILENAME=$(basename $STOCKS_CSV)
PRICE_ROWS_INS_SQL="${QUANTMOD_DIR}/sql/price-rows-ins-080.sql"
psql -d ${DB} -h ${HOST} -U ${USER} -f $PRICE_ROWS_INS_SQL -v filename=FILENAME


# add company information to db
#--------------

# create external table
INFO_EXT_CT_DDL="${QUANTMOD_DIR}/ddl/info-ext-ct-110.ddl"
psql -d ${DB} -h ${HOST} -U ${USER} -f $INFO_EXT_CT_DDL

# load csv to external table
INFO_CSV="${QUANTMOD_DIR}/loading/stocksInfo*.csv"
INFO_EXT_INS_SQL="${QUANTMOD_DIR}/sql/info-ext-ins-120.sql"
cat $INFO_CSV | psql -d ${DB} -h ${HOST} -U ${USER} -c "$(cat $INFO_EXT_INS_SQL)"

# create target table
INFO_TGT_CT_DDL="${QUANTMOD_DIR}/ddl/info-tgt-ct-130.ddl"
psql -d ${DB} -h ${HOST} -U ${USER} -f $INFO_TGT_CT_DDL

# load external table into target table
INFO_TGT_INS_DDL="${QUANTMOD_DIR}/sql/info-tgt-ins-140.sql"
psql -d ${DB} -h ${HOST} -U ${USER} -f $INFO_TGT_INS_DDL


# move csv files from loading to archive directory
#--------------

mv ./loading/stocks*.csv ./archive



exit