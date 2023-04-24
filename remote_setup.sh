#!/bin/bash

# filename: setup.sh
# author: @FrancescoLuzzi

# this script is designed to be launched as a downloadable script
# curl -o- https://raw.githubusercontent.com/FrancescoLuzzi/TerminalSetup/main/remote_setup.sh | bash

echo "unlock sudo for this installation!"
sudo echo "done"

git --version >/dev/null 2/&1

if [ $? -ne 0 ];then
    sudo apt install git
fi

__old_pwd=$(pwd)

cd

git clone https://github.com/FrancescoLuzzi/TerminalSetup.git .terminal_setup

cd ./.terminal_setup

chmod +x ./setup.sh
./setup.sh -I

cd "$__old_pwd"