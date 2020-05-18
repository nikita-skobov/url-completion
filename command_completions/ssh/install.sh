#!/usr/bin/env bash

if [[ -z $SCRIPTPATH ]]; then SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )" ; fi
LIBPATH="$SCRIPTPATH/../../lib/lib.sh"
if [[ -z $__COMPLETION_LIB_LOADED ]]; then source "$LIBPATH" ; fi
default_startup_script="$HOME/.bashrc"
startup_script="${1:-$default_startup_script}"

source_url_completion_if_not_exist
load_startup_script_if_not_exist "$startup_script"
write_url_completion_to_file_if_not_exist "$startup_script"
write_colon_removal_to_file_if_not_exist "$startup_script"

if ! startup_script_has "eval __orig_\"\$(declare -f _known_hosts_real)\"" ; then
    log_step "OVERWRITING _known_hosts_real function"
    echo -e "eval __orig_\"\$(declare -f _known_hosts_real)\"" >> "$startup_script"
    echo -e "_known_hosts_real(){ for i in \$(__url_completion); do COMPREPLY+=( \$i ) ; done ; __orig__known_hosts_real \"\$@\" ; }" >> "$startup_script"
fi

log_step "ALL DONE :)"
