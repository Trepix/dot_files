OH_MY_ZSH=~/.oh-my-zsh
FZF=~/.fzf
VIM_FOLDER=~/.vim
OH_MY_ZSH_CUSTOM=~/.custom
TFENV=~/.tfenv
GIT_BASE_URI=https://raw.githubusercontent.com/Trepix/automations/master/bash

ALIASES_FILE=$OH_MY_ZSH_CUSTOM/aliases
ENV_VARIABLES_FILE=$OH_MY_ZSH_CUSTOM/env_variables
ZSHRC_FILE=~/.zshrc
BASH_FILE=~/.bashrc 

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

# ________________________________________________________________________
# ________________________________________________________________________

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

# ________________________________________________________________________
# ________________________________________________________________________

echo "" && echo "Setting up vim configuration"
if [ ! -f $VIM_FOLDER/vimrc ]; then
    echo "  Downloading vim configuration file"
    download=$(wget -P $VIM_FOLDER $GIT_BASE_URI/vimrc 2>&1)
    check_last_command_and_print "  ${download}" "  Successfully vim configuration downloaded"
else
    print_warning_message "  Another vimrc file already exists in .vim folder"
fi

# ________________________________________________________________________
# ________________________________________________________________________


echo "" && echo "Setting up tmux configuration"
if [ ! -f ~/.tmux.conf ]; then
    echo "  Downloading .tmux.conf configuration file"
    download=$(wget -P ~ $GIT_BASE_URI/.tmux.conf 2>&1)
    check_last_command_and_print "  ${download}" "  Successfully tmux configuration downloaded"
else
    print_warning_message "  Another .tmux.conf file already exists in home folder"
fi

# ________________________________________________________________________
# ________________________________________________________________________

echo "" && echo "Setting up oh-my-zsh themes"
if [ ! -d $OH_MY_ZSH_CUSTOM/themes ]; then
    echo "  Downloading themes"
    download=$(wget -P $OH_MY_ZSH_CUSTOM/themes/ $GIT_BASE_URI/themes/bash-for-windows.zsh-theme 2>&1)
    check_last_command_and_print "  $download" "  Successfully themes downloaded"
else
    print_warning_message "  Themes folder already exists. Nothing has been downloaded"
fi

# ________________________________________________________________________
# ________________________________________________________________________

echo "" && echo "Setting up oh-my-zsh plugins"
if [ ! -d $OH_MY_ZSH_CUSTOM/plugins ]; then
    echo "  Downloading oh-my-zsh highlights"
    download=$(git clone https://github.com/zsh-users/zsh-syntax-highlighting.git 2>&1 ${OH_MY_ZSH_CUSTOM}/plugins/zsh-syntax-highlighting)
    check_last_command_and_print "  $download" "  Successfully zsh-syntax-highlighting downloaded"
else
    print_warning_message "  Plugins folder already exists. Nothing has been installed"
fi

# ________________________________________________________________________
# ________________________________________________________________________

echo "" && echo "Setting up aliases"
if [ ! -f $ALIASES_FILE ]; then
    echo "  Downloading aliases"
    downlaod=$(wget -O $ALIASES_FILE $GIT_BASE_URI/aliases 2>&1)
    check_last_command_and_print "  $downlaod" "  Successfully aliases downloaded"
    chmod +x $ALIASES_FILE
else
    print_warning_message "  Aliases file already exists. Nothing has been downloaded"
fi

# ________________________________________________________________________
# ________________________________________________________________________

echo "" && echo "Setting up envvars"
if [ ! -f $ENV_VARIABLES_FILE ]; then
    touch $ENV_VARIABLES_FILE
    check_last_command_and_print "  Can't create envvars file" "  Successfully envvars file created"
    chmod +x $ENV_VARIABLES_FILE
else
    print_warning_message "  Environment variables file already exists. Nothing has been created"
fi

# ________________________________________________________________________
# ________________________________________________________________________

echo "" && echo "Setting up oh-my-zsh configuration"
# oh-my-zsh repo clone
if [ ! -d "$OH_MY_ZSH" ]; then
    echo "  Installing oh-my-zsh" 
    download=$(git clone git://github.com/robbyrussell/oh-my-zsh.git $OH_MY_ZSH 2>&1)
    check_last_command_and_print "  $download" "  Successfully oh-my-zsh repository cloned"
else
    print_warning_message "  Another installation of oh-my-zsh exists"
fi

# .zshrc file
if [ ! -f "$ZSHRC_FILE" ]; then      
    download=$(wget -P $OH_MY_ZSH_CUSTOM/ $GIT_BASE_URI/zshrc.template 2>&1)
    check_last_command_and_print "  $downlaod" "  Successfully .zshrc template downloaded"
    export OH_MY_ZSH_CUSTOM ENV_VARIABLES_FILE ALIASES_FILE OH_MY_ZSH
    envsubst < $OH_MY_ZSH_CUSTOM/zshrc.template > $ZSHRC_FILE
else
    print_warning_message "  Another .zshrc file is detected nothing is replaced"
fi

# launch zsh instead of default bash
if [ "$(grep 'exec zsh' $BASH_FILE)"  ]; then
    print_warning_message "  Zsh's default execution has already set up"
else
    sed -i "1i# Launch Zsh \nif [ -t 1 ]; then\n    exec zsh\nfi" $BASH_FILE
    check_last_command_and_print "  Can't replace bash for zsh by default" "  Replaced bash for zsh by default"
fi

# ________________________________________________________________________
# ________________________________________________________________________

echo "" && echo "Setting up fzf configuration"
#fzf
if [ ! -d "$FZF" ]; then
    echo "  Installing fzf" 
    download=$(git clone --depth 1 https://github.com/junegunn/fzf.git $FZF 2>&1)
    check_last_command_and_print "  $download" "  Successfully fzf repository cloned"
    install=$(${FZF}/install --key-bindings --no-completion --update-rc 2>&1)
    check_last_command_and_print "  $install" "  Successfully fzf installed"
else
    print_warning_message "  Another installation of fzf exists"
fi

# ________________________________________________________________________
# ________________________________________________________________________

echo "" && echo "Setting up tfenv (terraform manager)"
#tfenv
if [ ! -d "$TFENV" ]; then
    echo "  Installing tfenv"
    download=$(git clone https://github.com/kamatama41/tfenv.git $TFENV 2>&1)
    check_last_command_and_print "  $download" "  Successfully tfenv repository cloned"
else
    print_warning_message "  Another installation of tfenv exists"
fi 

#tfenv symlinks
if [ -z "$(sudo ln -s $TFENV/bin/* /usr/local/bin 2>&1)" ]; then
    check_last_command_and_print  "  Unexpected error creating terraform and tfenv symlinks" "  Successfully terraform and tfenv symlinks created"
else
    print_warning_message "  Terraform and tfenv's symlinks already exists"
fi


git config --global core.editor "vim"
