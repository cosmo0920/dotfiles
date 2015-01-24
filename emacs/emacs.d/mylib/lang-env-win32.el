(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'japanese-cp932) ;; Shift-JIS
(set-language-info "Japanese" 'input-method "W32-IME")
(set-language-environment "Japanese")
(setq w32-ime-buffer-switch-p nil)
;;; IME の設定
(setq-default w32-ime-mode-line-state-indicator "[--]")
(setq w32-ime-mode-line-state-indicator-list '("[--]" "[あ]" "[--]"))
;; (w32-ime-initialize)

;;; IME ON/OFF 時にカーソル色を変える。
(setq ime-activate-cursor-color "#00a000")
(setq ime-inactivate-cursor-color "#000000")
(set-cursor-color ime-inactivate-cursor-color)
;; ※input-method-activate-hook, input-method-inactivate-hook じゃない方がいい感じになる。
(add-hook 'w32-ime-on-hook
          (function (lambda ()
                      (set-cursor-color ime-activate-cursor-color))))
(add-hook 'w32-ime-off-hook
          (function (lambda ()
                      (set-cursor-color ime-inactivate-cursor-color))))
(provide 'lang-env-win32)
