;;; init.el --- 

;; Copyright 2012 Jerry Xu
;;
;; Author: jerryxgh@gmail.com
;; Version: $Id: init.el,v 0.0 2012/02/29 02:18:19 jerry Exp $
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

;;; Commentary:

;; 

;; system-type: the operating system type
;; system-name: machine name

;;; Emacs plugins used.
;; quack: run scheme shell in Emacs.
;; evil: use Vim keybindings in Emacs.
;; undo-tree: visualized editing history.
;; cal-china: China lunar calendar.
;; ecb: make emacs an ide.
;; js2-mode: for writing javascript.
;; YASnippet: Best template tool.
;; auto-complete: just as its name implies.

;;; Installtion
;; Put this file into your load-path and add following code into your ~/.emacs:
;;   (load "<path to this file>")

;;; Code:

(provide 'init)

(defun add-directory-to-load-path-recursively (directory &optional exclude-directories-list)
  "Add filename to load-path recursively, only add those dirs which have el or elc files."
  (interactive)
  (unless (file-directory-p directory)
    (setq directory (file-name-directory directory)))
  (let (directory-stack (suffixes (get-load-suffixes)))
    (if (file-exists-p directory)
      (push directory directory-stack))
    (while directory-stack
           (let* ((current-directory (pop directory-stack))
                  (file-list (directory-files current-directory t))
                  should-add-to-load-path)
             (dolist (file file-list)
               (let ((file-name (file-name-nondirectory file)))
                 (if (file-directory-p file)
                   (if (and (not (equal file-name "."))
                            (not (equal file-name ".."))
                            (not (member file-name exclude-directories-list)))
                     (push file directory-stack))
                   (if (and (not should-add-to-load-path)
                            (member (file-name-extension file t) suffixes))
                     (setq should-add-to-load-path t)))))
             (if should-add-to-load-path
               (add-to-list 'load-path current-directory))))))

(defvar emacs-config-dir (file-name-directory load-file-name)
  "Emacs config file directory, including plugins and config files."
  )
(defvar exclude-directories '()
  "Directory names which should be excluded from load-path.")
(progn (if (< emacs-major-version 24)
	   (progn (add-to-list 'exclude-directories "js2-mode-emacs24")
		  (add-to-list 'exclude-directories "ack-1.3"))
         (add-to-list 'exclude-directories "js2-mode-emacs23")
         (add-to-list 'exclude-directories "ack-el-emacs23"))
       (if (or (< emacs-major-version 23)
               (and (= emacs-major-version 23)
                    (<= emacs-minor-version 1)))
	   (add-to-list 'exclude-directories "ecb")
         (setq exclude-directories (append '("ecb_patched_to_work_with_cedet_1_1" "cedet-1.1")
					   exclude-directories))))

(add-directory-to-load-path-recursively emacs-config-dir exclude-directories)


(require 'config-base) ; basic configurations
(require 'config-evil) ; for evil
(require 'config-org) ; for org
(require 'config-programming) ; for programming
(require 'config-extra) ; configuration for rarely used plugin
(require 'config-desktop) ; this should be put in the end of all emacs configuration.

;;; init.el ends here
