;;; tdl-mode.el --- 

;; Copyright 2013 Jerry Xu
;;
;; Author: Jerry Xu jerryxgh@gmail.com
;; Version: 0.0
;; Keywords: tdl
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
;;   (require 'tdl-mode)

;;; Code:

(provide 'tdl-mode)

(define-derived-mode tdl-mode c++-mode "TDL"
  "Major mode for TDL programming."
  (font-lock-add-keywords 'tdl-mode
                          '(("\\<\\(set\\|include\\|stop\\|start\\|in\\|out\\|to\\|with\\)\\>" . font-lock-keyword-face)
                            ("\\<\\(state\\|timer\\|port\\|channel\\)\\>" . font-lock-type-face))))

(setq auto-mode-alist
        (append
         '(("\\.tdl\\'" . tdl-mode))
         auto-mode-alist))

;;; tdl-mode.el ends here