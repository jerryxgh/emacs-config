;;; config-evil.el --- Evil configuration
;; Firstly,there is a bug in evil-core.el 276行，改为下面的样子：
;; defadvice switch-to-buffer (before evil activate)
  ;; "Initialize Evil in the displayed buffer."
  ;; (when evil-mode
  ;;   (when (and (ad-get-arg 0) (get-buffer (ad-get-arg 0)))
  ;;     (with-current-buffer (ad-get-arg 0)
  ;;       (unless evil-local-mode
  ;;         (evil-local-mode 1))))))

(setq evil-want-C-w-in-emacs-state t 
      evil-want-C-w-delete nil
      evil-want-C-i-jump nil
      evil-want-visual-char-semi-exclusive t
      evil-cross-lines t)
(require 'goto-chg)
(require 'evil)

(defun config-evil-key-bindings nil
  "Define my own key binding in Evil"
  (define-key evil-insert-state-map (kbd "C-d") 'delete-char)
  (define-key evil-insert-state-map (kbd "C-e") 'move-end-of-line)
  (define-key evil-insert-state-map (kbd "C-k") 'paredit-kill)
  (define-key evil-insert-state-map (kbd "C-n") 'next-line)
  (define-key evil-insert-state-map (kbd "C-p") 'previous-line)
  (define-key evil-insert-state-map (kbd "C-w") 'evil-window-map)
  (define-key evil-insert-state-map (kbd "C-y") 'yank)
  
  (define-key evil-motion-state-map (kbd "C-i") 'evil-jump-forward)

  (define-key evil-window-map (kbd "w") 'switch-window)
  (define-key evil-window-map (kbd "C-w") 'switch-window)
;;  (if (featurep 'switch-window)
;;      (dolist index-key-pair (list '(1 "C-a") '(2 "C-s") '(3 "C d") '(4 "C-f"))
;;              (define-key evil-window-map (kbd (cdar index-key-pair))
;;                '(lambda ()
;;                   (interactive)
;;                   (apply-to-window-index 'select-window (car index-key-pair) "Move to %S"))
)

(config-evil-key-bindings)

(loop for (mode . state) in '((calendar-mode . emacs)
                              (help-mode . emacs)
                              (Info-mode . emacs)
                              (dired-mode . emacs)
                              (Man-mode . emacs)
                              (grep-mode . emacs)
                              (view-mode . emacs)
                              (image-mode . emacs))
      do (evil-set-initial-state mode state))


;; Load Evil
(evil-mode 1)

(require 'evil-tab-minor-mode)
(evil-tab-global-mode t)

(provide 'config-evil)

;;; config-evil.el ends here
