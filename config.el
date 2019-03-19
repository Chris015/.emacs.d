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
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(when (boundp 'package-pinned-packages)
  (setq package-pinned-packages
        '((org-plus-contrib . "org"))))
(package-initialize)

;;; Bootstrap use-package
;; Install use-package if it's not already installed.
;; use-package is used to configure the rest of the packages.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'bind-key)

(use-package org
             :ensure org-plus-contrib)

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

(use-package gruvbox-theme
    :ensure t
    :config (load-theme 'gruvbox-dark-medium t))

(add-to-list 'default-frame-alist
	     '(font . "Inconsolata-14"))

(use-package magit
  :ensure t)
;; disable built in VC package for performance
(setq vc-handled-backends nil)

(when (string-equal system-type "darwin")
  (setq mac-option-modifier nil
        mac-command-modifier 'meta
        x-select-enable-clipboard t))

;; Saves backup files to a custom directory
(setq backup-directory-alist `(("." . "~/.emacs-saves")))

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

(use-package tern
  :ensure t
  :init 
  (add-to-list 'load-path "~/Repos/tern/emacs/")
  (add-hook 'js2-mode-hook (lambda () (tern-mode t)))
  :config
  (use-package company-tern
    :ensure t
    :init (with-eval-after-load 'company(add-to-list 'company-backends 'company-tern))))

(define-key tern-mode-keymap (kbd "M-,") nil)
(define-key tern-mode-keymap (kbd "M-.") nil)

;; In JS indent to 2 spaces. 
(setq-default js-indent-level 2)

;;JS2-mode improves built in JS mode.
(use-package js2-mode
  :ensure t
  :mode "\\.js\\'"
  :config
  (setq-default js2-ignored-warnings '("msg.extra.trailing.comma")))

;; JS2-refactor builds on top of JS2-mode and adds refactoring.
(use-package js2-refactor
  :ensure t
  :config
  (js2r-add-keybindings-with-prefix "C-c <C-m>")
  (add-hook 'js2-mode-hook 'js2-refactor-mode))

;; RJSX mode makes JSX work well.
(use-package rjsx-mode
:mode "[components|containers|hoc]\\/.*\\.js\\'"
:ensure t)
