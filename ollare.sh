#!/bin/bash

# filename: setup.sh
# author: @FrancescoLuzzi

showHelp() {
# `cat << EOF` This means that cat should stop reading when EOF is detected
cat >&2 << EOF  
Usage: ./installer [-hvrV] args
Install Pre-requisites for EspoCRM with docker in Development mode

-h                   Display help

-v                   Set and Download specific version of EspoCRM

-r                   Rebuild php vendor directory using composer and compiled css using grunt

-V                   Run script in verbose mode. Will print out each step of execution.

EOF
# EOF is found above and hence cat command stops reading. This is equivalent to echo but much neater when printing out.
}


export version=0
export verbose=0
export rebuilt=0

if [ $# -eq 0 ];then
    showHelp
    exit 0
fi


while getopts ':rhVv:' OPTION ; do
    case $OPTION in
        h) 
            showHelp
            exit 0
            ;;

        v) 
            echo "$OPTARG"
            ;;

        V)
            echo "VERBOSE"
            ;;
        
        r)
            echo "rebuild"
            ;;

        ?) 
            showHelp
            exit 1
            ;;
    esac
done

# getopts cycles over $*, doesn't shift it
shift $(($OPTIND - 1))