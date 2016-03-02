# author      :tracyone
# date        :2013-08-25/17:25:29
# lastchange  :2014-02-23/01:20:00
# ---------------------------------------------------

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="mgutz"

OS=$(uname)

if [[ ${OS} == "Linux" ]]; then
	alias locate='locate -r'  #regular expression support
	alias ls='ls --color=auto'
	alias ll='ls -ahl'
	alias open='xdg-open'
	alias la='ls -A'
	alias gvim='gvim 2>/dev/null'
	export PATH=$PATH:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/local/bin:/home/tracyone/work/vpr_rdk/Source/ti_tools/linux_devkit/bin/nfsroot/arm-linux-gdb/bin:/opt/CodeSourcery/Sourcery_G++_Lite/bin:/opt/Clang/bin
elif [[ ${OS} == "Darwin" ]]; then
	alias locate="locate"  #regular expression support
	alias gvim=mvim
	# instead of coreutils 
	PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:$PATH"
	export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
fi

which nvim > /dev/null
if [[ $? -eq 0 ]]; then
	#alias nvim='nvim -u ~/.nvimrc'
	alias nvim="stty stop '' -ixoff ; nvim"
	# {{{deal with ctrl-s in vim
	# `Frozing' tty, so after any command terminal settings will be restored
	ttyctl -f

	# {{{
	# bash
	# No ttyctl, so we need to save and then restore terminal settings
	nvim()
	{
		local STTYOPTS="$(stty --save)"
		stty stop '' -ixoff
		command nvim "$@"
		stty "$STTYOPTS"
	}
	# }}}
	# }}}
fi
#{{{vim()
alias vim="stty stop '' -ixoff ; vim"
vim()
{
	local STTYOPTS="$(stty --save)"
	stty stop '' -ixoff
	command vim "$@"
	stty "$STTYOPTS"
}
#}}}

#{{{ aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias l='ls -CF'
alias c='clear'
alias cls='clear'
alias o='nautilus'
alias -s gz='tar -xzvf'
alias -s bz2='tar -xjvf'
alias -s zip='unzip'
alias gtab='gvim --remote-tab-silent '
alias wps='wps 2>/dev/null'
alias j='jump'
alias b='bookmark'
alias evince='evince 2>/dev/null'
alias et='et 2>/dev/null'
alias minicom="minicom -C ~/work/debug_info/$(date +%Y%m%d%H%M%S).log"
#}}}

# {{{shell basic setting

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
export UPDATE_ZSH_DAYS=30

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

export MGLS_LICENSE_FILE="C:\\flexlm\\license.dat"
export SVN_EDITOR=vim
export MINICOM='-m -c on' 


# }}}

# {{{plugin setting
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git OSX autojump mvn gradle history-substring-search command-not-found \
	 svn web-search zshmarks ssh-agent) 

zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
source $ZSH/oh-my-zsh.sh
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh

autoload -U compinit promptinit
compinit
# }}}

which tmux > /dev/null
if [[ $? -eq 0  ]]; then
	case $- in *i*)
		[ -z "$TMUX" ] && exec $(TERM=xterm-256color tmux -2)
	esac
fi
export TERM=xterm-256color

ssh-add -l >/dev/null 
if [[ $? -ne 0 ]]; then
	file_lst=$(find ${HOME}/.ssh/ -name "*.pub")
	for i in ${file_lst}; do
		ssh-add ${i%.pub}
	done
fi

# vim: set fdm=marker foldlevel=0:
