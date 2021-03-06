;; config-auto-complete.el ---

;;(require 'config-cedet)
(require 'auto-complete-config)

(add-to-list 'ac-dictionary-directories (concat emacs-config-dir "/config/ac-dict"))
(add-to-list 'ac-user-dictionary-files (concat emacs-config-dir "/config/ac-dict/config.dict"))
(ac-config-default)
(setq ac-auto-start 1 
      ac-comphist-file "~/.emacs.d/auto-save-list/ac-comphist.dat"
      ac-modes (append ac-modes
                       '(shell-mode graphviz-dot-mode mpr-mode pdu-mode tdl-mode conf-xdefaults-mode html-mode nxml-mode objc-mode jde-mode sql-mode change-log-mode text-mode makefile-gmake-mode makefile-bsdmake-mo autoconf-mode makefile-automake-mode snippet-mode eshell-mode))
      ac-use-menu-map t)

(setq-default ac-sources (append (list 'ac-source-filename) ac-sources))

(add-hook 'js2-mode-hook
          (lambda ()
            (auto-complete-mode)))

(add-hook 'c-mode-common-hook
          (lambda nil
            ;;(setq ac-sources (append (list 'ac-source-gtags 'ac-source-semantic 'ac-source-semantic-raw) ac-sources))
            (setq ac-sources (append (list 'ac-source-semantic) ac-sources))))

(define-key ac-mode-map (kbd "M-/") 'auto-complete)
(define-key ac-completing-map (kbd "<tab>") 'ac-expand)
(define-key ac-completing-map (kbd "<backtab>") 'ac-previous)
(define-key ac-completing-map (kbd "<return>") 'ac-complete)

(require 'pos-tip)
(setq ac-quick-help-prefer-pos-tip t) 
(provide 'config-auto-complete)

;;; config-auto-complete.el ends here---
