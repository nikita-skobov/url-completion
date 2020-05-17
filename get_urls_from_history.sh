#!/usr/bin/env bash

# this file is used by sourcing
# so prevent overwriting the item/word variable.
# if user already has one of those set, exit with a warning:
if [[ ! -z $__item ]]; then
    echo "You already have the variable named '__item' defined"
    echo "This script does not want to alter any of your variables"
    echo "So consider running this in a new shell that isnt using the variable '__item'"
    echo "or run:"
    echo "unset __item"
elif [[ ! -z $__word ]]; then
    echo "You already have the variable named '__word' defined"
    echo "This script does not want to alter any of your variables"
    echo "So consider running this in a new shell that isnt using the variable '__word'"
    echo "or run:"
    echo "unset __word"
elif [[ ! -z $__ipregx ]]; then
    echo "You already have the variable named '__ipregx' defined"
    echo "This script does not want to alter any of your variables"
    echo "So consider running this in a new shell that isnt using the variable '__ipregx'"
    echo "or run:"
    echo "unset __ipregx"
else
    # stolen from: https://unix.stackexchange.com/a/111855
    __ipregx='([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'

    # iterate through your history line by line
    # and add any items from the history that contain a url:

    # HISTTIMEFORMAT is added to remove line numbers
    # from the history command
    IFS=$'\n'
    for __item in $(HISTTIMEFORMAT=$'\r\e[K' history) ; do
        if [[ $__item == *"http"* || $__item == *"git"* || $__item == *"ftp"* || $__item == *"ssh"* || $__item =~ ^$__ipregx\.$__ipregx\.$__ipregx\.$__ipregx$ || $__item =~ (.*)@(.*)\.(.*) ]]; then
            IFS=" "
            for __word in $__item; do
                if [[ $__word == *"http"* || $__word == *"git"* || $__word == *"ftp"* || $__word == *"ssh"* || $__word =~ $__ipregx\.$__ipregx\.$__ipregx\.$__ipregx || $__word =~ (.*)@(.*)\.(.*) ]]; then
                    # remove quotes if it has any at beginning or end
                    if [[ $__word == "\""* ]]; then
                        __word="${__word:1}"
                    fi
                    if [[ $__word == *"\"" ]]; then
                        __word="${__word::-1}"
                    fi

                    # make sure the word has the http(s):// colon
                    # otherwise it might be from lines like above
                    # that simply check if it has http in it
                    # or if its a url for an ssh user like:
                    # ssh pi@192.168.1.100 or something
                    if [[ $__word == *":"* || $__word == *"@"* ]]; then
                        echo "$__word"
                    fi
                fi
            done
            IFS=$'\n'
        fi
    done
    IFS=" "

    # we defined these variables:
    # unset them so they dont pollute users environment
    unset __word
    unset __item
    unset __ipregx
fi
