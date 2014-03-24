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
(require 'config-auto-complete)
(require 'config-auto-insert)
(require 'config-autopair)
(require 'config-ecb)
(require 'config-yasnippet)
(require 'config-slime)
;;M-x tabify/untabify : replace tab to spaces
(setq-default indent-tabs-mode nil)
;; cc-mode --- C like language, such as C C++ Java
(require 'cc-mode)
(add-hook 'c-mode-common-hook
          '(lambda nil
             (setq c-default-style '((java-mode . "java")
                                     (awk-mode . "awk")
                                     (other . "k&r")) 
		   c-basic-offset 4) ; width of indent
             (local-set-key  (kbd "C-c z") 'ff-find-other-file)))

(defun compile-immediately ()
  "Just as its name implies, compile-immediately."
  (interactive)
  (compile compile-command))

(define-key c-mode-map (kbd "<f9>") 'compile-immediately)
(define-key c++-mode-map (kbd "<f9>") 'compile-immediately)

;;; HTML/XHTML/JSP/PHP -------------------------------------------------------
(setq nxml-child-indent 4)
(add-to-list 'auto-mode-alist
             (cons (concat
                    "\\."
                    (regexp-opt
                     '("xml" "xsd" "sch" "rng" "xslt" "svg" "rss") t) "\\'")
                   'nxml-mode))
(setq magic-mode-alist
      (cons '("<＼＼?xml " . nxml-mode)
            magic-mode-alist)
      nxml-slash-auto-complete-flag t)
(fset 'xml-mode 'nxml-mode)
(fset 'html-mode 'nxml-mode)

(require 'html-script)
(autoload 'php-mode "php-mode" "PHP mode" t)
(setq auto-mode-alist (cons '("\\.php[34]?$" . nxml-mode) auto-mode-alist))


;;; freemarker ---------------------------------------------------------------
(require 'config-web-mode)


;;; JavaScript ---------------------------------------------------------------
(autoload 'js2-mode "js2-mode" nil t)
(add-hook 'js2-mode-hook (lambda ()
                           (undo-tree-mode 1)))
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;;; Emacs Lisp ---------------------------------------------------------------
(require 'find-func)
(defun find-function-or-variable-or-file-at-point ()
  "Just as its name implies."
  (interactive)
  (let ((variable (variable-at-point))
	(function (function-called-at-point)))
    (cond ((null (equal variable 0))
           (find-function-do-it variable
                                'defvar
                                'switch-to-buffer-other-window))
	  (function
           (find-function-do-it function nil 'switch-to-buffer-other-window))
	  (t (find-file-at-point)))))
(define-key emacs-lisp-mode-map (kbd "<f10>")
  'find-function-or-variable-or-file-at-point)
(define-key lisp-interaction-mode-map (kbd "<f10>")
  'find-function-or-variable-or-file-at-point)
;; paredit --- Auto balance brackets.
(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       (lambda () (paredit-mode +1)))
(add-hook 'lisp-mode-hook             (lambda () (paredit-mode +1)))
(add-hook 'lisp-interaction-mode-hook
          (lambda ()
            (paredit-mode +1)
            (define-key paredit-mode-map (kbd "C-j") 'eval-print-last-sexp)))
(add-hook 'scheme-mode-hook           (lambda () (paredit-mode +1)))

;;; sh-mode --- Shell programming
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

;; graphviz-dot-mode --- dot
(setq graphviz-dot-indent-width 4)

;; lex-mode and bison-mode --- for flex and bison
(autoload 'bison-mode "bison-mode.el")
(add-to-list 'auto-mode-alist '("\\.y$" . bison-mode))

(autoload 'flex-mode "flex-mode")
(add-to-list 'auto-mode-alist '("\\.l$" . flex-mode))

;; twiki-mode  ---  for edit twiki pages
(require 'twiki)
(setq twiki-shell-cmd "twikish -p")
(add-to-list 'auto-mode-alist'("\\.twiki$" . twiki-mode))
;; ag.el -- front end of ag - The Silver Searcher
(require 'ag) ; grep for programmers
(setq ag-highlight-search t
      ag-reuse-window t
      ag-reuse-buffers)

;;; config-programming.el ends here
