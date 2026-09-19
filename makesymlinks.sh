#!/bin/bash

############################
# makesymlinks.sh
#
# Symlinks dotfiles from this repo into $HOME (and ~/.config), makes sure
# zsh is installed, and installs the CLI tools the dotfiles depend on via
# Homebrew (assumes Homebrew/Linuxbrew is already set up).
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
    "tofurc:.tofurc"
    "zprofile:.zprofile"
    "zshrc:.zshrc"
    "zshrc.local:.zshrc.local"
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
    "opentofu:tofu"
    "jq:jq"
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

# Bootstrap a per-host zshrc.local from the template on first run. It's
# gitignored, so this only happens once per clone/machine and never gets
# clobbered afterwards.
if [ ! -e "$dir/zshrc.local" ] && [ -f "$dir/zshrc.local.example" ]; then
    cp "$dir/zshrc.local.example" "$dir/zshrc.local"
fi

# tofurc's plugin_cache_dir points here; OpenTofu errors out if it's missing.
mkdir -p "$HOME/.tofu.d/plugin-cache"

# gitconfig includes this for OS-specific settings (credential helper, merge
# tool, ...) that don't belong hardcoded in the shared, committed gitconfig.
# Fully derived from `uname`, so it's regenerated (and gitignored) rather
# than hand-edited like gitconfig-local.
configure_git_platform() {
    local out="$dir/gitconfig-os"
    case "$(uname -s)" in
        Darwin)
            cat > "$out" <<-'EOF'
			[credential]
				helper = osxkeychain
			[merge]
				tool = opendiff
			EOF
            ;;
        Linux)
            # No macOS Keychain equivalent is installed by default; `cache`
            # (built into git) keeps credentials in memory for an hour
            # instead of failing outright or storing them in plaintext.
            cat > "$out" <<-'EOF'
			[credential]
				helper = cache --timeout=3600
			EOF
            ;;
        *)
            : > "$out"
            ;;
    esac
}

configure_git_platform

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
                if ! sudo apt-get update; then
                    echo "Could not run 'apt-get update' (no sudo access?); install zsh manually, then re-run this script."
                    return
                fi
                if ! sudo apt-get install -y zsh; then
                    echo "Could not install zsh via apt; install it manually, then re-run this script."
                    return
                fi
            elif [ -f /etc/redhat-release ]; then
                if ! sudo yum install -y zsh; then
                    echo "Could not install zsh via yum; install it manually, then re-run this script."
                    return
                fi
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

    zsh_path="$(command -v zsh)"
    if [[ "$(current_login_shell)" != "$zsh_path" ]]; then
        # Can fail without sudo/TTY access (e.g. sandboxed containers); don't
        # let that abort the rest of the script - just retry next run.
        if ! chsh -s "$zsh_path"; then
            echo "Could not change login shell to $zsh_path (no permission or no TTY)."
            echo "Set it manually later, e.g.: chsh -s $zsh_path"
        fi
    fi
}

install_zsh

install_dependencies() {
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found on PATH; skipping dependency install (starship, direnv, zoxide, mcfly, eza, bat, bun, ripgrep, gh, herdr, opentofu)."
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
    if ! brew install "${missing[@]}"; then
        echo "Some Homebrew packages failed to install; re-run this script to retry."
    fi
}

install_dependencies

# Wire the statusline script into Claude Code's settings.json. The script
# lives in the repo (not symlinked into ~/.claude) since its path is stable
# across machines already; only the settings.json entry pointing at it is
# actually machine state that needs installing. Merges into whatever
# settings.json already has instead of overwriting it, since Claude Code
# stores other machine-specific state there.
configure_claude() {
    chmod +x "$dir/claude/statusline-command.sh"

    if ! command -v jq &> /dev/null; then
        echo "jq not found; skipping Claude Code statusline setup."
        return
    fi

    local config_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
    local settings="$config_dir/settings.json"
    local cmd="$dir/claude/statusline-command.sh"

    mkdir -p "$config_dir"
    [ -f "$settings" ] || echo '{}' > "$settings"

    if [ "$(jq -r '.statusLine.command // empty' "$settings")" = "$cmd" ]; then
        return
    fi

    local tmp
    tmp="$(mktemp)"
    jq --arg cmd "$cmd" '.statusLine = {"type": "command", "command": $cmd}' "$settings" > "$tmp" \
        && mv "$tmp" "$settings"
    echo "Configured Claude Code statusline in $settings"
}

configure_claude

echo "Done."
