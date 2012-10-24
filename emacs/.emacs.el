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
                            "~/.emacs.d/rc.d/"
                            "~/.emacs.d/auto-install"
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
;;auto-complete
(require 'init_auto-complete)
;;twmode
(require 'init_twmode)
;; 行番号表示
(require 'linum)
(global-linum-mode t)
;; twmode で無効にする
(defadvice linum-on(around my-linum-twmode-on() activate)
  (unless (eq major-mode 'twittering-mode) ad-do-it))
(require 'init_anything)

;;(when run-linux
;;  (when (locate-library "flymake")))
;;verify file mode
(require 'my-ftype)
;;for magit
(autoload 'magit "magit" "Emacs git client." t)
(require 'init_elscreen)
;;speedbarの設定
(require 'init_speedbar)
;; 日本語入力の設定
(require 'my-langenv)
;;雑多な設定 @my-econf
(require 'my-econf)
;; uniquify/recentf/shell-pop関連
(require 'init_setting)
;; @ hideshow/fold-dwim.el
(require 'init_fold)
;;http://d.hatena.ne.jp/rubikitch/20100423/bytecomp
;;自動バイトコンパイルを行う
(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
