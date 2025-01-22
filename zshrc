setopt prompt_subst
#autoload bashcompinit && bashcompinit

HISTSIZE=50000
SAVEHIST=50000
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt EXTENDED_HISTORY  # record command start time
setopt appendhistory
export HISTORY_IGNORE="(l|l *|ls|ls *|cd|cd ..*|cd -|z *|pwd|exit)"

# --------------------------------------------------------
# -- HOMEBREW
# --------------------------------------------------------
# rearange path to so that homebrew nano wins over builtin nano -> sideeffects?
export PATH="/usr/local/sbin:/opt/homebrew/bin:$PATH"


# ------------------
# -- Oh-My-Zsh
# ------------------
export ZSH="$HOME/.oh-my-zsh" # Path to your oh-my-zsh installation.
plugins=(git brew docker)
# ZSH_THEME=""
source "$ZSH/oh-my-zsh.sh"

# Others
#source "$HOME/.cargo/env"

ZSH_DOTENV_PROMPT=false
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
eval "$(mcfly init zsh)"
eval "$(direnv hook zsh)"

# --------------------------------------------------------
# -- zsh Syntax Highlighting
# --------------------------------------------------------
ZSH_SYNTAX_HIGHLIGHTING_PLUGIN_PATH="/opt/homebrew/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
test -e $ZSH_SYNTAX_HIGHLIGHTING_PLUGIN_PATH && source $ZSH_SYNTAX_HIGHLIGHTING_PLUGIN_PATH



# set an easier to get alias for zoxide on german keyboards
alias c=z
alias c="z"


# Check if EZA is installed
if command -v eza &> /dev/null; then
    alias ls="eza --icons --git"
    alias l="eza -l --icons --git -a"
    alias ll="eza -l --icons --git -a"
    alias lt="eza --tree --level=2 --long --icons --git"
    alias ltree="eza --tree --level=2  --icons --git"
else
    echo "EZA is not installed. Please install it using 'cargo install eza'"
fi
alias la="tree -L 2"


alias cat="bat"
alias less="bat"
alias more="bat"


alias tg=terragrunt
alias tf=terraform
alias weather="curl wttr.in/vie"
alias wsearch="web_search duckduckgo"



# ------------------
# -- Homebrew
# ------------------

export HOMEBREW_CLEANUP_MAX_AGE_DAYS=7

# ------------------
# -- Julia
# ------------------

# -- Set number of threads to use for julia
#export JULIA_NUM_THREADS=$(nproc)

# Slow Julia / Script julia
alias sjulia="julia -O0 --compile=min --startup=no"
alias sysjulia="julia -O0 --compile=min --startup=no --project=@. --sysimage=JuliaSysimage.dylib --sysimage-native-code=yes"
export JULIA_EDITOR="code"

# ------------------
# -- Go
# ------------------
# Add go/bin to path
test -d "$HOME/go/bin" && export PATH="$PATH:$HOME/go/bin"

# ------------------
# -- RUST
# ------------------
# Add cargo/bin to path
test -d "$HOME/.cargo/bin" && export PATH="$PATH:$HOME/.cargo/bin"


# ------------------
# -- MATLAB
# ------------------


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

alias tf=tofu
alias tg=terragrunt
alias tgps=tg plan -no-color | grep -E '^[[:punct:]]|Plan'

# ------------------
# -- Nix
# ------------------

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix


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


# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


#------------------------------------------------------------
# %%    PNPM
#------------------------------------------------------------


# pnpm
export PNPM_HOME="/Users/benjaminkulnik/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end



# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/Users/benjaminkulnik/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<

PATH=~/.console-ninja/.bin:$PATH


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

