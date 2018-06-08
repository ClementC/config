# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Include date and time in history
HISTTIMEFORMAT="%d/%m/%y %T "

# When displaying prompt, write previous command to history file so that,
# any new shell immediately gets the history lines from all previous shells.
PROMPT_COMMAND='history -a'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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
alias la='ls -A'
alias l='ls -CF'
# Thanks Andreas Mueller for this one :)
alias nicelog='git log --graph --decorate --all --oneline'

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
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi



# Prompt
lred="\[\e[1;31m\]"
lgreen="\[\e[1;32m\]"
lyellow="\[\e[1;33m\]"
lblue="\[\e[1;34m\]"
lpurple="\[\e[1;35m\]"
lcyan="\[\e[1;36m\]"
lwhite="\[\e[1;37m\]"

dred="\[\e[0;31m\]"
dgreen="\[\e[0;32m\]"
dorange="\[\e[0;33m\]"
dblue="\[\e[0;34m\]"
dpurple="\[\e[0;35m\]"
dcyan="\[\e[0;36m\]"
dgrey="\[\e[0;37m\]"

reset="\[\e[0m\]"

PROMPT_COMMAND='prompt'

function gitdir()
{
        if [ -z "${1-}" ]; then
                if [ -n "${__git_dir-}" ]; then
                        echo "$__git_dir"
                elif [ -d .git ]; then
                        echo .git
                else
                        git rev-parse --git-dir 2>/dev/null
                fi
        elif [ -d "$1/.git" ]; then
                echo "$1/.git"
        else
                echo "$1"
        fi
}


# Automatic activation of Python virtualenvs
function prompt()
{
  if [ "$PWD" != "$MYOLDPWD" ]; then
    MYOLDPWD="$PWD"
    test -f tools/setup_venv.sh && test -d virtualenv && source tools/setup_venv.sh
  fi
  __res=$?
  if test $(gitdir)
  then
    # Git prompt
    local name=$(basename $(readlink -f "$(gitdir)"/..))
    local path=$(readlink -f "$(pwd)" | sed -re s,$(readlink -f "$(gitdir)"/..),,)
    local branch=$(git symbolic-ref HEAD 2>/dev/null)
    branch=${branch##refs/heads/}
    local dirty=""
    git diff --no-ext-diff --quiet --exit-code || dirty="C"
    test -n "$(git ls-files --others --exclude-standard)" && dirty="${dirty}U"
    test -n "$dirty" && dirty=" $dirty"
    PS1="$dorange($branch) $dgreen$name$lyellow$path$lpurple$dirty$reset "
  else
    # Normal prompt
    local name=$(pwd | sed -re s,$(readlink -f ~),,)
    local home=$(pwd | grep -E "^$(readlink -f ~)" > /dev/null 2> /dev/null && echo '~')
    PS1="$lyellow$home$dgreen$name$reset "
  fi
  if test ! -z "$VIRTUALENV"
  then
      PS1="$dblue(virtualenv) $PS1"
  fi
  PS1="$PS1\`test \$__res -eq 0 && echo -n '$lgreen'[✔] || echo -n '$lred'[✘]; echo $reset\`"
  PS1="$PS1$lwhite→$reset "
  export PS1=$PS1
}
