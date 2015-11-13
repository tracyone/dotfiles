#!/bin/bash

cur_dir=$(pwd)
echo "Start install..."
sudo apt-get install zsh tmux git 
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
ln -sf ${cur_dir}/.zshrc ${HOME}
ln -sf ${cur_dir}/.tmux.conf ${HOME}
ln -sf ${cur_dir}/.gitconfig ${HOME}
sudo cp 10-monitor.conf /usr/share/X11/xorg.conf.d/
echo "Install finish."
