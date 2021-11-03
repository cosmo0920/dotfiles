(eval-when-compile (require 'cl))

(defvar installing-package-list
  '(
    ;; ここに使っているパッケージを書く。
    ;;apel
    ;;auto-async-byte-compile
    auto-complete
    helm
    anzu
    elscreen
    expand-region
    powerline
    ;;recentf-ext
    shell-pop
    yasnippet
    markdown-mode
    haskell-mode
    yaml-mode
    ))

(when (require 'package nil t)
  (let ((not-installed (loop for x in installing-package-list
                             when (not (package-installed-p x))
                             collect x)))
    (when not-installed
      (package-refresh-contents)
      (dolist (pkg not-installed)
        (package-install pkg)))))
(provide 'package-install)
