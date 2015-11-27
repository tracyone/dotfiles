#!/bin/bash

OS=$(uname)


cur_dir=$(pwd)
echo "Start install..."
ln -sf ${cur_dir}/.zshrc ${HOME}
ln -sf ${cur_dir}/.tmux.conf ${HOME}
ln -sf ${cur_dir}/.gitconfig ${HOME}
if [[ $OS == "Linux" ]] ;then
    echo OS is $OS
    sudo cp 10-monitor.conf /usr/share/X11/xorg.conf.d/
fi
echo "Install finish."
