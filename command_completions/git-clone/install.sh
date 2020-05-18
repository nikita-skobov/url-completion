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


if ! startup_script_has "eval \"\$__git_clone_temp\"" ; then
    log_step "OVERWRITING _git_clone function"

    # the following code is ran when the startup_script is sourced
    # so there can potentially be errors here?
    # i tested it, and it seems if _git_clone is undefined, nothing happens
    # because you essentially try to modify and evaluate an empty string
    # if this goes horribly wrong, may I remind you that this license
    # states that there is no warranty for this program
    echo '__git_clone_temp=$(declare -f _git_clone)' >> "$startup_script"
    # replace the first esac with a temporary string
    echo '__git_clone_temp="${__git_clone_temp/esac/"BRINGBACKHERE"}"' >> "$startup_script"
    # replace the next (and last esac) with our code:
    echo '__git_clone_temp="${__git_clone_temp/esac/"\t*)\n\t\t__gitcomp \"\$(__url_completion)\"\n\t\treturn\n\t\t;;\n\tesac"}"' >> "$startup_script"
    # replace our temporary "BRINGBACKHERE" string with esac as it was originally:
    echo '__git_clone_temp="${__git_clone_temp/BRINGBACKHERE/"esac"}"' >> "$startup_script"
    # convert tabs and newline codes to the actual characters
    echo '__git_clone_temp="$(echo -e $__git_clone_temp)"' >> "$startup_script"
    echo 'eval "$__git_clone_temp"' >> "$startup_script"
fi
log_step "ALL DONE :)"

