
# add a function path
fpath=($ZSH/functions $ZSH/completions $ZSH/themes /usr/usr/local/share/zsh-completions $fpath)

# Load all stock functions (from $fpath files) called below.
# confifure dumpfile
DUMPFILE=~/.zsh/zcompdump
autoload -Uz compaudit compinit

if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' $DUMPFILE) ]; then
    compinit -d ${DUMPFILE}
else
    compinit -C -d $DUMPFILE
    {
	# Compile zcompdump, if modified, to increase startup speed.
	if [[ -s "$DUMPFILE" && (! -s "${DUMPFILE}.zwc" || "$DUMPFILE" -nt "${DUMPFILE}.zwc") ]]; then
	    zcompile "$DUMPFILE"
	fi
    } &!
fi


: ${ZSH_DISABLE_COMPFIX:=true}

export HISTFILE=${HISTFILE:-"${ZSH}/histfile"}
export HISTSIZE=${HISTSIZE:-5000}
export SAVEHIST=${SAVEHIST:-20000}
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt CORRECT_ALL


# Set ZSH_CACHE_DIR to the path where cache files should be created
# or else we will use the default cache/
if [[ -z "$ZSH_CACHE_DIR" ]]; then
  ZSH_CACHE_DIR="$ZSH/cache"
fi




# pyenv integration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$HOME/.pyenv/shims:$PATH"

if which pyenv-virtualenv-init > /dev/null; then
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
fi

# iterm integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# homebrew need this
export PATH="/usr/local/sbin:/usr/local/bin:$PATH"

