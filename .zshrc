# author      :tracyone
# date        :2013-08-25/17:25:29
# lastchange  :2014-02-23/01:20:00
# ---------------------------------------------------

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# for faster loading,we use zsh buildin command zcompile
# to compile the .zshrc
if [ ! -f ~/.zshrc.zwc -o ~/.zshrc -nt ~/.zshrc.zwc ]; then
    zcompile ~/.zshrc
fi

# environment {{{

export EDITOR=vim
export LANG=en_US.UTF-8

# Better umask
umask 022

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Print core files?
#unlimit
#limit core 0
#limit -s
#limit coredumpsize  0

# improved less option
export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS'

export MGLS_LICENSE_FILE="C:\\flexlm\\license.dat"
export SVN_EDITOR=vim
export MINICOM='-m -c on' 

OS=$(uname)

if [[ ${OS} == "Linux" ]]; then
	export PATH=$PATH:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/local/bin:/home/tracyone/work/vpr_rdk/Source/ti_tools/linux_devkit/bin/nfsroot/arm-linux-gdb/bin:/opt/CodeSourcery/Sourcery_G++_Lite/bin:/opt/Clang/bin
	alias open='xdg-open'
elif [[ ${OS} == "Darwin" ]]; then
	alias gvim=mvim
	export EVENT_NOKQUEUE=1
	# instead of coreutils 
	PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:$PATH"
	export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
fi

# }}}

# aliases {{{
# Global aliases {{{
alias -g A="| awk"
alias -g G="| grep"
alias -g GV="| grep -v"
alias -g H="| head"
alias -g L="| $PAGER"
alias -g P=' --help | less'
alias -g R="| ruby -e"
alias -g S="| sed"
alias -g T="| tail"
alias -g V="| vim -R -"
alias -g U=' --help | head'
alias -g W="| wc"
# }}}
# you can type filename with following subffix and zsh will open it with default specifial command
# Suffix aliases {{{
alias -s zip=zipinfo
alias -s tgz=gzcat
alias -s gz=gzcat
alias -s tbz=bzcat
alias -s bz2=bzcat
alias -s java=vim
alias -s c=vim
alias -s h=vim
alias -s C=vim
alias -s cpp=vim
alias -s txt=vim
alias -s xml=vim
alias -s html=chrome
alias -s xhtml=chrome
alias -s gif=display
alias -s jpg=display
alias -s jpeg=display
alias -s png=display
alias -s bmp=display
alias -s mp3=amarok
alias -s m4a=amarok
alias -s ogg=amarok
# }}}
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
alias minicom="minicom -C $(date +%Y%m%d%H%M%S).log"
alias vi="vim -u NONE"
alias locate='locate -r'  #regular expression support
alias gvim='gvim 2>/dev/null'
export MANPAGER="vim -c 'set ft=neoman' -"
#}}}

# keybinds {{{

# emacs keybinds
bindkey -e

# History completion
# autoload history-search-end
# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end
# bindkey "^p" history-beginning-search-backward-end
# bindkey "^n" history-beginning-search-forward-end
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# Like bash
bindkey "^u" backward-kill-line

# }}}

# oh-my-zsh setting {{{

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="mortalscumbag"

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

# {{{plugin setting
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git OSX autojump history-substring-search command-not-found \
	 svn web-search zshmarks  github git-flow sudo ) 

zmodload zsh/terminfo
source $ZSH/oh-my-zsh.sh
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh

autoload -U compinit promptinit
compinit
# }}}
# }}}

# Functions {{{

# source config
r() {
    source ~/.zshrc
    if [ -d ~/.zsh/comp ]; then
        # Reload complete functions
        local f
        f=(~/.zsh/comp/*(.))
        unfunction $f:t 2> /dev/null
        autoload -U $f:t
    fi
}

vim()
{
	local STTYOPTS="$(stty --save)"
	stty stop '' -ixoff
	command vim "$@"
	stty "$STTYOPTS"
}
# }}}

# other {{{
# {{{tmux
which tmux > /dev/null
if [[ $? -eq 0  ]]; then
	case $- in *i*)
		[ -z "$TMUX" ] && exec $(TERM=xterm-256color tmux -2)
	esac
fi
export TERM=xterm-256color
# }}}"

# }}}

# vim: set fdm=marker foldlevel=0:
