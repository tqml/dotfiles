#!/bin/bash

############################
# makesymlinks.sh
#
# Symlinks dotfiles from this repo into $HOME (and ~/.config), makes sure
# zsh + oh-my-zsh are installed, and installs the CLI tools the dotfiles
# depend on via Homebrew (assumes Homebrew/Linuxbrew is already set up).
#
# Safe to re-run: existing correct symlinks are left untouched, and already
# installed packages/shells are skipped.
############################

set -euo pipefail # Exit on error, undefined variable, or failed pipe

########## Variables

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # dotfiles directory (absolute, stable across cwd)
olddir="$HOME/dotfiles_old"                          # old dotfiles backup directory

#----------------------
#!!!!! IMPORTANT !!!!!
#----------------------
# Specify your files here
# "source relative to $dir : destination relative to $HOME"
dotfiles=(
    "bash_profile:.bash_profile"
    "bashrc:.bashrc"
    "gitconfig:.gitconfig"
    "gitignore:.gitignore"
    "profile:.profile"
    "tmux.conf:.tmux.conf"
    "terraformrc:.terraformrc"
    "zprofile:.zprofile"
    "zshrc:.zshrc"
    "iterm-config:.iterm-config"
    "config/ghostty/config:.config/ghostty/config"
    "config/starship.toml:.config/starship.toml"
    "config/herdr/config.toml:.config/herdr/config.toml"
)

# Homebrew formula -> binary it provides (differs for a couple, e.g. ripgrep -> rg)
brew_deps=(
    "starship:starship"
    "direnv:direnv"
    "zoxide:zoxide"
    "mcfly:mcfly"
    "eza:eza"
    "bat:bat"
    "bun:bun"
    "ripgrep:rg"
    "gh:gh"
    "herdr:herdr"
)

##########

# Symlink one dotfile, backing up whatever was there before.
# Idempotent: a no-op if $dst is already the correct symlink.
link_file() {
    local src="$1" dst="$2"

    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        return
    fi

    mkdir -p "$(dirname "$dst")"

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mkdir -p "$olddir"
        echo "Backing up existing $dst to $olddir"
        mv "$dst" "$olddir/"
    fi

    ln -s "$src" "$dst"
    echo "Linked $dst -> $src"
}

echo "Linking dotfiles into $HOME ..."
for entry in "${dotfiles[@]}"; do
    src="${entry%%:*}"
    rel_dst="${entry##*:}"
    link_file "$dir/$src" "$HOME/$rel_dst"
done

# Print the shell configured for the current user in the system's user database,
# rather than trusting the (possibly stale) $SHELL env var, so chsh only runs once.
current_login_shell() {
    if command -v getent &> /dev/null; then
        getent passwd "$(id -un)" | cut -d: -f7
    elif command -v dscl &> /dev/null; then
        dscl . -read "/Users/$(id -un)" UserShell 2>/dev/null | awk '{print $2}'
    else
        echo "$SHELL"
    fi
}

install_zsh() {
    if ! command -v zsh &> /dev/null; then
        platform=$(uname)
        if [[ $platform == 'Linux' ]]; then
            if [ -f /etc/debian_version ]; then
                sudo apt-get update
                sudo apt-get install -y zsh
            elif [ -f /etc/redhat-release ]; then
                sudo yum install -y zsh
            else
                echo "Unrecognized Linux distro; install zsh manually, then re-run this script."
                return
            fi
        elif [[ $platform == 'Darwin' ]]; then
            echo "zsh not found. Install it with 'brew install zsh', then re-run this script."
            return
        else
            echo "Unsupported platform ($platform); install zsh manually, then re-run this script."
            return
        fi
    fi

    if [[ ! -d "$dir/oh-my-zsh" ]]; then
        git clone --depth 1 https://github.com/robbyrussell/oh-my-zsh.git "$dir/oh-my-zsh"
    fi
    link_file "$dir/oh-my-zsh" "$HOME/.oh-my-zsh"

    zsh_path="$(command -v zsh)"
    if [[ "$(current_login_shell)" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
    fi
}

install_zsh

install_dependencies() {
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found on PATH; skipping dependency install (starship, direnv, zoxide, mcfly, eza, bat, bun, ripgrep, gh, herdr)."
        return
    fi

    local missing=()
    for entry in "${brew_deps[@]}"; do
        local pkg="${entry%%:*}" bin="${entry##*:}"
        command -v "$bin" &> /dev/null || missing+=("$pkg")
    done

    if [ ${#missing[@]} -eq 0 ]; then
        echo "All Homebrew dependencies already installed."
        return
    fi

    echo "Installing missing dependencies via Homebrew: ${missing[*]}"
    brew install "${missing[@]}"
}

install_dependencies

echo "Done."
