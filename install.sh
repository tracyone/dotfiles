#!/bin/bash
# Author:tracyone
# Email:tracyone@live.cn

OS=$(uname)
echo -e "\nOS Kernel is $OS\n"
cur_dir=$(pwd)
mkdir -p temp

# Function definition {{{
function AptInstall()
{
	read -n1 -p "Install $1 ?(y/n)" ans
	if [[ $ans =~ [Yy] ]]; then
		sudo apt-get install $1 --allow-unauthenticated -y || AptSingleInstall "$1"
	else
		echo -e  "\nAbort install\n"
	fi
	sleep 2
}

# $1:software list to install..
function AptSingleInstall()
{
for i in $1
do
	sudo apt-get install $i --allow-unauthenticated -y
done
}

# clean screen
function clear_screen()
{
	# clear screen
	echo -e "\e[2J\e[1;1H"
}

# accept one argument:command line programs name to be tested
function configure()
{
	local package_lack=""
	for i in $1
	do
		which $i > /dev/null 2>&1
		if [[ $? -ne 0 ]]; then
			echo -e "Checking for $i ..... no"
			package_lack="$i ${package_lack}"
		else
			echo -e "Checking for $i ..... yes"
		fi
	done	
	if [[ ${package_lack} != "" ]]; then
		echo "Please install ${package_lack} manually!"
		exit 3
	fi
}
# }}}

echo -e "\nInstall start ...\n"
echo -e "\nStart install zsh tmux git....\n"
if [[ $OS == "Linux" ]] ;then
	configure "apt-get cp which mv "
	clear_screen
	AptInstall "zsh git xclip autoconf automake curl wget git-core"
	sudo cp 10-monitor.conf /usr/share/X11/xorg.conf.d/
	which tmux > /dev/null
	if [[ $? -ne 0 ]]; then
		lsb_release -a | grep 10.04
		if [[  $? -eq 0 ]]; then
			echo "OS is Ubuntu 10.04"
			if [[ ! -d "./temp/libevent" ]]; then
				echo "get libevent 2.0 from internet then build and install"
				cd temp
				curl -fLo libevent.tar.gz https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
				tar xvf libevent.tar.gz
				mv libevent-* libevent && cd libevent && ./configure --prefix=/usr && make && sudo make install || ( echo "Error occured!exit.";exit 3 )
				echo "get latest tmux from internet then build and install"
				git clone https://github.com/tmux/tmux && cd tmux && ./autogen.sh && ./configure && make && sudo make install || ( echo "Error occured!exit.";exit 3 )
			fi
			cd ${cur_dir}
		else
			if [[ ! -d "./temp/tmux" ]]; then
				cd temp
				AptInstall libevent-dev libcurses-ocaml-dev
				echo "get latest tmux from internet then build and install"
				git clone https://github.com/tmux/tmux && cd tmux && ./autogen.sh && ./configure && make && sudo make install || ( echo "Error occured!exit.";exit 3 )
			fi
			cd ${cur_dir}
		fi
	fi
elif [[ $OS == 'Darwin' ]]; then
	configure "brew cp which mv "
	clear_screen
	brew install zsh tmux git
elif [[ $OS =~ MSYS_NT.* ]]; then
	configure "pacman cp which mv "
	clear_screen
	pacman -S zsh tmux git 
fi

if [[ ! -d ${HOME}/.oh-my-zsh ]]; then
	echo -e "\nInstall oh-my-zsh ...\n"
    if [[ ! -d "oh-my-zsh" ]]; then
        git clone https://github.com/robbyrussell/oh-my-zsh   
    fi
    cd oh-my-zsh/tools && ./install.sh || ( echo "Error occured!exit.";exit 3 )
fi

if [[ -d ${HOME}/.oh-my-zsh/plugins ]]; then
	if [[ ! -d ${HOME}/.oh-my-zsh/plugins/zshmarks ]]; then
		git clone https://github.com/jocelynmallon/zshmarks  ~/.oh-my-zsh/plugins/zshmarks && chmod 755 ~/.oh-my-zsh/plugins/zshmarks -R  && echo -e "\nInstall zshmarks successfully!\n" \
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
mkdir -p ${HOME}/.config/nvim
ln -sf ${HOME}/.vim ${HOME}/.config/nvim
${install_cmd} ${cur_dir}/vim/vimrc ${HOME}/.vimrc
${install_cmd} ${cur_dir}/vim/vimrc ${HOME}/.config/nvim/init.vim

echo -e "\n"
read -n1 -p "Install desktop files(y/n)" ans
if [[ $ans =~ [yY] ]]; then
	sudo cp -a ./desktop_files/*.desktop /usr/share/applications/
fi
echo -e "\n\nInstall Finish..."

# vim: set fdm=marker foldlevel=0 foldmarker&:
