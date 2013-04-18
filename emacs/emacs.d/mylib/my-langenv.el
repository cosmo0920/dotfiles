;;OS判別
;;(load-file "~/.emacs.d/mylib/my-ostype.el")
(when run-linux
 (require 'lang-env-linux))
;;for windows
(when run-w32
  (require 'lang-env-w32))
(provide 'my-langenv)
