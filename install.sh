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
	brew install zsh tmux git
elif [[ $OS =~ MSYS_NT.* ]]; then
	configure "pacman cp which mv "
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

if [[ ! -d ${HOME}/.tmux/plugins/tmux-resurrect ]]; then
	echo -e "\nInstall tmux plugin tmux-resurrect ...\n"
	git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect && echo -e "\nInstall tmux-resurrect successfully!\n"  || ( echo "Error occured!exit.";exit 3 )
fi

if [[ ! -d ${HOME}/.tmux/plugins/tmux-copycat ]]; then
	echo -e "\nInstall tmux plugin tmux-copycat ...\n"
	git clone https://github.com/tmux-plugins/tmux-copycat ~/.tmux/plugins/tmux-copycat && echo -e "\nInstall tmux-copycat successfully!\n"  || ( echo "Error occured!exit.";exit 3 )
fi

if [[ $# -eq 1 ]]; then
	ans=$1
else
	echo -e "\n"
	read -n1 -p "Copy  or Link(soft link) the dotfiles ? (c|l)" ans
fi

if [[ ${ans} =~ [Cc] ]]; then
	install_cmd="cp -a"

elif [[ ${ans} =~ [lL] ]]; then
	install_cmd="ln -sFf"
else
	echo -e "\nWrong argument\n";exit 3

fi

mkdir -p ${HOME}/.ssh

cd t-macs && ./install.sh && cd -
cd t-vim && ./install.sh 1 && cd -

${install_cmd} ${cur_dir}/.zshrc ${HOME}/.zshrc
${install_cmd} ${cur_dir}/.tmux.conf ${HOME}/.tmux.conf
${install_cmd} ${cur_dir}/.gitconfig ${HOME}/.gitconfig
${install_cmd} ${cur_dir}/minirc.dfl ${HOME}/.minirc.dfl
${install_cmd} ${cur_dir}/ssh_config ${HOME}/.ssh/config

echo -e "\n"
if [[ $OS == "Linux" ]]; then
	sudo cp -a ./desktop_files/*.desktop /usr/share/applications/
fi
rm -rf temp
echo -e "\n\nInstall Finish..."

# vim: set fdm=marker foldlevel=0 foldmarker&:
