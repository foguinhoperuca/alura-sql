#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "--------------------------- forge.sh ==> $SCRIPT_DIR ---------------------------"
source $SCRIPT_DIR/forge/main.sh
echo "--------------------------- forge.sh ==> $SCRIPT_DIR ---------------------------"

# Put all customization bellow
# export RIVER_APP_PWD=$(cat $BOT_ENV_FILE | grep RIVER_APP_PWD | cut -d = -f2)


local_vars() {
    export PGPASSFILE=".pgpass"
    export PGHOST=""
    export PGPORT=""
    export PGDATABASE=""
    export PGUSER=""
    export PGPASSWORD=""

    export DB_HOST=$(cat $PGPASSFILE | cut -d : -f1 | sed -n '1,1p')
    export DB_PORT=$(cat $PGPASSFILE | cut -d : -f2 | sed -n '1,1p')
    export DB_DATABASE=$(cat $PGPASSFILE | cut -d : -f3 | sed -n '1,1p')
    export DB_USER=$(cat $PGPASSFILE | cut -d : -f4 | sed -n '1,1p')
    export DB_PASS=$(cat $PGPASSFILE | cut -d : -f5 | sed -n '1,1p')
    export DB_ADMIN_HOST=$(cat $PGPASSFILE | cut -d : -f1 | sed -n '2,2p')
    export DB_ADMIN_PORT=$(cat $PGPASSFILE | cut -d : -f2 | sed -n '2,2p')
    export DB_ADMIN_DATABASE=$(cat $PGPASSFILE | cut -d : -f3 | sed -n '2,2p')
    export DB_ADMIN_USER=$(cat $PGPASSFILE | cut -d : -f4 | sed -n '2,2p')
    export DB_ADMIN_PASS=$(cat $PGPASSFILE | cut -d : -f5 | sed -n '2,2p')
}

db_script() {
    DBHOST=$1
    DBPORT=$2
    DBDATABASE=$3
    DBUSER=$4
    DBSCRIPT=$5
    FORGESYSPATH=$(pwd)

    echo "forgesyspath=$FORGESYSPATH -h $DBHOST -p $DBPORT -d $DBDATABASE -U $DBUSER -f $DBSCRIPT" 

    psql -v forgesyspath=$FORGESYSPATH -h $DBHOST -p $DBPORT -d $DBDATABASE -U $DBUSER -f $DBSCRIPT
}

case $1 in
    "local_vars")
        local_vars $2
        ;;
    "db_script")
        db_script $DB_HOST $DB_PORT $DB_DATABASE $DB_USER $2
        ;;
    "db_script_admin")
        db_script $DB_ADMIN_HOST $DB_ADMIN_PORT $DB_ADMIN_DATABASE $DB_ADMIN_USER $2
        ;;
    *)
        echo "USAGE: [env]. $1 *NOT* found!!"
        echo "source ./forge.sh env <ENV:[local|dev|stage|prod]>"
esac
