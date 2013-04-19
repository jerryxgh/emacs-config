;;; evil-tab-minor-mode.el --- 

;; Copyright 2012 Jerry Xu
;;
;; Author: gh_xu@qq.com
;; Version: $Id: evil-tab-minor-mode.el,v 0.0 2012/02/14 12:27:57 jerry Exp $
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

;; 设定evil模式下tab行为，如果yasnippet模式可以开启，tab被绑定到yas-expand，通过动态设定yas-fallback-behavior让taba在无法补全时缩进当前行。如果yasnippet没有开启，tab绑定到其主模式原来的函数

;; Put this file into your load-path and the following into your ~/.emacs:
;;   (require 'evil-tab-minor-mode)

;;; Code:

(provide 'evil-tab-minor-mode)


;;;###autoload
(define-minor-mode evil-tab-minor-mode
  "If evil is enabled and yasnippet is not enabled, in evil-normal-state, <tab> is bound to evil-jump-forward which is not wanted, change it by using emulation-mode-map-alists"

  ;; The initial value
  :init-value nil
  ;; The indicator for the mode line
  :lighter ""
  :group 'evil-tab
  :global nil
  :version "1.0 beta"
  
  ;; Body
  (let ((map (make-sparse-keymap))
        (tab-command (evil-tab-get-tab-command))
        (is-yasnippet-on (and (featurep 'yasnippet)
                              (not (cond ((functionp yas-dont-activate)
					  (funcall yas-dont-activate))
					 ((consp yas-dont-activate)
					  (some #'funcall yas-dont-activate))
					 (yas-dont-activate))))))
    (if is-yasnippet-on 
        (setq yas-fallback-behavior '(apply evil-tab-yas-fallback-behavior . nil))
      (define-key map (kbd "<tab>") tab-command)
      (set (make-local-variable 'evil-tab-emulation-alist) (list (cons t map)))
      (add-to-list 'emulation-mode-map-alists 'evil-tab-emulation-alist 'append))))

;;;###autoload
(defun evil-tab-minor-mode-on ()
  "* Turn on evil-tab minor mode"
  (unless (and (minibufferp) (featurep 'evil) evil-mode)
    (evil-tab-minor-mode 1)))

;;;###autoload
(define-globalized-minor-mode evil-tab-global-mode evil-tab-minor-mode evil-tab-minor-mode-on
  :group 'evil-tab
  :require 'evil-tab-minor-mode)

(defun evil-tab-get-tab-command ()
  "Get the command <tab> should be bound to according to major-mode that yasnippet is not enabled and the global-map."
  (let ((major-mode-map (symbol-value (intern-soft (concat (symbol-name major-mode) "-map")))))
    (or (and major-mode-map
             (lookup-key major-mode-map (kbd "C-i")))
        (lookup-key global-map (kbd "C-i")))))

(defun evil-tab-yas-fallback-behavior ()
  "yasnippet's yas-fallback-behavior"
  (interactive)
  (let ((tab-command (evil-tab-get-tab-command))
        (old-point (point)))
    (if (functionp tab-command)
        (funcall tab-command))
    (if (and (eq (point) old-point)
             (eq (following-char) ?\)))
        (forward-char))))


;;; evil-tab-minor-mode.el ends here
