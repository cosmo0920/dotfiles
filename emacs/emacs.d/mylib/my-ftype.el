(provide 'my-ftype)
;;my autoload elisp library
;;verify file mode section
;;--------------------------------------------------------------------------
;;such as ... 
;;C,C++,C#,Ruby,Obj-C,Haskell,CUDA,Python,Fortran,org-mode,lua,go,rust,perl,D
;;and so on.
;;--------------------------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;org-mode
(autoload 'org "org" "md-lang" t)
(autoload 'org-install "org-mode" "md lang" t)
(add-hook 'org-mode-hook 'turn-on-visual-line-mode)
(setq org-startup-truncated nil)	; ファイルは折り畳んだ状態で開く
(setq org-return-follows-link t)	; return でリンクを追う
(add-to-list 'auto-mode-alist (cons '("\\.org$" . org-mode) auto-mode-alist)) 	; *.org を org-modeで開く
(setq org-directory "/media/Data/Document/org-memo/")
;;org-mode for tex
(setq org-export-latex-coding-system 'utf-8)
(setq org-export-latex-date-format "%Y-%m-%d")
;;for obj-c
 ;;
;; ===== Some basic XCode Integration =====
;;
(setq auto-mode-alist
       (cons '("\\.m$" . objc-mode) auto-mode-alist))
(setq auto-mode-alist
       (cons '("\\.mm$" . objc-mode) auto-mode-alist))

;;
;; ===== Opening header files =====
;; Allows to choose between objc-mode, c++-mode and c-mode
(defun bh-choose-header-mode ()
   (interactive)
   (if (string-equal (substring (buffer-file-name) -2) ".h")
       (progn
         ;; OK, we got a .h file, if a .m file exists we'll assume 
	 ;;it's an objective c file. Otherwise, we'll look for a .cpp file.
	 ;; if there's no matching .m or .cpp, then we assume objc as it might  
	 ;;be a protocol.
         (let ((dot-m-file (concat (substring (buffer-file-name) 0 -1)"m"))
               (dot-cpp-file (concat (substring (buffer-file-name) 0 -1) "cpp")))
           (if (file-exists-p dot-m-file)
               (progn
                 (objc-mode)
                 )
             (if (file-exists-p dot-cpp-file)
                 (c++-mode)
                 (objc-mode)
		 )
	     )
	   )
	 )
     )
   )

(add-hook 'find-file-hook 'bh-choose-header-mode)
;;(setq auto-mode-alist (cons ("\\.m$" . objc-mode) auto-mode-alist))
;;my C and C++ code style
(require 'my-codestyle)
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
(setq auto-mode-alist (cons '("\\.tmpl$". c++-mode) auto-mode-alist))
;;for ruby
(setq auto-mode-alist (cons '("\\.rb$". ruby-mode) auto-mode-alist))
;;for python
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
;; for fortran
(setq auto-mode-alist (cons '("\\.f$" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.for$" . fortran-mode) auto-mode-alist))
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
;; for SML mode
(autoload 'sml-mode "sml-mode" "Major mode for editing SML code." t)
(setq auto-mode-alist (cons '("\\.sml$" . sml-mode) auto-mode-alist))
;;for Emas Lisp mode
(autoload 'emacs-lisp-mode "emacs-lisp-mode" "editing ELisp." t)
(setq auto-mode-alist (cons '("\\.el$" . emacs-lisp-mode) auto-mode-alist))
(setq auto-mode-alist (cons '(".emacs$" . emacs-lisp-mode) auto-mode-alist))
;;for OpenCL
(setq auto-mode-alist (cons '("\.cl$" . c-mode) auto-mode-alist))
;;cuda-mode
(autoload 'cuda-mode "cuda-mode" "NVIDIA GPGPU Computing Lang." t)
(setq auto-mode-alist (cons '("\\.cu\\w?" . cuda-mode) auto-mode-alist))
;;tuareg-mode for OCaml
(setq auto-mode-alist (cons '("\\.ml\\w?" . tuareg-mode) auto-mode-alist))
(autoload 'tuareg-mode "tuareg-mode" "Major mode for editing Caml code" t)
;;for D Lang
(autoload 'd-mode "d-mode" "Major mode for editing D code." t)
(setq auto-mode-alist (cons '("\\.d[i]?\\'" . d-mode) auto-mode-alist))
;;for Kuin
(autoload 'kuin-mode "kuin-mode" nil t)
(add-hook 'kuin-mode-hook '(lambda () (font-lock-mode 1)))
(setq auto-mode-alist (cons '("\\.kn$" 'kuin-mode) auto-mode-alist))
;; ;;;;
;; bison-mode / flex-mode
;; ;;;;
(autoload 'bison-mode "bison-mode.el")
(setq auto-mode-alist (cons '("\\.y$" . bison-mode) auto-mode-alist))

(autoload 'flex-mode "flex-mode")
(setq auto-mode-alist (cons '("\\.l$" . flex-mode) auto-mode-alist))
;; coffee-mode
(autoload 'coffee-mode "coffee-mode" "Major mode for editing CoffeeScript." t)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))
;;Haskell-mode
(load "~/.emacs.d/elisp/haskell-mode/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'font-lock-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-ghci)
