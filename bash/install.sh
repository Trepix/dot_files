ZSH=~/.oh-my-zsh
VIM_FOLDER=~/.vim
ZSH_CUSTOM=~/.custom
GIT_BASE_URI=https://raw.githubusercontent.com/Trepix/automations/master/bash

ALIASES_FILE=$ZSH_CUSTOM/aliases
ENV_VARIABLES_FILE=$ZSH_CUSTOM/env_variables
ZSHRC_FILE=~/.zshrc
DEFAULT_BASH_FILE=./.bashrc 

# Colors
Color_Off='\033[0m'       # Text Reset
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[38;5;214m'   # Yellow

# $1: error message
# $2: success message
check_last_command_and_print() {
    if [ $? -eq 0 ]; then
        if [ ! -z "$2" ]; then
            echo "${Green}${2}$Color_Off"
        fi
    else
	echo "$Red${1}$Color_Off"
	exit -1
    fi
}

print_warning_message() {
    echo "${Yellow}${1}$Color_Off"
}

echo "Installing packages"
wget -qO- $GIT_BASE_URI/packages | while read package
do
    if [ -z "$(hash $package 2>&1)" ]; then
        print_warning_message "  $package is already installed"
    else
        echo "  Installing $package"
        install=$(sudo apt-get install $package --yes 2>&1)
        check_last_command_and_print "  ${install}" "  Successfully ${package} installed"
    fi
done

echo "" && echo "Setting up vim configuration"
if [ ! -f $VIM_FOLDER/vimrc ]; then
    echo "  Downloading vim configuration file"
    download=$(wget -P $VIM_FOLDER $GIT_BASE_URI/vimrc 2>&1)
    check_last_command_and_print "  ${download}" "  Successfully vim configuration downloaded"
else
    print_warning_message "  Another vimrc file already exists in .vim folder"
fi


echo "" && echo "Setting up oh-my-zsh configuration"
#oh-my-zsh
if [ ! -d "$ZSH" ]; then
    echo "  Installing oh-my-zsh" 
    install=$(git clone git://github.com/robbyrussell/oh-my-zsh.git $ZSH 2>&1 && cp $ZSH/templates/zshrc.zsh-template $ZSHRC_FILE)
    check_last_command_and_print "  $install" "  Successfully oh-my-zsh installed"

    #replace theme
    sed -i -E "s/.*(ZSH_THEME=).*/\1bash-for-windows/" $ZSHRC_FILE

    #add plugins
    sed -i -E "s/(plugins=.*)\)/\1 zsh-syntax-highlighting)/" $ZSHRC_FILE

    #set custom directory
    sed -i -E "s|.*(ZSH_CUSTOM=).*|\1$ZSH_CUSTOM|" $ZSHRC_FILE
else
    print_warning_message "  Another installation of ZSH exists"
fi

echo "" && echo "Setting up oh-my-zsh plugins"
if [ ! -d $ZSH_CUSTOM/plugins ]; then
    echo "  Downloading oh-my-zsh highlights"
    install=$(git clone https://github.com/zsh-users/zsh-syntax-highlighting.git 2>&1 ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting)
    check_last_command_and_print "  $install" "  Successfully zsh-syntax-highlighting downloaded"
else
    print_warning_message "  Plugins folder already exists. Nothing has been installed"
fi

echo "" && echo "Setting up oh-my-zsh themes"
if [ ! -d $ZSH_CUSTOM/themes ]; then
    echo "  Downloading themes"
    install=$(wget -P $ZSH_CUSTOM/themes/ $GIT_BASE_URI/themes/bash-for-windows.zsh-theme 2>&1)
    check_last_command_and_print "  $install" "  Successfully themes downloaded"
else
    print_warning_message "  Themes folder already exists. Nothing has been downloaded"
fi

#source aliases file
echo "\nif [ -f ${ALIASES_FILE} ]; then \n    source ${ALIASES_FILE}\nfi" >> $ZSHRC_FILE

#TODO: set variables from file like property file VAR#VALUE and replace it for load it
if [ ! -f $ALIASES_FILE ]; then
    echo "Setting aliases"
    downlaod=$(wget -O $ALIASES_FILE $GIT_BASE_URI/aliases 2>&1)
    check_last_command_and_print "  $downlaod" "  Successfully aliases downloaded"
    chmod +x $ALIASES_FILE
else
    print_warning_message "  Aliases file already exists. Nothing has been downloaded"
fi

sed -i "1i# Launch Zsh \nif [ -t 1 ]; then\n    exec zsh\nfi" $DEFAULT_BASH_FILE
git config --global core.editor "vim"
