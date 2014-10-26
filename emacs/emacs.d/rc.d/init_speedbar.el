;;speedbarの設定
(when (locate-library "speedbar")
  (require 'speedbar)
  (add-hook 'speedbar-mode-hook
          '(lambda ()
             (speedbar-add-supported-extension
              '("cs" "hs" "cu" "lhs" "html" "css" "rb" "erb" "*"))))
  ; "a" で無視ファイル表示/非表示のトグル
  (define-key speedbar-file-key-map "a" 'speedbar-toggle-show-all-files)
  ;; ← や → でもディレクトリを開閉 ;;デフォルト: "=" "+", "-"
  (define-key speedbar-file-key-map [right] 'my-speedbar-expand-line)
  (define-key speedbar-file-key-map "\C-f" 'my-speedbar-expand-line)
  (define-key speedbar-file-key-map [left] 'speedbar-contract-line)
  (define-key speedbar-file-key-map "\C-b" 'speedbar-contract-line)
  ;; BS でも上位ディレクトリへ ;;デフォルト: "U"
  (define-key speedbar-file-key-map [backspace] 'speedbar-up-directory)
  (define-key speedbar-file-key-map "\C-h" 'speedbar-up-directory))
  ;; sr-speedbarの設定
  (if (<= emacs-major-version 24)
    (progn
      (if (< emacs-minor-version 4)
      (progn
        (when (locate-library "sr-speedbar")
          (require 'sr-speedbar)
          (setq sr-speedbar-right-side t)
          (setq sr-speedbar-width-x 40)
          (setq sr-speedbar-width-console 24)
          (setq sr-speedbar-delete-windows nil)
          (setq speedbar-use-images nil)
          (setq speedbar-frame-parameters '((minibuffer)
                                            (width . 30)
                                            (border-width . 0)
                                            (menu-bar-lines . 0)
                                            (tool-bar-lines . 0)
                                            (unsplittable . t)
                                            (left-fringe . 0)))
          (setq speedbar-default-position 'left-right)
          (setq speedbar-hide-button-brackets-flag t)
          (global-set-key (kbd "\C-^") 'sr-speedbar-toggle)))))
    (progn
      (print "version greater than 24.4. Don't use sr-speedbar.el.")))
(provide 'init_speedbar)
