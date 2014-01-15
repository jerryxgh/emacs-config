;;; config-cedet.el --- 

;; Copyright 2013 Jerry Xu
;;
;; Author: Jerry Xu jerryxgh@gmail.com
;; Version: 0.0
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

;; Put this file into your load-path and the following into your ~/.emacs:
;;   (require 'config-cedet)

;;; Code:

(provide 'config-cedet)

;;Currently CEDET issues a warning “Warning: cedet-called-interactively-p called with 0 arguments, but requires 1”, which can be suppressed by adding
(setq byte-compile-warnings nil)
(require 'cedet)

;; Enable EDE (Project Management) features
(global-ede-mode 1)

;; Enabling Semantic (code-parsing, smart completion) features

;; * This enables the database and idle reparse engines
(semantic-load-enable-minimum-features)

;; * This enables some tools useful for coding, such as summary mode,
;;   imenu support, and the semantic navigator
(semantic-load-enable-code-helpers)

;; * This enables some tools useful for coding, such as summary mode,
;;   imenu support, and the semantic navigator
(semantic-load-enable-code-helpers)
(semantic-load-enable-excessive-code-helpers)
(semantic-load-enable-semantic-debugging-helpers)
(global-semantic-stickyfunc-mode -1)
(global-semantic-show-unmatched-syntax-mode -1)
(global-semantic-idle-completions-mode -1)
(global-ede-mode 1)
(ede-cpp-root-project "Allocator"
                :name "Allocator Project"
                :file "/sandbox/POC/Allocator/Makefile"
                :include-path '("/if_allocator"
                                "/src")
                :system-include-path '("/usr/include")
                :spp-table '())

(setq semanticdb-default-save-directory "~/.emacs.d/auto-save-list/.semanticdb"
      ;;semantic-idle-summary-function 'semantic-format-tag-summarize
      ede-project-placeholder-cache-file "~/.emacs.d/auto-save-list/ede-projects.el")


(defun semantic-ia-fast-jump-back ()
  "Jump back when use command semantic-ia-fast-jump to jump to a file."
  (interactive)
  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
      (error "Semantic Bookmark ring is currently empty"))
  (let* ((ring (oref semantic-mru-bookmark-ring ring))
         (alist (semantic-mrub-ring-to-assoc-list ring))
         (first (cdr (car alist))))
    (if (semantic-equivalent-tag-p (oref first tag) (semantic-current-tag))
        (setq first (cdr (car (cdr alist)))))
    (semantic-mrub-switch-tags first)))

(add-hook 'c++-mode-hook (lambda ()
			  (define-key c++-mode-map (kbd "<f12>") 'semantic-ia-fast-jump)
			  (define-key c++-mode-map (kbd "<f11>") 'semantic-ia-fast-jump-back)))
(add-hook 'c-mode-hook (lambda ()
			 (define-key c-mode-map (kbd "<f12>") 'semantic-ia-fast-jump)
			 (define-key c-mode-map (kbd "<f11>") 'semantic-ia-fast-jump-back)))

(add-hook 'java-mode-hook (lambda ()
			 (define-key java-mode-map (kbd "<f12>") 'semantic-ia-fast-jump)
			 (define-key java-mode-map (kbd "<f11>") 'semantic-ia-fast-jump-back)))

;;; config-cedet.el ends here