(eval-when-compile (require 'cl))
;;yasnippet ref:http://fukuyama.co/yasnippet
;; 問い合わせを簡略化 yes/no を y/n
(fset 'yes-or-no-p 'y-or-n-p)
(when (require 'yasnippet nil t)
  ;; ~/.emacs.d/にsnippetsというフォルダを作っておきましょう
  (setq yas-snippet-dirs
        '("~/.emacs.d/snippets" ;; 作成するスニペットはここに入る
          "~/.emacs.d/yasnippet/snippets"
          ))
  (yas-global-mode 1)

  ;; 単語展開キーバインド (ver8.0から明記しないと機能しない)
  ;; (setqだとtermなどで干渉問題ありでした)
  ;; もちろんTAB以外でもOK 例えば "C-;"とか
  (custom-set-variables '(yas-trigger-key "C-i"))

  ;; anything interface ref:http://shibayu36.hatenablog.com/entry/2012/12/18/224535
  (eval-after-load "anything-config"
    '(progn
       (defun my-yas/prompt (prompt choices &optional display-fn)
         (let* ((names (loop for choice in choices
                             collect (or (and display-fn (funcall display-fn choice))
                                         choice)))
                (selected (anything-other-buffer
                           `(((name . ,(format "%s" prompt))
                              (candidates . names)
                              (action . (("Insert snippet" . (lambda (arg) arg))))))
                           "*anything yas/prompt*")))
           (if selected
               (let ((n (position selected names :test 'equal)))
                 (nth n choices))
             (signal 'quit "user quit!"))))
       (custom-set-variables '(yas/prompt-functions '(my-yas/prompt)))))

  ;; 既存スニペットを挿入する
  (define-key yas-minor-mode-map (kbd "C-x i i") 'yas-insert-snippet)
  ;; 新規スニペットを作成するバッファを用意する
  (define-key yas-minor-mode-map (kbd "C-x i n") 'yas-new-snippet)
  ;; 既存スニペットを閲覧・編集する
  (define-key yas-minor-mode-map (kbd "C-x i v") 'yas-visit-snippet-file))
(provide 'init_yasnippet)
