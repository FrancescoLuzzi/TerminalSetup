#!/bin/bash

# filename: setup.sh
# author: @FrancescoLuzzi

# this script is designed to be launched as a downloadable script
# curl -o- https://raw.githubusercontent.com/FrancescoLuzzi/TerminalSetup/main/remote_setup.sh | bash

echo "unlock sudo for this installation!"
sudo echo "done"

git --version >/dev/null 2>&1

if [ $? -ne 0 ];then
    sudo apt install git
fi

__old_pwd=$(pwd)

cd

git clone https://github.com/FrancescoLuzzi/TerminalSetup.git .terminal_setup

cd ./.terminal_setup

chmod +x ./setup.sh

if [ ! -t 0 ]; then
    # The installer is going to want to ask for confirmation by
    # reading stdin.  This script was piped into `sh` though and
    # doesn't have stdin to pass to its children. Instead we're going
    # to explicitly connect /dev/tty to the installer's stdin.
    if [ ! -t 1 ]; then
        err "Unable to run interactively. Run the setup by yourself!"
    fi

    ./setup.sh -I < /dev/tty
else
    ./setup.sh -I
fi



cd "$__old_pwd"