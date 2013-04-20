;;OS判別
(load-file "~/.emacs.d/mylib/my-ostype.el")
(provide 'my-semantic)
(when run-linux
  ;; http://stackoverflow.com/questions/15853753/autocompletion-in-cedet
  ;; sedet-trunk for Emacs 24.3
  (setq cedet-root-path (file-name-as-directory "~/.emacs.d/cedet/"))
  (load-file (concat cedet-root-path "cedet-devel-load.el"))
  (add-to-list 'load-path (concat cedet-root-path "contrib"))

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
  
  (defun qt-cedet-setup ()
    "Set up c-mode and related modes. Includes support for Qt code (signal, slots and alikes)."
    
    ;; add knowledge of qt to emacs
    (setq qt4-base-dir (concat (getenv "QTDIR") "/include"))
    (semantic-add-system-include (concat qt4-base-dir "/Qt") 'c++-mode)
    (semantic-add-system-include (concat qt4-base-dir "/QtGui") 'c++-mode)
    (semantic-add-system-include (concat qt4-base-dir "/QtCore") 'c++-mode)
    (semantic-add-system-include (concat qt4-base-dir "/QtTest") 'c++-mode)
    (semantic-add-system-include (concat qt4-base-dir "/QtNetwork") 'c++-mode)
    (semantic-add-system-include (concat qt4-base-dir "/QtSvg") 'c++-mode)
    (add-to-list 'auto-mode-alist (cons qt4-base-dir 'c++-mode))
    (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig.h"))
    (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig-large.h"))
    (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qglobal.h"))
    ;; qt keywords and stuff ...
    ;; set up indenting correctly for new qt kewords
    (setq c-protection-key (concat "\\<\\(public\\|public slot\\|protected"
				   "\\|protected slot\\|private\\|private slot"
				   "\\)\\>")
	  c-C++-access-key (concat "\\<\\(signals\\|public\\|protected\\|private"
				   "\\|public slots\\|protected slots\\|private slots"
				   "\\)\\>[ \t]*:"))

    ;; modify the colour of slots to match public, private, etc ...
    (font-lock-add-keywords 'c++-mode '(("\\<\\(slots\\|signals\\)\\>" . font-lock-type-face)))
    ;; make new font for rest of qt keywords
    (make-face 'qt-keywords-face)
    (set-face-foreground 'qt-keywords-face "BlueViolet")
    ;; qt keywords
    (font-lock-add-keywords 'c++-mode '(("\\<Q_[A-Z]*\\>" . 'qt-keywords-face)))
    (font-lock-add-keywords 'c++-mode '(("\\<SIGNAL\\|SLOT\\>" . 'qt-keywords-face)))
    (font-lock-add-keywords 'c++-mode '(("\\<Q[A-Z][A-Za-z]*\\>" . 'qt-keywords-face)))
    (font-lock-add-keywords 'c++-mode '(("\\<Q[A-Z_]+\\>" . 'qt-keywords-face)))
    (font-lock-add-keywords 'c++-mode
			    '(("\\<q\\(Debug\\|Wait\\|Printable\\|Max\\|Min\\|Bound\\)\\>" . 'font-lock-builtin-face)))

    (setq c-macro-names-with-semicolon '("Q_OBJECT" "Q_PROPERTY" "Q_DECLARE" "Q_ENUMS"))
    (c-make-macro-with-semi-re)
    )
  (when (getenv "QTDIR") (add-hook 'c-mode-common-hook 'qt-cedet-setup))
  
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
    ))
)
