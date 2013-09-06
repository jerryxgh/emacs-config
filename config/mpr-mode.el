;;; mpr-mode.el --- 

;; Copyright 2013 Jerry Xu
;;
;; Author: Jerry Xu jerryxgh@gmail.com
;; Version: 0.0
;; Keywords: mpr TAT
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
;;   (require 'mpr-mode)

;;; Code:

(provide 'mpr-mode)

(define-derived-mode mpr-mode c++-mode "MPR"
  "Major mode for mpr script writing."
  (font-lock-add-keywords 'mpr-mode
                          '(("\\<\\(via\\|mscdocument\\|msc\\|endmsc\\|text\\|instance\\|endinstance\\|reference\\|action\\|to\\|from\\|in\\|out\\)\\>" . font-lock-keyword-face)
                            ("\\<\\(TAT\\|SUT\\)\\>" . font-lock-type-face))))

(setq auto-mode-alist
        (append
         '(("\\.mpr\\'" . mpr-mode))
         auto-mode-alist))


;;; mpr-mode.el ends here