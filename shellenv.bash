#!/bin/bash
# create emacs env file
perl -wle \
    'do { print qq/(setenv "$_" "$ENV{$_}")/ if exists $ENV{$_} } for @ARGV' \
        PATH > ~/.emacs.d/shellenv.el
