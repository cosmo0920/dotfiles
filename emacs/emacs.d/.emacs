(add-to-list 'load-path "/home/cosmo/.emacs.d")
(require 'auto-complete)
(require 'auto-complete-config)    ; 必須ではないですが一応
(global-auto-complete-mode t)
;; 起動時のサイズ,表示位置,フォントを指定
(setq initial-frame-alist
      (append (list
	       '(width . 120)
	       '(height . 45)
	       '(top . 0)
	       '(left . 0)
	       '(font . "VL Gothic-11")
	       )
	      initial-frame-alist))
(setq default-frame-alist initial-frame-alist)
