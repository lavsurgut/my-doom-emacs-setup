;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Valery Lavrentiev"
      user-mail-address "lavsurgut@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Source Code Pro" :size 13)
      doom-variable-pitch-font (font-spec :family "Source Code Pro" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-laserwave)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;; make "Space" key faster to react
(setq which-key-idle-delay 0.1)
;; emacs server port
(setq server-port 12345)
;; maximize the screen
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
;; make vterm popup to appear on the far right
(after! vterm
  (set-popup-rule! "*doom:vterm-popup:*" :size 0.3 :vslot -4 :select t :quit nil :ttl 0 :side 'right)
  )

(use-package! python-black
  :demand t
  :after python)
;; Feel free to throw your own personal keybindings here
(map! :leader :desc "Blacken Buffer" "m b b" #'python-black-buffer)
(map! :leader :desc "Blacken Region" "m b r" #'python-black-region)
(map! :leader :desc "Blacken Statement" "m b s" #'python-black-statement)

(use-package! poetry
  :defer t
  :config
  (setq poetry-tracking-strategy 'projectile)
  )

(use-package! company-jedi
  :defer t
  :config
  (defun my/python-mode-hook ()
    (add-to-list 'company-backends 'company-jedi))
  (add-hook 'python-mode-hook 'my/python-mode-hook))

(use-package! ejc-sql
  :defer t
  :config
  ;;(setq ejc-completion-system 'vertico)
  ;;(require 'ejc-autocomplete)
  (setq nrepl-sync-request-timeout 12000)
  (setq clomacs-httpd-default-port 8090)
  ;;(defun k/ejc-sql-mode-hook ()
  ;; Enable one of the completion frontend by by default but not both.
  ;;(auto-complete-mode t) ; Enable `auto-complete-mode'
  ;;(ejc-ac-setup)
  ;; (company-mode t)    ; or `company-mode'.
  ;;(ejc-eldoc-setup)      ; Setup ElDoc.
  ;;(font-lock-warn-todo)       ; See custom/look-and-feel.el
  ;;(rainbow-delimiters-mode t) ; https://github.com/Fanael/rainbow-delimiters
  ;;(idle-highlight-mode t)     ; https://github.com/nonsequitur/idle-highlight-mode
  ;;(paredit-everywhere-mode)   ; https://github.com/purcell/paredit-everywhere
  ;;(electric-pair-mode)
  ;;)
  (add-hook 'ejc-sql-connected-hook
            (lambda ()
              (ejc-set-fetch-size 50)
              (ejc-set-max-rows 50)
              (ejc-set-show-too-many-rows-message t)
              (ejc-set-column-width-limit nil)
              (ejc-set-use-unicode t)
                                        ;(ejc-result-table-impl 'ejc-result-mode)
              ))
  ;;(add-hook 'ejc-sql-minor-mode-hook 'k/ejc-sql-mode-hook)
  )

(use-package! elfeed-webkit
  :ensure
  :after elfeed)

(after! lsp-mode
  (setq gofmt-command "goimports")
  (setq  lsp-go-analyses '((fieldalignment . t)
                           (nilness . t)
                           (shadow . t)
                           (unusedparams . t)
                           (unusedwrite . t)
                           (useany . t)
                           (unusedvariable . t)))
  (add-hook 'before-save-hook 'gofmt-before-save)
  )
