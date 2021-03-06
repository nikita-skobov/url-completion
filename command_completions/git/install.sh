#!/usr/bin/env bash

if [[ -z $SCRIPTPATH ]]; then SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )" ; fi
LIBPATH="$SCRIPTPATH/../../lib/lib.sh"
if [[ -z $__COMPLETION_LIB_LOADED ]]; then source "$LIBPATH" ; fi
default_startup_script="$HOME/.bashrc"
startup_script="${1:-$default_startup_script}"

source_url_completion_if_not_exist
load_startup_script_if_not_exist "$startup_script"
add_comment_guard_before "$startup_script"
write_url_completion_to_file_if_not_exist "$startup_script"
write_colon_removal_to_file_if_not_exist "$startup_script"

if ! startup_script_has "eval __orig_\"\$(declare -f __git_remotes)\"" ; then
    log_step "OVERWRITING __git_remotes function"
    echo -e "eval __orig_\"\$(declare -f __git_remotes)\"" >> "$startup_script"
    echo -e "__git_remotes(){ __orig___git_remotes ; __url_completion ; }" >> "$startup_script"
fi
add_comment_guard_after "$startup_script"

log_step "ALL DONE :)"
