#!/bin/bash

_pwd=$(pwd)
ln -sf ${_pwd}/linux_terminal/.vimrc $HOME/.vimrc
ln -sf ${_pwd}/linux_terminal/.git.plugin.sh $HOME/.git.plugin.sh
ln -sf ${_pwd}/linux_terminal/.luzzi_theme.omp.json $HOME/.luzzi_theme.omp.json
ln -sf ${_pwd}/linux_terminal/.tmux.conf $HOME/.tmux.conf
if ! nvm;then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
fi
source ~/.bashrc
if ! node;then
    nvm install --lts
fi

if [ ! -d ~/.tmux/plugins/tpm ];then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
