local ret_status="%(?:%{$fg_bold[green]%}o :%{$fg_bold[red]%}x )"
PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)%{$FG[136]%}$(tf_prompt_info)%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}x"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
