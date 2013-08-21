;;; pdu-mode.el --- 

;; Copyright 2013 Jerry Xu
;;
;; Author: Jerry Xu jerryxgh@gmail.com
;; Version: 0.0
;; Keywords: pdu - Protocol Data Unit
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
;;   (require 'pdu-mode)

;;; Code:

(provide 'pdu-mode)

(define-derived-mode pdu-mode java-mode "PDU"
  "Major mode for TDL programming."
  (font-lock-add-keywords 'pdu-mode
                          '(("\\<\\(iei\\|messagetype\\|header\\|bidirectionalmessages\\|packmessages\\|unpackmessages\\|option\\|nextstate\\|state\\|start\\|in\\|out\\|to\\|with\\|length\\|case\\|export\\|import\\|use\\|include\\|package\\)\\>" . font-lock-keyword-face)
                            ("\\<\\(byte\\|bytes\\|bit\\|bits\\|field\\|message\\|interface\\)\\>" . font-lock-type-face))))

(setq auto-mode-alist
        (append
         '(("\\.pdu\\'" . pdu-mode))
         auto-mode-alist))

;;; pdu-mode.el ends here