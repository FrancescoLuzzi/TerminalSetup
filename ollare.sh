#!/bin/bash

# filename: setup.sh
# author: @FrancescoLuzzi

showHelp() {
    cat >&2 <<EOF
Usage: ./installer [-i vim|lvim] [-w tmux|zellij] [-IU] [-gnopr]
Install Pre-requisites for EspoCRM with docker in Development mode

-h                   Display help

-I                   Interactive installer

-U                   Update terminal setup after first installation

-e [vim|lvim]        Optional text editor with custom configuration

-w [tmux|zellij]     Optional window manager with custom keybindings and packages

-g                   Install golang for developement

-n                   Install nvm/node/npm for developement (also installed with lvim and vim)

-p                   Install python for developement (also installed with lvim)

-r                   Install rust for developement (also installed with lvim)
EOF

}

export version=0
export verbose=0
export rebuilt=0

if [ $# -eq 0 ]; then
    showHelp
    exit 0
fi

while getopts ':IUgnpre:w:' OPTION; do
    case $OPTION in
    h)
        showHelp
        exit 0
        ;;

    I)
        interactive=true
        ;;

    U)
        update=true
        ;;

    e)
        if [[ $OPTARG =~ (^vim$|^lvim$) ]]; then
            echo "-e ok"
            editor=$OPTARG
        else
            echo "unsupported value for -e: $OPTARG"
            showHelp
            exit 0
        fi
        ;;

    w)
        if [[ $OPTARG =~ (tmux|zellij) ]]; then
            echo "-w ok"
            window_manager=$OPTARG
        else
            echo "unsupported value for -w: $OPTARG"
            showHelp
            exit 0
        fi
        ;;

    g)
        program+=("golang")
        ;;

    n)
        program+=("node")
        ;;

    p)
        program+=("python")
        ;;

    r)
        program+=("rust")
        ;;

    ?)
        showHelp
        exit 1
        ;;
    esac
done

# getopts cycles over $*, doesn't shift it
shift $(($OPTIND - 1))
