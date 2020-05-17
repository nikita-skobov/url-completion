git ships with a completion script that is typically sourced in a `.bashrc` or `.bash_profile` startup script.

Url completion in git commands works as follows:

1. modifying the global `COMP_WORDBREAKS` variable to remove the colon `:` from the wordbreak characters.
2. overwriting the `__git_remotes` function to return a list of urls from your `URL_HISTORY` file as well as the remotes that `__git_remotes` normally returns

To enable git completion, run the `install.sh` script in this directory which will do the following things:

1. appends the end of your `.bashrc` or `.bash_profile` script with a removal of the colon character `:` from `COMP_WORDBREAKS`
2. appends the end of your `.bashrc` or `.bash_profile` script with an overwriting of the `__git_remotes` function

Simply run `./install.sh` from this directory to install url completion for git. Pass in an optional parameter as the path of the startup script to modify (ie: run it as `./install.sh ~/.bash_profile` or any other startup script you wish to append). If you do not pass any argument, then by default it will modify ~/.bashrc


NOTE: make sure that the startup file you are modifying sources the git bash completion script before you run the install script. See the top of [the git completion script](https://github.com/git/git/blob/master/contrib/completion/git-completion.bash) for some install notes

