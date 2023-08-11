case "${OSTYPE}" in
darwin*)
	alias ls="ls -G"
	alias ll="ls -lG"
	alias la="ls -laG"
	;;
linux*)
	alias ls='ls --color=auto'
	alias ll='ls -alF'
	alias la='ls -A'
	alias l='ls -CF'
	;;
esac
#---- 入力コマンドの履歴機能を設定する ------------------------------------------
HISTFILE=~/.zsh_history    # 履歴ファイルの指定
HISTSIZE=10000         # 履歴の記憶量
SAVEHIST=10000           # 履歴の保存量
setopt hist_ignore_dups    # 直前と同じコマンドラインはヒストリに追加しない
bindkey -e
bindkey "^?"    backward-delete-char
bindkey "^H"    backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
#---- プロンプトを設定する ------------------------------------------------------
setopt prompt_subst
unsetopt promptcr
## プロンプトの設定
autoload colors
colors
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
autoload -Uz is-at-least
if is-at-least 4.3.10; then
    # zshが4.3.10以上の場合にcheck-for-changesを有効にする
    zstyle ':vcs_info:git:*' check-for-changes true
    zstyle ':vcs_info:git:*' stagedstr "+"
    zstyle ':vcs_info:git:*' unstagedstr "-"
    zstyle ':vcs_info:git:*' formats '(%s)[%b]%u%c'
    zstyle ':vcs_info:git:*' actionformats '%s,%u%c,%b|%a'
fi

# プロンプトを表示直前に呼び出される組み込みのprecmd()関数をフックする関数
function _precmd_vcs_info() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    psvar[1]=$vcs_info_msg_0_
}
add-zsh-hook precmd _precmd_vcs_info
RPROMPT="%1(v|%F{blue}%1v%f|)"
# プロンプト定義
local DEFAULTC=$'%{\e[m%}'
local LEFTC='%{$fg[cyan]%}' #$'%{\e[38;5;37m%}'
#local RIGHTC=$'%{\e[38;5;88m%}'
RPROMPT+="%(?.%F{green}[OK]%f.%F{red}[Fail]%f)"
#SPROMPT="%r is correct? [n,y,a,e]: "
PROMPT="$LEFTC%n@%m$DEFAULTC %c
%% "
PROMPT2='>> '
if [ "$TERM" = "xterm" -o "$TERM" = "kterm" ]
then
  hostname=`hostname -s`
  function _setcaption() { echo -ne "\e]1;${hostname}\a\e]2;${hostname}$1\a" > /dev/tty }
  # ディレクトリを移動したら、ウィンドウのタイトルを
  # ホスト名:現在地 のように変更
  function chpwd() {  print -Pn "\e]2; %n@%m %~\a" }
  # 初期設定してあげる(cd . でも可)
  chpwd
  # 特定のコマンド実行中は、タイトルを ホスト名 (コマンド 名) のように
  # 変更
  function _cmdcaption() { _setcaption " ($1)"; "$@"; chpwd }
  for cmd in telnet slogin ssh rlogin rsh su sudo
  do
    alias $cmd="_cmdcaption $cmd"
  done
fi
###############################################################
#into bash
###############################################################
# some more ls aliases
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
case "${OSTYPE}" in
darwin*)
	;;
linux*)
	alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
	;;
esac
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

case "${OSTYPE}" in
darwin*)
	switch-arch() {
        if  [[ "$(uname -m)" == arm64 ]]; then
            arch=x86_64
        elif [[ "$(uname -m)" == x86_64 ]]; then
            arch=arm64e
        fi
        exec arch -arch $arch "$SHELL" -l
	}
	;;
linux*)
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
	;;
esac
# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh)"

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
#For Ubuntu
if [ -f /etc/zsh_command_not_found ]; then
  . /etc/zsh_command_not_found
fi

unsetopt list_beep
zstyle ':completion:*' menu select
zstyle ':completion:*' format '%F{white}%d%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' completer _oldlist _complete _match _ignored \
  _approximate _list _history

