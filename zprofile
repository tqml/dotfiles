# ------------------
# -- PYENV
# ------------------

# Add pyenv executable to PATH and
# enable shims by adding the following
# to ~/.profile and ~/.zprofile:

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if [[ -d "$PYENV_ROOT" ]]; then
    eval "$(pyenv init --path)"
fi


# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
