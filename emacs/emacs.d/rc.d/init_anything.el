(when (locate-library "anything")
  (require 'anything)
  (require 'anything-startup)
  (require 'anything-config)
  (defun anything-custom-filelist ()
    (interactive)
    (anything-other-buffer
     (append
      '(anything-c-source-ffap-line
        anything-c-source-ffap-guesser
        anything-c-source-buffers+
        )
      (anything-c-sources-git-project-for)
      '(anything-c-source-recentf
        anything-c-source-bookmarks
        anything-c-source-file-cache
        anything-c-source-filelist
        ))
     "*anything file list*"))
  (setq  anything-sources
		 '(anything-c-source-buffers
			anything-c-source-imenu
			anything-c-source-emacs-commands
			anything-c-source-ctags
			))
  (define-key global-map (kbd "C-;") 'anything)
  (define-key global-map (kbd "C-x b") 'anything-filelist+)
  (define-key anything-map "\C-o" 'anything-execute-persistent-action)
)
(provide 'init_anything)
