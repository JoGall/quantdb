#!/bin/sh

source ./config.sh

if [ "$( psql -U ${USER} -h ${HOST} -tAc "SELECT 1 FROM pg_database WHERE datname='$DB'" )" = '1' ]
then
    echo -e "WARNING: Database '$DB' already exists:"
    read -r -p "Are you sure you want to overwrite? [ yes / no ]: " input
    
    case $input in
        [yY][eE][sS])
            echo "Overwriting '$DB' database..."
            psql -U ${USER} -h ${HOST} -c "DROP DATABASE IF EXISTS $DB"
            psql -U ${USER} -h ${HOST} -c "CREATE DATABASE $DB WITH OWNER = $USER ENCODING = 'UTF8' TABLESPACE = pg_default CONNECTION LIMIT = -1"
            psql -U ${USER} -h ${HOST} -d ${DB} -c "CREATE SCHEMA ss AUTHORIZATION $USER"
            psql -U ${USER} -h ${HOST} -d ${DB} -c "CREATE SCHEMA ss_stg AUTHORIZATION $USER"
            psql -U ${USER} -h ${HOST} -d ${DB} -c "CREATE SCHEMA ss_ext AUTHORIZATION $USER"
            ;;
    
        [nN][oO]|[nN])
            echo "Kept existing '$DB' database"
            ;;
    
        *)
        echo "Invalid input..."
        exit 1
        ;;
    esac
else   
    echo "Making new database '$DB'"
    psql -U ${USER} -h ${HOST} -c "DROP DATABASE IF EXISTS $DB"
    psql -U ${USER} -h ${HOST} -c "CREATE DATABASE $DB WITH OWNER = $USER ENCODING = 'UTF8' TABLESPACE = pg_default CONNECTION LIMIT = -1"
    psql -U ${USER} -h ${HOST} -d ${DB} -c "CREATE SCHEMA ss AUTHORIZATION $USER"
    psql -U ${USER} -h ${HOST} -d ${DB} -c "CREATE SCHEMA ss_stg AUTHORIZATION $USER"
    psql -U ${USER} -h ${HOST} -d ${DB} -c "CREATE SCHEMA ss_ext AUTHORIZATION $USER"
fi


# psql -U ${USER} -h ${HOST} -c "DROP DATABASE IF EXISTS $DB"
# 
# psql -U ${USER} -h ${HOST} -c "CREATE DATABASE $DB WITH OWNER = postgres ENCODING = 'UTF8' TABLESPACE = pg_default CONNECTION LIMIT = -1"
# 
# psql -U ${USER} -h ${HOST} -d ${DB} -c "CREATE SCHEMA ss AUTHORIZATION $USER"
# psql -U ${USER} -h ${HOST} -d ${DB} -c "CREATE SCHEMA ss_stg AUTHORIZATION $USER"
# psql -U ${USER} -h ${HOST} -d ${DB} -c "CREATE SCHEMA ss_ext AUTHORIZATION $USER"