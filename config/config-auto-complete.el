;; config-auto-complete.el ---

(require 'config-cedet)
(require 'auto-complete-config)

;; ���� auto-complete.el �ĺ��� ac-mode-dictionary�������ܼ��ض��Ŀ¼�µ��ֵ��ļ�
(defun ac-mode-dictionary (mode)
  (let (result)
    (dolist (name (cons (symbol-name mode)
		      (ignore-errors (list (file-name-extension (buffer-file-name))))))
    (dolist (dir ac-dictionary-directories)
      (let ((file (concat dir "/" name)))
 	(if (file-exists-p file)
 	    (setq result (append result (ac-file-dictionary file)))))))
    result))

(add-to-list 'ac-dictionary-directories (concat emacs-config-dir "/config/ac-dict"))
(add-to-list 'ac-user-dictionary-files (concat emacs-config-dir "/config/ac-dict/config.dict"))
(ac-config-default)
(setq ac-auto-start 1 ;�Զ���ʾ�������һ������������ʾ��������ֵ��ַ���ʼ�Զ���ȫ�������nil���Զ���ʾ
      ac-comphist-file "~/.emacs.d/auto-save-list/ac-comphist.dat"
      ac-modes (append ac-modes
                       '(conf-xdefaults-mode html-mode nxml-mode nxhtml-mode objc-mode jde-mode sql-mode change-log-mode text-mode makefile-gmake-mode makefile-bsdmake-mo autoconf-mode makefile-automake-mode snippet-mode))
      ac-use-quick-help nil
      )
(setq-default ac-sources (append '(ac-source-semantic) ac-sources))
(defun ac-common-setup ()
  "This function is defined in the file auto-complete-config.el, redefine it here to add some sources which will be used in all modes."
  (add-to-list 'ac-sources 'ac-source-filename)
  (add-to-list 'ac-sources 'ac-source-yasnippet))

(define-key ac-mode-map (kbd "M-/") 'auto-complete)
(define-key ac-completing-map (kbd "<tab>") 'ac-expand)
(define-key ac-completing-map (kbd "<backtab>") 'ac-previous)
(define-key ac-completing-map (kbd "<return>") 'ac-complete)


(provide 'config-auto-complete)

;;; config-auto-complete.el ends here---
