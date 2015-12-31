#!/bin/bash
# Author:tracyone
# Email:tracyone@live.cn

OS=$(uname)
echo OS is $OS
cur_dir=$(pwd)
echo "Start install zsh tmux git...."
if [[ $OS == "Linux" ]] ;then
	sudo apt-get install zsh git xclip
    sudo cp 10-monitor.conf /usr/share/X11/xorg.conf.d/
sudo apt-get install libevent-dev libcurses-ocaml-dev
	git clone https://github.com/tmux/tmux && cd tmux && ./autogen.sh && ./configure && make && sudo make install
cd ${cur_dir}
elif [[ $OS == 'Darwin' ]]; then
	brew install zsh tmux git xclip
elif [[ $OS =~ MSYS_NT.* ]]; then
	pacman -S zsh tmux git 
fi

if [[ ! -d ${HOME}/.oh-my-zsh ]]; then
	echo "Install oh-my-zsh ..."
	sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" 
fi

if [[ -d ${HOME}/.oh-my-zsh/plugins ]]; then
	git clone https://github.com/jocelynmallon/zshmarks  ~/.oh-my-zsh/plugins/zshmarks && echo "Install zshmarks successfully!"
else
	echo "Error!Please install oh-my-zsh first."
fi

echo "Install tmux plugin manager ..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && echo "Install tpm successfully!"

read -n1 -p "Copy  or Link(soft link) the dotfiles ? (c|l)" ans
if [[ ${ans} =~ [Cc] ]]; then
	install_cmd="cp -a"
fi
if [[ ${ans} =~ [lL] ]]; then
	install_cmd="ln -sf"
fi
${install_cmd} ${cur_dir}/.zshrc ${HOME}
${install_cmd} ${cur_dir}/.tmux.conf ${HOME}
${install_cmd} ${cur_dir}/.gitconfig ${HOME}
${install_cmd} ${cur_dir}/minirc.dfl ${HOME}/.minirc.dfl
echo "Install finish."
