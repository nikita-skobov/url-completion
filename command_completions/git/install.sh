#!/usr/bin/env bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# source the url completion script via path relative to this file
source "$SCRIPTPATH/../../url_completion.sh"
default_startup_script="$HOME/.bashrc"
startup_script="${1:-$default_startup_script}"


# does __url_completion exist?
if [[ -z $(type -t "__url_completion") ]]; then
    # nope: give a warning to user and exit
    echo "Missing __url_completion function,"
    echo "make sure you source the url_completion.sh"
    echo "file before you source this script"
    exit 1
fi


echo " -> USING STARTUP SCRIPT $startup_script"


# only load the script if it has not
# been loaded as an environment variable
if [[ -z $STARTUP_SCRIPT_LOADED ]]; then
    STARTUP_SCRIPT_LOADED="$(<$startup_script)"
fi

# does it already contain the url completion function?
if [[ -z $STARTUP_SCRIPT_CONTAINS_URL_COMPLETION ]]; then
    # nope, env var not set, check if the function exists:
    if [[ $STARTUP_SCRIPT_LOADED != *"__url_completion"* ]]; then
        echo " -> ADDING __url_completion function"
        echo -e "\n$(declare -f __url_completion)" >> "$startup_script"
    fi
    # set env var so future scripts
    # dont bother checking it
    STARTUP_SCRIPT_CONTAINS_URL_COMPLETION="true"
fi

# does it already contain the wordbreaks colon removal?
if [[ -z $STARTUP_SCRIPT_CONTAINS_WORDBREAKS_REMOVAL ]]; then
    # nope, env variable was not set, so lets check it now:
    if [[ $STARTUP_SCRIPT_LOADED != *"COMP_WORDBREAKS=\${COMP_WORDBREAKS//:}"* ]]; then
        # no, it does not contain the wordbreaks line, so lets add it:
        echo " -> REMOVING ':' from COMP_WORDBREAKS"
        echo -e "\n\nCOMP_WORDBREAKS=\${COMP_WORDBREAKS//:}" >> "$startup_script"
    fi
    # set env variable so that future scripts run in the same
    # subshell dont bother checking for it
    STARTUP_SCRIPT_CONTAINS_WORDBREAKS_REMOVAL="true"
fi

# does startup script already contain the __git_remotes overwrite?
if [[ $STARTUP_SCRIPT_LOADED != *"eval __orig_\"\$(declare -f __git_remotes)\""* ]]; then
    echo " -> OVERWRITING __git_remotes function"
    echo -e "\n"
    echo -e "\neval __orig_\"\$(declare -f __git_remotes)\"" >> "$startup_script"
    echo -e "\n__git_remotes(){ __orig___git_remotes ; __url_completion ; }" >> "$startup_script"
fi

echo " -> ALL DONE :)"
echo ""
