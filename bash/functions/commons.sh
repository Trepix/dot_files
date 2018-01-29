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
                read -p "Do you want really to override $file_path [Y|n]: " override 
                override=${override:-Y}
                [ $override != "Y" ] && [ $override != "n" ]
            do :; done
            if [ $override = "Y" ]; then
                rm -f $file_path
                eval "configure_$name"
            fi
        else
            print_warning_message $warning_message
        fi
    fi
}
