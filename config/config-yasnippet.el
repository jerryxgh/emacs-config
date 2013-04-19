;;; config-yasnippet.el ---

(provide 'config-yasnippet)
(require 'dropdown-list)
(require 'yasnippet)

;; yas-snippet-dirs configuration should be at first
(add-to-list 'yas-snippet-dirs (concat emacs-config-dir "/config/snippets"))
;; Delete dirs that don't exist in yas-snippet-dirs
(dolist (dir yas-snippet-dirs)
  (unless (file-directory-p dir)
    (setq yas-snippet-dirs (delete dir yas-snippet-dirs))))

(setq yas-trigger-key "<tab>"
      yas-next-field-key "<tab>"
      yas-use-menu 'abbreviate ; menu only show the mode according to the major-mode of the current buffer
      )

(defvar config-modes-defer-yasnippet (list 'js2-mode 'js-mode 'nxhtml-mode)
  "A list contains major mode name, in these modes yasnippet will be turn on by major mode hook.")
;; 要仔细设置 yas-dont-activate 这个变量，否则 yas-minor-mode 不能启动
(setq-default yas-dont-activate (add-to-list 'yas-dont-activate
                                             '(lambda ()
                                                buffer-read-only)))


(add-hook 'js2-mode-hook '(lambda ()
                            (make-local-variable 'yas-extra-modes)
                            (add-to-list 'yas-extra-modes 'javascript-mode)
                            (yas-minor-mode 1)
                            ))
(add-hook 'js-mode-hook '(lambda ()
                           (make-local-variable 'yas-extra-modes)
                           (add-to-list 'yas-extra-modes 'javascript-mode)
                           (yas-minor-mode 1)
                           ))
(add-hook 'nxhtml-mode-hook '(lambda ()
                               (make-local-variable 'yas-extra-modes)
                               (add-to-list 'yas-extra-modes 'html-mode)
                               (yas-minor-mode 1)
                               ))

(require 'popup)
;; add some shotcuts in popup menu mode
(define-key popup-menu-keymap (kbd "M-n") 'popup-next)
(define-key popup-menu-keymap (kbd "<tab>") 'popup-next)
(define-key popup-menu-keymap (kbd "<backtab>") 'popup-previous)
(define-key popup-menu-keymap (kbd "M-p") 'popup-previous)
(define-key popup-menu-keymap (kbd "<escape>") '(lambda nil
                                                  (interactive)
                                                  (evil-force-normal-state)
                                                  (keyboard-quit)))

(defun yas-popup-isearch-prompt (prompt choices &optional display-fn)
  (when (featurep 'popup)
    (popup-menu*
     (mapcar
      (lambda (choice)
        (popup-make-item
         (or (and display-fn (funcall display-fn choice))
             choice)
         :value choice))
      choices)
     :prompt prompt
     ;; start isearch mode immediately
     ;;:isearch t
     )))

(setq yas-prompt-functions '(yas-popup-isearch-prompt yas-no-prompt))

(yas-global-mode 1)


;;; config-yasnippet.el ---
