#user define aliases
alias vim='vim -f'
alias gvim='gvim -f'
alias ctags='ctags-exuberant'
case "${OSTYPE}" in
darwin*)
	export PKG_CONFIG_PATH=/usr/local/opt/libffi/lib/pkgconfig:/usr/local/opt/libxml2/lib/pkgconfig:$PKG_CONFIG_PATH
	export PATH=/usr/local/bin/:$PATH
	export PATH=~/Library/Haskell/bin/:$PATH
	;;
linux*)
	export PATH=~/.cabal/bin/:$PATH
	;;
esac
