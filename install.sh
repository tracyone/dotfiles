#!/bin/bash
# Author:tracyone
# Email:tracyone@live.cn

OS=$(uname)
echo -e "\nOS is $OS\n"
cur_dir=$(pwd)
echo -e "\nStart install zsh tmux git....\n"
if [[ $OS == "Linux" ]] ;then
	sudo apt-get install zsh git xclip autoconf automake curl wget
	sudo cp 10-monitor.conf /usr/share/X11/xorg.conf.d/
	which tmux > /dev/null
	if [[ $? -ne 0 ]]; then
		lsb_release -a | grep 10.04
		if [[  $? -eq 0 ]]; then
			echo "OS is Ubuntu 10.04"
			echo "get libevent 2.0 from internet then build and install"
			curl -fLo libevent.tar.gz https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
			tar xvf libevent.tar.gz
			mv libevent-* libevent && cd libevent && ./configure --prefix=/usr && make && sudo make install || ( echo "Error occured!exit.";exit 3 )
			echo "get latest tmux from internet then build and install"
			git clone https://github.com/tmux/tmux && cd tmux && ./autogen.sh && ./configure && make && sudo make install || ( echo "Error occured!exit.";exit 3 )
			cd ${cur_dir}
		else
			sudo apt-get install libevent-dev libcurses-ocaml-dev
			echo "get latest tmux from internet then build and install"
			git clone https://github.com/tmux/tmux && cd tmux && ./autogen.sh && ./configure && make && sudo make install || ( echo "Error occured!exit.";exit 3 )
			cd ${cur_dir}
		fi
	fi
elif [[ $OS == 'Darwin' ]]; then
	brew install zsh tmux git
elif [[ $OS =~ MSYS_NT.* ]]; then
	pacman -S zsh tmux git 
fi

if [[ ! -d ${HOME}/.oh-my-zsh ]]; then
	echo -e "\nInstall oh-my-zsh ...\n"
	git clone https://github.com/robbyrussell/oh-my-zsh && cd oh-my-zsh/tools && ./install.sh || ( echo "Error occured!exit.";exit 3 )
fi

if [[ -d ${HOME}/.oh-my-zsh/plugins ]]; then
	if [[ ! -d ${HOME}/.oh-my-zsh/plugins/zshmarks ]]; then
		git clone https://github.com/jocelynmallon/zshmarks  ~/.oh-my-zsh/plugins/zshmarks && echo -e "\nInstall zshmarks successfully!\n" \
			|| ( echo "Error occured!exit.";exit 3 )
	fi
else
	echo -e "\nError!Please install oh-my-zsh first.\n"
fi

if [[ ! -d ${HOME}/.tmux/plugins/tpm ]]; then
	echo -e "\nInstall tmux plugin manager ...\n"
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && echo -e "\nInstall tpm successfully!\n"  || ( echo "Error occured!exit.";exit 3 )
fi

echo -e "\n"
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

echo -e "\n"
read -n1 -p "Install desktop files(y/n)" ans
if [[ $ans =~ [yY] ]]; then
	sudo cp -a ./desktop_files/*.desktop /usr/share/applications/
fi
echo -e "\n\nInstall Finish..."
