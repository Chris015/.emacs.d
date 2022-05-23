;;; Turn off mouse interface early in startup to avoid momentary display
(when window-system
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1))

(setq inhibit-startup-message t)

(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(unless package--initialized (package-initialize t))

;;; Bootstrap use-package
;; Install use-package if it's not already installed.
;; use-package is used to configure the rest of the packages.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'bind-key)

;; Saves backup files to a custom directory
  (defvar user-temporary-file-directory
      (concat temporary-file-directory user-login-name "/"))
  (make-directory user-temporary-file-directory t)
  (setq backup-by-copying t)
  (setq backup-directory-alist
          `(("." . ,user-temporary-file-directory)
          (,tramp-file-name-regexp nil)))
  (setq auto-save-list-file-prefix
          (concat user-temporary-file-directory ".auto-saves-"))
  (setq auto-save-file-name-transforms
          `((".*" ,user-temporary-file-directory t)))


  ;; Answering just 'y' or 'n' will do
  (defalias 'yes-or-no-p 'y-or-n-p)

;; Turn off the blinking cursor
(blink-cursor-mode -1)

(setq-default indent-tabs-mode nil)

;; Don't count two spaces after a period as the end of a sentence.
;; Just one space is needed.
(setq sentence-end-double-space nil)

;; delete the region when typing, just like as we expect nowadays.
(delete-selection-mode t)

(show-paren-mode t)
(column-number-mode t)

(global-visual-line-mode)

;; -i gets alias definitions from .bash_profile
(setq shell-command-switch "-ic")

;; Change C-m from RET to C-m
(define-key input-decode-map [?\C-m] [C-m])

(defun inform-about-m-fix()
  (interactive)
  (message "C-m is not the same as RET any more!"))

(global-set-key (kbd "<C-m>") #'inform-about-m-fix)

(when (string-equal system-type "darwin")
(setq mac-option-modifier nil
        mac-command-modifier 'meta
        x-select-enable-clipboard t))

(use-package org-bullets
  :ensure t
  :init
  (setq org-bullets-bullet-list
        '("◉" "◎" "○" "☁" "◇" "►"))

  (setq org-todo-keywords '((sequence "☛ TODO(t)" "|" "✔ DONE(d)")
                            (sequence "⚑ WAITING(w)" "|")
                            (sequence "|" "✘ CANCELED(c)")))

  ;; Without this, org-mode becomes very slow
  (setq inhibit-compacting-font-caches t)
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package evil
            :ensure t)

(use-package gruvbox-theme
    :ensure t
    :config (load-theme 'gruvbox-dark-medium t))

(add-to-list 'default-frame-alist
             '(font . "Inconsolata-14"))

(use-package ace-jump-mode
  :ensure t
  :bind (("C-. C-." . ace-jump-word-mode)
         ("C-. C-k" . ace-jump-char-mode)
         ("C-. C-l" . ace-jump-line-mode)))

(use-package projectile
  :ensure t
  :bind-keymap
  ("C-c p" . projectile-command-map))

(use-package multiple-cursors
  :ensure t)
;; When you have an active region that spans multiple lines,
;; the following will add a cursor to each line:
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
;; When you want to add multiple cursors not based on continuous lines,
;; but based on keywords in the buffer, use:
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(use-package magit
  :ensure t)
;; disable built in VC package for performance
(setq vc-handled-backends nil)
