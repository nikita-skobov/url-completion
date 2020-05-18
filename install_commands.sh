#!/usr/bin/env bash

OUTTER_SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
SCRIPTPATH="$OUTTER_SCRIPTPATH/command_completions/git"
LIBPATH="$OUTTER_SCRIPTPATH/lib/lib.sh"
if [[ -z $__COMPLETION_LIB_LOADED ]]; then source "$LIBPATH" ; fi
default_startup_script="$HOME/.bashrc"
startup_script="${1:-$default_startup_script}"

log_step "LOADING STARTUP SCRIPT $startup_script"
STARTUP_SCRIPT_LOADED="$(<$startup_script)"

add_comment_guard_before "$startup_script"
unset __SHOULD_ADD_COMMENT_GUARDS

log_step "Installing everything from command_completions:"

log_step "======"
for install_file in $OUTTER_SCRIPTPATH/command_completions/*/install.sh; do
    PREFIX_SPACES="   "
    install_path="${install_file%/*.sh}"
    install_folder="${install_path##*/}"
    log_step "installing for $install_folder commands"
    source "$install_file"
    PREFIX_SPACES=" "
    log_step "======"
done

__SHOULD_ADD_COMMENT_GUARDS="true"
add_comment_guard_after "$startup_script"

log_step "Done installing everything :)"
