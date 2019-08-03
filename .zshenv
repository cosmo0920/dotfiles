#user define aliases
alias vim='vim -f'
alias gvim='gvim -f'
alias sshnh='ssh -o "StrictHostKeyChecking no"'
case "${OSTYPE}" in
darwin*)
	export PKG_CONFIG_PATH=/usr/local/opt/libffi/lib/pkgconfig:/usr/local/opt/libxml2/lib/pkgconfig:$PKG_CONFIG_PATH
	export X11_PKG_CONFIG_PATH=/opt/X11/lib/pkgconfig
	export PATH=/usr/local/bin:$PATH
	export PATSHOME=/usr/local/lib/ats2-postiats-`brew info ats2-postiats | egrep "ats2-postiats/.*\*" | awk 'match($0, /[0-9]\.[0-9]\.[0-9]/) {print substr($0, RSTART, RLENGTH)}'`
	;;
linux*)
	alias ctags='ctags-exuberant'
	;;
esac
if [ -d ~/bin ]; then
	export PATH=~/bin:$PATH
fi
export LANG=ja_JP.UTF-8

# Add GHC 7.10.1 to the PATH, via https://ghcformacosx.github.io/
export GHC_DOT_APP="/Applications/ghc-7.10.1.app"
if [ -d "$GHC_DOT_APP" ]; then
  export PATH="${HOME}/.cabal/bin:${GHC_DOT_APP}/Contents/bin:${PATH}"
fi
# Set up rustup
if [ -d $HOME/.cargo/env ]; then
	source $HOME/.cargo/env
fi

. /Users/cosmo/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

if [ -d $HOME/.goenv ]; then
    export GOENV_ROOT="$HOME/.goenv"
    export PATH="$GOENV_ROOT/bin:$PATH"
    eval "$(goenv init -)"
    export PATH="$GOROOT/bin:$PATH"
    export PATH="$GOPATH/bin:$PATH"
fi
