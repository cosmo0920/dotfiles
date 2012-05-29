;; OS��Ƚ�̡�UNIX�ϡ�
(defvar run-unix
  (or (equal system-type 'gnu/linux)
      (or (equal system-type 'usg-unix-v)
          (or  (equal system-type 'berkeley-unix)
               (equal system-type 'cygwin)))))
; OS��Ƚ�̡�����Ƚ��
(defvar run-linux
  (equal system-type 'gnu/linux))
(defvar run-system-v
  (equal system-type 'usg-unix-v)); OpenSolaris2090.06
(defvar run-bsd
  (equal system-type 'berkeley-unix))
(defvar run-cygwin ;; cygwin��unix���롼�פˤ��Ƥ���
  (equal system-type 'cygwin))

(defvar run-w32
  (and (null run-unix)
       (or (equal system-type 'windows-nt)
           (equal system-type 'ms-dos))))
(defvar run-darwin (equal system-type 'darwin))
;;for Ubuntu setting
(when run-linux
  (setq load-path (append '("~/.emacs.d/site-lisp/"
                            "~/.emacs.d/site-elisp/"
							"~/.emacs.d/elisp/"
                            )
                            load-path))
  ;;Ubuntu����apt-get����Elisp�Ϥ������֤����
  (let ((default-directory "/usr/share/emacs/site-lisp/"))
    (normal-top-level-add-subdirs-to-load-path))
)
;;for OSX setting
(when run-darwin
  (add-to-list 'load-path "~/.emacs.d/site-elisp/")
  (add-to-list 'load-path "~/.emacs.d/apel/")
  (add-to-list 'load-path "~/.emacs.d/"))
;;for Ubuntu setting
(when run-linux
  (load-file "~/.emacs.d/cedet/common/cedet.el")
  (require 'semantic-gcc)
  ;;(global-ede-mode t)
  (require 'semanticdb)
  ;; if you want to enable support for gnu global
  (when (cedet-gnu-global-version-check t)
    (require 'semanticdb-global)
    (semanticdb-enable-gnu-global-databases 'c-mode)
    (semanticdb-enable-gnu-global-databases 'c++-mode))
  (defun my-semantic-hook ()
    ;;for linux Kernel Reading (x86)
    (semantic-add-system-include "/media/Data/Kernel/linux-3.4.0/include" 'c-mode)
    (semantic-add-system-include "/media/Data/Kernel/linux-3.4.0/arch/x86/include" 'c-mode)
    ;;for BSD Kernel Reading
    (semantic-add-system-include "/media/Data/RemoteRepo/Subversion/BSD/bhyve_inc/lib/libvmmapi" 'c-mode)
    (semantic-add-system-include "/media/Data/RemoteRepo/Subversion/BSD/bhyve_inc/sys/amd64/vmm" 'c-mode)
    (semantic-add-system-include "/media/Data/RemoteRepo/Subversion/BSD/9.0.0/sys/" 'c-mode)
	;;for boost library
	(semantic-add-system-include "/media/Data/libboost_1_49_0/include" 'c++-mode)

	;;�ؿ���̾���������Υ��������٤�imenu���ɲ�
    (imenu-add-to-menubar "cedet-TAGS")
  )
  (semantic-load-enable-gaudy-code-helpers)
  ;;����¾�������ꤹ���
  (add-hook 'semantic-init-hooks 'my-semantic-hook)
  (add-hook 'c++-mode-common-hook 'my-c++-mode-cedet-hook)
  
  (defun my-cedet-hook ()
    (local-set-key [(control return)] 'semantic-ia-complete-symbol) 
    ;(local-set-key "." 'semantic-complete-self-insert)
    ;(local-set-key ">" 'semantic-complete-self-insert)
    (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
    (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
    (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
    (local-set-key "\C-xp" 'eassist-switch-h-cpp)
    (local-set-key "\C-xe" 'eassist-list-methods)
	;;����ܥ�λ��Ȥ򸡺�
    (local-set-key "\C-c/" 'semantic-symref)
	;;insert get/set methoid pair inc class field
    (local-set-key "\C-cgs" 'srecode-insert-getset)
	;;�����ȤΤҤʷ�������
	(local-set-key "\C-ci" 'srecode-document-insert-comment)
  )
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
(require 'auto-complete)
(require 'auto-complete-config)    ; ɬ�ܤǤϤʤ��Ǥ������
;�䴰��auto-complete�����뤫���פ�ʤ�����
;(define-key global-map "\C-c\C-i" 'dabbrev-expand)   
;; dirty fix for having AC everywhere
(define-globalized-minor-mode real-global-auto-complete-mode
  auto-complete-mode (lambda ()
                       (if (not (minibufferp (current-buffer)))
                         (auto-complete-mode 1))
                       ))
;;�䴰�����C-n/C-p�Ǥ�����Ǥ���褦��
;;Vimmer�ˤϴ򤷤����⡣
(add-hook 'auto-complete-mode-hook
          (lambda ()
            (define-key ac-completing-map (kbd "C-n") 'ac-next)
            (define-key ac-completing-map (kbd "C-p") 'ac-previous)))
(real-global-auto-complete-mode t)
;;twmode
(when run-darwin
  (add-to-list 'exec-path "/opt/local/bin"))
(autoload 'twittering-mode "twittering-mode" "Emacs twitter client." t)
(setq twittering-icon-mode t)
(setq twittering-use-master-password t)
(setq twittering-update-status-function 'twittering-update-status-from-pop-up-buffer)
(setq twittering-convert-fix-size 48)
(setq twittering-timer-interval 90)
(setq twittering-initial-timeline-spec-string
      '(":favorites"
        ":direct_messages"
        ":replies"
        ":home"))
 (add-hook 'twittering-mode-hook
           (lambda ()
             (mapc (lambda (pair)
                     (let ((key (car pair))
                           (func (cdr pair)))
                       (define-key twittering-mode-map
                         (read-kbd-macro key) func)))
                   '(("T" . twittering-friends-timeline)
                     ("R" . twittering-replies-timeline)
                     ("U" . twittering-user-timeline)
                     ("W" . twittering-update-status-interactive)
					 ("F". twittering-favorite )))))
;; ���ֹ�ɽ��
(require 'linum)
(global-linum-mode t)
; twmode ��̵���ˤ���
(defadvice linum-on(around my-linum-twmode-on() activate)
  (unless (eq major-mode 'twittering-mode) ad-do-it))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;verify file mode section
;;--------------------------------------------------------------------------
;;such as ... 
;;C,C++,C#,Ruby,Obj-C,Haskell,CUDA,Python,Fortran,org-mode,lua,go,rust,perl,D
;;and so on.
;;--------------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;org-mode
;(require 'org)
(autoload 'org-install "org-mode" "md lang" t)
;(require 'org-install)
(add-hook 'org-mode-hook 'turn-on-visual-line-mode)
(setq org-startup-truncated nil)	; �ե�������ޤ��������֤ǳ���
(setq org-return-follows-link t)	; return �ǥ�󥯤��ɤ�
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode)) 	; *.org �� org-mode�ǳ���
(setq org-directory "/media/Data/Document/org-memo/")
;;Haskell-mode
(setq auto-mode-alist
  (append auto-mode-alist
    '(("\\.[hg]s$"  . haskell-mode)    
      ("\\.hi$"     . haskell-mode)
      ("\\.l[hg]s$" . literate-haskell-mode))))

(autoload 'haskell-mode "haskell-mode"
          "Major mode for editing Haskell scripts." t)
(autoload 'literate-haskell-mode "haskell-mode"
          "Major mode for editing literate Haskell scripts." t)

(add-hook 'haskell-mode-hook 'turn-on-haskell-font-lock)
(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-hugs) ; Hugs��
(add-hook 'haskell-mode-hook 'turn-on-haskell-ghci)  
;#!/usr/bin/env runghc ��
(add-to-list 'interpreter-mode-alist '("runghc" . haskell-mode)) 
;#!/usr/bin/env runhaskell ��
(add-to-list 'interpreter-mode-alist '("runhaskell" . haskell-mode))
;;for obj-c
(setq auto-mode-alist
(append '(("\\.h$" . objc-mode)
("\\.m$" . objc-mode))))
;;org-mode for tex
(setq org-export-latex-coding-system 'utf-8)
(setq org-export-latex-date-format "%Y-%m-%d")
;;for c
(setq auto-mode-alist (cons '("\\.c$" . c-mode) auto-mode-alist))
;;for asm
(setq auto-mode-alist (cons '("\\.S$" . asm-mode) auto-mode-alist))
;;for java
(setq auto-mode-alist (cons '("\\.java$" . java-mode) auto-mode-alist))
;;for c++
(setq auto-mode-alist (cons '("\\.cpp$". c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cc$". c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cxx$". c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.hpp$". c++-mode) auto-mode-alist))
;;for ruby
(setq auto-mode-alist (cons '("\\.rb$". ruby-mode) auto-mode-alist))
;;for python
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
;; for fortran
(setq auto-mode-alist (cons '("\\f$" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.f90$" . fortran-mode) auto-mode-alist))
;;for lua
(autoload 'lua-mode "lua-mode" "LightweightLang." t)
(setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
;;for go mode
(autoload 'go-mode "go-mode" "GoLang" t)
(setq auto-mode-alist (cons '("\\.go$". go-mode) auto-mode-alist))
;;for perl mode
(setq auto-mode-alist (cons '("\\.pl$". perl-mode) auto-mode-alist))
;;rust-mode
(autoload 'rust-mode "rust-mode" "a mozilla's language." t)
(setq auto-mode-alist (cons '("\\.rs$". rust-mode) auto-mode-alist))
;; for C# mode
(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist (cons '("\\.cs$" . csharp-mode) auto-mode-alist))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;C# mode setting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Patterns for finding Microsoft C# compiler error messages:
(require 'compile)
(push '("^\\(.*\\)(\\([0-9]+\\),\\([0-9]+\\)): error" 1 2 3 2) compilation-error-regexp-alist)
(push '("^\\(.*\\)(\\([0-9]+\\),\\([0-9]+\\)): warning" 1 2 3 1) compilation-error-regexp-alist)

;; Patterns for defining blocks to hide/show:
(push '(csharp-mode
	"\\(^\\s *#\\s *region\\b\\)\\|{"
	"\\(^\\s *#\\s *endregion\\b\\)\\|}"
	"/[*/]"
	nil
	hs-c-like-adjust-block-beginning)
      hs-special-modes-alist)
;;cuda-mode
(autoload 'cuda-mode "cuda-mode" "NVIDIA GPGPU Computing Lang." t)
(setq auto-mode-alist (cons '("\\.cu\\w?" . cuda-mode) auto-mode-alist))
;;tuareg-mode forb OCaml
(setq auto-mode-alist (cons '("\\.ml\\w?" . tuareg-mode) auto-mode-alist))
(autoload 'tuareg-mode "tuareg-mode" "Major mode for editing Caml code" t)
;;for D Lang
(autoload 'd-mode "d-mode" "Major mode for editing D code." t)
(add-to-list 'auto-mode-alist '("\\.d[i]?\\'" . d-mode))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;verify mode section end.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;for magit
(autoload 'magit "magit" "Emacs git client." t)
;; �ޤ���install-elisp �Υ��ޥ�ɤ�Ȥ����ͤˤ��ޤ���
(autoload 'install-elisp "install-elisp" "install emacs lisp" t)
;; ���ˡ�Elisp �ե�����򥤥󥹥ȡ��뤹�������ꤷ�ޤ���
(setq install-elisp-repository-directory "~/.emacs.d/elisp/")
;;;Hide message
(setq inhibit-startup-message t)
(load "elscreen" "ElScreen" t)
;; ��ư���Υ�����,ɽ������,�ե���Ȥ����
(setq initial-frame-alist
      (append (list
	       '(width . 85)
	       '(height . 45)
	      )
	      initial-frame-alist))
(setq default-frame-alist initial-frame-alist)
(setq-default tab-width 4)
(setq default-tab-width 4)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60
                      64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���ܸ����Ϥ�����
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-language-environment "Japanese")
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
  (global-set-key "\C-\\" 'ibus-toggle))
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
(setq default-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8-unix)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ede-project-directories (quote ("/media/Data/Document")))
 '(haskell-notify-p t)
 '(haskell-process-type (quote cabal-dev)))
(when run-linux
  (custom-set-faces
    ;; custom-set-faces was added by Custom.
    ;; If you edit it by hand, you could mess it up, so be careful.
    ;; Your init file should contain only one such instance.
    ;; If there is more than one, they won't work right.
   '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 83 :width normal :foundry "unknown" :family "VL �����å�"))))))
;;chmod +x
(defun make-file-executable ()
  "Make the file of this buffer executable, when it is a script source."
  (save-restriction
    (widen)
    (if (string= "#!" (buffer-substring-no-properties 1 (min 3 (point-max))))
        (let ((name (buffer-file-name)))
          (or (equal ?. (string-to-char (file-name-nondirectory name)))
              (let ((mode (file-modes name)))
                (set-file-modes name (logior mode (logand (/ mode 4) 73)))
                (message (concat "Wrote " name " (+x)"))))))))
(add-hook 'after-save-hook 'make-file-executable)
;;change default directory for Ubuntu
(when run-linux
  (cd "/media/Data/Document")
)
;;change default directory for OSX
(when run-darwin
  (cd "~/Document/")
)
(when run-linux
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 83 :width normal :foundry "unknown" :family "VL �����å�")))))
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;����¾��¿������
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; �Хå����åץե��������ʤ�
(setq backup-inhibited t)
;;; ��λ���˥����ȥ����֥ե������ä�
(setq delete-auto-save-files t)
;;; ���̤��줿�ե�������Խ��Ǥ���褦�ˤ���
(auto-compression-mode t)
;;; �����ȥ�С��˥ե�����̾��ɽ������
(setq frame-title-format (format "emacs@%s : %%f" (system-name)))
;;; �⡼�ɥ饤��˻��֤�ɽ������
(display-time)
(which-function-mode 1)
;; spell check
(setq-default flyspell-mode t)
(setq ispell-dictionary "american")