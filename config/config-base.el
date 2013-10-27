;;; config-base.el --- 一些基本的设置，这些设置会改变 Emacs 的外观或者对大部分模式起作用
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
;;;覆盖原有函数定义
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

(load "config-custom") ;加载通过customize工具生成的配置

;;; 开启一些默认关闭的特性
(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

;;; 基础设置 ---
(setq user-full-name "Jerry Xu" ;设置全名和邮件，在发邮件时可以用到
      user-mail-address "jerryxgh@gmail.com"
      inhibit-startup-message t ;去掉Emacs启动时的界面
      ;;gnus-inhibit-startup-message t ;去掉guns启动时的界面
      ;;gnus-init-file (concat emacs-config-dir "/config/config-gnus.el") ;;设置gnus启动的文件。默认是为~/.gnus.el
      ;;abbrev-file-name "~/.emacs.d/auto-save-list/.abbrev_defs" ;设置缩略词的文件
      custom-file (concat emacs-config-dir "/config/config-custom.el") ;由菜单修改配置的东西将会保存在custom里，默认在.emacs
      sql-mysql-options '("-C" "-t" "-f" "-n" "--default-character-set=utf8") ;Show output on windows in buffer
      use-dialog-box nil ; 非空表示用对话框来向用户询问信息
      eshell-directory-name "~/.emacs.d/auto-save-list/.eshell" ;eshell配置文件位置
      frame-title-format ;设置标题栏显示文件完整的路径名
      '("%S" (buffer-file-name "%f"
			       (dired-directory dired-directory "%b")))
      make-backup-files nil ;不备份
      resize-mini-windows t ;允许minibuffer变化其大小
      ring-bell-function 'ignore ;关闭警告声音
      x-select-enable-clipboard t ;允许emacs和外部其他程序的粘贴
      enable-recursive-minibuffers t ;可以递归的使用 minibuffer
      confirm-kill-emacs 'y-or-n-p ; 退出 Emacs 时警告
      )
