(when (locate-library "anything")
  (require 'anything)
  (require 'anything-startup)
  (require 'anything-config)
  (setq  anything-sources
		 '(anything-c-source-buffers
			anything-c-source-imenu
			anything-c-source-emacs-commands
			anything-c-source-ctags
			)) 
  (define-key global-map (kbd "C-x b") 'anything)
  (define-key global-map (kbd "C-;") 'anything-for-files)
  (define-key anything-map "\C-o" 'anything-execute-persistent-action))
(provide 'init_anything)
