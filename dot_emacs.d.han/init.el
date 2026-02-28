;; TODO: avy (goto-char, goto-word, goto-word-or-subword, goto-line)
;; TODO: relative line numbers
;; TODO: major mode command exploring via ',' character
;; TODO: magit better hotkeys for finishing commit buffer
;; TODO: get evil keybinds working with help buffer (and others)
;; TODO: jira mode
;; TOOD: move to window by number
;; TODO: explore kill ring
;; TODO: load irc password from separate file or something more secure

(setq user-emacs-directory "~/.emacs.d.han")
(setq user-init-file "~/.emacs.d.han/init.el")
;; This TLS setting fixes "failed to download 'gnu' archive" error.
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;;(setq package-enable-at-startup nil) ;; dont load packages before startup

;; Set up MELPA, and the rest, via package.el
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")))
(require 'package)
(package-initialize)
(org-babel-load-file "~/.emacs.d.han/settings.org")

;; MCP server - allows Claude to interact with this Emacs session
(add-to-list 'load-path "~/code/emacs-mcp-server")
(require 'mcp-server)
(setq mcp-server-socket-directory "~/.emacs.d.han/.local/cache/")
(add-hook 'emacs-startup-hook #'mcp-server-start-unix)

;; Safe helper for Claude to read the *Warnings* buffer via MCP
(defun my/get-warnings ()
  "Return the contents of the *Warnings* buffer for MCP access."
  (if (get-buffer "*Warnings*")
      (with-current-buffer "*Warnings*" (buffer-string))
    "No warnings buffer found."))
(add-to-list 'mcp-server-security-allowed-dangerous-functions 'my/get-warnings)
;; ;;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; disable menu and tool bar
;; (menu-bar-mode -1)
;; (tool-bar-mode -1)
;; (scroll-bar-mode -1)
;; (add-hook 'before-save-hook 'whitespace-cleanup)
;; configure file backups
;; (setq backup-directory-alist `(("." . "~/.saves")))
;; (setq backup-by-copying t)
;; (setq delete-old-versions t
;;   kept-new-versions 6
;;   kept-old-versions 2
;;   version-control t)

;; ;; activate shell mode for AUR PKGBUILD files
;; (add-to-list 'auto-mode-alist'("PKGBUILD\\'" . shell-script-mode))
;; (global-set-key (kbd "RET") 'newline-and-indent)

;; ;; The value is in 1/10pt, so 100 will give you 10pt, etc.
;; ;; This doesn't seem to be necessary if the font size is specified with the font name.
;; ;; I'll leave it here for reference.
;; ;;(set-face-attribute 'default (selected-frame) :height 180)
;; (add-to-list 'default-frame-alist '(font . "Source Code Pro for Powerline-18"))
;; (global-display-line-numbers-mode)

;; ;; Bootstrap `use-package'
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
    go-mode
    exec-path-from-shell
    yaml-mode
    circe
    org
    spaceline
    evil-collection
    org-jira))
;; TODO: remove this auto installing with use-package ensure: t
;; install missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(use-package auto-complete :ensure t)
;; (use-package auto-complete :ensure t :defer t)
;; In elisp-mode, allows jumping to definition of function or variables under cursor.
(use-package elisp-def :ensure t)
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
  (add-hook hook #'elisp-def-mode))

;; (use-package helm :ensure t)
;; (require 'helm-config)
;; (helm-mode 1)
;; ;;(setq helm-mode-fuzzy-match t)
;; ;;(setq helm-completion-in-region-fuzzy-match t)
;; (setq-default helm-M-x-fuzzy-match t)
;; ;; Rebind tab in helm-find-files to complete the selection (instead of enter).
;; (define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
;; (define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)
;; ;; Since tab is 'helm-select-action', switch that to C-z so we can still call it.
;; (define-key helm-map (kbd "C-z") #'helm-select-action)


;; ;; (require 'mu4e)
;; ;; use mu4e for email in emacs
;; (setq mail-user-agent 'mu4e-user-agent)
;; ;;default
;; ;; (setq mu4e-maildir "~/Maildir")
;; (setq mu4e-sent-folder   "/Gmail/[Gmail].Sent Mail"
;;       mu4e-drafts-folder "/Gmail/[Gmail].Drafts"
;;       mu4e-trash-folder  "/Gmail/[Gmail].Trash"
;;       ;; don't save message to Sent Messages, Gmail/IMAP takes care of this
;;       mu4e-sent-messages-behavior 'delete
;;       ;; allow for updating mail using 'U' in the main view:
;;       mu4e-get-mail-command "offlineimap"
;;       user-mail-address "motard19@gmail.com"
;;       user-full-name  "Patrick Motard"
;;       smtpmail-default-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-service 587
;;       ;; allow use of helm to select mailboxes
;;       mu4e-completing-read-function 'completing-read
;;       ;; close messages after they are sent
;;       message-kill-buffer-on-exit t
;;       ;; don't ask for a 'context' upon opening mu4e
;;       mu4e-context-policy 'pick-first
;;       ;; don't ask to quit
;;       mu4e-confirm-quit nil
;;       mu4e-view-prefer-html t)

;; ;;    mu4e-compose-signature
;; ;;     (concat
;; ;;       "Foo X. Bar\n"
;; ;;       "http://www.example.com\n"))
;; ;; (use-package smtpmail :ensure t)
;; ;; (setq message-send-mail-function 'smtpmail-send-it
;; ;;    starttls-use-gnutls t
;; ;;    smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
;; ;;    smtpmail-auth-credentials
;; ;;      '(("smtp.gmail.com" 587 "motard19@gmail.com" nil))
;; ;;    smtpmail-default-smtp-server "smtp.gmail.com"
;; ;;    smtpmail-smtp-server "smtp.gmail.com"
;; ;;    smtpmail-smtp-service 587)
;; ;; ;; don't keep message buffers around
;; ;; (setq message-kill-buffer-on-exit t)

;; (use-package mu4e-alert
;;   :ensure t
;;   :after mu4e
;;   :init
;;   (setq mu4e-alert-interesting-mail-query
;; 	(concat
;; 	 "flag:unread maildir:/Gmail/INBOX"
;; 	 ))
;;   (mu4e-alert-enable-mode-line-display)
;;   (defun gjstein-refresh-mu4e-alert-mode-line ()
;;     (interactive)
;;     (mu4e~proc-kill)
;;     (mu4e-alert-enable-mode-line-display))
;;   (run-with-timer 0 60 'gjstein-refresh-mu4e-alert-mode-line))
(use-package winum
  :ensure t
  :init (winum-mode))

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))
(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))
;; Unset RET & SPC in evil mode so that other shortcuts can use them.
;; Without setting this, RET doesn't work for following links in org mode.
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "SPC") nil)
  (define-key evil-motion-state-map (kbd "RET") nil))

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
;; (use-package chocolate-theme
;;   :ensure t
;;   :config
;;   (load-theme 'chocolate t t))

(setq cycle-themes-theme-list
      '(doom-one
	chocolate
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

(require 'spaceline-config)
(spaceline-spacemacs-theme)

(require 'magit)

;; languages
;; golang
(use-package go-mode :ensure t :defer t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
;; godoc
(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))
(setenv "GOPATH" "/home/han/code/go")
(add-to-list 'exec-path "/home/han/code/go/bin")
(use-package go-autocomplete :ensure t)

(defun auto-complete-for-go ()
(auto-complete-mode 1))
 (add-hook 'go-mode-hook 'auto-complete-for-go)

(with-eval-after-load 'go-mode
   (require 'go-autocomplete))

(defun my-go-mode-hook ()
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
)
(add-hook 'go-mode-hook 'my-go-mode-hook)

(use-package go-guru :ensure t :defer t)
(go-guru-hl-identifier-mode)

;; Ansible
(use-package yaml-mode
  :ensure t)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-hook 'yaml-mode-hook '(lambda () (setq yaml-indent-offset 2)))
(add-hook 'yaml-mode-hook '(lambda () (setq tab-width 2)))
(add-hook 'yaml-mode-hook '(lambda () (setq evil-shift-width 2)))
;; enable ansible-mode whenever a yaml buffer is opened
(add-hook 'yaml-mode-hook '(lambda () (ansible 1)))
(add-hook 'yaml-mode-hook '(lambda () (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
(use-package ansible-doc :ensure t)
(add-hook 'yaml-mode-hook #'ansible-doc-mode)

;; irc
(require 'circe)
(setq circe-network-options
      '(("Freenode"
	 :tls t
	 :nick "han_mfalcon"
	 :sasl-username "han_mfalcon")))

;; jira
(use-package org :ensure t
  :config '(org-return-follows-link t))
;; # is shorthand for function
(add-hook 'org-mode-hook #'toggle-word-wrap)
(add-hook 'org-mode-hook #'(lambda ()
			     ;; make the lines in the buffer wrap around the edges of the screen.
			     ;; to press C-c q  or fill-paragraph ever again!
			     (visual-line-mode)
			     (org-indent-mode)))
;; Company - Complete anything. Auto-completion library.
;; (use-package company
;;   :ensure t
;;   :config
;;   (progn (add-hook 'after-init-hook 'global-company-mode)))


(defun org-update-cookies-after-save()
  (interactive)
  ;; This (4) is a "universal arguement". Still don't know what that means, but org-update-statistics-cookies
  ;; expects it to be set if you want to update all cookies in the whole file.
  (let ((current-prefix-arg '(4)))
  (org-update-statistics-cookies "ALL")))
;; Automatically update all cookies when saving the file. This makes sure that any checkboxes added,
;; removed, or finished, are counted/summed together on each todo (example: [ 1/12 ].
(add-hook 'org-mode-hook (lambda () (add-hook 'before-save-hook 'org-update-cookies-after-save)))

(use-package highlight-parentheses :ensure t)
(add-hook 'emacs-lisp-mode-hook #'highlight-parentheses-mode)

(use-package yasnippet                  ; Snippets
  :ensure t
  :config
  (yas-global-mode))
(use-package yasnippet-snippets         ; Collection of snippets
  :ensure t)
(use-package ansible :ensure t)
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(use-package all-the-icons :ensure t)

(use-package which-key :ensure t)
(which-key-mode)
(setq which-key-idle-delay 0.1)

(use-package general :ensure t
  :config
  (general-define-key
    :states '(normal visual emacs)
   "," (general-simulate-key "C-c"))
  (general-define-key
    :states '(normal visual insert emacs)
   "C-," (general-simulate-key "M-x"))
  (general-define-key
   :keymaps '(normal visual insert emacs dired-mode-map)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"
   "" nil
   "TAB" '(switch-to-prev-buffer :which-key "prev buffer")
   "," (general-simulate-key "C-c")
   "SPC" '(helm-M-x :which-key "helm-M-x")
   "1" '(winum-select-window-1 :which-key "window #1")
   "2" '(winum-select-window-2 :which-key "window #2")
   "3" '(winum-select-window-3 :which-key "window #3")
   "4" '(winum-select-window-4 :which-key "window #4")
   "5" '(winum-select-window-5 :which-key "window #5")
   "6" '(winum-select-window-6 :which-key "window #6")
   "7" '(winum-select-window-7 :which-key "window #7")
   "8" '(winum-select-window-8 :which-key "window #8")
   "9" '(winum-select-window-9 :which-key "window #9")

   "b" '(:which-key "buffer")
   "b b" '(helm-mini :which-key "helm-mini")
   "b n" '(switch-to-next-buffer :which-key "next buffer")
   "b p" '(switch-to-prev-buffer :which-key "previous buffer")
   "b d" '(kill-this-buffer :which-key "delete buffer")
   "b m" '((lambda () (interactive) (switch-to-buffer "*Messages*") (evil-motion-state)) :which-key "messages buffer")

   "c" '(:which-key "claude / code")
   "c c" '(claude-code-ide-menu :which-key "claude code")
   "c l" '(comment-line :which-key "comment line")
   "c r" '(comment-region :which-key "comment region")

   "e" '(:which-key "emacs")
   "e d" '(elisp-def :which-key "go to definition")
   "e i" '((lambda () (interactive) (find-file user-init-file)) :which-key "edit init.el")
   "e l" '((lambda () (interactive) (load-file user-init-file)) :which-key "load init.el")
   "e t" '(:which-key "theme")
   "e t n" '(cycle-themes :which-key "next theme")
   "e p" '(:which-key "package")
   "e p i" '(package-install :which-key "install")
   "e p d" '(package-delete :which-key "delete")
   "e p r" '(package-refresh-contents :which-key "refresh")

   "f" '(:which-key "file")
   "f l" '(load-file :which-key "load file")
   "f f" '(helm-find-files :which-key "find file")
   "f s" '(save-buffer :which-key "save file")

   "g" '(:which-key "git")
   "g s" '(magit-status :which-key "status")
   "g m" '(magit-dispatch :which-key "dispatch")

   "h" '(:which-key "help")
   "h a" '(ansible-doc :which-key "ansible-doc")

   "o" '(:which-key "org")
   "o d" '(org-do-demote :which-key "demote")
   "o p" '(org-do-promote :which-key "promote")
   "o c" '(:which-key "checkbox")
   "o c a" '(org-insert-todo-heading :which-key "add")
   "o c t" '(org-toggle-checkbox :which-key "toggle")
   "o t" '(org-todo :which-key "todo")

   "s" '(:which-key "search")
   "s s" '(helm-occur :which-key "search buffer")
   "s p" '(helm-projectile-grep :which-key "search project")

   "w" '(:which-key "window")
   "w d" '(delete-window :which-key "delete")
   "w ;" '(evil-window-right :which-key "right")
   "w l" '(evil-window-up :which-key "up")
   "w k" '(evil-window-down :which-key "down")
   "w j" '(evil-window-left :which-key "left")
   "w s" '(split-window-vertically :which-key "split vert")
   "w /" '(split-window-horizontally :which-key "split horiz")
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
   ["#2E3440" "#C16069" "#A2BF8A" "#ECCC87" "#80A0C2" "#B58DAE" "#86C0D1"
    "#ECEFF4"])
 '(custom-safe-themes
   '("3613617b9953c22fe46ef2b593a2e5bc79ef3cc88770602e7e569bbd71de113b"
     "7f791f743870983b9bb90c8285e1e0ba1bf1ea6e9c9a02c60335899ba20f3c94"
     "2277b74ae6f5aa018aa0057ef89752163e34fcb09ab6242f169c1740a72ca27a"
     "34c99997eaa73d64b1aaa95caca9f0d64229871c200c5254526d0062f8074693"
     "e3c87e869f94af65d358aa279945a3daf46f8185f1a5756ca1c90759024593dd"
     default))
 '(fci-rule-color "#4C566A")
 '(helm-minibuffer-history-key "M-p")
 '(jdee-db-active-breakpoint-face-colors (cons "#191C25" "#80A0C2"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#191C25" "#A2BF8A"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#191C25" "#434C5E"))
 '(objed-cursor-color "#C16069")
 '(org-link-frame-setup
   '((vm . vm-visit-folder-other-frame)
     (vm-imap . vm-visit-imap-folder-other-frame)
     (gnus . org-gnus-no-new-news) (file . find-file)
     (wl . wl-other-frame)))
 '(package-selected-packages nil)
 '(pdf-view-midnight-colors (cons "#ECEFF4" "#2E3440"))
 '(rustic-ansi-faces
   ["#2E3440" "#BF616A" "#A3BE8C" "#EBCB8B" "#81A1C1" "#B48EAD" "#88C0D0"
    "#ECEFF4"])
 '(send-mail-function 'mailclient-send-it)
 '(vc-annotate-background "#2E3440")
 '(vc-annotate-color-map
   (list (cons 20 "#A2BF8A") (cons 40 "#bac389") (cons 60 "#d3c788")
	 (cons 80 "#ECCC87") (cons 100 "#e3b57e") (cons 120 "#da9e75")
	 (cons 140 "#D2876D") (cons 160 "#c88982")
	 (cons 180 "#be8b98") (cons 200 "#B58DAE")
	 (cons 220 "#b97e97") (cons 240 "#bd6f80")
	 (cons 260 "#C16069") (cons 280 "#a15b66")
	 (cons 300 "#825663") (cons 320 "#625160")
	 (cons 340 "#4C566A") (cons 360 "#4C566A")))
 '(vc-annotate-very-old-color nil))
