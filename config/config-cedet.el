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


;;; config-cedet.el ends here