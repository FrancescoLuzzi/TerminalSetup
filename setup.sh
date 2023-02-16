#!/bin/bash

_pwd=$(pwd)
ln -sf ${_pwd}/linux_terminal/.vimrc $HOME/.vimrc
ln -sf ${_pwd}/linux_terminal/.git.plugin.sh $HOME/.git.plugin.sh
ln -sf ${_pwd}/linux_terminal/.luzzi_theme.omp.json $HOME/.luzzi_theme.omp.json
source ~/.bashrc
