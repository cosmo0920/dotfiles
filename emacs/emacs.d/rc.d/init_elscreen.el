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
(provide 'init_elscreen)
