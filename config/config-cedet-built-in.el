;;; config-cedet-built-in.el ---
;;; -*- coding: utf-8 -*-
;; Debug
(require 'semantic/java)
;; (require 'semantic/db-global)
;;(require 'semantic/analyze/refs)
(defadvice push-mark (around semantic-mru-bookmark activate)
  "Push a mark at LOCATION with NOMSG and ACTIVATE passed to `push-mark'.
 If `semantic-mru-bookmark-mode' is active, also push a tag onto
 the mru bookmark stack."
  (semantic-mrub-push semantic-mru-bookmark-ring
                      (point)
                      'mark)
  ad-do-it)
;; function below need advice up
(defun semantic-ia-fast-jump-back ()
  "Jump back when use command semantic-ia-fast-jump to jump to a file."
  (interactive)
  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
      (error "Semantic Bookmark ring is currently empty"))
  (let* ((ring (oref semantic-mru-bookmark-ring ring))
         (alist (semantic-mrub-ring-to-assoc-list ring))
         (first (cdr (car alist))))
    (if (semantic-equivalent-tag-p (oref first tag) (semantic-current-tag))
        (setq first (cdr (car (cdr alist)))))
    (semantic-mrub-switch-tags first)))
;; Enable EDE (Project Management) features
;; (global-ede-mode t)
;; (ede-cpp-root-project "mascheme"
;;                       :name "mzscheme"
;;                       :include-path '( "/include" "../include" "/src")
;;                       :system-include-path '( "F:/Program Files/MinGW/include" "F:/Program Files/MinGW/lib/gcc/mingw32/4.5.0/include" "F:/Program Files/MinGW/lib/gcc/mingw32/4.5.0/include/c++"))

;; Enable SRecode (Template management) minor-mode.
;;(global-srecode-minor-mode 1)
                                        ;(setq srecode-map-load-path (concat emacs-config-dir "/config/srecode/") 
                                        ;      srecode-map-save-file (concat emacs-config-dir "/config/srecode/srecode-map"))
(setq semantic-default-submodes '(global-semanticdb-minor-mode
                                  global-semantic-idle-scheduler-mode
                                  ;;global-semantic-idle-summary-mode
                                  ;;global-semantic-decoration-mode
                                  global-semantic-highlight-func-mode
                                  ;;global-semantic-stickyfunc-mode
                                  global-semantic-mru-bookmark-mode
                                  ))
(semantic-mode 1)
(global-semantic-highlight-edits-mode 1)
(global-semantic-idle-local-symbol-highlight-mode 1)
;;(global-semantic-idle-breadcrumbs-mode 1)
;;(global-semantic-show-unmatched-syntax-mode 1)
(global-semantic-show-parser-state-mode 1)
(setq semanticdb-default-save-directory "~/.emacs.d/auto-save-list/.semanticdb"
      ;;semantic-idle-summary-function 'semantic-format-tag-summarize
      ede-project-placeholder-cache-file "~/.emacs.d/auto-save-list/ede-projects.el")
(semanticdb-enable-gnu-global-databases 'c-mode)
(semanticdb-enable-gnu-global-databases 'c++-mode)
;; (defconst user-include-dirs
;;   (list "." "./include" "./inc" "./common" "./public"
;;         ".." "../include" "../inc" "../common" "../public"
;;         "../.." "../../include" "../../inc" "../../common" "../../public"))
(defconst mingw-include-dirs
  (list "F:/Program Files/MinGW/include"
        "F:/Program Files/MinGW/lib/gcc/mingw32/4.5.0/include"
        "F:/Program Files/MinGW/lib/gcc/mingw32/4.5.0/include/c++"

        "E:/Program Files/MinGW/include"
        "E:/Program Files/MinGW/lib/gcc/mingw32/4.5.0/include"
        "E:/Program Files/MinGW/lib/gcc/mingw32/4.5.0/include/c++"
        ))
(defconst java-src-dirs
  (list "/home/jerry/local/jdk1.7.0_04/src"))
(add-hook 'semantic-init-hook
          '(lambda ()
             ;; C C++
             (if (eq system-type 'windows-nt)
                 (mapc (lambda (dir)
                         (semantic-add-system-include dir 'c-mode)
                         (semantic-add-system-include dir 'c++-mode))
                       mingw-include-dirs))
             ;; Java
             (mapc (lambda (dir)
                     (add-to-list 'semantic-java-dependency-system-include-path
                                  dir)) java-src-dirs)))


(add-hook 'c-mode-common-hook ; other modes similarly
          (lambda ()
            (hs-minor-mode 1)
            (define-key c-mode-base-map (kbd "C-<f12>") 'semantic-analyze-proto-impl-toggle)
            (define-key c-mode-base-map (kbd "S-<f12>")  'semantic-ia-fast-jump-back)
            (define-key c-mode-base-map (kbd "<f12>") 'semantic-ia-fast-jump)
            ))
(add-hook 'emacs-lisp-mode-hook
          (lambda () (hs-minor-mode 1)))

(defun config-semantic-inhibit-func ()
  "Don't run cedet in some modes."
  (cond
   ((member major-mode '(js-mode javascript-mode html-helper-mode html-mode))
    ;; to disable semantic, return non-nil.
    t)
   (t nil)))
(add-to-list 'semantic-inhibit-functions 'config-semantic-inhibit-func)


(defadvice semantic-mrub-completing-read (around semantic-mrub-completing-read-around activate)
  "use ido-completing-read in semantic-mrub-completing-read"
  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
      (error "Semantic Bookmark ring is currently empty"))
  (let* ((ring (oref semantic-mru-bookmark-ring ring))
         (ans nil)
         (alist (semantic-mrub-ring-to-assoc-list ring))
         (first (cdr (car alist)))
         (semantic-mrub-read-history nil)
         (choices nil)
         )
    ;; Don't include the current tag.. only those that come after.
    (if (semantic-equivalent-tag-p (oref first tag)
                                   (semantic-current-tag))
        (setq first (cdr (car (cdr alist)))))
    ;; Create a fake history list so we don't have to bind
    ;; M-p and M-n to our special cause.
    (let ((elts (reverse alist)))
      (while elts
        (setq semantic-mrub-read-history
              (cons (car (car elts)) semantic-mrub-read-history))
        (setq elts (cdr elts))))
    (setq semantic-mrub-read-history (nreverse semantic-mrub-read-history))

    ;; Do the read/prompt
    (let ((prompt (if first (format "%s (%s): " prompt
                                    (semantic-format-tag-name
                                     (oref first tag) t)
                                    )
                    (concat prompt ": ")))
          )
      (setq ans
                                        ;(completing-read prompt alist nil nil nil 'semantic-mrub-read-history)))
            (ido-completing-read prompt semantic-mrub-read-history nil nil nil 'semantic-mrub-read-history)))
    ;; Calculate the return tag.
    (if (string= ans "")
        (setq ans first)
      ;; Return the bookmark object.
      (setq ans (assoc ans alist))
      (if ans
          (cdr ans)
        ;; no match.  Custom word.  Look it up somwhere?
        nil)
      )))


(provide 'config-cedet-built-in)

;;; config-cedet-built-in.el ends here ---
