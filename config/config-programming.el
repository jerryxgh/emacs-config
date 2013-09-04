;;; config-programming.el --- 

;; Copyright 2012 Jerry Xu
;;
;; Author: Jerry Xu jerryxgh@gmail.com
;; Version: 0.0
;; Keywords: programming settings
;; X-URL: not distributed yet

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; 

;; Put this file into your load-path and the following into your ~/.emacs:
;;   (require 'config-programming)

;;; Code:

(provide 'config-programming)
;;; Programming Base ---------------------------------------------------------
(require 'config-auto-complete) ;自动补全
(require 'config-auto-insert) ;创建文件时自动插入模板
(require 'config-autopair) ;自动补全括号
(require 'config-ecb) ;ecb--集成 cedet 的各种功能
(require 'config-yasnippet) ;模式的补全
(setq-default indent-tabs-mode nil) ;缩进时不用 tab ，全部使用空格缩进(M-x tabify/untabify 将区域中的特定个数的空格替换成tab或相反)
;; cc-mode --- C like language, such as C C++ Java
(require 'cc-mode)
(add-hook 'c-mode-common-hook
          '(lambda nil
             (setq c-default-style '((java-mode . "java") (awk-mode . "awk") (other . "k&r")) ;"k&r" ;设置c、c++、java等语言的缩进格式
		   c-basic-offset 4 ; 缩进的宽度
                   )

             (local-set-key  (kbd "C-c z") 'ff-find-other-file)))

;;; C/C++ --------------------------------------------------------------------
;; (setq compilation-finish-functions '(lambda (buffer msg)
;; 				      "Close compilation buffer when there is no error. This function may be called by other function, like grep, so only kill the buffer whos name is *compilation*."
;; 				      (when (and (string-match "finished" msg)
;;                                                  (string-equal "*compilation*"
;;                                                                (buffer-name buffer)))
;;                                         (kill-buffer-and-window)
;;                                         (toggle-eshell-buffer)))
;;       compilation-read-command nil ;运行 A-x compile 时不提示输入命令，如果想修改编译命令，可以 C-u A-x compile
;;       )
(defun compile-immediately ()
  "Just as its name implies, compile-immediately."
  (interactive)
  (compile compile-command))

(define-key c-mode-map (kbd "<f9>") 'compile-immediately)
(define-key c++-mode-map (kbd "<f9>") 'compile-immediately)

;;; HTML/XHTML/JSP/PHP -------------------------------------------------------
(setq nxml-child-indent 4)

;;; JavaScript ---------------------------------------------------------------
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;;; Emacs Lisp ---------------------------------------------------------------
(require 'find-func)
(defun find-function-or-variable-or-file-at-point ()
  "Just as its name implies."
  (interactive)
  (let ((variable (variable-at-point))
	(function (function-called-at-point)))
    (cond ((null (equal variable 0)) (find-function-do-it variable 'defvar 'switch-to-buffer-other-window))
	  (function (find-function-do-it function nil 'switch-to-buffer-other-window))
	  (t (find-file-at-point)))))
(define-key emacs-lisp-mode-map (kbd "<f10>") 'find-function-or-variable-or-file-at-point)
(define-key lisp-interaction-mode-map (kbd "<f10>") 'find-function-or-variable-or-file-at-point)
;; paredit --- 自动平衡括号
(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       (lambda () (paredit-mode +1)))
(add-hook 'lisp-mode-hook             (lambda () (paredit-mode +1)))
(add-hook 'lisp-interaction-mode-hook (lambda ()
                                        (paredit-mode +1)
                                        (define-key paredit-mode-map (kbd "C-j") 'eval-print-last-sexp)))
(add-hook 'scheme-mode-hook           (lambda () (paredit-mode +1)))

;; hideshowvis --- 在右边显示折叠标志
(autoload 'hideshowvis-enable "hideshowvis" "Highlight foldable regions")
(autoload 'hideshowvis-symbols "hideshowvis")
(autoload 'hideshowvis-minor-mode
  "hideshowvis"
  "Will indicate regions foldable with hideshow in the fringe."
  'interactive)
(dolist (hook (list 'emacs-lisp-mode-hook
                    'c++-mode-hook
                    'c-mode-hook
                    'java-mode-hook))
  (add-hook hook 'hideshowvis-enable))
(hideshowvis-symbols)

;; sh-mode --- Shell编程
(require 'sh-script)
(defun execute-interpret-immediately ()
  "Run script immediately"
  (interactive)
  (require 'compile)
  (let ((command (concat "\"" buffer-file-name "\"")))
    (save-some-buffers (not compilation-ask-about-save))
    (set (make-local-variable 'executable-command) command)
    (let ((compilation-error-regexp-alist executable-error-regexp-alist))
      (compilation-start command t (lambda (x) "*interpretation*")))))
(define-key sh-mode-map (kbd "<f9>") 'execute-interpret-immediately)


;; tdl-mode --- tdl programming.
(require 'tdl-mode)

;; pdu-mode --- Protocol Data Unit and isl programming
(require 'pdu-mode)



;;; config-programming.el ends here
