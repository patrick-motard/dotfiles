;; Set up MELPA
(require 'package)
;; Any add to list for package-archives (to add marmalade or melpa) goes here
(add-to-list 'package-archives 
    '("MELPA" .
      "http://melpa.milkbox.net/packages/"))
(package-initialize);; End Set up MELPA
      

(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

(add-to-list 'default-frame-alist '(font . "Inconsolata-18"))

;; The value is in 1/10pt, so 100 will give you 10pt, etc. 
;; This doesn't seem to be necessary if the font size is specified with the font name.
;; I'll leave it here for reference.
;;(set-face-attribute 'default (selected-frame) :height 180)

;; Remap esc to fd, for better evil experience.
(require 'key-chord)
(key-chord-mode 1)
(setq key-chord-two-keys-delay 0.2)
(key-chord-define evil-insert-state-map "fd" 'evil-normal-state)

;; disable menu and tool bar
(menu-bar-mode -1)
(tool-bar-mode -1)


;; custom-* is controlled by melpa, leave it alone.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (evil key-chord))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
