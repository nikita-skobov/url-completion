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

_git_split () 
{
    local cur prev words cword
    _init_completion || return

    COMPREPLY=($(compgen -W '$(__url_completion)' -- "$cur"))
}


if ! startup_script_has "_git_split" ; then
    log_step "ADDING CUSTOM _git_split COMPLETION FUNCTION"
    # add in our function to the startup script
    echo -e "$(declare -f _git_split)" >> "$startup_script"
fi
add_comment_guard_after "$startup_script"

log_step "ALL DONE :)"
