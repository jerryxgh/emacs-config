;;; config-base.el ---      
;; Time-stamp: <2014-02-26 17:51:02 Jerry Xu>

(require 'eshell)
(require 'ido)
(require 'switch-window) ;window navigation
(require 'temp-buffer-browse)
(temp-buffer-browse-mode 1)
(setq switch-window-shortcut-style 'qwerty)
(if (listp safe-local-variable-values)
    (setq safe-local-variable-values
          (append safe-local-variable-values
                  (quote ((byte-compile-warnings not cl-functions lexical unresolved obsolete) (lexical-binding . t))))))
(defun create-scratch-buffer nil
  "create a scratch buffer"
  (interactive)
  (unless (get-buffer "*scratch*")
    (switch-to-buffer (get-buffer-create "*scratch*"))
    (insert initial-scratch-message)
    (goto-char (point-max))
    (lisp-interaction-mode)))

(defun clear-scratch-buffer nil 
  "Clear the scratch buffer."
  (interactive)
  (when (equal (buffer-name (current-buffer)) "*scratch*")
    (delete-region (point-min) (point-max))
    (insert initial-scratch-message)
    (goto-char (point-max))))

(defun interactive-shell-on-exit-kill-buffer nil
  "kill the buffer on exit of interactive shell"
  (let ((process (get-buffer-process (current-buffer))))
    (if process
        (set-process-sentinel process
                              (lambda (process state)
                                (when (or (string-match "exited abnormally with code." state)
                                          (string-match "finished" state))
                                  (kill-buffer (current-buffer))))))))
(defun goto-previous-buffer ()
  "Back to the previous buffer."
  (interactive)
  (let ((buffer-to-switch
	 (catch 'break
	   (dolist (buffer (buffer-list (selected-frame)))
	     (unless (or (string-match "^ \\*" (buffer-name buffer))
			 (eq buffer (current-buffer)))
	       (throw 'break buffer))))))
    (if buffer-to-switch
	(switch-to-buffer-smartly buffer-to-switch)
      (message "Don't know which buffer to go..."))))

(defun toggle-eshell-buffer ()
  "If current buffer is eshell buffer, switch to previous buffer.
If current buffer is not eshell buffer, switch to eshell buffer,
if that does'texists, create one and swich to it."
  (interactive)
  (toggle-shell-buffer eshell-buffer-name 'eshell)
  )
;; (add-hook 'eshell-mode-hook
;;           (lambda ()
;;             (local-set-key (kbd "C-c h")
;;                            (lambda ()
;;                              (interactive)
;;                              (insert
;;                               (ido-completing-read "Eshell history: "
;;                                                    (delete-dups
;;                                                     (ring-elements eshell-history-ring))))))
;;             (local-set-key (kbd "C-c C-h") 'eshell-list-history)))
;; (add-hook 'comint-mode-hook
;;           (lambda ()
;;             (if (and (and (featurep 'evil) evil-mode))
;;                 (define-key evil-insert-state-map (kbd "C-c h") 'comint-history-isearch-backward)
;;               (define-key comint-mode-map (kbd "C-c h") 'comint-history-isearch-backward))))

(defun toggle-shell-buffer (shell-buffer-name shell-new-command)
  (if (equal (buffer-name (current-buffer)) shell-buffer-name)
      (goto-previous-buffer)
    (let ((shell-buffer (get-buffer shell-buffer-name)))
      (if shell-buffer
	  (switch-to-buffer-smartly shell-buffer)
        (if (functionp shell-new-command)
            (funcall shell-new-command))))))

(defun switch-to-buffer-smartly (buffer-to-switch)
  "Switch to buffer, if buffer has been shown in a window, goto that window, else act as switch-to-buffer"
  (let ((window-to-select (catch 'found
			    (walk-windows #'(lambda (window)
					      (if (eq buffer-to-switch (window-buffer window))
						  (throw 'found window)))))))
    (if window-to-select
	(select-window window-to-select)
      (switch-to-buffer buffer-to-switch))))
;;;             
(defun bookmark-completing-read (prompt &optional default)
  "Prompting with PROMPT, read a bookmark name in ido completion.
PROMPT will get a \": \" stuck on the end no matter what, so you
probably don't want to include one yourself.
Optional second arg DEFAULT is a string to return if the user enters
the empty string."
  (bookmark-maybe-load-default-file) ; paranoia
  (if (listp last-nonmenu-event)
      (bookmark-menu-popup-paned-menu t prompt
				      (if bookmark-sort-flag
					  (sort (bookmark-all-names)
						'string-lessp)
					(bookmark-all-names)))
    (let* ((completion-ignore-case bookmark-completion-ignore-case)
	   (default default)
	   (prompt (concat prompt (if default
                                      (format " (%s): " default)
                                    ": ")))
	   (str
	    (ido-completing-read prompt
                                 (mapcar 'car bookmark-alist)
                                 nil
                                 0
                                 nil
                                 'bookmark-history)))
      (if (string-equal "" str) default str))))

(load "config-custom") 

;;;               
(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

;;;  
(setq user-full-name "Jerry Xu" 
      user-mail-address "jerryxgh@gmail.com"
      inhibit-startup-message t 
      ;;gnus-inhibit-startup-message t ;    
      ;;gnus-init-file (concat emacs-config-dir "/config/config-gnus.el") 
      ;;abbrev-file-name "~/.emacs.d/auto-save-list/.abbrev_defs" 
      custom-file (concat emacs-config-dir "/config/config-custom.el") 
      ;;Show output on windows in buffer
      sql-mysql-options '("-C" "-t" "-f" "-n" "--default-character-set=utf8") 
      use-dialog-box nil 
      eshell-directory-name "~/.emacs.d/auto-save-list/.eshell" ;eshell            
      frame-title-format 
      '("%S" (buffer-file-name "%f"
			       (dired-directory dired-directory "%b")))
      make-backup-files nil 
      resize-mini-windows t 
      ring-bell-function 'ignore 
      x-select-enable-clipboard t 
      enable-recursive-minibuffers t 
      confirm-kill-emacs 'y-or-n-p 
      ediff-window-setup-function 'ediff-setup-windows-plain
      )
;;(add-to-list 'Info-default-directory-list " ")
(cond ((eq system-type 'windows-nt)
       (setq dired-listing-switches "-AlX"))
      (t (setq dired-listing-switches "-AlX  --group-directories-first" 
               ))
      )

(column-number-mode 1)
(mouse-avoidance-mode 'animate) 
(global-hl-line-mode 1) 
;;(global-linum-mode 1)
(show-paren-mode 1) 
(tooltip-mode 0) 
(global-auto-revert-mode 1) 
;;(global-subword-mode 1) 
(scroll-bar-mode 0) 
(tool-bar-mode 0) 
(set-default-font "Consolas-11") 
(set-background-color "#CCE8CF") 
(set-fontset-font t 'unicode '("WenQuanYi Micro Hei" .  "unicode-bmp"))

(setq-default indicate-buffer-boundaries '((top . left) (t . right))
              indicate-empty-lines t
	      )

;; (add-hook 'shell-mode-hook 
;;           '(lambda ()
;;              (setq comint-input-ring-file-name
;;                    "~/.emacs.d/auto-save-list/.history"
;;              (interactive-shell-on-exit-kill-buffer)))
;; (ad-activate (defadvice python-shell (after python-shell-exit-kill-buffer)
;;                "When python-shell exit,kill the buffer"
;;                (interactive-shell-on-exit-kill-buffer)))
;; (ad-activate (defadvice run-python (after python-shell-exit-kill-buffer)
;;                "When python-shell exit,kill the buffer"
;;                (interactive-shell-on-exit-kill-buffer)))
(add-hook 'comint-mode-hook 'interactive-shell-on-exit-kill-buffer)
;; (add-hook 'gdb-mode-hook 'interactive-shell-on-exit-kill-buffer)
;; (add-hook 'sql-interactive-mode-hook
;;           'interactive-shell-on-exit-kill-buffer)

;;; tramp ---     
;; Usage: type `C-x C-f' and then enter the filename`/user@machine:/path/to.file
(require 'tramp)
;;(with-demoted-errors (require 'tramp-sh))
(if (boundp 'tramp-remote-process-environment)
  (progn
    (delete "LC_ALL=C" tramp-remote-process-environment)
    (add-to-list 'tramp-remote-process-environment "LANG=zh_CN.utf8" 'append)
    (add-to-list 'tramp-remote-process-environment "LC_ALL=zh_CN.utf8" 'append)))

(setq ido-enable-tramp-completion t
      tramp-persistency-file-name (expand-file-name "~/.emacs.d/auto-save-list/tramp"))

;;; ibuffer ---  
(global-set-key (kbd "C-x C-b") 'ibuffer) 
(setq ibuffer-never-show-predicates (list "^ ?\\*.*\\*$"))

;;; time-stamp ---  
(setq time-stamp-active t ;    time-stamp
      time-stamp-warn-inactive t ;    time-stamp      
      time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S %U"
      )
(add-hook 'before-save-hook 'time-stamp)

;;; ido --- interactively do things
(setq ido-save-directory-list-file "~/.emacs.d/auto-save-list/.ido.last"
      )
(ido-mode t) ;    ido    
(ido-everywhere t) 
(setq ido-ignore-buffers  '("\\` " "^\\*.*\\*$") 
      )

;;; cal-china-x ---    
(require 'cal-china-x)
(setq mark-holidays-in-calendar t)
(setq cal-china-x-important-holidays cal-china-x-chinese-holidays)
(setq calendar-holidays cal-china-x-important-holidays)

;;; easypg ---         
;;(require 'epa) 
(setq epa-file-encrypt-to nil ;                 
      epa-file-cache-passphrase-for-symmetric-encryption t 
      epa-file-inhibit-auto-save t) 
(setenv "GPG_AGENT_INFO" nil) ;     minibuffer    passphrase              

;;; magit ---    Emacs        Git
(require 'magit)

;;; dired-x ---
(require 'dired-x)

;;; fill-column ----------------------------------------------------------
(setq-default fill-column 80)
(require 'fill-column-indicator)
(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode 1)

;;;
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(global-set-key (kbd "C-\\") 'toggle-truncate-lines) ;; ¡Á           
(global-set-key (kbd "C-<") 'shrink-window)
(global-set-key (kbd "C->") 'enlarge-window)
(define-key global-map (kbd "<f8>") 'goto-previous-buffer)
(define-key global-map (kbd "C-x C-z") 'goto-previous-buffer)
(define-key global-map (kbd "<f7>") 'toggle-eshell-buffer)
(define-key lisp-interaction-mode-map (kbd "C-x k") 'clear-scratch-buffer)
(global-set-key (kbd "C-x j") '(lambda () (interactive)
                                 (ido-find-file-in-dir (concat emacs-config-dir "/config")))) 

;;;
(setq mouse-wheel-scroll-amount '(3 ((shift) . 1)) ;; three line at a time
      mouse-wheel-progressive-speed nil ;; don't accelerate scrolling
      scroll-step 1
      scroll-preserve-screen-position t
      scroll-conservatively most-positive-fixnum ;         
      )

;;; bookmark ---
(require 'bookmark)
(setq bookmark-default-file "~/.emacs.d/auto-save-list/.emacs.bmk" 
      )
;; redefine function bookmark-completing-read to use ido
(defun bookmark-completing-read (prompt &optional default)
  "Prompting with PROMPT, read a bookmark name in completion.
  PROMPT will get a \": \" stuck on the end no matter what, so you
  probably don't want to include one yourself.
  Optional second arg DEFAULT is a string to return if the user enters
  the empty string."
  (bookmark-maybe-load-default-file) ; paranoia
  (if (listp last-nonmenu-event)
    (bookmark-menu-popup-paned-menu t prompt
                                    (if bookmark-sort-flag
                                      (sort (bookmark-all-names)
                                            'string-lessp)
                                      (bookmark-all-names)))
    (let* ((completion-ignore-case bookmark-completion-ignore-case)
           (default default)
           (prompt (concat prompt (if default
                                    (format " (%s): " default)
                                    ": ")))
           (str
             (ido-completing-read prompt
                                  (mapcar 'car bookmark-alist)
                                  nil
                                  0
                                  nil
                                  'bookmark-history)))
      (if (string-equal "" str) default str))))

(defun clear ()
  (interactive)
  (cond ((eq major-mode 'eshell-mode)
         (let ((eshell-buffer-maximum-lines 0))
           (eshell-truncate-buffer)))
        ((derived-mode-p 'comint-mode)
         (let ((comint-buffer-maximum-size 0))
           (comint-truncate-buffer)))))
(define-key shell-mode-map (kbd "C-j") 'comint-send-input)

(provide 'config-base)
;;; config-base.el ends here ---
