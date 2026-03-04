;; -*- lexical-binding: t; -*-

;; Emacs native compilation with Homebrew's libgccjit on macOS
;;
;; Problem: Emacs 28+ with native-comp fails with "error invoking gcc driver"
;; and "library 'emutls_w' not found" when libgccjit can't find GCC libraries.
;;
;; Solution: Set LIBRARY_PATH to include:
;;   1. /opt/homebrew/lib/gcc/current - main gcc libraries including libgccjit
;;   2. /opt/homebrew/lib/gcc/current/gcc/<arch>/<version> - contains libemutls_w.a
;;
;; GUI apps (launched from Dock/Spotlight) don't inherit shell environment,
;; so we must set LIBRARY_PATH here in early-init.el before native-comp runs.
;; The arch-specific path is found dynamically (e.g., aarch64-apple-darwin25/15).
;;
;; This is also set in ~/.zsh/.zshenv for terminal-launched Emacs.
;; Only activates if Homebrew's gcc is installed at the expected path.
(when (and (eq system-type 'darwin)
           (native-comp-available-p))
  (let ((gcc-base "/opt/homebrew/lib/gcc/current"))
    (when (file-directory-p gcc-base)
      (let* ((gcc-nested (concat gcc-base "/gcc/"))
             (gcc-arch-dir (when (file-directory-p gcc-nested)
                            (car (directory-files gcc-nested t "apple-darwin" t))))
             (gcc-version-dir (when (and gcc-arch-dir (file-directory-p gcc-arch-dir))
                               (car (directory-files gcc-arch-dir t "^[0-9]" t))))
             (lib-paths (delq nil (list gcc-base gcc-version-dir))))
        (setenv "LIBRARY_PATH"
                (mapconcat #'identity
                           (append lib-paths
                                   (when (getenv "LIBRARY_PATH")
                                     (list (getenv "LIBRARY_PATH"))))
                           ":"))))))
