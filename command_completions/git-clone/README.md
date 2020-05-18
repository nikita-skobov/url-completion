the other git completion script relies on using git's completion function: `__git_remotes`, which allows for url tab completion for many git commands that involve remote repositories such as (but not limited to):

- pull
- push
- fetch

Unfortunately, that function is not called for `git clone`, so the modifications needed to add url tab completion for git clone involve modifying the `_git_clone` function.

The modification this install script does is search for the final `esac` keyword in the `__git_clone` function, and replaces it with another case:

```sh
	*)
		__gitcomp "$(__url_completion)"
		return
		;;
    esac
```

This case gets matched for any keyword that doesnt start with a dash [see the original git-completion.bash file](https://github.com/git/git/blob/efcab5b7a3d2ce2ae4bf808b335938098b18d960/contrib/completion/git-completion.bash#L1421) for what the `_git_clone` function looks like.

NOTE: make sure that the `git-completion.bash` script is sourced in your provided startup file prior to running this install script.

