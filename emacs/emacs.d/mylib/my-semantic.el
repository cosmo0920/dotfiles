;;OS判別
(load-file "~/.emacs.d/mylib/my-ostype.el")
(provide 'my-semantic)
(when run-linux
  (load-file "~/.emacs.d/cedet/cedet-devel-load.el")
  (setq semantic-load-turn-everything-on t)
  (semantic-load-enable-code-helpers)
  (eval-when-compile 
    (require 'semantic/senator)
    (require 'semantic)
    (require 'semantic/ia)
    (require 'semantic/symref)
    (require 'semantic/symref/list)
    (require 'semantic/analyze)
    (require 'semantic/bovine/gcc)
    ;;(global-ede-mode t)
    (require 'semantic/db)
    ;; function definition is void: eieio-build-class-alist
    (require 'eieio)
    (require 'eieio-opt)
    ;;(require 'eassist)
    ;; ctags
    (require 'semantic/tag)
	)
  ;;(semantic-load-enable-secondary-exuberent-ctags-support)
  ;; if you want to enable support for gnu global
  (defun kernel-version()(replace-regexp-in-string "\n+$" "" (shell-command-to-string "uname -r")))
  (defun kernel-version-onlynum()(replace-regexp-in-string "-custom-fornewercore2\n+$" "" (shell-command-to-string "uname -r")))
  (defun my-semantic-hook ()
    ;;for linux Kernel Reading (x86)
    (semantic-add-system-include (format "/media/Data/Kernel/linux-%s/include" (kernel-version-onlynum)) 'c-mode)
    (semantic-add-system-include (format "/media/Data/Kernel/linux-%s/arch/x86/include" (kernel-version-onlynum)) 'c-mode)
    (semantic-add-system-include (format "/usr/src/linux-headers-%s/" (kernel-version)) 'c-mode)
    ;;for BSD Kernel Reading
    (semantic-add-system-include "/media/Data/RemoteRepo/Subversion/BSD/head/lib/libvmmapi" 'c-mode)
    (semantic-add-system-include "/media/Data/RemoteRepo/Subversion/BSD/head/sys/amd64/vmm" 'c-mode)
    (semantic-add-system-include "/media/Data/RemoteRepo/Subversion/BSD/head/sys/" 'c-mode)
    ;;for boost library
    (semantic-add-system-include "/media/Data/libboost_1_53_0/include" 'c++-mode)
    ;; for glib-2.0
    (semantic-add-system-include "/usr/include/glib-2.0" 'c-mode)
    (semantic-add-system-include "/usr/lib/x86_64-linux-gnu/glib-2.0/include" 'c-mode)
    ;;関数と名前空間等のタグに飛べるimenuの追加
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
    ;;(semantic-mode 1)
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
       global-semantic-mru-bookmark-mode
    )))
