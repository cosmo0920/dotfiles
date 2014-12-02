;;use melpa
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)
;;OS判別とload-pathの設定
(load-file "~/.emacs.d/rc.d/init_loadpath.el")
;; loading init/package-install
(require 'package-install)
;;.emacs.d/mylib以下を読み込む
(require 'load_mylib)
;;.emacs.d/rc.d以下を読み込む
(require 'load_rc.d)
;;上の2つが読み終わった後に読み込む
(require 'after-init)
