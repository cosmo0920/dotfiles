;;OS判別
;;(load-file "~/.emacs.d/mylib/my-ostype.el")
(provide 'my-langenv)
;;my japanese language Emacs environment setting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 日本語入力の設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;for Ubuntu setting
(when run-linux
  ;; ibus-mode
  (require 'ibus)
  ;; Turn on ibus-mode automatically after loading .emacs
  (add-hook 'after-init-hook 'ibus-mode-on)
  ;; Use C-SPC for Set Mark command
  (ibus-define-common-key ?\C-\s nil)
  ;; Use C-/ for Undo command
  (ibus-define-common-key ?\C-/ nil)
  ;; Change cursor color depending on IBus status
  (setq ibus-cursor-color '("limegreen" "white" "yellow"))
  (global-set-key "\C-\\" 'ibus-toggle)
  ;; 変換キーでon、無変換キーでoffで切り替え
  (global-set-key
   [henkan]
   (lambda () (interactive)
     (when (null current-input-method) (toggle-input-method))))
  (global-set-key
   [muhenkan]
   (lambda () (interactive)
     (inactivate-input-method)))
  (defadvice mozc-handle-event (around intercept-keys (event))
    "Intercept keys muhenkan and zenkaku-hankaku, before passing keys to mozc-server (which the function mozc-handle-event does), to properly disable mozc-mode."
  (if (member event (list 'zenkaku-hankaku 'muhenkan))
      (progn (mozc-clean-up-session)
             (toggle-input-method))
    (progn ;(message "%s" event) ;debug
      ad-do-it)))
  (ad-activate 'mozc-handle-event)
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; UTF-8 and Japanese Setting

;                      'unicode)
(set-coding-system-priority 'utf-8
                            'euc-jp
                            'iso-2022-jp
                            'cp932)
(set-language-environment 'Japanese)
(set-terminal-coding-system 'utf-8)
(setq file-name-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(setq buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8-unix)

(when run-linux
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 83 :width normal :foundry "unknown" :family "VL ゴシック"))))))
