;;OS判別
(eval-when-compile (load-file "~/.emacs.d/init/ostype.el"))

(setq semantic-load-turn-everything-on t)
(semantic-load-enable-code-helpers)
;; select which submodes we want to activate
(mapc (lambda (MODE) (add-to-list 'semantic-default-submodes MODE))
      '(global-semantic-mru-bookmark-mode
        global-semanticdb-minor-mode
        global-semantic-idle-scheduler-mode
        global-semantic-stickyfunc-mode
        global-cedet-m3-minor-mode
        global-semantic-highlight-func-mode
        global-semanticdb-minor-mode))
;; Activate semantic
(semantic-mode 1)
;; load contrib library
(require 'eassist)

(defun my-semantic-hook ()
  (imenu-add-to-menubar "cedet-TAGS"))

(semantic-load-enable-gaudy-code-helpers)
(setq semantic-load-turn-useful-things-on t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ede-project-directories (quote ("/media/Data/Document")))
 '(haskell-notify-p t)
 '(haskell-process-type (quote cabal-dev)))
;;その他色々設定するよ
(add-hook 'semantic-init-hooks 'my-semantic-hook)
(add-hook 'c++-mode-common-hook 'my-c++-mode-cedet-hook)

(defun my-cedet-hook ()
  (local-set-key [(control return)] 'semantic-ia-complete-symbol)
                                        ;(local-set-key "." 'semantic-complete-self-insert)
                                        ;(local-set-key ">" 'semantic-complete-self-insert)
  ;;semanticのキーバインド関連
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
  (local-set-key "\M-o" 'eassist-switch-h-cpp)
  (local-set-key "\M-m" 'eassist-list-methods)
  (local-set-key "\C-cj" 'semantic-complete-jump-local)
  (local-set-key "\C-cn" 'senator-next-tag)
  (local-set-key "\C-cp" 'senator-previous-tag)
  ;;シンボルの参照を検索
  (local-set-key "\C-c\M-g" 'semantic-symref-symbol)
  (local-set-key "\C-c/" 'semantic-symref)
  (local-set-key "\C-c\M-l" 'semantic-analyze-possible-completions)
  ;;insert get/set methoid pair inc class field
  (local-set-key "\C-cgs" 'srecode-insert-getset)
  ;;コメントのひな形を生成
  (local-set-key "\C-ci" 'srecode-document-insert-comment))
(when (cedet-ectag-version-check t)
  (semantic-load-enable-primary-ectags-support))

;; SRecode
(global-srecode-minor-mode 1)

(add-hook 'c-mode-common-hook 'my-cedet-hook)
(add-hook 'c++-mode-common-hook 'my-cedet-hook)
(setq semantic-default-submodes
      '(
        global-semantic-idle-scheduler-mode
        global-semantic-idle-completions-mode
        global-semanticdb-minor-mode
        global-semantic-decoration-mode
        global-semantic-highlight-func-mode
        global-semantic-stickyfunc-mode
        global-semantic-mru-bookmark-mode))
(provide 'my-semantic)
