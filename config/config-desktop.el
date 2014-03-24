;;; config-desktop.el ---

;;desktop.el
(require 'desktop)
(desktop-save-mode 1)
(setq desktop-path '("~/.emacs.d/auto-save-list/")
      desktop-dirname "~/.emacs.d/auto-save-list/"
      desktop-base-file-name ".emacs-desktop"
      history-length 250
      desktop-buffers-not-to-save (concat "\\("
                                          "^nn\\.a[0-9]+\\|\\.log\\|(ftp)\\|^tags\\|^TAGS"
                                          "\\|\\.emacs.*\\|\\.diary\\|\\.newsrc-dribble\\|\\.bbdb"
                                          "\\)$")
      )
(add-to-list 'desktop-modes-not-to-save 'Info-mode)

;; workgroups2 configuration
;; (require 'workgroups2)
;; Change some settings
;(workgroups-mode 1)        ; put this one at the bottom of .emacs


(provide 'config-desktop)
;;; config-desktop.el ends here ---
