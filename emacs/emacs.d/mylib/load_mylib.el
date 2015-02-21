(eval-when-compile (load-file "~/.emacs.d/init/ostype.el"))
;; semanticの設定
;; (require 'my-semantic)
;;verify file mode
(require 'my-ftype)
;; 日本語入力の設定
(require 'my-langenv)
;; 雑多な設定 @my-econf
(require 'my-econf)
(provide 'load_mylib)
