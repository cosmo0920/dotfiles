;;Proof general loads when exists
(cond
  ((equal (file-exists-p "~/.emacs.d/ProofGeneral/") t)
   (load-file "~/.emacs.d/ProofGeneral/generic/proof-site.el")))
(provide 'init_proof_general)
