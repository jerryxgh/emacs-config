;; config-org.el ---

(require 'org)

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
      )
;;(add-to-list 'org-export-language-setup (list "zh" "作者" "日期" "目录" "引用"))
(define-key global-map (kbd "C-c a") 'org-agenda)
(define-key global-map (kbd "C-c b") 'org-iswitchb)
(define-key global-map (kbd "C-c c") 'org-capture)
(define-key global-map (kbd "C-c l") 'org-store-link)

(define-key org-mode-map (kbd "C-c d") 'org-time-stamp)

(require 'config-org2blog)

(provide 'config-org)
;;; config-org.el ends here ---
