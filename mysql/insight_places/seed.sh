#!/bin/bash

function populate_mysql() {
    sudo mysql < terraform.sql
    mysql --defaults-extra-file=../.my.cnf < ddl.sql

    echo "Addresses"
    mysql --defaults-extra-file=../.my.cnf < data/01.1-addresses.sql

    echo "Clients"
    mysql --defaults-extra-file=../.my.cnf < data/02.1-clients.sql

    echo "Owners"
    mysql --defaults-extra-file=../.my.cnf < data/03.1-owners.sql

    echo "Accommodations"
    mysql --defaults-extra-file=../.my.cnf < data/04.1-accommodations.sql

    echo "Rents"
    mysql --defaults-extra-file=../.my.cnf < data/05.1-rents.sql

    echo "Reviews"
    mysql --defaults-extra-file=../.my.cnf < data/06.1-reviews.sql
}

function convert_data_files() {
    rm data/*.1-*.sql
    # cp data/backup/*.sql data/

    echo "addresses"
    iconv --from-code=ISO-8859-1 --to-code=UTF-8 data/01-addresses.sql > data/01.1-addresses.sql
    file -bi data/01-addresses.sql
    uchardet data/01-addresses.sql
    file -bi data/01.1-addresses.sql
    uchardet data/01.1-addresses.sql

    echo ""
    echo "clients"
    iconv --from-code=ISO-8859-1 --to-code=UTF-8 data/02-clients.sql > data/02.1-clients.sql
    file -bi data/02-clients.sql
    uchardet data/02-clients.sql
    file -bi data/02.1-clients.sql
    uchardet data/02.1-clients.sql

    echo ""
    echo "owners"
    iconv --from-code=ISO-8859-1 --to-code=UTF-8 data/03-owners.sql > data/03.1-owners.sql
    file -bi data/03-owners.sql
    uchardet data/03-owners.sql
    file -bi data/03.1-owners.sql
    uchardet data/03.1-owners.sql

    echo ""
    echo "accommodations"
    iconv --from-code=ISO-8859-13 --to-code=UTF-8 data/04-accommodations.sql > data/04.1-accommodations.sql
    # iconv --from-code=ISO-8859-13 --to-code=UTF-16 data/04-accommodations.sql > data/04.2-accommodations.sql
    # iconv --from-code=UTF-16 --to-code=UTF-8 data/04.2-accommodations.sql > data/04.3-accommodations.sql
    file -bi data/04-accommodations.sql
    uchardet data/04-accommodations.sql
    file -bi data/04.1-accommodations.sql
    uchardet data/04.1-accommodations.sql
    # file -bi data/04.2-accommodations.sql
    # uchardet data/04.2-accommodations.sql
    # file -bi data/04.3-accommodations.sql
    # uchardet data/04.3-accommodations.sql

    echo ""
    echo "rents"
    iconv --from-code=TIS-620 --to-code=UTF-8 data/05-rents.sql > data/05.1-rents.sql
    # iconv --from-code=US-ASCII --to-code=UTF-8 data/05-rents.sql > data/05.2-rents.sql
    file -bi data/05-rents.sql
    uchardet data/05-rents.sql
    file -bi data/05.1-rents.sql
    uchardet data/05.1-rents.sql
    # file -bi data/05.2-rents.sql
    # uchardet data/05.2-rents.sql

    echo ""
    echo "reviews"
    iconv --from-code=ISO-8859-1 --to-code=UTF-8 data/06-reviews.sql > data/06.1-reviews.sql
    file -bi data/06-reviews.sql
    uchardet data/06-reviews.sql
    file -bi data/06.1-reviews.sql
    uchardet data/06.1-reviews.sql


}

clear
date

# convert_data_files
populate_mysql

date
