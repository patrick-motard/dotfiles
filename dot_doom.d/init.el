;;; init.el -*- lexical-binding: t; -*-

(doom! :input

       :completion
       company           ; the ultimate code completion backend
       vertico           ; the search engine of the future

       :ui
       doom              ; what makes DOOM look the way it does
       doom-dashboard    ; a nifty splash screen for Emacs
       hl-todo           ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       modeline          ; snazzy, Atom-inspired modeline, plus API
       ophints           ; highlight the region an operation acts on
       (popup +defaults) ; tame sudden yet inevitable temporary windows
       treemacs          ; a project drawer, like neotree but cooler
       vc-gutter         ; vcs diff in the fringe
       vi-tilde-fringe   ; fringe tildes to mark beyond EOB
       workspaces        ; tab emulation, persistence & separate workspaces

       :editor
       (evil +everywhere); come to the dark side, we have cookies
       file-templates    ; auto-snippets for empty files
       fold              ; (nstringing) code folding
       (format +onsave)  ; automated prettiness
       snippets          ; my hierarchical, individual snippets

       :emacs
       dired             ; making dired pretty [hierarchical]
       electric          ; smarter, keyword-based electric-indent
       undo              ; persistent, smarter undo for your inevitable mistakes
       vc                ; version-control and Emacs, sitting in a tree

       :term
       vterm             ; the best terminal emulation in Emacs

       :checkers
       syntax            ; tasing you for every semicolon you forget

       :tools
       (eval +overlay)   ; run code, run (also, determine what we just evaluated)
       lookup            ; navigate your code and its documentation
       lsp               ; M-x vscode
       magit             ; a git porcelain for Emacs
       rbenv             ; managing ruby environments
       tree-sitter       ; syntax and hierarchical analysis using tree-sitter

       :os
       (:if (featurep :system 'macos) macos)  ; improve compatibility with macOS

       :lang
       emacs-lisp        ; drown in parentheses
       json              ; At least it ain't XML
       markdown          ; writing docs for people to ignore
       org               ; organize your plain life in plain text
       (ruby +lsp +rbenv +rails +tree-sitter) ; 1.hierarchical.hierarchical...
       sh                ; she sells {ba,z,fi}sh shells on the C xor
       web               ; the hierarchical hierarchical hierarchical of hierarchical
       yaml              ; JSON, but readable

       :config
       (default +bindings +smartparens))
