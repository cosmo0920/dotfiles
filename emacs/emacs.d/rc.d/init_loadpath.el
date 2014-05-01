;;OS判別
(eval-when-compile (load-file "~/.emacs.d/mylib/my-ostype.el"))
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
  (setq load-path (append '("~/.emacs.d/site-lisp/"
                            "~/.emacs.d/site-elisp/"
                            "~/.emacs.d/elisp/"
                            "~/.emacs.d/mylib/"
                            "~/.emacs.d/rc.d/"
                            "~/.emacs.d/cedet/"
                            "~/.emacs.d/auto-install/"
                            "~/.emacs.d/apel/"
                          )
                          load-path)))

(when run-w32
  (setq load-path (append '("~/.emacs.d/site-lisp/"
                            "~/.emacs.d/site-elisp/"
                            "~/.emacs.d/elisp/"
                            "~/.emacs.d/mylib/"
                            "~/.emacs.d/rc.d/"
                            "~/.emacs.d/cedet/"
                            "~/.emacs.d/rhtml/"
                            "~/.emacs.d/expand-region.el"
                            "~/.emacs.d/yasnippet"
                            "~/.emacs.d/auto-install/"
                            "~/.emacs.d/apel/"
                            )
                            load-path)))
(provide 'init_loadpath)
