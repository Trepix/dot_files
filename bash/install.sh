#!/bin/bash

ZSH=~/.oh-my-zsh
VIM_FOLDER=~/.vim
ZSH_CUSTOM=~/.custom
GIT_BASE_URI=https://raw.githubusercontent.com/Trepix/automations/master/bash

ALIASES_FILE=$ZSH_CUSTOM/aliases
ENV_VARIABLES_FILE=$ZSH_CUSTOM/env_variables
ZSHRC_FILE=~/.zshrc
DEFAULT_BASH_FILE=./.bashrc 

# $1: error message
# $2: success message
check_last_command_and_print() {
    if [ $? -eq 0 ]; then
        if [ ! -z "$2" ]; then
            printf "${2}\n"
        fi
    else
	printf "${1}\n"
	exit -1
    fi
}

wget -qO- $GIT_BASE_URI/packages | while read package
do
    if [ -z "$(hash $package 2>&1)" ]; then
        echo "$package is already installed"
    else
        echo "Installing $package"
        install=$(sudo apt-get install $package --yes 2>&1)
        check_last_command_and_print "$install" "Successfully $package installed"
    fi
done

if [ ! -f $VIM_FOLDER/vimrc ]; then
    echo "Downloading vim configuration file"
    download=$(wget -P $VIM_FOLDER $GIT_BASE_URI/vimrc 2>&1)
    check_last_command_and_print "$download" "Successfully vim configuration downloaded"
else
    echo "Another vimrc file already exists in .vim folder"
fi


#oh-my-zsh
if [ ! -d "$ZSH" ]; then
    echo "Installing oh-my-zsh" 
    install=$(git clone git://github.com/robbyrussell/oh-my-zsh.git $ZSH && cp $ZSH/templates/zshrc.zsh-template $ZSHRC_FILE)
    check_last_command_and_print "$install" "Successfully oh-my-zsh installed"

    #replace theme
    sed -i -E "s/.*(ZSH_THEME=).*/\1bash-for-windows/" $ZSHRC_FILE

    #add plugins
    sed -i -E "s/(plugins=.*)\)/\1 zsh-syntax-highlighting)/" $ZSHRC_FILE

    #set custom directory
    sed -i -E "s|.*(ZSH_CUSTOM=).*|\1$ZSH_CUSTOM|" $ZSHRC_FILE
else
    echo "Another installation of ZSH exists"
fi

if [ ! -d $ZSH_CUSTOM/plugins ]; then
    echo "Downloading oh-my-zsh highlights"
    install=$(git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting)
    check_last_command_and_print "$install" "Successfully zsh-syntax-highlighting downloaded"
fi

if [ ! -d $ZSH_CUSTOM/themes ]; then
    echo "Downloading themes"
    install=$(wget -P $ZSH_CUSTOM/themes/ $GIT_BASE_URI/themes/bash-for-windows.zsh-theme 2>&1)
    check_last_command_and_print "$install" "Successfully themes downloaded"
fi

#source aliases file
echo "\nif [ -f ${ALIASES_FILE} ]; then \n    source ${ALIASES_FILE}\nfi" >> $ZSHRC_FILE

#TODO: set variables from file like property file VAR#VALUE and replace it for load it
if [ ! -f $ALIASES_FILE ]; then
    echo "Setting aliases"
    downlaod=$(wget -O $ALIASES_FILE $GIT_BASE_URI/aliases 2>&1)
    check_last_command_and_print "$downlaod" "Successfully aliases downloaded"
    chmod +x $ALIASES_FILE
fi

sed -i "1i# Launch Zsh \nif [ -t 1 ]; then\n    exec zsh\nfi" $DEFAULT_BASH_FILE
git config --global core.editor "vim"
