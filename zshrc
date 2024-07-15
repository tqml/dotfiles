# Fig pre block. Keep at the top of this file.
#[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
#zmodload zsh/zprof

#zstyle ':completion:*' accept-exact '*(N)'
#zstyle ':completion:*' use-cache on
#zstyle ':completion:*' cache-path ~/.zsh/cache

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
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
eval "$(mcfly init zsh)"

# User configuration

# Declere GPG2 as GPG as they have almost the same CLI arguments
# Found here: https://unix.stackexchange.com/questions/188945/zsh-gpg2-autocompletion
# compdef gpg2=gpg
export GPG_TTY=$(tty)
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Check if iTerm is installed and run the integration
# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# --------------------------------------------------------
# -- zsh Syntax Highlighting
# --------------------------------------------------------
ZSH_SYNTAX_HIGHLIGHTING_PLUGIN_PATH="/opt/homebrew/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
test -e $ZSH_SYNTAX_HIGHLIGHTING_PLUGIN_PATH && source $ZSH_SYNTAX_HIGHLIGHTING_PLUGIN_PATH

# source ~/.zprofile
# source ~/dotfiles/zfunc

# --------------------------------------------------------
# -- PYENV
# --------------------------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"



# conda init "$(basename "${SHELL}")"

# set an easier to get alias for zoxide on german keyboards
alias c=z
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

# Slow Julia / Script julia
alias sjulia="julia -O0 --compile=min --startup=no"
alias sysjulia="julia -O0 --compile=min --startup=no --project=@. --sysimage=JuliaSysimage.dylib --sysimage-native-code=yes"

# ------------------
# -- Go
# ------------------

# Add go/bin to path
test -d "$HOME/go/bin" && export PATH="$PATH:$HOME/go/bin"

# ------------------
# -- MATLAB
# ------------------

# Make an alias for MATLAB
if [[ $(uname) == 'Darwin' ]]; then
    alias matlab="/Applications/MATLAB_R2021b.app/bin/matlab -nosplash -nodesktop"
fi


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


#fpath+=~/dotfiles/zfunc

# function mywatch() {
#     while :; do 
#         a=$($@); 
#         clear; 
#         echo "$(date)\n\n$a"; 
#         sleep 5;  
#     done
# }

ZSH_DOTENV_PROMPT=false


eval "$(direnv hook zsh)"



alias tgps=tg plan -no-color | grep -E '^[[:punct:]]|Plan'



tgs() {
  # get all command args
  #command="@"
  command=${@}
  echo "$command"
  if [ -z "$command" ]; then
      tg
      return 1
  fi

  
  tg $command -no-color | grep -E '^[[:punct:]]|Plan'
}

tf-new-module() {
    module_name="$1"

    if [ -z "$module_name" ]; then
        echo "Please provide a module name."
        return 1
    fi

    mkdir -p "$module_name"
    cd "$module_name" || return
    
    touch main.tf versions.tf vars.tf outputs.tf

    cat << EOF > main.tf
# main.tf - Your main Terraform configuration file

# Define your resources here

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

EOF

    cat << EOF > versions.tf
# versions.tf - Specify the required Terraform version

terraform {
  required_version = "~> 1.3"
  required_providers {
    aws = "~> 5.0"
  }
}
EOF

    cat << EOF > vars.tf
# vars.tf - Define input variables for the module

variable "example_variable" {
  type        = string
  description = "Example variable"
}
EOF

    cat << EOF > outputs.tf
# outputs.tf - Define outputs for the module

output "example_output" {
  value       = "Example output"
  description = "Example output"
}
EOF

    echo "Terraform module files created successfully."
}

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
#zprof

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

