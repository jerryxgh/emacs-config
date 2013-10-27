;;; config-base.el --- һЩ���������ã���Щ���û�ı� Emacs ����ۻ��߶Դ󲿷�ģʽ������
;; Time-stamp: <2013-10-26 18:20:02 Jerry Xu>

(require 'eshell)
(require 'ido)
(require 'switch-window) ;window navigation
(require 'temp-buffer-browse)
(temp-buffer-browse-mode 1)
(setq switch-window-shortcut-style 'qwerty)
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
  "If current buffer is eshell buffer, switch to previous buffer. If current buffer is not eshell buffer, switch to eshell buffer,if that does'texists, create one and swich to it."
  (interactive)
  (toggle-shell-buffer eshell-buffer-name 'eshell)
  )
(add-hook 'eshell-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c h")
                           (lambda ()
                             (interactive)
                             (insert
                              (ido-completing-read "Eshell history: "
                                                   (delete-dups
                                                    (ring-elements eshell-history-ring))))))
            (local-set-key (kbd "C-c C-h") 'eshell-list-history)))
(add-hook 'comint-mode-hook
          (lambda ()
            (if (and (and (featurep 'evil) evil-mode))
                (define-key evil-insert-state-map (kbd "C-c h") 'comint-history-isearch-backward)
              (define-key comint-mode-map (kbd "C-c h") 'comint-history-isearch-backward))))

(defun toggle-shell-buffer (shell-buffer-name shell-command)
  (if (equal (buffer-name (current-buffer)) shell-buffer-name)
      (goto-previous-buffer)
    (let ((shell-buffer (get-buffer shell-buffer-name)))
      (if shell-buffer
	  (switch-to-buffer-smartly shell-buffer))
      (shell-command))))

(defun switch-to-buffer-smartly (buffer-to-switch)
  "Switch to buffer, if buffer has been shown in a window, goto that window, else act as switch-to-buffer"
  (let ((window-to-select (catch 'found
			    (walk-windows #'(lambda (window)
					      (if (eq buffer-to-switch (window-buffer window))
						  (throw 'found window)))))))
    (if window-to-select
	(select-window window-to-select)
      (switch-to-buffer buffer-to-switch))))
;;;����ԭ�к�������
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

(load "config-custom") ;����ͨ��customize�������ɵ�����

;;; ����һЩĬ�Ϲرյ�����
(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

;;; �������� ---
(setq user-full-name "Jerry Xu" ;����ȫ�����ʼ����ڷ��ʼ�ʱ�����õ�
      user-mail-address "jerryxgh@gmail.com"
      inhibit-startup-message t ;ȥ��Emacs����ʱ�Ľ���
      ;;gnus-inhibit-startup-message t ;ȥ��guns����ʱ�Ľ���
      ;;gnus-init-file (concat emacs-config-dir "/config/config-gnus.el") ;;����gnus�������ļ���Ĭ����Ϊ~/.gnus.el
      ;;abbrev-file-name "~/.emacs.d/auto-save-list/.abbrev_defs" ;�������Դʵ��ļ�
      custom-file (concat emacs-config-dir "/config/config-custom.el") ;�ɲ˵��޸����õĶ������ᱣ����custom�Ĭ����.emacs
      sql-mysql-options '("-C" "-t" "-f" "-n" "--default-character-set=utf8") ;Show output on windows in buffer
      use-dialog-box nil ; �ǿձ�ʾ�öԻ��������û�ѯ����Ϣ
      eshell-directory-name "~/.emacs.d/auto-save-list/.eshell" ;eshell�����ļ�λ��
      frame-title-format ;���ñ�������ʾ�ļ�������·����
      '("%S" (buffer-file-name "%f"
			       (dired-directory dired-directory "%b")))
      make-backup-files nil ;������
      resize-mini-windows t ;����minibuffer�仯���С
      ring-bell-function 'ignore ;�رվ�������
      x-select-enable-clipboard t ;����emacs���ⲿ���������ճ��
      enable-recursive-minibuffers t ;���Եݹ��ʹ�� minibuffer
      confirm-kill-emacs 'y-or-n-p ; �˳� Emacs ʱ����
      )
;;����info��·����Ҳ��ͨ��Shell��ȫ�ֱ���$INFOPATH���ã�
;;(add-to-list 'Info-default-directory-list " ")
(cond ((eq system-type 'windows-nt)
       (setq dired-listing-switches "-AlX"))
      (t (setq dired-listing-switches "-AlX  --group-directories-first" ;Dired �г��ļ��ķ�ʽ������ A ��ʾ����ʾ . �� ..��l �Ǳ���ѡ��ģ�X ��ʾ������չ������ --group-directories-first ��ʾ��Ŀ¼����ǰ��
               ))
    )

(column-number-mode 1)
(mouse-avoidance-mode 'animate) ;����Զ��ܿ����
(global-hl-line-mode 1) ; ������ǰ��
(show-paren-mode 1) ;��ָ���ƶ���һ�������Աߣ�����ƥ�����һ������
(tooltip-mode 0) ;�رչ�����ʾ(����һ��һ����)
(global-auto-revert-mode 1) ;�ļ��仯ʱ�Զ���������
;;(global-subword-mode 1) ;�Դ���Сд��ϵĵ��ʣ��Դ�д��ĸ��Ϊ���ʵķָ�
(scroll-bar-mode 0) ;ȥ��������(Ҳ������ע����л���.Xdefault������)
(tool-bar-mode 0) ;ȥ��������(Ҳ������ע����л���.Xdefault������)
(set-default-font "Consolas-11") ;����Ĭ������(Ҳ������ע����л���.Xdefault������)
(set-background-color "#CCE8CF") ;���ñ���ɫ(Ҳ������ע����л���.Xdefault������)
(set-fontset-font t 'unicode '("Microsoft Yahei" .  "unicode-bmp")) ;������������

;;; ��ϲ�������������� fringe ��ʾ buffer ���޵ı�ǡ�
(setq-default indicate-buffer-boundaries '((top . left) (t . right))
              indicate-empty-lines t
	      )

;;; shell gdb sql �Ƚ���ʽ shell �˳����Զ��رն�Ӧ buffer
(add-hook 'shell-mode-hook 
          '(lambda ()
             (setq comint-input-ring-file-name "~/.emacs.d/auto-save-list/.history")
             (interactive-shell-on-exit-kill-buffer)))
(ad-activate (defadvice python-shell (after python-shell-exit-kill-buffer)
               "When python-shell exit,kill the buffer"
               (interactive-shell-on-exit-kill-buffer)))
(add-hook 'gdb-mode-hook 'interactive-shell-on-exit-kill-buffer)
(add-hook 'sql-interactive-mode-hook
          'interactive-shell-on-exit-kill-buffer)

;;; tramp --- Զ�̱༭�ļ�
;; Usage: type `C-x C-f' and then enter the filename`/user@machine:/path/to.file
(require 'tramp)
(with-demoted-errors (require 'tramp-sh))

(delete "LC_ALL=C" tramp-remote-process-environment)
;; ������������ tramp Զ�����ӵĻ��������е����Ի��������Խ�� tramp ��������������
(add-to-list 'tramp-remote-process-environment "LANG=zh_CN.utf8" 'append)
(add-to-list 'tramp-remote-process-environment "LC_ALL=zh_CN.utf8" 'append)
(setq ido-enable-tramp-completion t
      tramp-persistency-file-name (expand-file-name "~/.emacs.d/auto-save-list/tramp"))

;;; ibuffer --- ��ǿ��� buffer �б�
(global-set-key (kbd "C-x C-b") 'ibuffer) ;; ��ibuffer����Ĭ�ϵ�buffer switch
(setq ibuffer-never-show-predicates (list "^ ?\\*.*\\*$"))

;;; time-stamp --- ʱ�������
;; �趨�ĵ���һ�α������Ϣ��ֻҪ��������ĵ�����Time-stamp:�����ã��ͻ��Զ�����ʱ���
(setq time-stamp-active t ;����time-stamp
      time-stamp-warn-inactive t ;ȥ��time-stamp�ľ���
      time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S %U"
      )
(add-hook 'before-save-hook 'time-stamp)

;;; ido --- interactively do things ������ʽ������
(setq ido-save-directory-list-file "~/.emacs.d/auto-save-list/.ido.last"
      )
(ido-mode t) ;����idoģʽ
(ido-everywhere t) ; ���ܹ����� ido �ĵط��������� ido
(setq ido-ignore-buffers  '("\\` " "^\\*.*\\*$") ; �л� buffer ʱ����Ҫ��ʾ�� buffer
      )

;;; cal-china-x --- ũ��
(require 'cal-china-x)
(setq mark-holidays-in-calendar t)
(setq cal-china-x-important-holidays cal-china-x-chinese-holidays)
(setq calendar-holidays cal-china-x-important-holidays)

;;; easypg --- �����ļ�
;;(require 'epa) 
(setq epa-file-encrypt-to nil ;Ĭ��ʹ�öԳƼ��� 
      epa-file-cache-passphrase-for-symmetric-encryption t ;���������룬����༭ʱÿ�α��涼Ҫ�������� 
      epa-file-inhibit-auto-save t) ;�����Զ����� 
(setenv "GPG_AGENT_INFO" nil) ; ʹ��minibuffer����passphrase�������ǵ����Ի���Ļ������Խ���������GPG_AGENT_INFO��ա�

;;; magit --- �� Emacs ��ʹ�� Git
(require 'magit)

;;; dired-x --- �кܶ�õ����� ���� C-x C-j ������ǰ�ļ����ڵ�Ŀ¼
(require 'dired-x)

;;; ���� ---
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(global-set-key (kbd "C-\\") 'toggle-truncate-lines) ;; �Զ����п���
(global-set-key (kbd "C-<") 'shrink-window)
(global-set-key (kbd "C->") 'enlarge-window)
(define-key global-map (kbd "<f8>") 'goto-previous-buffer)
(define-key global-map (kbd "C-x C-z") 'goto-previous-buffer)
(define-key global-map (kbd "<f7>") 'toggle-eshell-buffer)
(define-key lisp-interaction-mode-map (kbd "C-x k") 'clear-scratch-buffer)
(global-set-key (kbd "C-x j") '(lambda () (interactive)
                                 (ido-find-file-in-dir (concat emacs-config-dir "/config")))) 

;;; ������� ---
(setq mouse-wheel-scroll-amount '(3 ((shift) . 1)) ;; three line at a time
      mouse-wheel-progressive-speed nil ;; don't accelerate scrolling
      scroll-preserve-screen-position t
      scroll-conservatively most-positive-fixnum ; ƽ������
      )

;;; bookmark --- ��ǩ����
(require 'bookmark)
(setq bookmark-default-file "~/.emacs.d/auto-save-list/.emacs.bmk" ;������ǩ�ļ���Ĭ����~/.emacs.bmk
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

(defun clear-shell ()
   (interactive)
   (cond ((eq major-mode 'eshell-mode)
          (let ((eshell-buffer-maximum-lines 0))
            (eshell-truncate-buffer)))
         ((derived-mode-p 'comint-mode)
          (let ((comint-buffer-maximum-size 0))
            (comint-truncate-buffer)))))

(provide 'config-base)
;;; config-base.el ends here ---
