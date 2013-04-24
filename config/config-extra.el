;;; config-extra.el --- 

;; Copyright 2012 Jerry Xu
;;
;; Author: jerryxgh@gmail.com
;; Version: $Id: config-extra.el,v 0.0 2012/05/31 06:22:28 XGH Exp $
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
;;   (require 'config-extra)

;;; Code:

(provide 'config-extra)
;;; quack --- for scheme
(setq quack-dir "~/.emacs.d/auto-save-list/.quack"
      quack-global-menu-p nil
      quack-default-program "guile")
(require 'quack)
(add-hook 'inferior-scheme-mode-hook 'interactive-shell-on-exit-kill-buffer)
(define-key scheme-mode-map (kbd "C-x C-z") 'switch-to-scheme)

(require 'config-nxhtml) ;写html jsp php等的工具


;;; config-extra.el ends here
