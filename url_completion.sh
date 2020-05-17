#!/usr/bin/env bash

# echo out a list of URLS
# located in $__url_completion_file
# which, if not defined, defaults to $HOME/.url_history
__url_completion() {
    local url_completion_file=${__url_completion_file:-"$HOME/.url_history"}
    if [[ -f $url_completion_file ]]; then
        echo "$(<$url_completion_file)"
    fi
}
