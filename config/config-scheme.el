;;; config-scheme.el --- 

;; Copyright 2014 Jerry Xu
;;
;; Author: Jerry Xu jerryxgh@gmail.com
;; Version: 0.0
;; Keywords: scheme
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
;;   (require 'config-scheme)

;;; Code:

(provide 'config-scheme)

;;; quack --- for scheme
(setq quack-dir "~/.emacs.d/auto-save-list/.quack"
      quack-fontify-style 'emacs
      quack-global-menu-p nil
      quack-default-program "guile")
(require 'quack)
(add-hook 'inferior-scheme-mode-hook 'interactive-shell-on-exit-kill-buffer)
(define-key scheme-mode-map (kbd "C-x C-z") 'switch-to-scheme)
(setq scheme-program-name "csi -:c")
(setq scheme-mit-dialect nil)

;; Rainbow delimiters
(require 'rainbow-delimiters)
(add-hook 'scheme-mode-hook 'rainbow-delimiters-mode)

;; Smartparens
(require 'smartparens-config)


;;; config-scheme.el ends here
