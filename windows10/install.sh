OH_MY_ZSH=~/.oh-my-zsh
FZF=~/.fzf
VIM_FOLDER=~/.vim
OH_MY_ZSH_CUSTOM=~/.custom
TFENV=~/.tfenv
GIT_REPOSITORY_URI=https://github.com/Trepix/dot_files.git

ALIASES_FILE=$OH_MY_ZSH_CUSTOM/aliases
ENV_VARIABLES_FILE=$OH_MY_ZSH_CUSTOM/env_variables
ZSHRC_FILE=~/.zshrc
BASH_FILE=~/.bashrc

REPLACE="true" 

# Colors
Color_Off='\033[0m'       # Text Reset
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green

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


if [ -z ${DOT_FILES_WINDOWS10_TMP_FOLDER+x} ]; then
    DOT_FILES_TMP_FOLDER=$(mktemp -d)
    echo "Installing essential git package"

    install=$(sudo apt-get install git --yes 2>&1)
    check_last_command_and_print "  ${install}" "  Successfully git installed"

    clone=$(git clone $GIT_REPOSITORY_URI $DOT_FILES_TMP_FOLDER 2>&1)
    check_last_command_and_print "  ${clone}" "  Successfully DOT_FILES repository cloned"

    DOT_FILES_WINDOWS10_TMP_FOLDER=$DOT_FILES_TMP_FOLDER/windows10
fi

#import commons function
. $DOT_FILES_WINDOWS10_TMP_FOLDER/functions/commons.sh
. $DOT_FILES_WINDOWS10_TMP_FOLDER/functions/python.sh

# ________________________________________________________________________
# ________________________________________________________________________

echo "Installing packages"
cat $DOT_FILES_WINDOWS10_TMP_FOLDER/packages | while read package
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

[ -d $VIM_FOLDER ] || mkdir $VIM_FOLDER

configure_vim()    {
    echo "  Downloading vimrc file"    
    download=$(cp $DOT_FILES_WINDOWS10_TMP_FOLDER/vimrc $VIM_FOLDER 2>&1)
    check_last_command_and_print "  ${download}" "  Successfully vim configuration downloaded"
}

check_and_configure_or_replace_file $VIM_FOLDER/vimrc "vim" "  Another vimrc file already exists in .vim folder"  $REPLACE

# ________________________________________________________________________

configure_tmux() {
    echo "  Downloading .tmux.conf file"    
    download=$(cp $DOT_FILES_WINDOWS10_TMP_FOLDER/.tmux.conf ~ 2>&1)
    check_last_command_and_print "  ${download}" "  Successfully tmux configuration downloaded"
}

check_and_configure_or_replace_file ~/.tmux.conf "tmux" "  Another .tmux.conf file already exists in home folder" $REPLACE

# ________________________________________________________________________
# ________________________________________________________________________

[ -d $OH_MY_ZSH_CUSTOM ] || mkdir $OH_MY_ZSH_CUSTOM

echo "" && echo "Setting up oh-my-zsh themes"
if [ ! -d $OH_MY_ZSH_CUSTOM/themes ]; then
    echo "  Downloading themes"
    download=$(mkdir $OH_MY_ZSH_CUSTOM/themes && cp $DOT_FILES_WINDOWS10_TMP_FOLDER/themes/* $OH_MY_ZSH_CUSTOM/themes/ 2>&1)
    check_last_command_and_print "  $download" "  Successfully themes downloaded"
else
    print_warning_message "  Themes folder already exists. Nothing has been downloaded"
fi

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

configure_aliases() {
    echo "  Downloading aliases"
    downlaod=$(cp $DOT_FILES_WINDOWS10_TMP_FOLDER/aliases $ALIASES_FILE 2>&1)
    check_last_command_and_print "  $downlaod" "  Successfully aliases downloaded"
    chmod +x $ALIASES_FILE
}

check_and_configure_or_replace_file $ALIASES_FILE "aliases" "  Aliases file already exists. Nothing has been downloaded" $REPLACE

# ________________________________________________________________________

configure_env_variables() {
    touch $ENV_VARIABLES_FILE
    check_last_command_and_print "  Can't create env_variables file" "  Successfully envvars file created"
    chmod +x $ENV_VARIABLES_FILE
}

check_and_configure_or_replace_file $ENV_VARIABLES_FILE "env_variables" "  Environment variables file already exists. Nothing has been created" $REPLACE

# ________________________________________________________________________

echo "" && echo "Setting up oh-my-zsh configuration"
# oh-my-zsh repo clone
if [ ! -d "$OH_MY_ZSH" ]; then
    echo "  Installing oh-my-zsh" 
    download=$(git clone git://github.com/ohmyzsh/ohmyzsh.git $OH_MY_ZSH 2>&1)
    check_last_command_and_print "  $download" "  Successfully oh-my-zsh repository cloned"
else
    print_warning_message "  Another installation of oh-my-zsh exists"
fi

# .zshrc file
configure_zshrc() {
    export OH_MY_ZSH_CUSTOM ENV_VARIABLES_FILE ALIASES_FILE OH_MY_ZSH
    envsubst=$(envsubst < $DOT_FILES_WINDOWS10_TMP_FOLDER/zshrc.template > $ZSHRC_FILE)
    check_last_command_and_print "  $envsubst" "  Successfully .zshrc file placed on ${HOME} folder"
}

check_and_configure_or_replace_file $ZSHRC_FILE "zshrc" "  Another .zshrc file is detected nothing is replaced" $REPLACE


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

# ________________________________________________________________________
# ________________________________________________________________________

echo "" && echo "Installing python ecosystem"

download=$(wget -P $DOT_FILES_WINDOWS10_TMP_FOLDER/ https://bootstrap.pypa.io/get-pip.py 2>&1)
check_last_command_and_print "  ${download}" "  Successfully downloaded get-pip.py script"

install_python_ecosystem "pip" "python" ${DOT_FILES_WINDOWS10_TMP_FOLDER}
install_python_ecosystem "pip3" "python3" ${DOT_FILES_WINDOWS10_TMP_FOLDER}

# ________________________________________________________________________
# ________________________________________________________________________

git config --global core.editor "vim"
