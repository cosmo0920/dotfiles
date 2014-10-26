;;OS判別
(require 'my-ostype)
;; 起動時のサイズ,表示位置,フォントを指定
(setq initial-frame-alist
  (append (list
    '(width . 90)
    '(height . 50)
  )initial-frame-alist))
(setq default-frame-alist initial-frame-alist)
(setq tab-width 4)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60
                      64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))
;; まず、install-elisp のコマンドを使える様にします。
(autoload 'install-elisp "install-elisp" "install emacs lisp" t)
;; 次に、Elisp ファイルをインストールする場所を指定します。
(setq install-elisp-repository-directory "~/.emacs.d/elisp/")
;;;Hide message
(setq inhibit-startup-message t)
(flyspell-mode t)
(setq ispell-dictionary "american")
(eval-when-compile
  ;; Emacs 21 defines `values' as a (run-time) alias for list.
  ;; Don't maerge this with the pervious clause.
  (if (string-match "values"
            (pp (byte-compile (lambda () (values t)))))
      (defsubst values (&rest values)
    values)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;雑多な設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;change default directory for Ubuntu
(when run-linux
  (require 'cd-linux nil t)
)
;;change default directory for OSX
(when run-darwin
  (cd "~/Documents/")
)
;;; バックアップファイルを作らない
(setq backup-inhibited t)
; バックアップファイルを一箇所にまとめる
(setq make-backup-files t)
(setq backup-directory-alist
      (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
     backup-directory-alist))
;;; .#* とかのバックアップファイルを作らない
(setq auto-save-default nil)
;;; 終了時にオートセーブファイルを消す
(setq delete-auto-save-files t)
;;; 圧縮されたファイルも編集できるようにする
(auto-compression-mode t)
;; クリップボード
(setq x-select-enable-clipboard t)
;;=====ediff=====
;;; ediffを1ウィンドウで実行
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;;; diffのオプション
(setq diff-switches '("-u" "-r" "-p" "-N"))
;;; タイトルバーにファイル名を表示する
(setq frame-title-format (format "emacs@%s : %%f" (system-name)))
;;; モードラインに時間を表示する
(display-time)
(which-function-mode 1)
;; バッファの最初の行で previous-line しても、
;; "beginning-of-buffer" と注意されないようにする。
(defun previous-line (arg)
  (interactive "p")
  (if (called-interactively-p t)
      (condition-case nil
          (line-move (- arg))
        ((beginning-of-buffer end-of-buffer)))
    (line-move (- arg)))
  nil)
;;大文字小文字を区別したい
(setq case-fold-search nil)
;;; 対応する括弧を光らせる。
(show-paren-mode t)
;;; ウィンドウ内に収まらないときだけ括弧内も光らせる。
(setq show-paren-style 'mixed)
(set-face-background 'show-paren-match-face "#a4d1ff")
(defadvice show-paren-function
  (around show-paren-closing-before
          activate compile)
  (if (eq (syntax-class (syntax-after (point))) 5)
      (save-excursion
        (forward-char)
        ad-do-it)
    ad-do-it))
;;; カーソルの位置が何文字目かを表示する
(column-number-mode t)
;;; カーソルの位置が何行目かを表示する
(line-number-mode t)
; scratchバッファの初期メッセージを消す
(setq initial-scratch-message "")
;;行ハイライト
;;参考：http://kawaguchi.posterous.com/25367725
(global-hl-line-mode t)
(set-face-background 'hl-line "alice blue")
;;; col-highlight.el
(require 'col-highlight nil t)
;; 常にハイライト
;;(column-highlight-mode 1)
;; col-highlightの色を変える
(custom-set-faces
 '(col-highlight((t (:background "lightgray")))))
(toggle-highlight-column-when-idle 1)
(col-highlight-set-interval 3)
;;バッファ自動再読み込み
(global-auto-revert-mode 1)
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
;; バックスラッシュ
(define-key global-map (kbd "M-|") "\\")
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
;;popwinの設定
(when (locate-library "popwin")
  (require 'popwin)
  (setq display-buffer-function 'popwin:display-buffer)
  (setq anything-samewindow nil)
  ;;anything
  (push '("*anything*" :height 20) popwin:special-display-config)
  ;; and so on
  (setq popwin:special-display-config '(
                                      ("*Help*")
                                      ("*Completions*" :noselect t)
                                      ("*compilatoin*" :noselect t)
                                      ("*Occur*")
                                      ("*Kill Ring*"))))
;; expand-region
(require 'expand-region nil t)
(global-set-key (kbd "C-@") 'er/expand-region)
(global-set-key (kbd "C-M-@") 'er/contract-region)
;;3 split vertically ref:http://d.hatena.ne.jp/yascentur/20110621/1308585547
(defun split-window-vertically-n (num_wins)
  (interactive "p")
  (if (= num_wins 2)
      (split-window-vertically)
    (progn
      (split-window-vertically
       (- (window-height) (/ (window-height) num_wins)))
      (split-window-vertically-n (- num_wins 1)))))
(defun split-window-horizontally-n (num_wins)
  (interactive "p")
  (if (= num_wins 2)
      (split-window-horizontally)
    (progn
      (split-window-horizontally
       (- (window-width) (/ (window-width) num_wins)))
      (split-window-horizontally-n (- num_wins 1)))))
(global-set-key "\C-x#" '(lambda ()
                           (interactive)
                           (split-window-vertically-n 3)))
(global-set-key "\C-x@" '(lambda ()
                           (interactive)
                           (split-window-horizontally-n 3)))
(provide 'my-econf)
