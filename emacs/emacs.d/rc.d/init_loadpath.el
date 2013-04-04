;;OS判別
(load-file "~/.emacs.d/mylib/my-ostype.el")
;;for Ubuntu setting
(when run-linux
  (setq load-path (append '("~/.emacs.d/site-lisp/"
                            "~/.emacs.d/site-elisp/"
                            "~/.emacs.d/elisp/"
                            "~/.emacs.d/mylib/"
                            "~/.emacs.d/rc.d/"
			    "~/.emacs.d/cedet/"
                            "~/.emacs.d/auto-install/"
                            "/usr/local/share/gtags/"
                            )
                            load-path))
  ;;Ubuntuだとapt-getしたElispはここに置かれる
  (let ((default-directory "/usr/share/emacs/site-lisp/"))
    (normal-top-level-add-subdirs-to-load-path)))

;;for OSX setting
(when run-darwin
  (add-to-list 'load-path "~/.emacs.d/site-elisp/")
  (add-to-list 'load-path "~/.emacs.d/apel/")
  (add-to-list 'load-path "~/.emacs.d/"))
(provide 'init_loadpath)
