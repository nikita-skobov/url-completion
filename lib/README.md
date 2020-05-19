This is a library to help with writing install.sh files
for the commands you wish to add.

Simply source the `lib.sh` file in your `install.sh` scripts, and then you will have a series of helper functions to help you write install scripts easier. Take a look inside the `lib.sh` file to see what the functions are, they are fairly well documented.

If you are writing a install script, every single install script should start with these lines:

```sh
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
```

And at the end of your install script, you should add:

```sh
add_comment_guard_after "$startup_script"
```

Then, you can write your code thats specific to your command. For example, for one of the git commands, I did:

```sh
if ! startup_script_has "eval __orig_\"\$(declare -f __git_remotes)\"" ; then
    log_step "OVERWRITING __git_remotes function"
    echo -e "\neval __orig_\"\$(declare -f __git_remotes)\"" >> "$startup_script"
    echo -e "\n__git_remotes(){ __orig___git_remotes ; __url_completion ; }" >> "$startup_script"
fi
```

