;; OSを判別、UNIX系？
(defvar run-unix
  (or (equal system-type 'gnu/linux)
     (or (equal system-type 'usg-unix-v)
          (or  (equal system-type 'berkeley-unix)
               (equal system-type 'cygwin)))))
;; OSを判別、個別判別
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
                            "~/.emacs.d/mylib/"
                            "/usr/local/share/gtags/"
                            )
                            load-path))
  ;;Ubuntuだとapt-getしたElispはここに置かれる
  (let ((default-directory "/usr/share/emacs/site-lisp/"))
    (normal-top-level-add-subdirs-to-load-path)))

;;for OSX setting
(when run-darwin
  (add-to-list 'load-path "~/.emacs.d/site-elisp/")
  (add-to-list 'load-path "~/.emacs.d/apel/")
  (add-to-list 'load-path "~/.emacs.d/"))

;;semanticの設定をまとめてみた。
(require 'my-semantic)

(require 'auto-complete)
(require 'auto-complete-config)    ; 必須ではないですが一応
;補完。auto-completeがあるから要らないかも
(define-key global-map "\C-c\C-i" 'dabbrev-expand)   
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
;; twmode で無効にする
(defadvice linum-on(around my-linum-twmode-on() activate)
  (unless (eq major-mode 'twittering-mode) ad-do-it))
(when run-linux
  (when (locate-library "anything")
	(require 'anything)
	(require 'anything-startup)
	(require 'anything-config)
	(setq  anything-sources
		   '(anything-c-source-buffers
			 anything-c-source-imenu
			 anything-c-source-emacs-commands
			 ;;anything-c-source-etags-select
			 ;;anything-c-source-gtags-select
			 )) 
	(define-key global-map (kbd "C-x b") 'anything)
	(autoload 'gtags-mode "gtags" "" t)))
;;(when run-linux
;;  (when (locate-library "flymake")))

;;verify file mode
(require 'my-ftype)
;;for magit
(autoload 'magit "magit" "Emacs git client." t)
;; まず、install-elisp のコマンドを使える様にします。
(autoload 'install-elisp "install-elisp" "install emacs lisp" t)
;; 次に、Elisp ファイルをインストールする場所を指定します。
(setq install-elisp-repository-directory "~/.emacs.d/elisp/")
;;;Hide message
(setq inhibit-startup-message t)
(when (locate-library "elscreen")
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
  )
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
             (speedbar-add-supported-extension '("cs" "hs" "cu" "lhs"))))
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
  (global-set-key [f4] 'speedbar-get-focus))
;; 日本語入力の設定
(require 'my-langenv)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;その他雑多な設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; バックアップファイルを作らない
(setq backup-inhibited t)
; バックアップファイルを一箇所にまとめる
(setq make-backup-files t)
(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
     backup-directory-alist))

;;; 終了時にオートセーブファイルを消す
(setq delete-auto-save-files t)
;;; 圧縮されたファイルも編集できるようにする
(auto-compression-mode t)
;;=====ediff=====
;;; ediffを1ウィンドウで実行
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;;; diffのオプション
(setq diff-switches '("-u" "-p" "-N"))
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
;;; 対応する括弧を光らせる。
(show-paren-mode 1)
;;; ウィンドウ内に収まらないときだけ括弧内も光らせる。
(setq show-paren-style 'mixed)
;;; カーソルの位置が何文字目かを表示する
(column-number-mode t)
;;; カーソルの位置が何行目かを表示する
(line-number-mode t)
; scratchバッファの初期メッセージを消す
(setq initial-scratch-message "")

;; 同名のファイルを開いたとき親のディレクトリ名も表示
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;; ファイルの履歴
(require 'recentf)
(recentf-mode t)
(setq recentf-exclude '("^\\.emacs\\.bmk$"))
(setq recentf-max-menu-items 10)
(setq recentf-max-saved-items 20)
(setq semantic-load-turn-useful-things-on t)
(require 'shell-pop)
(shell-pop-set-internal-mode "ansi-term")
(shell-pop-set-internal-mode-shell "/usr/bin/zsh")
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

;;行ハイライト
;;参考：http://kawaguchi.posterous.com/25367725
(global-hl-line-mode t)
(set-face-background 'hl-line "alice blue")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; キーバインドの設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; M-g で指定行へジャンプ
(global-set-key "\M-g" 'goto-line)
;; リージョンをコメントアウト
(global-set-key "\C-x;" 'comment-region)
;; リージョンをコメントアウト解除
(global-set-key "\C-c;" 'uncomment-region)
;; リージョンのコメントアウトをトグル
(global-set-key "\M-;" 'comment-or-uncomment-region)
;;bookmark-jump
(global-set-key "\C-c\C-f" 'bookmark-jump)
;; Emacsを半透明・透明にする
(global-set-key "\C-xa" 
  (lambda () (interactive) 
    (set-frame-parameter nil 'alpha 80)))
(global-set-key "\C-ca"
  (lambda () (interactive)
     (set-frame-parameter nil 'alpha 100)))
;;etags関連のキーバインド定義
(defun find-tag-next ()
  (interactive)
  (find-tag last-tag t))
(global-set-key (kbd "C-M-.")   'find-tag-next)
(global-set-key (kbd "M-,")     'find-tag-other-window)
(global-set-key (kbd "C-M-,")   'find-tag-regexp)

;; Prefixのghciとシステムのghciを切り替える
(when (locate-library "haskell-mode")
  (global-set-key "\C-\M-h" 
    (lambda () (interactive) 
      (setq haskell-program-name "~/gentoo/usr/bin/ghci")
      (message "ghci change to ~/gentoo/usr/bin/ghci")))
  (global-set-key "\C-\M-c"
    (lambda () (interactive)
      (setq haskell-program-name "/usr/bin/ghci")
      (message "ghci change to /usr/bin/ghci"))))
