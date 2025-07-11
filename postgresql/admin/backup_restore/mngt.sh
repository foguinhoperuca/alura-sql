#!/bin/bash

export NOW=$(date "+%FT%H-%M-%S")
export SCRIPT_PATH=$(dirname $0)
export LOG_DIR="${SCRIPT_PATH}/logs"
export REPORT_FILE="${LOG_DIR}/report.dat"
export TMP_DIR="${SCRIPT_PATH}/tmp"
export LOG_COMBINED="${TMP_DIR}/log_combined.log"
export LOG_COMPRESSED="${SCRIPT_PATH}/log_combined.tar.gz"

export BACKUP_PATH="/var/backups/postgresql/${PGDATABASE}"

backup_full_db() {
    echo "Backup full postgres from database $1"
    pg_dump -U $PGUSER -d $1 -F c -f "${BACKUP_PATH}/full_${NOW}.bkp"
}

backup_partial() {
    echo "Do a partial backup from tables of database $1"
    pg_dump -U $PGUSER -d $1 -t clients -t salesmans -t products -F c -f "${BACKUP_PATH}/various_dimensions_${NOW}.bkp"
}

case $1 in
    "full")
        clear
        date
        backup_full_db $PGDATABASE
        echo "Show content of $SCRIPT_PATH"
        tree $SCRIPT_PATH
        ;;
    "partial")
        echo "Do a partial backup"
        backup_partial
        ;;
    *)
        # TODO better usage message
        echo "USAGE: [full | partial]. $1 *NOT* found!!"
        echo "full <DATABASE>"
        echo "partial <DATABASE>"
esac