# auto-fu.zsh
function () { # precompile
    local A
    A=$HOME/auto-fu.zsh/auto-fu.zsh
    [[ -e "${A:r}.zwc" ]] && [[ "$A" -ot "${A:r}.zwc" ]] ||
    zsh -c "source $A; auto-fu-zcompile $A ${A:h}" >/dev/null 2>&1
}

if [ -f $HOME/zshlib/auto-fu.zsh/auto-fu.zsh ]; then
  source $HOME/zshlib/auto-fu.zsh/auto-fu.zsh
  function zle-line-init () {
    auto-fu-init
  }
  zle -N zle-line-init
  zstyle ':completion:*' completer _expand _complete _match _prefix\
	  _approximate _list _history
  zstyle ':auto-fu:var' postdisplay $'
auto-fu>'
  zstyle ':auto-fu:highlight' input bold
  zstyle ':auto-fu:highlight' completion fg=black,bold
  zstyle ':auto-fu:highlight' completion/one fg=white,bold,underline
  setopt   auto_list auto_param_slash list_packed rec_exact
fi

#syntax highlighting
if [ -f $HOME/zshlib/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source $HOME/zshlib/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
export LANG=ja_JP.utf8
#############################################################
#end bash backport setting
#############################################################
## 補完機能の強化
autoload -U compinit
compinit
setopt complete_aliases

#import export environment variables
if [ -f ~/.zshenv ]; then
  . ~/.zshenv
fi
if [ -f ~/.zsh_function ]; then
  . ~/.zsh_function
fi
#for rbenv
export RBENV_ROOT="${HOME}/.rbenv"
if [ -d "${RBENV_ROOT}" ]; then
  export PATH="${RBENV_ROOT}/bin:$PATH"
  eval "$(rbenv init -)"
fi

# notify pwd to ansi-term
function chpwd_emacs_ansi_term() {
    echo '\033AnSiTc' $PWD
}

if [ $EMACS ]; then
    chpwd_functions=($chpwd_functions chpwd_emacs_ansi_term)

    echo "\033AnSiTu" $USER
    echo "\033AnSiTh" $HOST
    chpwd_emacs_ansi_term
    export TERM=xterm-color
fi
# for eshell
[[ $EMACS = t ]] && unsetopt zle

# hsenv
# alias hsenva='source ~/.hsenv/bin/activate'
alias hsenva78='source ~/.haskell/hsenv/ghc-7.8.3/.hsenv/bin/activate'
# for cabal-sandbox installed binary
export PATH=./.cabal-sandbox/bin:$PATH
# pyenv
export PYENV_ROOT="${HOME}/.pyenv"
if [ -d "${PYENV_ROOT}" ]; then
    export PATH=${PYENV_ROOT}/bin:$PATH
    eval "$(pyenv init -)"
fi
# for packer
PACKERDIR=/media/work/packer
if [ -d $PACKERDIR ]; then
	export PATH=$PACKERDIR:$PATH
fi

# OPAM configuration
. ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# for cargo install
if [ -d ~/.cargo/bin ]; then
	export PATH=~/.cargo/bin:$PATH
fi

#import export environment variables
if [ -f ~/.zsh_profile ]; then
  . ~/.zsh_profile
fi
export ANDROID_HOME=/media/Data2/adt-bundle-linux-x86_64/sdk
if [ -d $ANDROID_HOME ]; then
  export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH
  export LD_LIBRARY_PATH=$ANDROID_SDK_HOME/tools/lib:$LD_LIBRARY_PATH
fi
case "${OSTYPE}" in
darwin*)
    export GOPATH=~/go/lib
    export LANG=ja_JP.UTF-8
    export XMODIFIERS=@im=uim
    export GTK_IM_MODULE=uim
    ;;
linux*)
	;;
esac

if [ -f $HOME/.cargo/env ]; then
    . $HOME/.cargo/env
fi
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
## create emacs env file
perl -wle \
    'do { print qq/(setenv "$_" "$ENV{$_}")/ if exists $ENV{$_} } for @ARGV' \
    PATH > ~/.emacs.d/shellenv.el

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi
