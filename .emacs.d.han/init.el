;; TODO: org mode
;; TODO: avy (goto-char, goto-word, goto-word-or-subword, goto-line)
;; TODO: relative line numbers
;; TODO: better commenting/uncommenting
;; TODO: golang layer
;; TODO: major mode command exploring via ',' character
;; TODO: magit better hotkeys for finishing commit buffer
;; TODO: get evil keybinds working with help buffer (and others)
;; TODO: jira mode
;; TOOD: move to window by number
;; TODO: explore kill ring
;; TODO: load irc password from separate file or something more secure
;; TODO: neotree
;; TODO: helm swoop

(setq user-emacs-directory "~/.emacs.d.han")
(setq user-init-file "~/.emacs.d.han/init.el")
;; This TLS setting fixes "failed to download 'gnu' archive" error.
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;;(setq package-enable-at-startup nil) ;; dont load packages before startup

;; Set up MELPA, and the rest, via package.el
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")))
(require 'package)
(package-initialize)

;;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; disable menu and tool bar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(add-hook 'before-save-hook 'whitespace-cleanup)
;; activate shell mode for AUR PKGBUILD files
(add-to-list 'auto-mode-alist'("PKGBUILD\\'" . shell-script-mode))

;; The value is in 1/10pt, so 100 will give you 10pt, etc.
;; This doesn't seem to be necessary if the font size is specified with the font name.
;; I'll leave it here for reference.
;;(set-face-attribute 'default (selected-frame) :height 180)
(add-to-list 'default-frame-alist '(font . "Inconsolata-18"))
(global-display-line-numbers-mode)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package) ; unless it is already installed
  (package-refresh-contents) ; updage packages archive
  (package-install 'use-package)) ; and install the most recent version of use-package
(require 'use-package)
;; fetch list of packages available
(unless package-archive-contents
  (package-refresh-contents))
;; package list
(setq package-list '(
    evil
    key-chord
    doom-themes
    cycle-themes
    magit
    evil-magit
    helm
    which-key
    go-mode
    exec-path-from-shell
    yaml-mode
    circe
    org
    general
    spaceline
    org-jira))
;; install missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(require 'evil)
(evil-mode 1)

(require 'key-chord)
(key-chord-mode 1)
(setq key-chord-two-keys-delay 0.2)
;; Remap esc to fd, for better evil experience.
(key-chord-define evil-insert-state-map "fd" 'evil-normal-state)

(require 'doom-themes)
(load-theme 'doom-nord t)
(load-theme 'doom-one t t)
(load-theme 'doom-city-lights t t)
(load-theme 'doom-dracula t t)
(load-theme 'doom-nord-light t t)
(load-theme 'doom-peacock t t)
(load-theme 'doom-solarized-light t t)

(setq cycle-themes-theme-list
      '(doom-one
	doom-nord
	doom-city-lights
	doom-dracula
	doom-nord-light
	doom-solarized-light
	doom-peacock))

;; cl is required for cycle-themes, at least until
;; https://github.com/toroidal-code/cycle-themes.el/issues/4
;; is fixed
(require 'cl)
(require 'cycle-themes)
(cycle-themes-mode)

;;(require 'ivy)
;;(ivy-mode 1)
;;(setq ivy-use-virtual-buffers t)
;;(setq enable-refcursive-minibuffers t)

(require 'helm)
(require 'helm-config)
(helm-mode 1)
;;(setq helm-mode-fuzzy-match t)
;;(setq helm-completion-in-region-fuzzy-match t)
(setq-default helm-M-x-fuzzy-match t)
;; Rebind tab in helm-find-files to complete the selection (instead of enter).
(define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
(define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)
;; Since tab is 'helm-select-action', switch that to C-z so we can still call it.
(define-key helm-map (kbd "C-z") #'helm-select-action)

(require 'which-key)
(which-key-mode)
;; How quickly which-key's popup pops up. Setting to 0.0 is bad. Smaller = faster.
(setq which-key-idle-delay 0.1)

(require 'spaceline-config)
(spaceline-spacemacs-theme)

(require 'magit)
(require 'evil-magit)

;; languages
;; golang
(require 'go-mode)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))


;; Ansible
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;; irc
(require 'circe)
(setq circe-network-options
      '(("Freenode"
	 :tls t
	 :nick "han_mfalcon"
	 :sasl-username "han_mfalcon")))

;; jira
(require 'org)
;; # is shorthand for function
(add-hook 'org-mode-hook #'toggle-word-wrap)
(add-hook 'org-mode-hook #'(lambda ()
			     ;; make the lines in the buffer wrap around the edges of the screen.
			     ;; to press C-c q  or fill-paragraph ever again!
			     (visual-line-mode)
			     (org-indent-mode)))
;; (require 'org-jira)

(use-package yasnippet                  ; Snippets
  :ensure t
  :config
  (yas-global-mode))

(use-package yasnippet-snippets         ; Collection of snippets
  :ensure t)

(use-package auto-complete
  :ensure t)
(use-package ansible
  :ensure t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; "ensure t" makes sure the package is accessible and downloads it if it's not.
 (use-package general :ensure t
  :config
  (general-define-key
    :states '(normal visual emacs)
   "," (general-simulate-key "C-c"))
  (general-define-key
    :states '(normal visual insert emacs)
   "C-," (general-simulate-key "M-x"))
  (general-define-key
   :keymaps '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"
   "" nil
   ;; TODO: fiture out how to make tab switch between current and previous buffer
   ;; with switch-to-prev-buffer it just rotates backwards
   "TAB" '(switch-to-prev-buffer :which-key "prev buffer")
   "," (general-simulate-key "C-c")
   "SPC" '(helm-M-x :which-key "helm-M-x")

   "b" '(:which-key "buffer")
   "b b" '(helm-mini :which-key "helm-mini")
   "b n" '(switch-to-next-buffer :which-key "next buffer")
   "b p" '(switch-to-prev-buffer :which-key "previous buffer")
   "b d" '(kill-this-buffer :which-key "delete buffer")

   "b m" '((lambda () (interactive) (switch-to-buffer "Messages") (evil-motion-state)) :which-key "messages buffer")

   "c l" '(comment-line :which "comment line")
   "c r" '(comment-region :which "comment region")
   "j" '(:which "jira")
   "j i" '(org-jira-get-issues :which "get issues")

   "e" '(:which-key "emacs misc")
   "e i" '((lambda () (interactive) (find-file user-init-file)) :which-key "edit init.el")
   "e l" '((lambda () (interactive) (load-file user-init-file)) :which-key "load init.el")
   "e t" '(:which-key "theme")
   "e t n" '(cycle-themes :which-key "next theme")
   "e p" '(:which-key "package")
   "e p i" '(package-install :which-key "install")
   "e p d" '(package-delete :which-key "delete")
   "e p r" '(package-refresh-contents :which-key "refresh-contents")
   "e n" '((lambda () (interactive) (find-file "~/Dropbox/documents/notes/emacs.org")) :which-key "open notes")

   "f" '(:which-key "file")
   "f l" '(load-file :which-key "load file")
   "f f" '(helm-find-files :which-key "find-file")
   "f s" '(save-buffer :which-key "save file")

   "g" '(:which-key "git")
   "g s" '(magit-status :which-key "status")
   "g m" '(magit-dispatch :which-key "dispatch popup")

   "o" '(:which-key "org")
   "o t" '(org-todo :which-key "todo")

   "w" '(:which-key "window")
   "w d" '(delete-window :which-key "delete window")
   "w ;" '(evil-window-right :which-key "select window right")
   "w l" '(evil-window-up :which-key "select window up")
   "w k" '(evil-window-down :which-key "select window down")
   "w j" '(evil-window-left :which-key "select window left")
   "w s" '(split-window-vertically :which-key "split window vert")
   "w /" '(split-window-horizontally :which-key "split window horizontally")
   )
  )
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("e3c87e869f94af65d358aa279945a3daf46f8185f1a5756ca1c90759024593dd" "9c27124b3a653d43b3ffa088cd092c34f3f82296cf0d5d4f719c0c0817e1afa6" "b0fd04a1b4b614840073a82a53e88fe2abc3d731462d6fde4e541807825af342" "34c99997eaa73d64b1aaa95caca9f0d64229871c200c5254526d0062f8074693" default)))
 '(package-selected-packages
   (quote
    (which-key cycle-themes helm doom-themes key-chord evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#2E3440" "#C16069" "#A2BF8A" "#ECCC87" "#80A0C2" "#B58DAE" "#86C0D1" "#ECEFF4"])
 '(custom-safe-themes
   (quote
    ("34c99997eaa73d64b1aaa95caca9f0d64229871c200c5254526d0062f8074693" "e3c87e869f94af65d358aa279945a3daf46f8185f1a5756ca1c90759024593dd" default)))
 '(fci-rule-color "#4C566A")
 '(jdee-db-active-breakpoint-face-colors (cons "#191C25" "#80A0C2"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#191C25" "#A2BF8A"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#191C25" "#434C5E"))
 '(objed-cursor-color "#C16069")
 '(package-selected-packages
   (quote
    (ansible yasnippet-snippets auto-complete markdown-mode org-jira circe evil-magit yaml-mode magit go-mode dash spaceline ivy use-package which-key-posframe key-chord helm evil doom-themes cycle-themes)))
 '(vc-annotate-background "#2E3440")
 '(vc-annotate-color-map
   (list
    (cons 20 "#A2BF8A")
    (cons 40 "#bac389")
    (cons 60 "#d3c788")
    (cons 80 "#ECCC87")
    (cons 100 "#e3b57e")
    (cons 120 "#da9e75")
    (cons 140 "#D2876D")
    (cons 160 "#c88982")
    (cons 180 "#be8b98")
    (cons 200 "#B58DAE")
    (cons 220 "#b97e97")
    (cons 240 "#bd6f80")
    (cons 260 "#C16069")
    (cons 280 "#a15b66")
    (cons 300 "#825663")
    (cons 320 "#625160")
    (cons 340 "#4C566A")
    (cons 360 "#4C566A")))
 '(vc-annotate-very-old-color nil))
