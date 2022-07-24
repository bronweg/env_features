# -------------------------
# Manual settings.
# -------------------------

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias lh='ll -h'
alias la='ls -A'
alias l='ls -CF'
alias adb='/home/ulis/Downloads/adt-bundle-linux/sdk/platform-tools/adb'
alias fastboot='/home/ulis/Downloads/adt-bundle-linux/sdk/platform-tools/fastboot'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
alias k=kubectl
complete -F __start_kubectl k

####################
### User defined ###
####################
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
#PS1='\[\033[01;30m\][\A] \[\033[01;31m\][\[\033[01;34m\]\h\[\033[01;34m\] \W\[\033[01;31m\]] \[\033[00;31m\]\$\[\033[00m\] '
#PS1="\[\033]0;$PWD\007\]\[\033[33m\][\D{%Y-%m-%d %H:%M.%S}]\[\033[0m\] \[\033[35m\]\w\[\033[0m\] \[\033\n[36m\][\u.\h]\[\033[0m\] \[\033(0\]b\[\033(B\]"
PS1="\[\033[36m\][\u@\h]\[\033[0m\] \[\033(0\]b\[\033(B\]\n\[\033]0;$PWD\007\]\[\033[33m\][\D{%Y-%m-%d %H:%M.%S}]\[\033[0m\] \[\033[35m\]\w\[\033[36m\]:\[\033[0m\]\$(parse_git_branch) "


case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}\007"'
    ;;
*)
    ;;
esac

function dns {
        grep '^nameserver' /etc/resolv.conf | cut -c 12- | xargs -i host $1 {} | grep -B 5 "has address"
}

function docker-ssh {
	docker exec -it $1 /bin/bash;
}

bind 'set enable-bracketed-paste off'

parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
current_cluster() {
	kubectx --current
}
current_namespace() {
	kubens --current
}
#source /usr/lib/kube-ps1.sh
#PS1='\[\033[01;30m\][\A] \[\033[01;31m\][\[\033[01;34m\]\h\[\033[01;34m\] \W\[\033[01;31m\]] \[\033[00;31m\]\$\[\033[00m\] '
#PS1="\[\033]0;$PWD\007\]\[\033[33m\][\D{%Y-%m-%d %H:%M.%S}]\[\033[0m\] \[\033[35m\]\w\[\033[0m\] \[\033\n[36m\][\u.\h]\[\033[0m\] \[\033(0\]b\[\033(B\]"
#PS1="\[\033[36m\][\u@\h]\[\033[0m\] \[\033(0\]b\[\033(B\]\n\[\033[32m\]\$(current_cluster)/\[\033[32m\]\$(current_namespace)\n\[\033]0;$PWD\007\]\[\033[33m\][\D{%Y-%m-%d %H:%M.%S}]\[\033[0m\] \[\033[35m\]\w\[\033[36m\]:\[\033[0m\]\$(parse_git_branch) "
PS1="\[\033[36m\][\u@\h]\[\033[0m\] \[\033(0\]b\[\033(B\]\n\[\033[32m\]\$(kube_ps1)\n\[\033]0;$PWD\007\]\[\033[33m\][\D{%Y-%m-%d %H:%M.%S}]\[\033[0m\] \[\033[35m\]\w\[\033[36m\]:\[\033[0m\]\$(parse_git_branch) "


case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}\007"'
    ;;
*)
    ;;
esac

function dns {
        grep '^nameserver' /etc/resolv.conf | cut -c 12- | xargs -i host $1 {} | grep -B 5 "has address"
}

function docker-ssh {
	docker exec -it $@ /bin/bash;
}

function kx {
  case $1 in
    "")
      kubectx
      ;;
    lab)
      kubectx dwh-dwh-illab-cluster
      ;;
    stg)
      case $2 in
        sun1)
          kubectx stg_dwh_sun1
          ;;
        ber1)
          kubectx stg_tis_ber1
          ;;
        fra1)
          echo "Staging cluster in FRA1 still hasn't been configured"
          ;;
        "")
          echo "Error! You have to provide an argument of exact staging environment do you want to connect"
          ;;
        *)
          echo "Error! Unknown argument $2 for staging environment"
          ;;
      esac
      ;;
    prd)
      case $2 in
        sun1)
          kubectx prd_all_sun1
          ;;
        ber1)
          kubectx prd_dwh_ber1
          ;;
        fra1)
          kubectx prd_tis_fra1
          ;;
        "")
          echo "Error! You have to provide an argument of exact production environment do you want to connect"
          ;;
        *)
          echo "Error! Unknown argument $2 for production environment"
          ;;
      esac
      ;;
    *|--)
      if [[ $1 == "--" ]]; then
        shift
      else
        echo -e "Error! Unknown argument $1\nRunning a regular kubectx with all provided arguments."
      fi
      kubectx $@
      ;;
  esac
}

alias ns="kubens"
source "/home/linuxbrew/.linuxbrew/opt/kube-ps1/share/kube-ps1.sh"
export PATH=${PATH}:/home/$USER/.local/bin
alias idea="/home/$USER/Downloads/idea-IU-221.5591.52/bin/idea.sh"
alias atom="/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=atom --file-forwarding io.atom.Atom"
alias meld="/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=meld --file-forwarding org.gnome.meld"
