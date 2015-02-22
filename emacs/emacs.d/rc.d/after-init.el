;; -*- coding: euc-jp -*-
;; 行番号表示
(require 'linum)
(global-linum-mode t)
;; twmode で無効にする
(defadvice linum-on(around my-linum-twmode-on() activate)
  (unless (eq major-mode 'twittering-mode) ad-do-it))
;; linum を ansi-term で無効にする
(defadvice linum-on(around my-linum-term-on() activate)
  (unless (eq major-mode 'term-mode) ad-do-it))
;;http://d.hatena.ne.jp/rubikitch/20100423/bytecomp
;;自動バイトコンパイルを行う
(when (require 'auto-async-byte-compile nil t)
  (setq auto-async-byte-compile-exclude-files-regexp "/junk/")
  (add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (setq indent-tabs-mode nil))))
;;便利関数
 (require 'my-func)
;;powerline
(eval-when-compile
  (require 'cl))
(when (require 'powerline nil t)
  (powerline-default-theme))
;; 他挙動を変更したい場合
(require 'after-customize nil t)
(provide 'after-init)
