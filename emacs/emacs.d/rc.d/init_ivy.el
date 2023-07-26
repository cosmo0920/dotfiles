(when (locate-library "ivy")
  (require 'ivy)
  (require 'ivy-hydra)

  (setq ivy-use-virtual-buffers t)

  (when (setq enable-recursive-minibuffers t)
    (minibuffer-depth-indicate-mode 1))

  (define-key ivy-minibuffer-map (kbd "<escape>") 'minibuffer-keyboard-quit)

  (ivy-mode 1)
  )
(when (locate-library "counsel")
  (require 'counsel)

  (require 'ibuffer)
  ;; Like helm-file-files. ref: https://qiita.com/keita44_f4/items/93a03c09c38f0e5b5256
  (defun ibuffer-find-file-by-counsel ()
    "Like `counsel-find-file', but default to the directory of the buffer
at point."
    (interactive)
    (let ((default-directory
            (let ((buf (ibuffer-current-buffer)))
              (if (buffer-live-p buf)
                  (with-current-buffer buf
                    default-directory)
                default-directory))))
      (counsel-find-file default-directory)))

  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "M-y") 'counsel-yank-pop)
  (global-set-key (kbd "C-M-z") 'counsel-fzf)
  (global-set-key (kbd "C-x C-f") 'ibuffer-find-file-by-counsel)
  (global-set-key (kbd "C-x C-r") 'counsel-recentf)
  (global-set-key (kbd "C-x b") 'counsel-ibuffer)
  (global-set-key (kbd "C-M-f") 'counsel-ag)

  (counsel-mode 1)
  )
(provide 'init_ivy)
