#!/bin/bash

############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################


########## Variables

dir="$(pwd)"                # dotfiles directory
olddir="$HOME/dotfiles_old" # old dotfiles backup directory
current_workdir="$(pwd)"    # the directory we're currently in

#----------------------
#!!!!! IMPORTANT !!!!!
#----------------------
# Specify your files here
# list of files/folders to symlink in homedir
files="bash_profile iterm-config gitconfig gitignore profile tmux.conf terraformrc zfunc zprofile zshrc oh-my-zsh"

folders_to_create=".config"

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir || exit
echo "done"

for folder in $folders_to_create; do
    echo "Create folder '$folder' if not exist"
    mkdir -p "$HOME/$folder"
done

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do

    # check if file already exists

    if test -f "$HOME/.$file"; then
        echo "Moving any existing dotfiles from ~ to $olddir"
        mv "$HOME/.$file" "$olddir"
    fi

    echo "Creating symlink to $file in home directory."
    ln -s "$dir/$file" "$HOME/.$file"
done

install_zsh() {
    # Test to see if zshell is installed.  If it is:
    if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
        # Clone my oh-my-zsh repository from GitHub only if it isn't already present
        if [[ ! -d $dir/oh-my-zsh/ ]]; then
            git clone http://github.com/robbyrussell/oh-my-zsh.git
        fi
        # Set the default shell to zsh if it isn't currently set to zsh
        if [[ ! $SHELL == $(which zsh) ]]; then
            chsh -s "$(which zsh)"
        fi
    else
        # If zsh isn't installed, get the platform of the current machine
        platform=$(uname)
        # If the platform is Linux, try an apt-get to install zsh and then recurse
        if [[ $platform == 'Linux' ]]; then
            if [[ -f /etc/redhat-release ]]; then
                sudo yum install zsh
                install_zsh
            fi
            if [[ -f /etc/debian_version ]]; then
                sudo apt-get install zsh
                install_zsh
            fi
        # If the platform is OS X, tell the user to install zsh :)
        elif [[ $platform == 'Darwin' ]]; then
            echo "Please install zsh, then re-run this script!"
            exit
        fi
    fi
}

install_zsh

# Install Autosuggestions
#git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

