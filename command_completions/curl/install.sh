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

__url_curl () 
{
    local cur prev words cword
    _init_completion || return
    local compreply_before="${COMPREPLY[@]}"
    _curl "$@" > /dev/null 2>&1
    local compreply_after="${COMPREPLY[@]}"


    # ONLY offer url completion if
    # the curl completion did not add anything
    if [[ $compreply_before == $compreply_after ]]; then
        COMPREPLY=($(compgen -W '$(__url_completion)' -- "$cur"))
    fi
}


if ! startup_script_has "complete -F __url_curl curl" ; then
    log_step "HIJACKING COMPLETION COMMAND FOR _curl FUNCTION"
    # force the completion loader to load curl
    echo -e "_completion_loader curl" >> "$startup_script"
    # add in our function to the startup script
    echo -e "$(declare -f __url_curl)" >> "$startup_script"
    # overwrite the completion function to use __url_curl
    # instead of _curl
    echo -e "complete -F __url_curl curl" >> "$startup_script"
fi
add_comment_guard_after "$startup_script"

log_step "ALL DONE :)"
