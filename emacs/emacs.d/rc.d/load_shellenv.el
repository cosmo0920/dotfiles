;; load environment value
(unless run-w32
      (load-file (expand-file-name "~/.emacs.d/shellenv.el"))
      (dolist (path (reverse (split-string (getenv "PATH") ":")))
	(add-to-list 'exec-path path)))
(provide 'load_shellenv)
