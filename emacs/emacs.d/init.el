;;OS判別とload-pathの設定
(load-file "~/.emacs.d/rc.d/init_loadpath.el")
;;.emacs.d/mylib以下を読み込む
(require 'load_mylib)
;;.emacs.d/rc.d以下を読み込む
(require 'load_rc.d)
;;上の2つが読み終わった後に読み込む
(require 'after-init)
