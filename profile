

# Define some useful aliases
alias ll="ls -lah"


# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
source "$HOME/.cargo/env"


# -- PYENV

# Add pyenv executable to PATH and
# enable shims by adding the following
# to ~/.profile and ~/.zprofile:

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Load pyenv into the shell by adding
# the following to ~/.zshrc:

eval "$(pyenv init -)"