# url-completion

![tab completion example](./example.gif)

## What is it?

`url-completion` is a collection of scripts that modify common command completion functions to allow for URL tab completion in bash.

**WARNING: The installation scripts will modify `$HOME/.bashrc` by default. It is strongly recommended to run the installation script on a temporary file, and source that file to test the completions before you apply it to your actual startup script.**


## How does it work?

The core functionality comes from a `__url_completion` function defined in [./url_completion.sh](./url_completion.sh). The function simply echoes out everything defined in a file thats referenced by `$__url_completion_file`. If this variable is not set, the `__url_completion` function will use `$HOME/.url_history` by default.

Next, it contains install scripts that **overwrite existing completion functions to use `__url_completion`.**

The install scripts append startup scripts such as `.bashrc` or `.bash_profile` to overwrite common command completion scripts to use the `__url_completion` function in certain cases. For example, the git pull command completion allows you to do:

```sh
git pull https://github<TAB><TAB>
```

because the git command completion install script modifies the `__git_remotes` function to show urls in addition to git remotes.

## Prerequisites

Before you run these install scripts, make sure you have installed, and sourced the [bash-completion](https://github.com/scop/bash-completion) script, and the [git-completion](https://github.com/git/git/blob/master/contrib/completion/git-completion.bash).

These scripts should be sourced somewhere in your startup scripts prior to running any of the install scripts below.

## Installation

Clone the repo and cd into it:

```sh
git clone https://github.com/nikita-skobov/url-completion
cd url-completion
```

You will need to create a url history file somewhere. For your convenience, a `.url_history` file is provided in this repo, so you can use that by copying it to the default url history location:

```sh
cp ./.url_history $HOME
```

Otherwise, you can create on yourself. For simplest use, you can do:

```sh
# replace the below url with whatever you want
echo "https://github.com" > $HOME/.url_history
```

Alternatively, create this file somewhere else, and then make sure to edit your startup script and add this line:

```sh
# put this inside $HOME/.bashrc or $HOME/.bash_profile
__url_completion_file="/absolute/path/to/your/file"
```

Next, you can install the `command_completion/` scripts in two ways:

1. Install everything within `command_completions/`:
    ```sh
    # make a temporary empty file:
    echo "" > tempfile.sh
    # run the install script on the tempfile:
    ./install_commands.sh tempfile.sh
    # source the tempfile, and try out the completions
    source tempfile.sh
    # if you are satisfied with the completions, you can
    # run the install_commands script on your actual startup script:
    # this will modify $HOME/.bashrc by default:
    ./install_commands.sh
    ```
2. Install individual command completion scripts
    ```sh
    # make a temporary empty file:
    echo "" > tempfile.sh
    # run the individual install scripts that you want
    # for example:
    ./command_completions/git/install.sh tempfile.sh
    ./command_completions/git-clone/install.sh tempfile.sh
    # source the tempfile and try out the completions:
    source tempfile.sh
    # if satisfied, run the above install scripts again
    # on your actual bash startup script:
    # these will use $HOME/.bashrc by default
    ./command_completions/git/install.sh
    ./command_completions/git-clone/install.sh
    ```
    - If you do not see one that you want to use, feel free to make one and send a pull request :)

For a full list of command completion scripts, see the [./command_completions](./command_completions/README.md) directory

## The url history file

The url history file should contain a single url per line. it doesn't even have to contain urls, any line that is included in this file will be used for tab completion for the commands that `url_completion` was installed for.

Most users type urls in the command line all the time. If you want to easily output a list of urls from your history, there is a script provided called `get_urls_from_history.sh`.

This script is meant to be sourced because it uses the history command, which requires it to be ran in an interactive shell (ie: not as a script). So if you do:

```sh
source ./get_urls_from_history.sh
```

it will echo out any url that it finds from your history. Then, if you want to simply append your url history with the entire output, you can do:

```sh
source ./get_urls_from_history.sh >> $HOME/.url_history

# or if your __url_completion_file variable is defined:
source ./get_urls_from_history.sh >> $__url_completion_file
```

Alternatively, you can just manually pick the urls you wish to save from the output of `get_urls_from_history.sh`

