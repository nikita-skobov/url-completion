#!/usr/bin/env bash

# TODO:
# make it ignore comments from the url_completion_file
# make it ignore newlines

# echo out a list of URLS
# located in $__url_completion_file
# which, if not defined, defaults to $HOME/.url_history
__url_completion() {
    local url_completion_file=${__url_completion_file:-"$HOME/.url_history"}
    if [[ -f $url_completion_file ]]; then
        echo "$(<$url_completion_file)"
    fi
}
