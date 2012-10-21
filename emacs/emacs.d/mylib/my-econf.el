(require 'my-ostype)
(provide 'my-econf)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;雑多な設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;change default directory for Ubuntu
(when run-linux
  (cd "/media/Data/Document")
)
;;change default directory for OSX
(when run-darwin
  (cd "~/Document/")
)
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
(show-paren-mode 1)
;;; ウィンドウ内に収まらないときだけ括弧内も光らせる。
(setq show-paren-style 'mixed)
(set-face-background 'show-paren-match-face "alice blue")
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
