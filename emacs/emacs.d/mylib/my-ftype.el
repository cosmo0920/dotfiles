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
(setq auto-mode-alist (cons '("\\.org$" . org-mode) auto-mode-alist)) 	; *.org を org-modeで開く
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
;;for ruby
(setq auto-mode-alist (cons '("Gemfile$". ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("Rakefile$". ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("Vagrantfile$". ruby-mode) auto-mode-alist))
(eval-after-load "ruby-end"
  '(progn (abbrev-mode 1)
          (electric-pair-mode t)
          (electric-indent-mode t)
          (electric-layout-mode t)))
;;for python
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
;; for fortran
(setq auto-mode-alist (cons '("\\.f$" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.for$" . fortran-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.f90$" . fortran-mode) auto-mode-alist))
;;for go mode
(autoload 'go-mode "go-mode" "GoLang" t)
(setq auto-mode-alist (cons '("\\.go$". go-mode) auto-mode-alist))
;;for perl mode
(setq auto-mode-alist (cons '("\\.pl$". perl-mode) auto-mode-alist))
;; for SML mode
(autoload 'sml-mode "sml-mode" "Major mode for editing SML code." t)
(setq auto-mode-alist (cons '("\\.sml$" . sml-mode) auto-mode-alist))
;;for OpenCL
(setq auto-mode-alist (cons '("\.cl$" . c-mode) auto-mode-alist))
;;tuareg-mode for OCaml
(add-hook 'tuareg-mode-hook '(lambda ()
  (define-key tuareg-mode-map [f10] 'caml-types-show-type); requires caml-types
  ))
(autoload 'caml-types-show-type "caml-types" "Show the type of expression or pattern at point." t)
;;for D Lang
(autoload 'd-mode "d-mode" "Major mode for editing D code." t)
(setq auto-mode-alist (cons '("\\.d[i]?\\'" . d-mode) auto-mode-alist))
;;for Rails(erb)
(autoload 'rhtml-mode "rhtml-mode" "RHTML" t)
(setq auto-mode-alist (cons '("\\.rhtml$" . rhtml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.html\.erb$" . rhtml-mode) auto-mode-alist))
;;css
(autoload 'css-mode "css-mode" "CSS" t)
(setq auto-mode-alist (cons '("\\.css$" . css-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.scss$" . css-mode) auto-mode-alist))
;;js2-mode
(autoload 'js2-mode "js2-mode" "Javascript" t)
(setq auto-mode-alist (cons '("\\.js$" . js2-mode) auto-mode-alist))
;;haml-mode
(add-hook 'haml-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (define-key haml-mode-map "\C-m" 'newline-and-indent)))
;;for Kuin
(autoload 'kuin-mode "kuin-mode" "Kuin" t)
(add-hook 'kuin-mode-hook '(lambda () (font-lock-mode 1)))
(setq auto-mode-alist (cons '("\\.kn$" 'kuin-mode) auto-mode-alist))
;; ;;;;
;; bison-mode / flex-mode
;; ;;;;
(autoload 'bison-mode "bison-mode" nil t)
;; *.y *.yy ファイルを 自動的に bison-mode にする
(setq auto-mode-alist
      (cons '("\.\(y\|yy\)$" . bison-mode) auto-mode-alist))
(autoload 'flex-mode "flex-mode" nil t)
;; *.l *.ll ファイルを 自動的に flex-mode にする
(setq auto-mode-alist
      (cons '("\.\(l\|ll\)$" . flex-mode) auto-mode-alist))
;; coffee-mode(emacs goodies)
(setq auto-mode-alist (cons '("Cakefile" . coffee-mode) auto-mode-alist))
;;Haskell-mode
(eval-after-load "haskell-mode"
  '(progn
     (add-hook 'haskell-mode-hook 'haskell-hook)
))
(defun haskell-hook ()
  (turn-on-haskell-simple-indent)
  (turn-on-haskell-indent)
  (turn-on-haskell-indentation)
  (turn-on-haskell-doc)
  (turn-on-haskell-indentdecl-scan)
  (autoload 'ghc-init "ghc" nil t)
  (add-hook 'haskell-mode-hook
            (lambda () (ghc-init)))
  (add-to-list 'ac-sources 'ac-source-ghc-mod)
)
;; Customization
(custom-set-variables
  ;; Use notify.el (if you have it installed) at the end of running
  ;; Cabal commands or generally things worth notifying.
  '(haskell-notify-p t)

  ;; To enable tags generation on save.
  '(haskell-tags-on-save t)

  ;; To enable stylish on save.
  '(haskell-stylish-on-save t))

;;nemerle-mode
(autoload 'nemerle-mode "nemerle" "Major mode for editing nemerle." nil t)
(setq auto-mode-alist (cons '("\\.n$" . nemerle-mode) auto-mode-alist))
;;ats-mode
(autoload 'ats-mode "ats-mode" "Major mode for editing ats." nil t)
(setq auto-mode-alist (cons '("\\.dats$" . ats-mode) auto-mode-alist))
;;idris-mode
(autoload 'idris-mode "idris-mode" "Major mode for editing Idris." nil t)
(setq auto-mode-alist (cons '("\\.idr$" . idris-mode) auto-mode-alist))
