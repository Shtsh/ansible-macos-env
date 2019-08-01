export GOPATH=${HOME}/go
export PATH=${PATH}:${GOPATH}/bin

# pyenv

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"

if which pyenv-virtualenv-init > /dev/null; then
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
fi

# homebrew need this
export PATH="/usr/local/sbin:/usr/local/bin:$PATH"
