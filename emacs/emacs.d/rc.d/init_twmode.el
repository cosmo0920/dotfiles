;;twmode
(when run-darwin
  (add-to-list 'exec-path "/opt/local/bin"))
(autoload 'twittering-mode "twittering-mode" "Emacs twitter client." t)
(setq twittering-icon-mode t)
(setq twittering-use-master-password t)
(setq twittering-update-status-function 'twittering-update-status-from-pop-up-buffer)
(setq twittering-convert-fix-size 48)
(setq twittering-timer-interval 90)
(setq twittering-initial-timeline-spec-string
      '(":favorites"
        ":direct_messages"
        ":replies"
        ":home"))
 (add-hook 'twittering-mode-hook
           (lambda ()
             (mapc (lambda (pair)
                     (let ((key (car pair))
                           (func (cdr pair)))
                       (define-key twittering-mode-map
                         (read-kbd-macro key) func)))
                   '(("T" . twittering-friends-timeline)
                     ("R" . twittering-replies-timeline)
                     ("U" . twittering-user-timeline)
                     ("W" . twittering-update-status-interactive)
                     ("F". twittering-favorite )))))
(provide 'init_twmode)
