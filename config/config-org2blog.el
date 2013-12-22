;;; config-org2blog.el --- 

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
;;   (require 'config-org2blog)

;;; Code:

(provide 'config-org2blog)

(setq org2blog/wp-track-posts '()
      org2blog/wp-blog-alist
      '(("cnblogs"
         :url "http://www.cnblogs.com/jerryxgh/services/metaweblog.aspx"
         :username "jerryxgh"
        )))
(defadvice url-http-end-of-document-sentinel (before set-url-http-no-retry-t activate)
  (with-current-buffer (process-buffer (ad-get-arg 0))
    (setq url-http-no-retry t)))

(require 'org2blog-autoloads)
(require 'htmlize)

;;; config-org2blog.el ends here
