# logs a step in "fancy"
# format. $1 is the logging text
# uses an environment variable
# PREFIX_SPACES to change the prefix before
# the "fancy" arrow. if PREFIX_SPACES
# is null or unset, it will use a single space
log_step() {
    local logging_text="$1"
    local arrow=" -> "
    local prefix="${PREFIX_SPACES:-" "}"
    echo "$prefix$arrow$logging_text"
}

# a helper function that checks if
# __url_completion is already sourced
# and if not, it sources it.
# If it fails to source, it exits with an error.
# It relies on an environment variable SCRIPTPATH being set
# to the path of the install script
source_url_completion_if_not_exist() {
    # does __url_completion exist?
    if [[ -z $(type -t "__url_completion") ]]; then
        # nope: try to source it
        log_step "SOURCING url_completion.sh"
        source "$SCRIPTPATH/../../url_completion.sh" > /dev/null 2>&1
        if [[ $? != "0" ]]; then
            # something is horribly wrong :(
            echo "Failed to source url_completion.sh file"
            echo "is it missing? is it corrupted?"
            echo "did you try to source this file instead of"
            echo "running it? Please report this"
            echo "error and the steps you took to reproduce it."
            exit 1
        fi
    fi
}

# takes $1 as the name of function
# returns true if it exists
# or false otherwise
function_exists() {
    if [[ -z $(type -t "$1") ]]; then
        # does not exist
        return 1
    fi
    # does exist
    return 0
}


# A helper function that checks if an environment
# variable: STARTUP_SCRIPT_LOADED has been set already.
# If not, it loads the startup script provided by
# the first argument: $1
load_startup_script_if_not_exist() {
    # only load the script if it has not
    # been loaded as an environment variable
    if [[ -z $STARTUP_SCRIPT_LOADED ]]; then
        log_step "LOADING STARTUP SCRIPT $1"
        STARTUP_SCRIPT_LOADED="$(<$1)"
    fi
}


# A helper function that checks if an environment variable:
# STARTUP_SCRIPT_CONTAINS_URL_COMPLETION has been set already.
# If not, it checks if the __url_completion function exists
# in the STARTUP_SCRIPT_LOADED. If it fails to find __url_completion
# in the STARTUP_SCRIPT, it writes it into the startup script
# provided by $1.
write_url_completion_to_file_if_not_exist() {
    # does it already contain the url completion function?
    if [[ -z $STARTUP_SCRIPT_CONTAINS_URL_COMPLETION ]]; then
        # nope, env var not set, check if the function exists:
        if ! startup_script_has "__url_completion" ; then
            log_step "ADDING __url_completion function"
            echo -e "$(declare -f __url_completion)" >> "$1"
        fi
        # set env var so future scripts
        # dont bother checking it
        STARTUP_SCRIPT_CONTAINS_URL_COMPLETION="true"
    fi
}

# A helper function that writes the COMP_WORDBREAKS
# colon removal line if it does not exist in the
# STARTUP_SCRIPT_LOADED variable. It will write
# to a file provided by $1
write_colon_removal_to_file_if_not_exist() {
    # does it already contain the wordbreaks colon removal?
    if [[ -z $STARTUP_SCRIPT_CONTAINS_WORDBREAKS_REMOVAL ]]; then
        # nope, env variable was not set, so lets check it now:
        if ! startup_script_has "COMP_WORDBREAKS=\${COMP_WORDBREAKS//:}"; then
            # no, it does not contain the wordbreaks line, so lets add it:
            log_step "REMOVING ':' from COMP_WORDBREAKS"
            echo -e "COMP_WORDBREAKS=\${COMP_WORDBREAKS//:}" >> "$1"
        fi
        # set env variable so that future scripts run in the same
        # subshell dont bother checking for it
        STARTUP_SCRIPT_CONTAINS_WORDBREAKS_REMOVAL="true"
    fi
}

# returns true
# If STARTUP_SCRIPT_LOADED contains
# the string given by $1, false otherwise.
startup_script_has() {
    if [[ $STARTUP_SCRIPT_LOADED == *"$1"* ]]; then
        return 0
    fi
    return 1
}

# call this after adding any lines to the $1 file
add_comment_guard_after() {
    if [[ ! -z $__SHOULD_ADD_COMMENT_GUARDS && -f $1 ]]; then
        echo "# THE ABOVE LINES ^^^^ WERE ADDED BY $__PROJECT_NAME" >> "$1"
    fi
}

# call this before adding any lines to the $1 file
add_comment_guard_before() {
    if [[ ! -z $__SHOULD_ADD_COMMENT_GUARDS && -f $1 ]]; then
        echo "# THE BELOW LINES vvvv WERE ADDED BY $__PROJECT_NAME" >> "$1"
    fi
}

__SHOULD_ADD_COMMENT_GUARDS="true"
__PROJECT_NAME="https://github.com/nikita-skobov/url-completion"
__COMPLETION_LIB_LOADED="true"
