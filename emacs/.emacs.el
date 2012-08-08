;; OSを判別、UNIX系？
(defvar run-unix
  (or (equal system-type 'gnu/linux)
      (or (equal system-type 'usg-unix-v)
          (or  (equal system-type 'berkeley-unix)
               (equal system-type 'cygwin)))))
; OSを判別、個別判別
(defvar run-linux
  (equal system-type 'gnu/linux))
(defvar run-system-v
  (equal system-type 'usg-unix-v)); OpenSolaris2090.06
(defvar run-bsd
  (equal system-type 'berkeley-unix))
(defvar run-cygwin ;; cygwinもunixグループにしておく
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
							"/usr/local/share/gtags/"
                            )
                            load-path))
  ;;Ubuntuだとapt-getしたElispはここに置かれる
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
    (semantic-add-system-include "/media/Data/Kernel/linux-3.5.0/include" 'c-mode)
    (semantic-add-system-include "/media/Data/Kernel/linux-3.5.0/arch/x86/include" 'c-mode)
    ;;for BSD Kernel Reading
    (semantic-add-system-include "/media/Data/RemoteRepo/Subversion/BSD/bhyve_inc/lib/libvmmapi" 'c-mode)
    (semantic-add-system-include "/media/Data/RemoteRepo/Subversion/BSD/bhyve_inc/sys/amd64/vmm" 'c-mode)
    (semantic-add-system-include "/media/Data/RemoteRepo/Subversion/BSD/9.0.0/sys/" 'c-mode)
	;;for boost library
	(semantic-add-system-include "/media/Data/libboost_1_49_0/include" 'c++-mode)

	;;関数と名前空間等のタグに飛べるimenuの追加
    (imenu-add-to-menubar "cedet-TAGS")
  )
  (semantic-load-enable-gaudy-code-helpers)
  ;;その他色々設定するよ
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
	;;シンボルの参照を検索
    (local-set-key "\C-c/" 'semantic-symref)
	;;insert get/set methoid pair inc class field
    (local-set-key "\C-cgs" 'srecode-insert-getset)
	;;コメントのひな形を生成
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
(require 'auto-complete-config)    ; 必須ではないですが一応
;補完。auto-completeがあるから要らないかも
;(define-key global-map "\C-c\C-i" 'dabbrev-expand)   
;; dirty fix for having AC everywhere
(define-globalized-minor-mode real-global-auto-complete-mode
  auto-complete-mode (lambda ()
                       (if (not (minibufferp (current-buffer)))
                         (auto-complete-mode 1))
                       ))
(when run-linux
  (require 'auto-complete-etags)) 
;;補完候補をC-n/C-pでも選択できるように
;;Vimmerには嬉しいかも。
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
;; 行番号表示
(require 'linum)
(global-linum-mode t)
(when run-linux
  (require 'anything)
  (require 'anything-config)
  (setq  anything-sources
     '(anything-c-source-buffers
       anything-c-source-imenu
       anything-c-source-emacs-commands
       ;;anything-c-source-etags-select
       ;;anything-c-source-gtags-select
      )) 
  (define-key global-map (kbd "C-x b") 'anything)
  (autoload 'gtags-mode "gtags" "" t))

; twmode で無効にする
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
(autoload 'org "org" "md-lang" t)
(autoload 'org-install "org-mode" "md lang" t)
(add-hook 'org-mode-hook 'turn-on-visual-line-mode)
(setq org-startup-truncated nil)	; ファイルは折り畳んだ状態で開く
(setq org-return-follows-link t)	; return でリンクを追う
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode)) 	; *.org を org-modeで開く
(setq org-directory "/media/Data/Document/org-memo/")
;;Haskell-mode
(load "/usr/share/emacs/site-lisp/haskell-mode/haskell-site-file")
(autoload 'haskell-mode "haskell-mode" "editing Haskell." t)
(autoload 'literate-haskell-mode "haskell-mode" "editing literate Haskell." t)
(autoload 'haskell-cabal "haskell-cabal" "editing Haskell cabal." t)
(autoload 'ghc-init "ghc" nil t)
(setq auto-mode-alist
  (append auto-mode-alist
    '(("\\.[hg]s$"  . haskell-mode)
      ("\\.hi$"     . haskell-mode)
      ("\\.l[hg]s$" . literate-haskell-mode)
      ("\\.cabal\\'" . haskell-cabal-mode))))
(add-hook 'haskell-mode-hook (lambda () (ghc-init)(flymake-mode)))
(add-hook 'haskell-mode-hook 'turn-on-haskell-font-lock)
(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-hugs) ; Hugs用
(add-hook 'haskell-mode-hook 'turn-on-haskell-ghci)  
;#!/usr/bin/env runghc 用
(add-to-list 'interpreter-mode-alist '("runghc" . haskell-mode)) 
;#!/usr/bin/env runhaskell 用
(add-to-list 'interpreter-mode-alist '("runhaskell" . haskell-mode))
;;for obj-c
(setq auto-mode-alist
(append '(("\\.h$" . objc-mode)
("\\.m$" . objc-mode))))
;;org-mode for tex
(setq org-export-latex-coding-system 'utf-8)
(setq org-export-latex-date-format "%Y-%m-%d")
;;for c
;;; C-mode,C++-modeの設定
(defconst my-c-style
  '(
    ;; 基本オフセット量の設定
    (c-basic-offset             . 2)
    ;; tab キーでインデントを実行
    (c-tab-always-indent        . t)
    ;; コメント行のオフセット量の設定
    (c-comment-only-line-offset . 0)
    ;; カッコ前後の自動改行処理の設定
    (c-hanging-braces-alist
     . (
        (class-open after)       ; クラス宣言の'{'の後
        (class-close nil)            ; クラス宣言の'}'の後
        (defun-open before after)       ; 関数宣言の'{'の前後
        (defun-close after)             ; 関数宣言の'}'の後
        (inline-open after)             ; クラス内のインライン
                                        ; 関数宣言の'{'の後
        (inline-close after)            ; クラス内のインライン
                                        ; 関数宣言の'}'の後
        (brace-list-close after) ; 列挙型、配列宣言の'}'の後
        (block-open after)              ; ステートメントの'{'の後
        (block-close after)             ; ステートメントの'}'前後
        (substatement-open after)       ; サブステートメント
                                        ; (if 文等)の'{'の後
        (statement-case-open after)     ; case 文の'{'の後
        (extern-lang-open after) ; 他言語へのリンケージ宣言の
                                        ; '{'の前後
        (extern-lang-close before)      ; 他言語へのリンケージ宣言の
                                        ; '}'の前
		(inexpr-class-open after)
		(inexpr-class-close before)
        ))
    ;; コロン前後の自動改行処理の設定
    (c-hanging-colons-alist
     . (
        (case-label after)              ; case ラベルの':'の後
        (label after)                   ; ラベルの':'の後
        (access-label after)            ; アクセスラベル(public等)の':'の後
        (member-init-intro)             ; コンストラクタでのメンバー初期化
                                        ; リストの先頭の':'では改行しない
        (inher-intro before)            ; クラス宣言での継承リストの先頭の
                                        ; ':'では改行しない
        ))
    ;; 挿入された余計な空白文字のキャンセル条件の設定
    ;; 下記の*を削除する
    (c-cleanup-list
     . (
	    brace-else-brace                ; else の直前
                                        ; "} * else {"  ->  "} else {"
        brace-elseif-brace              ; else if の直前
                                        ; "} * else if (.*) {"
                                        ; ->  } "else if (.*) {"
        empty-defun-braces              ; 空のクラス・関数定義の'}' の直前
                                        ;；"{ * }"  ->  "{}"
        defun-close-semi                ; クラス・関数定義後の';' の直前
                                        ; "} * ;"  ->  "};"
        list-close-comma                ; 配列初期化時の'},'の直前
                                        ; "} * ,"  ->  "},"
        scope-operator                  ; スコープ演算子'::' の間
                                        ; ": * :"  ->  "::"
        ))
    ;; オフセット量の設定
    ;; 必要部分のみ抜粋(他の設定に付いては info 参照)
    ;; オフセット量は下記で指定
    ;; +  c-basic-offsetの 1倍, ++ c-basic-offsetの 2倍
    ;; -  c-basic-offsetの-1倍, -- c-basic-offsetの-2倍
    (c-offsets-alist
     . (
        (arglist-intro          . ++)   ; 引数リストの開始行
        (arglist-close          . c-lineup-arglist) ; 引数リストの終了行
        (substatement-open      . ++)    ; サブステートメントの開始行
        (statement-cont         . ++)   ; ステートメントの継続行
        (case-label             . 0)    ; case 文のラベル行
        (label                  . 0)    ; ラベル行
        (block-open             . 0)    ; ブロックの開始行
		(member-init-intro      . ++)   ; メンバオブジェクトの初期化リスト
		(defun-block-intro      . +)    ; ブロックで字下げ
        ))
    ;; インデント時に構文解析情報を表示する
    (c-echo-syntactic-information-p . t)
    )
  "My C Programming Style")
;; hook 用の関数の定義
(defun my-c-mode-common-hook ()
  ;; my-c-stye を登録して有効にする
  (c-add-style "My C Programming Style" my-c-style t)

  ;; 次のスタイルがデフォルトで用意されているので選択してもよい
  ;; (c-set-style "gnu")
  ;; (c-set-style "k&r")
  ;; (c-set-style "bsd")
  ;; (c-set-style "linux")
  ;; (c-set-style "cc-mode")
  ;; (c-set-style "stroustrup")
  ;; (c-set-style "ellemtel")
  ;; (c-set-style "whitesmith")
  ;; (c-set-style "python")
  
  ;; 既存のスタイルを変更する場合は次のようにする
  ;; (c-set-offset 'member-init-intro '++)

  ;; auto-fill-mode を有効にする
  (auto-fill-mode t)
  ;; タブ長の設定
  (make-variable-buffer-local 'tab-width)
  (setq tab-width 4)
  ;; タブの代わりにスペースを使う
  (setq indent-tabs-mode nil)
  ;; 自動改行(auto-newline)を有効にする
  (setq c-auto-newline 1)
  ;; 最後に改行を入れる。
  (setq require-final-newline t)
  ;; 連続する空白の一括削除(hungry-delete)を有効にする
  (c-toggle-auto-hungry-state 1)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;参考：http://d.hatena.ne.jp/syohex/20110119/1295450495
  ;; for whitespace-mode
  (require 'whitespace)
  ;; see whitespace.el for more details
  (setq whitespace-style '(face tabs tab-mark spaces space-mark))
  (setq whitespace-display-mappings
    '((space-mark ?\u3000 [?\u25a1])
      ;; WARNING: the mapping below has a problem.
      ;; When a TAB occupies exactly one column, it will display the
      ;; character ?\xBB at that column followed by a TAB which goes to
      ;; the next TAB column.
      ;; If this is a problem for you, please, comment the line below.
      (tab-mark ?\t [?\xBB ?\t] [?\\ ?\t])))
  (setq whitespace-space-regexp "\\(\u3000+\\)")
  (set-face-foreground 'whitespace-tab "#20b2aa")
  (set-face-background 'whitespace-tab 'nil)
  (set-face-underline  'whitespace-tab t)
  (set-face-foreground 'whitespace-space "#4169e1")
  (set-face-background 'whitespace-space 'nil)
  (set-face-bold-p 'whitespace-space t)
  (global-whitespace-mode 1)
  (global-set-key (kbd "C-x w") 'global-whitespace-mode)
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; white space mode setting end
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; セミコロンで自動改行しない
  (setq c-hanging-semi&comma-criteria nil)

  ;; キーバインドの追加
  ;; ------------------
  ;; C-m        改行＋インデント
  ;; C-c c      コンパイルコマンドの起動
  ;; C-h        空白の一括削除
  (define-key c-mode-base-map "\C-m" 'newline-and-indent)
  (define-key c-mode-base-map "\C-cc" 'compile)
  (define-key c-mode-base-map "\C-h" 'c-electric-backspace)

  ;; コンパイルコマンドの設定
  ;; (setq compile-command "gcc ")
  ;;(setq compile-command "make -k ")
  (setq compile-command "")
  ;; (setq compile-command "gmake -k ")
)

;;; Ruby用のスタイル
(c-add-style
 "ruby"
 '("bsd"
   (c-basic-offset . 2)
   (knr-argdecl-intro . 2)
   (defun-block-intro . 2)
   ))
;;; Python用のスタイル
(c-add-style
 "python"
 '("python"
   (c-basic-offset . 2)
   (knr-argdecl-intro . 2)
   (defun-block-intro . 2)
   ))
;; モードに入るときに呼び出す hook の設定
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

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
;; for SML mode
(autoload 'sml-mode "sml-mode" "Major mode for editing SML code." t)
(setq auto-mode-alist (cons '("\\.sml$" . sml-mode) auto-mode-alist))
;;for Emas Lisp mode
(autoload 'emacs-lisp-mode "emacs-lisp-mode" "editing ELisp." t)
(setq auto-mode-alist (cons '("\\.el$" . emacs-lisp-mode) auto-mode-alist))
(setq auto-mode-alist (cons '(".emacs$" . emacs-lisp-mode) auto-mode-alist))
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
;;tuareg-mode for OCaml
(setq auto-mode-alist (cons '("\\.ml\\w?" . tuareg-mode) auto-mode-alist))
(autoload 'tuareg-mode "tuareg-mode" "Major mode for editing Caml code" t)
;;for D Lang
(autoload 'd-mode "d-mode" "Major mode for editing D code." t)
(add-to-list 'auto-mode-alist '("\\.d[i]?\\'" . d-mode))
;;for Kuin
(autoload 'kuin-mode "kuin-mode" nil t)
(add-hook 'kuin-mode-hook '(lambda () (font-lock-mode 1)))
(setq auto-mode-alist
    (cons (cons "\\.kn$" 'kuin-mode) auto-mode-alist))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;verify mode section end.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;for magit
(autoload 'magit "magit" "Emacs git client." t)
;; まず、install-elisp のコマンドを使える様にします。
(autoload 'install-elisp "install-elisp" "install emacs lisp" t)
;; 次に、Elisp ファイルをインストールする場所を指定します。
(setq install-elisp-repository-directory "~/.emacs.d/elisp/")
;;;Hide message
(setq inhibit-startup-message t)
(load "elscreen" "ElScreen" t)
(global-set-key "\M-n" 'next-buffer)
(global-set-key "\M-p" 'previous-buffer)
;; 以下は自動でスクリーンを生成する場合の設定
(defmacro elscreen-create-automatically (ad-do-it)
  `(if (not (elscreen-one-screen-p))
       ,ad-do-it
     (elscreen-create)
     (elscreen-notify-screen-modification 'force-immediately)
     (elscreen-message "New screen is automatically created")))

(defadvice elscreen-next (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))
(defadvice elscreen-previous (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))
(defadvice elscreen-toggle (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))

;; elscreen-server
(require 'elscreen-server)
;; elscreen-dired
(require 'elscreen-dired)
;; elscreen-color-theme
(require 'elscreen-color-theme)
;; 起動時のサイズ,表示位置,フォントを指定
(setq initial-frame-alist
      (append (list
	       '(width . 85)
	       '(height . 50)
		   )
	      initial-frame-alist))
(setq default-frame-alist initial-frame-alist)
(setq-default tab-width 4)
(setq default-tab-width 4)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60
                      64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))
;;speedbarの設定
(when (locate-library "speedbar")
  (require 'speedbar)
  (add-hook 'speedbar-mode-hook
          '(lambda ()
             (speedbar-add-supported-extension '("cs" "hs" "cu"))))
  ; "a" で無視ファイル表示/非表示のトグル
  (define-key speedbar-file-key-map "a" 'speedbar-toggle-show-all-files)
  ;; ← や → でもディレクトリを開閉 ;;デフォルト: "=" "+", "-"
  (define-key speedbar-file-key-map [right] 'my-speedbar-expand-line)
  (define-key speedbar-file-key-map "\C-f" 'my-speedbar-expand-line)
  (define-key speedbar-file-key-map [left] 'speedbar-contract-line)
  (define-key speedbar-file-key-map "\C-b" 'speedbar-contract-line)
  ;; BS でも上位ディレクトリへ ;;デフォルト: "U"
  (define-key speedbar-file-key-map [backspace] 'speedbar-up-directory)
  (define-key speedbar-file-key-map "\C-h" 'speedbar-up-directory)
  ;; F4 で Speedbar
  (global-set-key [f4] 'speedbar-get-focus)
           )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 日本語入力の設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
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
  (global-set-key "\C-\\" 'ibus-toggle)
  ;; 変換キーでon、無変換キーでoffで切り替え
  (global-set-key
   [henkan]
   (lambda () (interactive)
     (when (null current-input-method) (toggle-input-method))))
  (global-set-key
   [muhenkan]
   (lambda () (interactive)
     (inactivate-input-method)))
  (defadvice mozc-handle-event (around intercept-keys (event))
    "Intercept keys muhenkan and zenkaku-hankaku, before passing keys to mozc-server (which the function mozc-handle-event does), to properly disable mozc-mode."
  (if (member event (list 'zenkaku-hankaku 'muhenkan))
      (progn (mozc-clean-up-session)
             (toggle-input-method))
    (progn ;(message "%s" event) ;debug
      ad-do-it)))
  (ad-activate 'mozc-handle-event)
  )
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
   '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 83 :width normal :foundry "unknown" :family "VL ゴシック")))))
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;その他雑多な設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; バックアップファイルを作らない
(setq backup-inhibited t)
;;; 終了時にオートセーブファイルを消す
(setq delete-auto-save-files t)
;;; 圧縮されたファイルも編集できるようにする
(auto-compression-mode t)
;;; タイトルバーにファイル名を表示する
(setq frame-title-format (format "emacs@%s : %%f" (system-name)))
;;; モードラインに時間を表示する
(display-time)
(which-function-mode 1)
;; spell check
(flyspell-mode t)
(setq ispell-dictionary "american")
(eval-when-compile
  ;; Emacs 21 defines `values' as a (run-time) alias for list.
  ;; Don't maerge this with the pervious clause.
  (if (string-match "values"
            (pp (byte-compile (lambda () (values t)))))
      (defsubst values (&rest values)
    values)))

;; 同名のファイルを開いたとき親のディレクトリ名も表示
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;; ファイルの履歴
(require 'recentf)
(recentf-mode t)
(setq recentf-exclude '("^\\.emacs\\.bmk$"))
(setq recentf-max-menu-items 10)
(setq recentf-max-saved-items 20)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; キーバインドの設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; M-g で指定行へジャンプ
(global-set-key "\M-g" 'goto-line)

;; リージョンをコメントアウト
(global-set-key "\C-c;" 'comment-region)

;; バッファの最初の行で previous-line しても、
;; "beginning-of-buffer" と注意されないようにする。
(defun previous-line (arg)
  (interactive "p")
  (if (interactive-p)
      (condition-case nil
          (line-move (- arg))
        ((beginning-of-buffer end-of-buffer)))
    (line-move (- arg)))
  nil)
;;大文字小文字を区別したい
(setq default-case-fold-search nil)
