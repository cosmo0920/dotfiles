(provide 'my-func)
;;chmod +x
(defun make-file-executable ()
  "Make the file of this buffer executable, when it is a script source."
  (save-restriction
    (widen)
    (if (string= "#!/" (buffer-substring-no-properties 1 (min 3 (point-max))))
        (let ((name (buffer-file-name)))
          (or (equal ?. (string-to-char (file-name-nondirectory name)))
              (let ((mode (file-modes name)))
                (set-file-modes name (logior mode (logand (/ mode 4) 73)))
                (message (concat "Wrote " name " (+x)"))))))))
(add-hook 'after-save-hook 'make-file-executable)

(defun swap-screen()
  "Swap two screen,leaving cursor at current window."
  (interactive)
  (let ((thiswin (selected-window))
      (nextbuf (window-buffer (next-window))))
    (set-window-buffer (next-window) (window-buffer))
    (set-window-buffer thiswin nextbuf)))

(defun swap-screen-with-cursor()
  "Swap two screen,with cursor in same buffer."
  (interactive)
  (let ((thiswin (selected-window))
      (thisbuf (window-buffer)))
    (other-window 1)
    (set-window-buffer thiswin (window-buffer))
    (set-window-buffer (selected-window) thisbuf)))
(global-set-key [f2] 'swap-screen)
(global-set-key [S-f2] 'swap-screen-with-cursor)

(defun duplicate-line (&optional numlines)
  "One line is duplicated wherever there is a cursor."
  (interactive "p")
  (let* ((col (current-column))
         (bol (progn (beginning-of-line) (point)))
         (eol (progn (end-of-line) (point)))
         (line (buffer-substring bol eol)))
    (while (> numlines 0)
      (insert "\n" line)
      (setq numlines (- numlines 1)))
    (move-to-column col)))
(define-key esc-map "k" 'duplicate-line)

;; Prefixのghciとシステムのghciを切り替える
(when (locate-library "haskell-mode")
  (global-set-key "\C-\M-h"
    (lambda () (interactive)
      (setq haskell-program-name "~/gentoo/usr/bin/ghci")
      (message "ghci change to ~/gentoo/usr/bin/ghci")))
  (global-set-key "\C-\M-c"
    (lambda () (interactive)
      (setq haskell-program-name "/usr/bin/ghci")
      (message "ghci change to /usr/bin/ghci")))
  ;; change execute "cabal-dev ghci"
  (global-set-key "\C-\M-m"
    (lambda () (interactive)
      (setq haskell-program-name "cabal-dev ghci")
      (message "ghci change to ghci with cabal-dev")))
)
