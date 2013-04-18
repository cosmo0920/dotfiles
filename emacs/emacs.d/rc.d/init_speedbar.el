;;speedbarの設定
(when (locate-library "speedbar")
  (require 'speedbar)
  (add-hook 'speedbar-mode-hook
          '(lambda ()
             (speedbar-add-supported-extension 
	      '("cs" "hs" "cu" "lhs" "html" "css" "rb" "erb"))))
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
(provide 'init_speedbar)
