;; 同名のファイルを開いたとき親のディレクトリ名も表示
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;;for magit
(autoload 'magit "magit" "Emacs git client." nil t)
(when (locate-library "magit")
  (global-set-key (kbd "C-x g") 'magit-status))
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
(cond
 ((equal (file-exists-p "/usr/bin/zsh") t)
  (setq ansi-term-shell-name "/usr/bin/zsh"))
 ((equal (file-exists-p "/bin/zsh") t)
  (setq ansi-term-shell-name "/bin/zsh"))
 ((equal (file-exists-p "/bin/bash") t)
  (setq ansi-term-shell-name "/bin/bash"))
 ((equal (file-exists-p "/bin/dash") t)
  (setq ansi-term-shell-name "/bin/dash"))
 ((equal (file-exists-p "/usr/bin/tcsh") t)
  (setq ansi-term-shell-name "/usr/bin/tcsh"))
 ((equal (file-exists-p "/usr/bin/csh") t)
  (setq ansi-term-shell-name "/usr/bin/csh"))
 (t
  (setq ansi-term-shell-name "/bin/sh")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(shell-pop-shell-type (quote ("ansi-term" "*ansi-term*" (lambda nil (ansi-term shell-pop-term-shell)))))
 '(shell-pop-term-shell ansi-term-shell-name)
 '(shell-pop-universal-key "C-t")
 '(shell-pop-window-height 30)
 '(shell-pop-window-position "bottom"))
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
;; basic
(define-key global-map (kbd "C-u") 'undo)                 ; undo
(define-key global-map (kbd "M-C-g") 'grep)               ; grep
(require 'whitespace)
(setq whitespace-style '(face              ; faceを使って視覚化する。
                         trailing          ; 行末の空白を対象とする。
                         lines-tail        ; 長すぎる行のうち
                                           ; whitespace-line-column以降のみを
                                           ; 対象とする。
                         space-before-tab  ; タブの前にあるスペースを対象とする。
                         space-after-tab)) ; タブの後にあるスペースを対象とする。

;; デフォルトで視覚化を有効にする。
(global-whitespace-mode 1)
;;; 行の先頭でC-kを一回押すだけで行全体を消去する
(setq kill-whole-line t)
;;to ensure that your files have no trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)
; make characters after column 80 purple
(setq whitespace-style
  (quote (face trailing tab-mark)))
(add-hook 'find-file-hook 'whitespace-mode)
(eval-when-compile (require 'cl)
  (defun toggle-delete-trailing-whitespace-setting ()
    (interactive)
    (cond ((find 'delete-trailing-whitespace before-save-hook)
           (remove-hook 'before-save-hook 'delete-trailing-whitespace))
          (
           (add-hook 'before-save-hook 'delete-trailing-whitespace)))
))
;; 再帰的にgrep
;; http://www.clear-code.com/blog/2012/3/20.html
(require 'grep)
(setq grep-command-before-query "grep -nH -r -e ")
(defun grep-default-command ()
  (if current-prefix-arg
      (let ((grep-command-before-target
             (concat grep-command-before-query
                     (shell-quote-argument (grep-tag-default)))))
        (cons (if buffer-file-name
                  (concat grep-command-before-target
                          " *."
                          (file-name-extension buffer-file-name))
                (concat grep-command-before-target " ."))
              (+ (length grep-command-before-target) 1)))
    (car grep-command)))
(setq grep-command (cons (concat grep-command-before-query " .")
                         (+ (length grep-command-before-query) 1)))
(when (locate-library "anzu")
  (eval-when-compile (require 'anzu))
  (global-anzu-mode +1)
  (global-set-key (kbd "M-%") 'anzu-query-replace)
  (global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp)
)
(provide 'init_setting)
