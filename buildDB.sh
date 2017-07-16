#!/bin/bash

#=================================================================================
# buildDB.sh
#=================================================================================
# DESCRIPTION
#    * Retrieves stock prices and company information from a list of stock symbols 
#      (defined in a text file, e.g. 'my_symbols.txt') using the R package 
#      'quantmod', and loads into an postgreSQL table 'prices' in 'ss' schema
#    * Global parameters can be set in 'config.sh'
#
#=================================================================================
# AUTHOR:           Joe Gallagher <joedgallagher@gmail.com>
# DATE:             2017-07-15
# VERSION:          0.0.1
# UPDATES:
#
#=================================================================================
# TODO LIST
#
#=================================================================================


# set variables
source ./config.sh


# create database and schema structure
#--------------

# # check if db exists and ask for user confirmation before overwriting
# if [ "$( psql -U ${USER} -h ${HOST} -tAc "SELECT 1 FROM pg_database WHERE datname='$DB'" )" = '1' ]
# then
#     echo -e "WARNING: Database '$DB' already exists:"
#     read -r -p "Are you sure you want to overwrite? [ yes / no ]: " input
#     
#     case $input in
#         [yY][eE][sS])
#             echo "Overwriting '$DB' database..."
#             psql -U ${USER} -h ${HOST} -c "DROP DATABASE IF EXISTS $DB"
#             psql -U ${USER} -h ${HOST} -c "CREATE DATABASE $DB WITH OWNER = $USER ENCODING = 'UTF8' TABLESPACE = pg_default CONNECTION LIMIT = -1"
#             psql -U ${USER} -h ${HOST} -d ${DB} -c "CREATE SCHEMA ss AUTHORIZATION $USER"
#             psql -U ${USER} -h ${HOST} -d ${DB} -c "CREATE SCHEMA ss_stg AUTHORIZATION $USER"
#             psql -U ${USER} -h ${HOST} -d ${DB} -c "CREATE SCHEMA ss_ext AUTHORIZATION $USER"
#             ;;
#     
#         [nN][oO]|[nN])
#             echo "Kept existing '$DB' database"
#             ;;
#     
#         *)
#         echo "Invalid input"
#         exit 1
#         ;;
#     esac
# else   
#     echo "Making new database '$DB'"
#     psql -U ${USER} -h ${HOST} -c "DROP DATABASE IF EXISTS $DB"
#     psql -U ${USER} -h ${HOST} -c "CREATE DATABASE $DB WITH OWNER = $USER ENCODING = 'UTF8' TABLESPACE = pg_default CONNECTION LIMIT = -1"
#     psql -U ${USER} -h ${HOST} -d ${DB} -c "CREATE SCHEMA ss AUTHORIZATION $USER"
#     psql -U ${USER} -h ${HOST} -d ${DB} -c "CREATE SCHEMA ss_stg AUTHORIZATION $USER"
#     psql -U ${USER} -h ${HOST} -d ${DB} -c "CREATE SCHEMA ss_ext AUTHORIZATION $USER"
# fi

# grant permissions to db user
# chmod -R 777 ${QUANTMOD_DIR}/


# retrieve stock prices and company information using quantmod and write to csv
#--------------

# Rscript ./R/buildNewStocks.R $TICKERS $START_DATE $QUANTMOD_DIR


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