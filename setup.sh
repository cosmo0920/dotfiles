#!/bin/sh

# emacs
ln -s `pwd`/emacs/emacs.d/ ~/.emacs.d
# vim
if [ ! -d ~/.vim/bundle/ ]; then
  mkdir -p ~/.vim/bundle
  git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
  git clone https://github.com/Shougo/vimproc ~/.vim/bundle/vimproc
fi
ln -s `pwd`/vimrc/vimrc ~/.vimrc
ln -s `pwd`/vimrc/gvimrc ~/.gvimrc
# zsh
ln -s `pwd`/.zshrc ~/.zshrc
#ln -s `pwd`/.zsh_profile ~/.zsh_profile
ln -s `pwd`/.zshenv ~/.zshenv
# git
ln -s `pwd`/.gitconfig ~/.gitconfig
ln -s `pwd`/.gitignore ~/.gitignore
# sbt
ln -s `pwd`/.sbtconfig ~/.sbtconfig
# opam
ln -s `pwd`/.ocamlinit ~/.ocamlinit
