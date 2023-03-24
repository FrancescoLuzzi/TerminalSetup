#!/bin/bash

# load nvm just to be sure
source ~/.nvm/nvm.sh 2>/dev/null

_pwd=$(pwd)
ln -sf ${_pwd}/linux_terminal/.vimrc $HOME/.vimrc
ln -sf ${_pwd}/linux_terminal/.git.plugin.sh $HOME/.git.plugin.sh
ln -sf ${_pwd}/linux_terminal/.luzzi_theme.omp.json $HOME/.luzzi_theme.omp.json
ln -sf ${_pwd}/linux_terminal/.tmux.conf $HOME/.tmux.conf

is_ping_usable=$(ping -q -c 1 -W 1 8.8.8.8 1>/dev/null 2>&1; echo $?)

if [ $is_ping_usable = "2" ];then
    echo "Enabling use of ping in wsl"
    sudo setcap cap_net_raw+p /bin/ping
fi

if ! nvm --version;then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    source ~/.nvm/nvm.sh
fi

if ! node --version;then
    nvm install --lts
fi

if [ ! -d ~/.tmux/plugins/tpm ];then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    # start a server but don't attach to it
    tmux start-server
    # source .tmux.conf
    tmux source $HOME/.tmux.conf
    # create a new session but don't attach to it either
    tmux new-session -d
    # install the plugins
    ~/.tmux/plugins/tpm/scripts/install_plugins.sh
    # killing the server is not required, I guess
    tmux kill-server
fi
