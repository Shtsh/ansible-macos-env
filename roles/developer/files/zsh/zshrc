# Load additional logic
ZSH='/Users/shtsh/.zsh'
source ${ZSH}/init.zsh

# history configuration
export HISTFILE=${HISTFILE:-"${ZSH}/histfile"}
export HISTSIZE=50000
export SAVEHIST=20000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt CORRECT_ALL


# theme
export GEOMETRY_PROMPT_PLUGINS=(pyenv git)
export PROMPT_GEOMETRY_COLORIZE_ROOT=true
export GEOMETRY_SYMBOL_ROOT="#"
export GEOMETRY_SYMBOL_PROMPT=">"
export GEOMETRY_SYMBOL_EXIT_VALUE="\u2601"
export GEOMETRY_PROMPT_PREFIX=""
export GEOMETRY_COLOR_EXIT_VALUE=red

source ${ZSH}/themes/geometry/geometry.zsh-theme
# end of theme configuration

# plugins configuraion
export ZSH_AUTOSUGGEST_USE_ASYNC=true

# plugins installation
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug zsh-users/zsh-autosuggestions
zplug zsh-users/zsh-history-substring-search
zplug load
# end of plugins installation


#plugins=(autoenv git osx colored-man-pages colorize)
#autoload -U colors && colors

# colors
eval $(gdircolors ${ZSH}/colors)
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
CLICOLOR=1
alias ls="gls --color=auto"
alias help=tldr
export BAT_THEME="Monokai Extended Origin"


# emacs
export EDITOR="emacsclient -c"
alias e="emacsclient -c"
#ps aux | grep '[e]macs --daemon' > /dev/null || emacs --daemon

alias v=nvim


# Keys settings
# more inteligent Ctrl-W
my-backward-delete-word() {
    local WORDCHARS='*?_-[]~&;!#$%^(){}<>'
    zle backward-delete-word
}
zle -N my-backward-delete-word
bindkey '^W' my-backward-delete-word
bindkey '^[^?' my-backward-delete-word
# Search history pressing Up and Down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# Alt + left/right move by words
bindkey '^[f' backward-word
bindkey '^[b' forward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line


# misc
export PYTHON_CONFIGURE_OPTS="--enable-framework"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1


