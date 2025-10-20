#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "--------------------------- forge.sh ==> $SCRIPT_DIR ---------------------------"
source $SCRIPT_DIR/forge/main.sh
echo "--------------------------- forge.sh ==> $SCRIPT_DIR ---------------------------"

# Put all customization bellow
# export RIVER_APP_PWD=$(cat $BOT_ENV_FILE | grep RIVER_APP_PWD | cut -d = -f2)
