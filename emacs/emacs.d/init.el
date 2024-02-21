;;use melpa
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(fset 'package-desc-vers 'package--ac-desc-version)
(package-initialize)
;;OS判別とload-pathの設定
(load-file "~/.emacs.d/init/loadpath.el")
(require 'load-path-subdir)
;;; site-lispディレクトリをサブディレクトリごとload-pathに追加
(add-to-load-path-with-subdir "site-lisp")
;; loading init/package-install
(require 'package-install)
;;.emacs.d/mylib以下を読み込む
(require 'load_mylib)
;;.emacs.d/rc.d以下を読み込む
(require 'load_rc.d)
;;; afterディレクトリをサブディレクトリごとload-pathに追加
(add-to-load-path-with-subdir "after")
;;上の2つが読み終わった後に読み込む
(require 'after-init)
