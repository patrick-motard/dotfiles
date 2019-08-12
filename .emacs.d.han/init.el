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

(require 'helm-config)

;; "ensure t" makes sure the package is accessible and downloads it if it's not.
(use-package general :ensure t
  :config
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"
   "TAB" '(switch-to-other-buffer :which-key "prev buffer")
   "b n" '(switch-to-next-buffer :which-key "next buffer")
   "b p" '(switch-to-prev-buffer :which-key "previous buffer")))



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
    (use-package which-key-posframe key-chord helm evil doom-themes cycle-themes)))
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
