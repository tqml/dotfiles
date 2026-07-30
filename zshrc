setopt prompt_subst
#autoload bashcompinit && bashcompinit

HISTFILE="$HOME/.zsh_history"
[ -f "$HISTFILE" ] || touch "$HISTFILE"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt EXTENDED_HISTORY  # record command start time
setopt appendhistory
export HISTORY_IGNORE="(l|l *|ls|ls *|cd|cd ..*|cd -|z *|pwd|exit)"


# %%---------------------------------------------- 
# GITHUB
# -------------------------------------------------- 
export GITHUB_USER="tqml"


# --------------------------------------------------------
# -- HOMEBREW
# --------------------------------------------------------
# Find brew wherever this platform installed it (macOS Apple Silicon, macOS
# Intel, or Linuxbrew) and let it set up PATH/MANPATH/HOMEBREW_PREFIX etc.
for _brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [ -x "$_brew_bin" ]; then
        eval "$("$_brew_bin" shellenv)"
        break
    fi
done
unset _brew_bin


ZSH_DOTENV_PROMPT=false
command -v starship &> /dev/null && eval "$(starship init zsh)"
command -v direnv &> /dev/null && eval "$(direnv hook zsh)"
command -v zoxide &> /dev/null && eval "$(zoxide init zsh)"
command -v mcfly &> /dev/null && eval "$(mcfly init zsh)"

# --------------------------------------------------------
# -- zsh Syntax Highlighting
# --------------------------------------------------------
ZSH_SYNTAX_HIGHLIGHTING_PLUGIN_PATH="${HOMEBREW_PREFIX:-/opt/homebrew}/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
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

# Check if BAT is installed
if ! command -v bat &> /dev/null; then
    echo "BAT is not installed. Please install it using 'brew install bat'"
else
    alias cat="bat"
    alias less="bat"
    alias more="bat"
fi

alias weather="curl wttr.in/vie"
alias wsearch="web_search duckduckgo"



# ------------------
# -- Homebrew
# ------------------

export HOMEBREW_CLEANUP_MAX_AGE_DAYS=7

# ------------------
# -- GPG
# ------------------

# https://cloudlumberjack.com/posts/github-signed-commits-macos/
# brew install gnupg pinentry-mac
export GPG_TTY=$(tty)
gpgconf --launch gpg-agent


# ------------------
# -- Copilot
# ------------------


function ask() {
    # ask copilot to suggest a shell command
    # usage. ask "your question here"
    # or (without quotes) ask your question here
    # ask your question here 
    gh copilot suggest -t shell "$@" 
}


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
# -- OpenTofu
# ------------------

alias tf=tofu
alias tg=terragrunt
alias tgps=tg plan -no-color | grep -E '^[[:punct:]]|Plan'

# Point terragrunt at opentofu instead of a (possibly absent) terraform binary
command -v tofu &> /dev/null && export TERRAGRUNT_TFPATH="$(command -v tofu)"

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

if [[ $(uname) == 'Darwin' ]]; then
    export PNPM_HOME="$HOME/Library/pnpm"
else
    export PNPM_HOME="$HOME/.local/share/pnpm"
fi
if [ -d "$PNPM_HOME" ]; then
    case ":$PATH:" in
      *":$PNPM_HOME:"*) ;;
      *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
fi

# >>> juliaup initialize >>>
# !! Managed by juliaup; path generalized to $HOME so it works on any account !!
test -d "$HOME/.juliaup/bin" && path=("$HOME/.juliaup/bin" $path) && export PATH
# <<< juliaup initialize <<<

test -d "$HOME/.console-ninja/.bin" && export PATH="$HOME/.console-ninja/.bin:$PATH"

# >>> conda initialize >>>
# !! Managed by 'conda init'; only runs when miniforge is actually installed !!
_conda_bin="${HOMEBREW_PREFIX:-/opt/homebrew}/Caskroom/miniforge/base/bin/conda"
if [ -x "$_conda_bin" ]; then
    __conda_setup="$("$_conda_bin" 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        . "${_conda_bin%/bin/conda}/etc/profile.d/conda.sh" 2> /dev/null
    fi
    unset __conda_setup
fi
unset _conda_bin
# <<< conda initialize <<<

export PATH="$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# --------------------------------------------------------
# -- Host-specific overrides
# --------------------------------------------------------
# Anything that's true for this machine only (one-off app paths, local
# secrets, per-host aliases) belongs in .zshrc.local, not here. See
# zshrc.local.example for the pattern. Loaded last so it can override
# anything set above.
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
