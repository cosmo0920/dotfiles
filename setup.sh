#!/bin/sh

# emacs
ln -s `pwd`/emacs/emacs.d/ ~/.emacs.d
# vim
if [ ! -d ~/.vim/rc/ ]; then
  mkdir -p ~/.vim/rc
  ln -s `pwd`/vim/rc/* ~/.vim/rc
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
bash shellenv.bash
