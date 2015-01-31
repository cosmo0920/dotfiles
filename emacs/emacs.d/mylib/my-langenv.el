(eval-when-compile
  ;;OS判別
  (load-file "~/.emacs.d/init/ostype.el")
)
(when run-linux
 (require 'lang-env-linux))
;;for windows
(when run-w32
  (require 'lang-env-win32))
(provide 'my-langenv)
