#!/bin/bash
# Author:tracyone
# Email:tracyone@live.cn

OS=$(uname)
echo -e "\nOS Kernel is $OS\n"
mkdir -p temp

app_name='dotfiles'
[ -z "$APP_PATH" ] && APP_PATH="$HOME/.dotfiles"
[ -z "$REPO_URI" ] && REPO_URI='https://github.com/tracyone/dotfiles.git'
[ -z "$REPO_BRANCH" ] && REPO_BRANCH='master'

# Function definition {{{

function msg() {
    printf '%b\n' "$1" >&2
}

function success() {
    if [ "$ret" -eq '0' ];
    then
        msg "\33[32m[✔]\33[0m ${1}${2}"
    fi
}

function error() {
    msg "\33[31m[✘]\33[0m ${1}${2}"
    exit 1
}

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

function sync_repo() {
    local repo_path="$1"
    local repo_uri="$2"
    local repo_branch="$3"
    local repo_name="$4"

    #.vim is exist and is a git repo
    if [ -d "$repo_path/.git" ];
    then
        cd ${repo_path}
        local git_remote_url=$(git remote get-url `git remote` | grep tracyone | grep dotfiles)
        #not my repo
        if [ -z ${git_remote_url} ];
        then
            msg "\033[1;34m==>\033[0m Find git repo $(git remote get-url `git remote`) in $repo_path!"
            msg "\033[1;34m==>\033[0m Backup to other place"
            backup "${repo_path}"
        fi
        cd -
    elif [ -d "${repo_path}" ];
    then
        # find ~/.vim and is not a git repo
        msg "\033[1;34m==>\033[0m Find $repo_path"
        msg "\033[1;34m==>\033[0m Backup to other place"
        backup "${repo_path}"
    fi

    if [ ! -d "$repo_path" ];
    then
        msg "\033[1;34m==>\033[0m Trying to clone $repo_name"
        mkdir -p "$repo_path"
        git clone  -b "$repo_branch" "$repo_uri" "$repo_path" 
        ret="$?"
        if [ $ret -eq 0 ]; then
            success "Successfully cloned $repo_name."
            cd ${repo_path}
            local latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)
            git checkout ${latest_tag}
            cd -
        fi
    else
        msg "\033[1;34m==>\033[0m Trying to update $repo_name"
        cd "$repo_path" && git fetch --all
        ret="$?"
        if [ $ret -eq 0 ]; then
            success "Successfully updated $repo_name"
            local latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)
            git checkout ${latest_tag}
        fi
    fi

}
# }}}

echo -e "\nInstall start ...\n"

sync_repo       "$APP_PATH" \
                "$REPO_URI" \
                "$REPO_BRANCH" \
                "$app_name"


cd $APP_PATH

echo -e "\nStart install zsh tmux git....\n"
if [[ $OS == "Linux" ]] ;then
	configure "apt-get cp which mv "
	AptInstall "zsh git xclip autoconf automake curl wget git-core"
	sudo cp 10-monitor.conf /usr/share/X11/xorg.conf.d/
	which tmux > /dev/null
	if [[ $? -ne 0 ]]; then
		if [[ ! -d "./temp/tmux" ]]; then
			cd temp
			AptInstall libevent-dev libcurses-ocaml-dev
			echo "get latest tmux from internet then build and install"
			git clone https://github.com/tmux/tmux && cd tmux && ./autogen.sh && ./configure && make && sudo make install || ( echo "Error occured!exit.";exit 3 )
		fi
		cd ${APP_PATH}
	fi
elif [[ $OS == 'Darwin' ]]; then
	configure "ruby curl"
    which brew > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo -e "Install homebrew"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
	brew bundle
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
    cd ${APP_PATH}
fi

if [[ -d ${HOME}/.oh-my-zsh/plugins ]]; then
	if [[ ! -d ${HOME}/.oh-my-zsh/plugins/zshmarks ]]; then
		git clone https://github.com/jocelynmallon/zshmarks  ~/.oh-my-zsh/plugins/zshmarks && chmod 755 ~/.oh-my-zsh/plugins/zshmarks -R  && echo -e "\nInstall zshmarks successfully!\n" \
			|| ( echo "Error occured!exit.";exit 3 )
        cd ${APP_PATH}
	fi
else
	echo -e "\nError!Please install oh-my-zsh first.\n"
fi

if [[ ! -d ${HOME}/.tmux/plugins/tpm ]]; then
	echo -e "\nInstall tmux plugin manager ...\n"
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && echo -e "\nInstall tpm successfully!\n"  || ( echo "Error occured!exit.";exit 3 )
    cd ${APP_PATH}
fi

if [[ ! -d ${HOME}/.tmux/plugins/tmux-resurrect ]]; then
	echo -e "\nInstall tmux plugin tmux-resurrect ...\n"
	git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect && echo -e "\nInstall tmux-resurrect successfully!\n"  || ( echo "Error occured!exit.";exit 3 )
    cd ${APP_PATH}
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

#install emacs config
bash -c "$(curl -fsSL https://git.io/vAZ0K)"

if [[ $OS == 'Darwin' ]]; then
    cd launchd/ && ./install.sh && cd -
fi
#install vim config
bash -c "$(curl -fsSL https://git.io/vNDOQ)"


${install_cmd} ${APP_PATH}/.zshrc ${HOME}/.zshrc
is_tmux_3=$(tmux -V | grep next-3)
if [[  -z ${is_tmux_3} ]]; then
    ${install_cmd} ${APP_PATH}/.tmux.conf ${HOME}/.tmux.conf
else
    ${install_cmd} ${APP_PATH}/.tmux3.conf ${HOME}/.tmux.conf
fi
${install_cmd} ${APP_PATH}/.gitconfig ${HOME}/.gitconfig
${install_cmd} ${APP_PATH}/minirc.dfl ${HOME}/.minirc.dfl
${install_cmd} ${APP_PATH}/ssh_config ${HOME}/.ssh/config
${install_cmd} ${APP_PATH}/.tigrc ${HOME}/.tigrc

${install_cmd} ${APP_PATH}/.bashrc ${HOME}/.bashrc
${install_cmd} ${APP_PATH}/.bash_prompt ${HOME}/.bash_prompt
${install_cmd} ${APP_PATH}/.bash_profile ${HOME}/.bash_profile
${install_cmd} ${APP_PATH}/.aliases ${HOME}/.aliases
${install_cmd} ${APP_PATH}/.functions ${HOME}/.functions
${install_cmd} ${APP_PATH}/.path ${HOME}/.path

echo -e "\n"
if [[ $OS == "Linux" ]]; then
	sudo cp -a ./desktop_files/*.desktop /usr/share/applications/
fi
rm -rf temp
echo -e "\n\nInstall Finish..."

# vim: set fdm=marker foldlevel=0 foldmarker&:
