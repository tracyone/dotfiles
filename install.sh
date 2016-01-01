#!/bin/bash
# Author:tracyone
# Email:tracyone@live.cn

OS=$(uname)
echo OS is $OS
cur_dir=$(pwd)
echo "\nStart install zsh tmux git....\n"
if [[ $OS == "Linux" ]] ;then
	sudo apt-get install zsh git xclip
	sudo cp 10-monitor.conf /usr/share/X11/xorg.conf.d/
	which tmux > /dev/null
	if [[ $? -ne 0 ]]; then
		sudo apt-get install libevent-dev libcurses-ocaml-dev
		git clone https://github.com/tmux/tmux && cd tmux && ./autogen.sh && ./configure && make && sudo make install
		cd ${cur_dir}

	fi
elif [[ $OS == 'Darwin' ]]; then
	brew install zsh tmux git xclip
elif [[ $OS =~ MSYS_NT.* ]]; then
	pacman -S zsh tmux git 
fi

if [[ ! -d ${HOME}/.oh-my-zsh ]]; then
	echo "\nInstall oh-my-zsh ...\n"
	sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" 
fi

if [[ -d ${HOME}/.oh-my-zsh/plugins ]]; then
	if [[ ! -d ${HOME}/.oh-my-zsh/plugins/zshmarks ]]; then
		git clone https://github.com/jocelynmallon/zshmarks  ~/.oh-my-zsh/plugins/zshmarks && echo "\nInstall zshmarks successfully!\n"
	fi
else
	echo "\nError!Please install oh-my-zsh first.\n"
fi

if [[ ! -d ${HOME}/.tmux/plugins/tpm ]]; then
	echo "\nInstall tmux plugin manager ...\n"
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && echo "\nInstall tpm successfully!\n"
fi

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

echo 
read -n1 -p "Install desktop files(y/n)" ans
if [[ $ans =~ [yY] ]]; then
	sudo cp -a ./desktop_files/*.desktop /usr/share/applications/
fi
echo -e "\nInstall Finish...\n"
