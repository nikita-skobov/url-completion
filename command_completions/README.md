# command completions

url-completion works by modifying completion scripts for specific commands.

In this directory you will find specific installations scripts for each command.

In the future, if you wish to add a completion to use url completions for a command that doesn't exist here, you can add those here, with each going in its own folder.

** PLEASE NOTE: **

Some of these install scripts are simpler than others. For example, the curl install script takes advantage of the simplicity of the [curl completion function provided from bash-completions](https://github.com/scop/bash-completion/blob/master/completions/curl). Our curl install script only needs to do something like this:

```sh
# this is our function:
__url_curl ()
{
    # this is the real _curl command completion function:
    _curl "$@"

    # we add this to generate url completion:
    COMPREPLY=($compgen -W '$(__url_completion)' -- "$1")
}

# essentially, we hijack the command completion for _curl
# by forcing completion to go to our __url_curl
# function first, and our function calls the original _curl
# function
complete -F __url_curl curl
```

Other install scripts like the one for git, change the actual `__git_*` functions at source time, and add/replace lines dynamically.

The ones for ssh,scp,sftp, etc work by changing a function from bash-completions called `_known_hosts_real`, and this function is called by many completion functions for various network related commands. By modifying that single function, url completion works for ssh, scp, sftp, ping, etc...

# Available completions:

- [git](./git/)
- [ssh,scp,sftp, and other network related programs](./ssh/)
- [git-clone](./git-clone/)
- [curl](./curl/)
