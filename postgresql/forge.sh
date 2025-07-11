#!/bin/bash

vars() {
    export PGPASSFILE=""
    export PGHOST=""
    export PGPORT=""
    export PGDATABASE=""
    export PGUSER=""
    export PGPASSWORD=""
}

case $1 in
    "env")
        vars $2
        ;;
    *)
        echo "USAGE: [env]. $1 *NOT* found!!"
        echo "source ./forge.sh env <ENV:[local|dev|stage|prod]>"
esac
