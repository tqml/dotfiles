# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="agnoster"
#ZSH_THEME="robbyrussell"
#ZSH_THEME="passion"
#ZSH_THEME="powerlevel9k/powerlevel9k"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git 
	brew 
	pyenv 
	docker 
	docker-compose 
	web-search
	zsh-autosuggestions
	iterm2
)

# Add Brew Compleition
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

source $ZSH/oh-my-zsh.sh

# User configuration

# Declere GPG2 as GPG as they have almost the same CLI arguments
# Found here: https://unix.stackexchange.com/questions/188945/zsh-gpg2-autocompletion
compdef gpg2=gpg

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
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Add zsh Syntax Highlighting
test -e "/usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" && source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# See here to learn how to only show your username instead.
# prompt_context() {
  # prompt_segment $CURRENT_BG default  "λ "
# }

# To Optionally to hide the “user@hostname” info when you’re logged in as yourself on your local machine, add prompt_context(){} at the bottom of your ~/.zshrc. 
# prompt_context() {
#   if [[ -n "$SSH_CLIENT" ]]; then
#     # Additional condition would be "$USER" != "$DEFAULT_USER", but it doesnt work well, because default user is not set
#     prompt_segment black default "$USER@$HOST "
#   else
#     if [[ $(date +"%m%d") = "0501" ]]; then   # 1st May
#       prompt_segment $CURRENT_BG default "%(!.%{%F{yellow}%}.)🇦🇹 "
#     elif [[ $(date +"%m%d") = "1224" ]]; then # Christmas
#       prompt_segment $CURRENT_BG default "%(!.%{%F{yellow}%}.)🎄 "
#     else
#       # prompt_segment $CURRENT_BG default "%(!.%{%F{yellow}%}.)🤯 "
#       prompt_segment $CURRENT_BG default "🌱🌕👾 "
#     fi
#   fi
# }


# Taken from: https://github.com/agnoster/agnoster-zsh-theme/issues/19
# prompt_dir() {
#   # prompt_segment blue black '%~'
#   # Limits the viisble path dir levels to 3
#   prompt_segment blue black "%(5~|%-1~/…/%3~|%4~)"
# }


#source ~/.zprofile
source ~/dotfiles/zfunc
# source ~/.profile
export PATH="/usr/local/sbin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
