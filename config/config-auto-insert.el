;;; config-auto-insert.el --- 

;; Copyright 2012 Jerry Xu
;;
;; Author: jerryxgh@gmail.com
;; Version: $Id: config-auto-insert.el,v 0.0 2012/07/09 14:27:56 jerry Exp $
;; Keywords: 
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

;;; Commentary: This file is to configure auto-insert, which can auto insert something to the new buffer.

;; 

;; Put this file into your load-path and the following into your ~/.emacs:
;;   (require 'config-auto-insert)

;;; Code:

(require 'yasnippet)

(defvar auto-insert-snippet-keyword
  "template"
  "Snippet KEY in yasnippet to auto insert into new file")
(provide 'config-auto-insert)

(auto-insert-mode 1)
(setq auto-insert-directory nil
      auto-insert 'other
      auto-insert-query nil
      auto-insert-alist
      '(((java-mode . "Java Template") . [auto-insert-snippet])
        ((emacs-lisp-mode . "Emacs Lisp Template") . [auto-insert-snippet])
        ((makefile-gmake-mode . "Makefile Template") . [auto-insert-snippet])
        ((html-mode . "HTML Template") . [auto-insert-snippet])
        ))

(defun auto-insert-snippet ()
  "Auto insert a snippet of yasnippet into new file."
  (interactive)
  (let ((is-yasnippet-on (not (cond ((functionp yas-dont-activate)
                                     (funcall yas-dont-activate))
                                    ((consp yas-dont-activate)
                                     (some #'funcall yas-dont-activate))
                                    (yas-dont-activate))))
        (snippet (get-snippet-by-key auto-insert-snippet-keyword)))
    (when (and is-yasnippet-on snippet)
      (yas/expand-snippet snippet)
      (if (and (featurep 'evil) evil-mode)
          (evil-initialize-state 'insert)))))

(defun get-snippet-by-key (key)
  "Get snipptes by KEY given."
  (let ((template (cdar (mapcan #'(lambda (table) (yas--fetch table key))
                                (yas--get-snippet-tables)))))
    (if template
        (yas--template-content template)
      nil)))




;;; config-auto-insert.el ends here
