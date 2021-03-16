# ------------------
# -- Path Settings
# -----------------

# Add Linux specific paths
if [[ $(uname) == "Linux" ]] then
    export PATH="$HOME/.local/bin:$PATH" 
fi

# ------------------
# -- Editor Settings
# ------------------

export EDITOR=nano

# ------------------
# -- Custom Aliases
# ------------------

alias ll="ls -lah"

alias weather="curl wttr.in/vie"
alias wsearch="web_search duckduckgo"

# ------------------
# -- Julia
# ------------------

# -- Set number of threads to use for julia
export JULIA_NUM_THREADS=$(nproc)

# Slow Julia / Script julia
alias sjulia="julia -O0 --compile=min --startup=no"


# ------------------
# -- Go
# ------------------

# Add go/bin to path
test -d "$HOME/go/bin" && export PATH="$PATH:$HOME/go/bin"


# ------------------
# -- MATLAB
# ------------------


alias matlab="/Applications/MATLAB_R2019b.app/bin/matlab -nosplash -nodesktop"

# ------------------
# -- LANGUAGE
# ------------------

# This fixes wrong locale settings on macOS

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export MM_CHARSET=utf8
export LC_COLLATE="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"



#************************
# OS-X: ZSH Key Bindigns & Aliases
#************************

# Taken from: https://coderwall.com/p/a8uxma/zsh-iterm2-osx-shortcuts

if [[ $(uname) = "Darwin" ]] then

    # OS X Keybindings
    bindkey "[D" backward-word
    bindkey "[C" forward-word
    bindkey "^[a" beginning-of-line
    bindkey "^[e" end-of-line

    # OS X Aliases
    alias openInCode="open -b com.microsoft.VSCode"
fi
