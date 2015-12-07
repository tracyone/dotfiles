#!/bin/bash

OS=$(uname)
echo OS is $OS
cur_dir=$(pwd)
echo "Start install..."
if [[ $OS == "Linux" ]] ;then
	sudo apt-get install zsh tmux git xclip
    sudo cp 10-monitor.conf /usr/share/X11/xorg.conf.d/
elif [[ $OS == 'Darwin' ]]; then
	brew install zsh tmux git xclip
fi
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" 

if [[ $? -eq 0 && -d ~/.oh-my-zsh/plugins ]]; then
	git clone https://github.com/jocelynmallon/zshmarks  ~/.oh-my-zsh/plugins/zshmarks && echo "Install zshmarks successfully!"
else
	echo "Error!Please install oh-my-zsh first."
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && echo "Install tpm successfully!"

ln -sf ${cur_dir}/.zshrc ${HOME}
ln -sf ${cur_dir}/.tmux.conf ${HOME}
ln -sf ${cur_dir}/.gitconfig ${HOME}
echo "Install finish."
