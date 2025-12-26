;;; config.el -*- lexical-binding: t; -*-

;; User info
(setq user-full-name "Patrick Motard"
      user-mail-address "")

;; Faster which-key popup
(after! which-key
  (setq which-key-idle-delay 0.1))

;; Theme
(setq doom-theme 'doom-one)
;; Always use dark theme, ignore system appearance
(setq ns-use-system-appearance nil)

;; Line numbers
(setq display-line-numbers-type 'relative)

;; Font (adjust size as needed)
(setq doom-font (font-spec :family "Iosevka Term Nerd Font" :size 14))

;; Claude Code IDE
(use-package! claude-code-ide
  :bind ("C-c C-'" . claude-code-ide-menu)
  :config
  (claude-code-ide-emacs-tools-setup))

;; Ruby configuration
(after! ruby-mode
  (setq ruby-insert-encoding-magic-comment nil))

;; Use rbenv
(after! rbenv
  (global-rbenv-mode))
