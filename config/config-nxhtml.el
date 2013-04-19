;;; config-nxhtml.el --- nxhtml configuration

(load (concat emacs-config-dir "lib/nxhtml/autostart.el"))

(setq majmodpri-no-nxml t
      nxhtml-skip-welcome t
      rng-nxml-auto-validate-flag nil
      nxhtml-menu-mode nil)
(setq-default mumamo-no-chunk-coloring t)
;; вўВи Warning: `font-lock-beginning-of-syntax-function' is an obsolete variable (as of Emacs 23.3) use `syntax-begin-function' instead
(when (and (equal emacs-major-version 23)
           (or (equal emacs-minor-version 3)
               (equal emacs-minor-version 4)))
  (eval-after-load "bytecomp"
    '(add-to-list 'byte-compile-not-obsolete-vars
                  'font-lock-beginning-of-syntax-function))
  ;; tramp-compat.el clobbers this variable!
  (eval-after-load "tramp-compat"
    '(add-to-list 'byte-compile-not-obsolete-vars
                  'font-lock-beginning-of-syntax-function)))


(ourcomments-M-x-menu-mode t)
(ourcomments-paste-with-convert-mode t)

(provide 'config-nxhtml)

;;; config-nxhtml.el ends here ---
