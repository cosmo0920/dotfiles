;; 行番号表示
(require 'linum)
(global-linum-mode t)
;; twmode で無効にする
(defadvice linum-on(around my-linum-twmode-on() activate)
  (unless (eq major-mode 'twittering-mode) ad-do-it))
;;http://d.hatena.ne.jp/rubikitch/20100423/bytecomp
;;自動バイトコンパイルを行う
(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)))
;;便利関数
(require 'my-func)
;;powerline
(eval-when-compile
  (require 'cl))
(require 'powerline)
(provide 'after-init)
