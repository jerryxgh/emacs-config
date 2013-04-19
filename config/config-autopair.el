;;; config-autopair.el --- 

;; Copyright 2012 Jerry Xu
;;
;; Author: gh_xu@qq.com
;; Version: $Id: config-autopair.el,v 0.0 2012/01/06 16:48:13 jerry Exp $
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
;;   (require 'config-autopair)

;;; Code:

(provide 'config-autopair)

(require 'autopair)
(autopair-global-mode) ;; to enable in all buffers
;; 在 nxhtml-mumamo 模式下编辑 css 时 autopair 有问题，关闭
(add-hook 'css-mode-hook '(lambda ()
                            (if nxhtml-mumamo-mode
                                (setq autopair-dont-activate t))))

(add-hook 'python-mode-hook
          #'(lambda ()
              (setq autopair-handle-action-fns
                    (list #'autopair-default-handle-action
                          #'autopair-python-triple-quote-action))))

;; In minibuffer eshell-mode shell-mode sql-interactive-mode ... don't run delete-horizontal-space
(defadvice autopair-newline (before autopair-newline-and-delete-horizontal-space activate)
  "Delete horizontal space before insert new line"
  (unless (or (minibufferp)
              (eq major-mode 'eshell-mode)
              (eq major-mode 'shell-mode)
              (eq major-mode 'comint-mode)
              (eq major-mode 'sql-interactive-mode))
    (delete-horizontal-space)))
(defadvice autopair-newline (after autopair-newline-and-indent activate)
  "Auto indent after insert new line"
  (indent-according-to-mode))


;;; config-autopair.el ends here
