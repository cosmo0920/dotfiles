;;for Ubuntu setting
(eval-when-compile (require 'my-ostype))
(provide 'my-semantic)
(when run-linux
  (load-file "~/.emacs.d/cedet/common/cedet.el")
  (setq semantic-load-turn-everything-on t)
  (semantic-load-enable-code-helpers)
  (require 'semantic/senator)
  (require 'semantic)
  (require 'semantic-ia)
  (require 'semantic-symref)
  (require 'semantic-symref-list)
  (require 'semantic-load)
  (require 'semantic-gcc)
  ;;(global-ede-mode t)
  (require 'semanticdb)
  ;; function definition is void: eieio-build-class-alist
  (require 'eieio)
  (require 'eieio-opt)
  (require 'eassist)
  ;; ctags
  (require 'semanticdb-ectag)
  (semantic-load-enable-secondary-exuberent-ctags-support)
  ;; if you want to enable support for gnu global
  (when (cedet-gnu-global-version-check t)
    (require 'semanticdb-global)
    (semanticdb-enable-gnu-global-databases 'c-mode)
    (semanticdb-enable-gnu-global-databases 'c++-mode))
  (defun my-semantic-hook ()
    ;;for linux Kernel Reading (x86)
    (semantic-add-system-include "/media/Data/Kernel/linux-3.6.3/include" 'c-mode)
    (semantic-add-system-include "/media/Data/Kernel/linux-3.6.3/arch/x86/include" 'c-mode)
    ;;for BSD Kernel Reading
    (semantic-add-system-include "/media/Data/RemoteRepo/Subversion/BSD/bhyve_inc/lib/libvmmapi" 'c-mode)
    (semantic-add-system-include "/media/Data/RemoteRepo/Subversion/BSD/bhyve_inc/sys/amd64/vmm" 'c-mode)
    (semantic-add-system-include "/media/Data/RemoteRepo/Subversion/BSD/9.0.0/sys/" 'c-mode)
    ;;for boost library
    (semantic-add-system-include "/media/Data/libboost_1_51_0/include" 'c++-mode)
    ;; for glib-2.0
    (semantic-add-system-include "/usr/include/glib-2.0" 'c-mode)
    (semantic-add-system-include "/usr/lib/x86_64-linux-gnu/glib-2.0/include" 'c-mode)
    ;;関数と名前空間等のタグに飛べるimenuの追加
    (imenu-add-to-menubar "cedet-TAGS"))

  (semantic-load-enable-gaudy-code-helpers)
  (setq semantic-load-turn-useful-things-on t)
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
  (setq qt4-base-dir "/usr/include/qt4")
  (semantic-add-system-include qt4-base-dir 'c++-mode)
  (add-to-list 'auto-mode-alist (cons qt4-base-dir 'c++-mode))
  (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig.h"))
  (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig-dist.h"))
  (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qglobal.h"))
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
