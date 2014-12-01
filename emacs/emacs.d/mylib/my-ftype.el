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
;;for c++
(setq auto-mode-alist (cons '("\\.cpp$". c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cc$". c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cxx$". c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.hpp$". c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.tmpl$". c++-mode) auto-mode-alist))
;;for ruby
(setq auto-mode-alist (cons '("\\.rb$". ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("Gemfile$". ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("Rakefile$". ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("Vagrantfile$". ruby-mode) auto-mode-alist))
(require 'ruby-end nil t)
(add-hook 'ruby-mode-hook
  '(lambda ()
    (abbrev-mode 1)
    (electric-pair-mode t)
    (electric-indent-mode t)
    (electric-layout-mode t)))
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
(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
(autoload 'camldebug "camldebug" "Run the Caml debugger" t)
;; (add-hook 'tuareg-mode-hook 'tuareg-imenu-set-imenu)
 (setq auto-mode-alist
       (append '(("\\.ml[ily]?$" . tuareg-mode)
                ("\\.topml$" . tuareg-mode))
               auto-mode-alist))
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
;;yaml
(autoload 'yaml-mode "yaml-mode" "YAML" t)
(setq auto-mode-alist (cons '("\\.yml$" . yaml-mode) auto-mode-alist))
;;css
(autoload 'css-mode "css-mode" "CSS" t)
(setq auto-mode-alist (cons '("\\.css$" . css-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.scss$" . css-mode) auto-mode-alist))
;;js2-mode
(autoload 'js2-mode "js2-mode" "Javascript" t)
(setq auto-mode-alist (cons '("\\.js$" . js2-mode) auto-mode-alist))
;;coffee-mode
(autoload 'coffee-mode "coffee" "Coffeescript" t)
(setq auto-mode-alist (cons '("\\.coffee$" . coffee-mode) auto-mode-alist))
;;haml-mode
(autoload 'haml-mode "haml-mode" "HAML" t)
(setq auto-mode-alist (cons '("\\.haml$" . haml-mode) auto-mode-alist))
(add-hook 'haml-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (define-key haml-mode-map "\C-m" 'newline-and-indent)))
;;scala-mode2
(autoload 'scala-mode "scala-mode2" "Scala" t)
(setq auto-mode-alist (cons '("\\.scala$" . scala-mode) auto-mode-alist))
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
(autoload 'coffee-mode "coffee-mode" "Major mode for editing CoffeeScript." t)
(setq auto-mode-alist (cons '("\\.coffee$" . coffee-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("Cakefile" . coffee-mode) auto-mode-alist))
;;Haskell-mode
(autoload 'haskell-mode-autoloads "haskell-mode-autoloads" "haskell-mode autoload." t)
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

;;hamlet-mode
(autoload 'hamlet-mode "hamlet-mode" "Major mode for editing hamlet." t)
(setq auto-mode-alist (cons '("\\.hamlet$" . hamlet-mode) auto-mode-alist))
;;nemerle-mode
(autoload 'nemerle-mode "nemerle" "Major mode for editing nemerle." nil t)
(setq auto-mode-alist (cons '("\\.n$" . nemerle-mode) auto-mode-alist))
;;ats-mode
(autoload 'ats-mode "ats-mode" "Major mode for editing ats." nil t)
(setq auto-mode-alist (cons '("\\.dats$" . ats-mode) auto-mode-alist))
;;idris-mode
(autoload 'idris-mode "idris-mode" "Major mode for editing Idris." nil t)
(setq auto-mode-alist (cons '("\\.idr$" . idris-mode) auto-mode-alist))
;;Dockerfile-mode
(autoload 'dockerfile-mode "dockerfile-mode" "Major mode for editing Dockerfile." nil t)
(add-to-list 'auto-mode-alist '("Dockerfile" . dockerfile-mode))
;;powershell-mode
(autoload 'powershell-mode "powershell-mode" "Major mode for editing powershell." nil t)
(add-to-list 'auto-mode-alist '("\\.ps1$" . powershell-mode))
