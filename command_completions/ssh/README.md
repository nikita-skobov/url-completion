This install script sets up url tab completion for ssh, scp, slogin, autossh, talk, ftp, rsh, rlogin, fping, etc, etc.

Basically, it works by modifying the `_known_hosts_real` function provided by [bash-completion](https://github.com/scop/bash-completion). This function returns known hosts from a variety of sources (including your ssh known hosts file), so when we modify it, we save the old version as `_known_hosts_real` as `__orig__known_hosts_real` and we make our `_known_hosts_real` simply call `__url_completion` and then it calls `__orig_known_hosts_real` with all of the other original arguments.


By modifying this single function, url tab completion will work for any other command that uses `_known_hosts_real` for its tab completion.


NOTE: make sure you have the `bash-completion` script sourced in your startup script prior to running this, as it depends on certain functions from that project being set.
