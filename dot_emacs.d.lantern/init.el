;; Lantern profile: doom-lantern theme, settings managed via settings.org

(setq user-emacs-directory "~/.emacs.d.lantern")
(setq user-init-file "~/.emacs.d.lantern/init.el")
(setq custom-file "~/.emacs.d.lantern/custom.el")
(load custom-file 'noerror)

(setq package-archives '(("org"   . "https://orgmode.org/elpa/")
                          ("gnu"   . "https://elpa.gnu.org/packages/")
                          ("melpa" . "https://melpa.org/packages/")))
(require 'package)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(org-babel-load-file "~/.emacs.d.lantern/settings.org")
