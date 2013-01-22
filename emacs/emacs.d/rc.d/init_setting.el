;; 同名のファイルを開いたとき親のディレクトリ名も表示
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;;for magit
(autoload 'magit "magit" "Emacs git client." t)
;; ファイルの履歴
(require 'recentf)
(when (locate-library "recentf")
  (require 'recentf-ext)
  (recentf-mode t)
  (setq recentf-exclude '("^\\.emacs\\.bmk$"))
  (setq recentf-auto-cleanup 'never) ;;tramp対策。
  (setq recentf-max-menu-items 10)
  (setq recentf-max-saved-items 20)
  (recentf-mode 1)
)
(require 'shell-pop)
(shell-pop-set-internal-mode "ansi-term")
(shell-pop-set-internal-mode-shell "/usr/bin/zsh")
;;shell-pop.elの設定
(defvar ansi-term-after-hook nil)
(add-hook 'ansi-term-after-hook
          (function
           (lambda ()
             (define-key term-raw-map "\C-t" 'shell-pop))))
(defadvice ansi-term (after ansi-term-after-advice (arg))
  "run hook as after advice"
  (run-hooks 'ansi-term-after-hook))
(ad-activate 'ansi-term)
(global-set-key "\C-t" 'shell-pop)
;; use shift + arrow keys to switch between visible buffers
(require 'windmove)
(windmove-default-keybindings)
(provide 'init_setting)

