(provide 'myfunc)
;;chmod +x
(defun make-file-executable ()
  "Make the file of this buffer executable, when it is a script source."
  (save-restriction
    (widen)
    (if (string= "#!" (buffer-substring-no-properties 1 (min 3 (point-max))))
        (let ((name (buffer-file-name)))
          (or (equal ?. (string-to-char (file-name-nondirectory name)))
              (let ((mode (file-modes name)))
                (set-file-modes name (logior mode (logand (/ mode 4) 73)))
                (message (concat "Wrote " name " (+x)"))))))))
(add-hook 'after-save-hook 'make-file-executable)
;; Prefixのghciとシステムのghciを切り替える
(when (locate-library "haskell-mode")
  (global-set-key "\C-\M-h" 
    (lambda () (interactive) 
      (setq haskell-program-name "~/gentoo/usr/bin/ghci")
      (message "ghci change to ~/gentoo/usr/bin/ghci")))
  (global-set-key "\C-\M-c"
    (lambda () (interactive)
      (setq haskell-program-name "/usr/bin/ghci")
      (message "ghci change to /usr/bin/ghci"))))

