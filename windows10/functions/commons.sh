# Colors
Color_Off='\033[0m'       # Text Reset
Yellow='\033[38;5;214m'   # Yellow

print_warning_message() {
    echo "${Yellow}${1}$Color_Off"
}

check_and_configure_or_replace_file() {
    file_path=$1
    name=$2
    warning_message=$3
    have_to_replace=$4 #( true | false )
    
    echo "" && echo "Setting up $name"
    if [ ! -f $file_path ]; then
        eval "configure_$name"
    else 
        if [ $have_to_replace = "true" ]; then
            while
                read -p "Do you really want to override $file_path [Y/n]: " override 
                override=$( echo ${override:-y} | tr '[:upper:]' '[:lower:]' )
                [ $override != "y" ] && [ $override != "n" ]
            do :; done
            if [ $override = "y" ]; then
                rm -f $file_path
                eval "configure_$name"
            fi
        else
            print_warning_message $warning_message
        fi
    fi
}
