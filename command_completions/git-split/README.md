This one is for my custom git command: [git split](https://github.com/nikita-skobov/git-monorepo-tools).

The completion for this one works pretty simply:

git completion for specific commands will try to use `_git_<name_of_command>`, so we just define a `_git_split` completion function.