;;设置info的路径，也可通过Shell的全局变量$INFOPATH设置，
;;(add-to-list 'Info-default-directory-list " ")
(cond ((eq system-type 'windows-nt)
       (setq dired-listing-switches "-AlX"))
      (t (setq dired-listing-switches "-AlX  --group-directories-first" ;Dired 列出文件的方式，其中 A 表示不显示 . 和 ..，l 是必须选择的，X 表示按照扩展名排序 --group-directories-first 表示把目录排在前面
               ))
    )

(column-number-mode 1)
(mouse-avoidance-mode 'animate) ;鼠标自动避开光标
(global-hl-line-mode 1) ; 高亮当前行
(show-paren-mode 1) ;当指针移动到一个括号旁边，高亮匹配的另一个括号
(tooltip-mode 0) ;关闭工具提示(老是一闪一闪的)
(global-auto-revert-mode 1) ;文件变化时自动重新载入
;;(global-subword-mode 1) ;对待大小写混合的单词，以大写字母作为单词的分隔
(scroll-bar-mode 0) ;去掉滚动条(也可以在注册表中或者.Xdefault中设置)
(tool-bar-mode 0) ;去掉工具栏(也可以在注册表中或者.Xdefault中设置)
(set-default-font "Consolas-11") ;设置默认字体(也可以在注册表中或者.Xdefault中设置)
(set-background-color "#CCE8CF") ;设置背景色(也可以在注册表中或者.Xdefault中设置)
(set-fontset-font t 'unicode '("Microsoft Yahei" .  "unicode-bmp")) ;设置中文字体

;;; 我喜欢下面的这个，在 fringe 显示 buffer 界限的标记。
(setq-default indicate-buffer-boundaries '((top . left) (t . right))
              indicate-empty-lines t
	      )

;;; shell gdb sql 等交互式 shell 退出后，自动关闭对应 buffer
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

;;; tramp --- 远程编辑文件
;; Usage: type `C-x C-f' and then enter the filename`/user@machine:/path/to.file
(require 'tramp)
(with-demoted-errors (require 'tramp-sh))

(delete "LC_ALL=C" tramp-remote-process-environment)
;; 以下两行设置 tramp 远程连接的环境变量中的语言环境，可以解决 tramp 的中文乱码问题
(add-to-list 'tramp-remote-process-environment "LANG=zh_CN.utf8" 'append)
(add-to-list 'tramp-remote-process-environment "LC_ALL=zh_CN.utf8" 'append)
(setq ido-enable-tramp-completion t
      tramp-persistency-file-name (expand-file-name "~/.emacs.d/auto-save-list/tramp"))

;;; ibuffer --- 更强大的 buffer 列表
(global-set-key (kbd "C-x C-b") 'ibuffer) ;; 用ibuffer代替默认的buffer switch
(setq ibuffer-never-show-predicates (list "^ ?\\*.*\\*$"))

;;; time-stamp --- 时间戳设置
;; 设定文档上一次保存的信息，只要里在你得文档里有Time-stamp:的设置，就会自动保存时间戳
(setq time-stamp-active t ;启用time-stamp
      time-stamp-warn-inactive t ;去掉time-stamp的警告
      time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S %U"
      )
(add-hook 'before-save-hook 'time-stamp)

;;; ido --- interactively do things （交互式地做）
(setq ido-save-directory-list-file "~/.emacs.d/auto-save-list/.ido.last"
      )
(ido-mode t) ;开启ido模式
(ido-everywhere t) ; 在能够开启 ido 的地方尽量开启 ido
(setq ido-ignore-buffers  '("\\` " "^\\*.*\\*$") ; 切换 buffer 时不需要显示的 buffer
      )

;;; cal-china-x --- 农历
(require 'cal-china-x)
(setq mark-holidays-in-calendar t)
(setq cal-china-x-important-holidays cal-china-x-chinese-holidays)
(setq calendar-holidays cal-china-x-important-holidays)

;;; easypg --- 加密文件
;;(require 'epa) 
(setq epa-file-encrypt-to nil ;默认使用对称加密 
      epa-file-cache-passphrase-for-symmetric-encryption t ;允许缓存密码，否则编辑时每次保存都要输入密码 
      epa-file-inhibit-auto-save t) ;允许自动保存 
(setenv "GPG_AGENT_INFO" nil) ; 使用minibuffer输入passphrase，而不是弹出对话框的话，可以将环境变量GPG_AGENT_INFO清空。

;;; magit --- 在 Emacs 中使用 Git
(require 'magit)

;;; dired-x --- 有很多好的特性 比如 C-x C-j 跳到当前文件所在的目录
(require 'dired-x)

;;; 键绑定 ---
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(global-set-key (kbd "C-\\") 'toggle-truncate-lines) ;; 自动折行开关
(global-set-key (kbd "C-<") 'shrink-window)
(global-set-key (kbd "C->") 'enlarge-window)
(define-key global-map (kbd "<f8>") 'goto-previous-buffer)
(define-key global-map (kbd "C-x C-z") 'goto-previous-buffer)
(define-key global-map (kbd "<f7>") 'toggle-eshell-buffer)
(define-key lisp-interaction-mode-map (kbd "C-x k") 'clear-scratch-buffer)
(global-set-key (kbd "C-x j") '(lambda () (interactive)
                                 (ido-find-file-in-dir (concat emacs-config-dir "/config")))) 

;;; 鼠标设置 ---
(setq mouse-wheel-scroll-amount '(3 ((shift) . 1)) ;; three line at a time
      mouse-wheel-progressive-speed nil ;; don't accelerate scrolling
      scroll-preserve-screen-position t
      scroll-conservatively most-positive-fixnum ; 平滑滚动
      )

;;; bookmark --- 书签设置
(require 'bookmark)
(setq bookmark-default-file "~/.emacs.d/auto-save-list/.emacs.bmk" ;设置书签文件，默认是~/.emacs.bmk
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
