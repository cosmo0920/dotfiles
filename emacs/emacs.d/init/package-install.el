(eval-when-compile (require 'cl))

(defvar installing-package-list
  '(
    ;; ここに使っているパッケージを書く。
    auto-async-byte-compile
    anything
    col-highlight
    powerline
    recentf-ext
    yasnippet
    markdown-mode
    haskell-mode
    yaml-mode
    ))

(let ((not-installed (loop for x in installing-package-list
                            when (not (package-installed-p x))
                            collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
        (package-install pkg))))
(provide 'package-install)
