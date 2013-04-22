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
(cond
 ((equal (file-exists-p "/usr/bin/zsh") t)
  (shell-pop-set-internal-mode-shell "/usr/bin/zsh"))
 ((equal (file-exists-p "/bin/zsh") t)
  (shell-pop-set-internal-mode-shell "/bin/zsh"))
 ((equal (file-exists-p "/bin/bash") t)
  (shell-pop-set-internal-mode-shell "/bin/bash"))
 ((equal (file-exists-p "/bin/dash") t)
  (shell-pop-set-internal-mode-shell "/bin/dash")) 
 ((equal (file-exists-p "/usr/bin/tcsh") t)
  (shell-pop-set-internal-mode-shell "/usr/bin/tcsh")) 
 ((equal (file-exists-p "/usr/bin/csh") t)
  (shell-pop-set-internal-mode-shell "/usr/bin/csh")) 
 (t
  (shell-pop-set-internal-mode-shell "/bin/sh")))
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
;;C-RET RET -- cua-mode
(cua-mode t)
(setq cua-enable-cua-keys nil) ;; 変なキーバインド禁止
(provide 'init_setting)
