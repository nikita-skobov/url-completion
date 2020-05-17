#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source "$SCRIPTPATH/url_completion.sh"
default_startup_script="$HOME/.bashrc"
startup_script="${1:-$default_startup_script}"

echo " -> LOADING STARTUP SCRIPT $startup_script"
STARTUP_SCRIPT_LOADED="$(<$startup_script)"
echo " -> Installing everything from command_completions:"

for install_file in $SCRIPTPATH/command_completions/*/install.sh; do
    echo " -> ====== "
    source "$install_file"
    echo " -> ====== "
done
