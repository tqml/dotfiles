#zmodload zsh/zprof

export PATH="/usr/local/sbin:$PATH"

# ------------------
# -- Oh-My-Zsh
# ------------------
export ZSH="$HOME/.oh-my-zsh" # Path to your oh-my-zsh installation.
plugins=(git brew docker)
ZSH_THEME=""
source $ZSH/oh-my-zsh.sh

# Others
#source "$HOME/.cargo/env"
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
eval "$(mcfly init zsh)"


alias c="z"


# ------------------
# -- Homebrew
# ------------------

export HOMEBREW_CLEANUP_MAX_AGE_DAYS=7

# ------------------
# -- Julia
# ------------------

# -- Set number of threads to use for julia
#export JULIA_NUM_THREADS=$(nproc)
export JULIA_NUM_THREADS=6

# Slow Julia / Script julia
alias sjulia="julia -O0 --compile=min --startup=no"
alias sysjulia="julia -O0 --compile=min --startup=no --project=@. --sysimage=JuliaSysimage.dylib --sysimage-native-code=yes"

# ------------------
# -- Go
# ------------------

# Add go/bin to path
test -d "$HOME/go/bin" && export PATH="$PATH:$HOME/go/bin"

# ------------------
# -- Custom Aliases
# ------------------

alias ll="ls -lh"
alias lsd="ls -d */"

#alias tmux="TERM=screen-256color-bce tmux"
alias weather="curl wttr.in/vienna"
alias wsearch="web_search duckduckgo"

function wetta() {
    echo "-- Fetching: wttr.in/$1"

    # Get the weather for the current location
    curl "wttr.in/$1"
}

function cheat() {
    curl "https://cheat.sh/$1"
}

# ------------------
# -- Docker
# ------------------

#alias docker=podman
alias docktop="docker attach ctop > /dev/null || docker run --rm -ti --name=ctop --volume /var/run/docker.sock:/var/run/docker.sock:ro quay.io/vektorlab/ctop:latest"

# ------------------
# -- MATLAB
# ------------------

# Make an alias for MATLAB
if [[ $(uname) == 'Darwin' ]]; then
    alias matlab="/Applications/MATLAB_R2021b.app/bin/matlab -nosplash -nodesktop"
fi

# ------------------
# -- Terraform
# ------------------

alias tf=terraform
alias tg=terragrunt

# ------------------
# -- LANGUAGE
# ------------------

# This fixes wrong locale settings on macOS
# export LANG=en_US.UTF-8
# export LC_ALL=en_US.UTF-8
# export LC_CTYPE=en_US.UTF-8
# export MM_CHARSET=utf8
# export LC_COLLATE="en_US.UTF-8"
# export LC_TIME="en_US.UTF-8"
# export LC_NUMERIC="en_US.UTF-8"
# export LC_MONETARY="en_US.UTF-8"
# export LC_MESSAGES="en_US.UTF-8"

#************************
# OS-X: ZSH Key Bindigns & Aliases
#************************

# Taken from: https://coderwall.com/p/a8uxma/zsh-iterm2-osx-shortcuts

if [[ $(uname) = "Darwin" ]]; then

    # OS X Keybindings
    bindkey "[D" backward-word
    bindkey "[C" forward-word
    bindkey "^[a" beginning-of-line
    bindkey "^[e" end-of-line

    # OS X Aliases
    alias openInCode="open -b com.microsoft.VSCode"
fi

#zprof

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/Users/benjaminkulnik/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<
