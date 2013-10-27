;;; init.el --- 

;; Copyright 2012 Jerry Xu
;;
;; Author: gh_xu@qq.com
;; Version: $Id: init.el,v 0.0 2012/02/29 02:18:19 jerry Exp $
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

;; 根据不同的操作系统平台设置 --变量 system-type
;; 根据不同的机器设置 --变量 system-name

;;; 我安装的 Emacs 插件
;; quack 在Emacs中运行scheme的工具
;; template 模版工具
;; evil 在 Emacs 中完美模拟 Vim
;; -- undo-tree
;; session
;; nxhtml 编辑 html php jsp 等文件
;; cal-china
;; ecb
;; js2-mode
;; YASnippet
;; auto-complete 自动补全工具
;; Put this file into your load-path and the following into your ~/.emacs:
;;   (require 'init)

;;; Code:

(provide 'init)

(defun add-directory-to-load-path-recursively (directory &optional exclude-directories-list)
  "Add filename to load-path recursively, only add those dirs which have el or elc files."
  (interactive)
  (unless (file-directory-p directory)
    (setq directory (file-name-directory directory)))
  (let (directory-stack (suffixes (get-load-suffixes)))
    (if (file-exists-p directory)
      (push directory directory-stack))
    (while directory-stack
           (let* ((current-directory (pop directory-stack))
                  (file-list (directory-files current-directory t))
                  should-add-to-load-path)
             (dolist (file file-list)
               (let ((file-name (file-name-nondirectory file)))
                 (if (file-directory-p file)
                   (if (and (not (equal file-name "."))
                            (not (equal file-name ".."))
                            (not (member file-name exclude-directories-list)))
                     (push file directory-stack))
                   (if (and (not should-add-to-load-path)
                            (member (file-name-extension file t) suffixes))
                     (setq should-add-to-load-path t)))))
             (if should-add-to-load-path
               (add-to-list 'load-path current-directory))))))

(defvar emacs-config-dir (file-name-directory load-file-name)
  "Emacs config file directory, including plugins and config files."
  )
(defvar exclude-directories '()
  "Directory names which should be excluded from load-path.")
(progn (if (< emacs-major-version 24)
           (add-to-list 'exclude-directories "js2-mode-emacs24")
         (add-to-list 'exclude-directories "js2-mode-emacs23"))
       (if (or (< emacs-major-version 23)
               (and (= emacs-major-version 23)
                    (<= emacs-minor-version 1)))
         (add-to-list 'exclude-directories "ecb")
         (setq exclude-directories (append '("ecb_patched_to_work_with_cedet_1_1"
                                                                                  "cedet-1.1")
                                                                                exclude-directories))))

(add-directory-to-load-path-recursively emacs-config-dir exclude-directories)


(require 'config-base) ;基础设置，大部分模式共享
(require 'config-evil) ;Emacs的vim模拟
(require 'config-org) ;记笔记工具org
(require 'config-programming) ;编程方面的设置
(require 'config-extra) ;平时用的比较少的插件
(require 'config-desktop)
                                        ;必须放在初始化文件的最后，记录上次关闭时打开的文件、buffer、变量等

;;; init.el ends here
