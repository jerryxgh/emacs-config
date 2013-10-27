;; config-auto-complete.el ---

;;(require 'config-cedet)
(require 'auto-complete-config)

;; 覆盖 auto-complete.el 的函数 ac-mode-dictionary，这样能加载多个目录下的字典文件
;; (defun ac-mode-dictionary (mode)
;;   (let (result)
;;     (dolist (name (cons (symbol-name mode)
;;                         (ignore-errors (list (file-name-extension (buffer-file-name))))))
;;       (dolist (dir ac-dictionary-directories)
;;         (let ((file (concat dir "/" name)))
;;           (if (file-exists-p file)
;;               (setq result (append result (ac-file-dictionary file)))))))
;;     result))

(add-to-list 'ac-dictionary-directories (concat emacs-config-dir "/config/ac-dict"))
(add-to-list 'ac-user-dictionary-files (concat emacs-config-dir "/config/ac-dict/config.dict"))
(ac-config-default)
(setq ac-auto-start 1 ;自动提示，如果是一个正整数，表示输入该数字的字符后开始自动补全，如果是nil则不自动提示
      ac-comphist-file "~/.emacs.d/auto-save-list/ac-comphist.dat"
      ac-modes (append ac-modes
                       '(mpr-mode pdu-mode tdl-mode conf-xdefaults-mode html-mode nxml-mode nxhtml-mode objc-mode jde-mode sql-mode change-log-mode text-mode makefile-gmake-mode makefile-bsdmake-mo autoconf-mode makefile-automake-mode snippet-mode eshell-mode))
      ac-use-menu-map t
      ;ac-use-quick-help nil
      ;ac-quick-help-delay 1
      )

;;(setq-default ac-sources (append (list 'ac-source-filename 'ac-source-yasnippet) ac-sources))

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
