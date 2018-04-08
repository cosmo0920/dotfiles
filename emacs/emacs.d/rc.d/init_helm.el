(when (locate-library "helm")
  (require 'helm)

  (require 'helm-config)
  (require 'helm-source)
  (helm-mode 1)

  (custom-set-variables
   '(helm-mini-default-sources '(helm-source-buffers-list
                                 helm-source-recentf
                                 helm-source-files-in-current-dir
                                 )))
  (define-key global-map (kbd "C-x C-f") 'helm-find-files)
  (define-key global-map (kbd "C-x C-r") 'helm-recentf)
  (define-key global-map (kbd "C-x C-b") 'helm-buffers-list)
  (define-key global-map (kbd "C-x b") 'helm-mini)
  (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
)
(provide 'init_helm)
