;; config-org.el ---

(require 'org-exp)
(require 'org-install)
(org-remember-insinuate)

(set-face-foreground 'org-hide (face-background 'default))
(setq org-directory "~/Ubuntu One/org"
      org-agenda-files (list (concat org-directory "/gtd.org")
			     (concat org-directory "/notes.org"))
      org-completion-use-ido t
      org-default-notes-file (concat org-directory "/notes.org")
      org-hide-leading-stars t ;只高亮显示最后一个代表层级的 *
      org-id-locations-file "~/.emacs.d/auto-save-list/.org-id-locations"
      org-log-done 'note
      org-startup-truncated nil
      org-export-html-style-include-default nil
      org-export-html-toplevel-hlevel 1
      org-export-html-postamble nil
      )
(add-to-list 'org-export-language-setup (list "zh" "作者" "日期" "目录" "引用"))
(define-key global-map (kbd "C-c a") 'org-agenda)
(define-key global-map (kbd "C-c l") 'org-store-link)
(define-key global-map (kbd "C-c c") 'org-capture)

(require 'config-org2blog)

(provide 'config-org)
;;; config-org.el ends here ---
