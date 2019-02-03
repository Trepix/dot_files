install_python_ecosystem() {
    pip=$1
    python=$2
    pip_folder=$3

    if [ -z "$(hash $pip 2>&1)" ]; then
        print_warning_message "  $pip is already installed"
    else
        echo "  Installing $pip"
        install=$(sudo $python $pip_folder/get-pip.py  2>&1)
        check_last_command_and_print "  ${install}" "  Successfully $pip installed"
    fi
}
