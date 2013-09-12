(require 'auto-complete)
(require 'auto-complete-config)    ; 必須ではないですが一応
(require 'my-ostype)
;補完。auto-completeがあるから要らないかも
(define-key global-map "\C-c\C-i" 'dabbrev-expand)
;; dirty fix for having AC everywhere
(define-globalized-minor-mode real-global-auto-complete-mode
  auto-complete-mode (lambda ()
                       (if (not (minibufferp (current-buffer)))
                         (auto-complete-mode 1))
                       ))
(ac-set-trigger-key "TAB")
(when run-linux
  (require 'auto-complete-etags)
  (add-to-list 'ac-sources 'ac-source-etags))
;;補完候補をC-n/C-pでも選択できるように
;;Vimmerには嬉しいかも。
(add-hook 'auto-complete-mode-hook
          (lambda ()
            (define-key ac-completing-map (kbd "C-n") 'ac-next)
            (define-key ac-completing-map (kbd "C-p") 'ac-previous)))
(real-global-auto-complete-mode t)
(provide 'init_auto-complete)
