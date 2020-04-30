(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
  Your version of Emacs does not support SSL connections,
  which is unsafe because it allows man-in-the-middle attacks.
  There are two things you can do about this warning:
  1. Install an Emacs version that does support SSL and be safe.
  2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

(use-package quelpa
  :init
  (setq quelpa-update-melpa-p nil)
  :ensure t)

(use-package quelpa-use-package
  :ensure t)

(use-package gcmh
  :init
  (add-hook 'emacs-startup-hook
            (lambda ()
              (setq gc-cons-threshold 16777216 ;; 16mb
                    gc-cons-percentage 0.1))))

(add-hook 'window-setup-hook 'delete-other-windows)
(add-hook 'after-init-hook 'my-disable-variable-pitch)
(fset 'yes-or-no-p 'y-or-n-p)

(set-display-table-slot standard-display-table
                        'selective-display
                        (string-to-vector "."))

(menu-bar-mode nil)
(setq-default menu-bar-mode nil)
(setq menu-bar-mode nil)
(setq-default indent-tabs-mode nil)

(setq save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      require-final-newline t
      visible-bell nil
      load-prefer-newer t
      ediff-window-setup-function 'ediff-setup-windows-plain)

(setq backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))

(defvaralias 'udir 'user-emacs-directory)

(setq sentence-end nil
      undo-limit 320000
      custom-safe-themes t
      inhibit-read-only nil
      confirm-kill-emacs t
      focus-follows-mouse t
      evil-want-keybinding nil
      initial-buffer-choice nil
      inhibit-startup-message t
      undo-outer-limit 48000000
      use-package-always-ensure t
      initial-scratch-message nil
      sentence-end-double-space nil
      inhibit-startup-buffer-menu t
      initial-major-mode 'scratch-mode
      custom-file (concat udir ".emacs-custom.el")
      default-frame-alist '((font . "Input Mono Light 18")))
(setq parens-require-spaces nil)
(blink-cursor-mode 0)

;; (server-start)
;; (load-file custom-file)
;; (toggle-frame-fullscreen)

(defun line-numbers ()
  (interactive)
  (setq display-line-numbers 'visual)
  (setq display-line-numbers-widen nil)
  (setq display-line-numbers-current-absolute nil))

;; (setq-default left-fringe-width nil)

(defun line-numbers-absolute ()
  (interactive)
  (setq display-line-numbers 'visual)
  (setq display-line-numbers-widen nil)
  (setq display-line-numbers-current-absolute t))

(defun noct:relative ()
  (setq-local display-line-numbers 'visual))

(defun noct:absolute ()
  (setq-local display-line-numbers t))

(defun line-no-numbers ()
  (interactive)
  (setq display-line-numbers nil))

(defun my-disable-variable-pitch ()
  (interactive)
  (cl-loop for face in (face-list) do
           (unless (eq face 'default)
             (set-face-attribute face nil :height 1.0))))


(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(use-package evil
  :init
  (setq evil-respect-visual-line-mode nil
        evil-want-integration t
        evil-want-keybinding nil
        evil-jumps-cross-buffers nil
        evil-ex-substitute-global t
        evil-want-Y-yank-to-eol t)

  ;;;; EVIL ORG MODE ;;;
  (add-hook 'org-mode-hook 'evil-org-mode)
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys)

  :bind (:map evil-normal-state-map
              ("z=" . endless/ispell-word-then-abbrev)
              ("ç" . insert-char)
              ;; ("=" . evil-indent)
              ;; ("C--" . kill-whole-line)
              ("gh" . org-up-element)
              ("gl" . org-down-element)
              ("gM" . evil-set-marker)
              ("k"             . evil-previous-visual-line)
              ("j"             . evil-next-visual-line)
              ("m" . hydra-text-motions/body)
              ("u" . undo-fu-only-undo)
              ("zb" . evil-scroll-line-to-bottom)
              ("C-r" . undo-fu-only-redo)
              ("<mouse-2>" . my-kill-this-buffer)
              ;; ("M-i"               . delete-frame)
              ("M-o"               . evil-jump-backward)
              ("M-i"               . evil-jump-forward)
              ("Q"                 . delete-frame)
              ("\\"                . toggle-truncate-lines)
              ("M-r"               . ivy-switch-buffer)
              ("gU"                . fix-word-upcase)
              ("gu"                . fix-word-downcase)
              ("Ç"                 . git-timemachine)
              ("X"                 . whack-whitespace)
              ("0"                 . beginning-of-visual-line)
              ("C-a"                 . evil-numbers/inc-at-pt)
              ("gm"                . nil)
              ("z0"                . flyspell-correct-wrapper)
              ("C-k"               . my-kill-line)
              ("F"                 . avy-goto-word-1-above)
              ("f"                 . avy-goto-word-1-below)
              ("gf"                . evil-find-char)
              ("gF"                . evil-find-char-backward)
              ("C-."               . nil)
              ("."                 . counsel-org-capture)
              (","                 .  hydra-org-agenda/body)
              ("gx"                . evil-exchange)
              ("gX"                . evil-exchange-cancel)
              (";"                 . evil-ex)
              ("<XF86Explorer>"  . quick-calc)
              ("K"                 . ignore)
              ("'"                 . evil-goto-mark)
              ("`"                 . evil-goto-mark-line)
              ;; ("C-s"               . helm-occur)
              ("M-s"               . last-buffer)
              ("gr"                . my-sel-to-end)
              ("C-h"               . hydra-help/body)
              ("zi"                . outline-show-all)
              ("M-RET"             . my-indent-buffer)
              ("g3"                . evil-backward-word-end)
              ("ge"                . end-of-visual-line)
              ("gt"                . fix-word-capitalize)
              ("z-"                . my-insert-current-word)
              ("C-S-x"             . evil-numbers/dec-at-pt)
              ("C-S-a"             . evil-numbers/inc-at-pt)
              ("<escape>"          . my-save-buffer)
              ("go"                . cool-moves-open-line-below)
              ("gi"                . cool-moves-open-line-above)
              ("M-,"               . nswbuff-switch-to-previous-buffer)
              ("M-."               . nswbuff-switch-to-next-buffer)
              ("g."               . evil-repeat)
              ("C-a"                 . evil-numbers/inc-at-pt))

  :bind (:map evil-visual-state-map
              ("ç" . insert-char)
              ("K"                 . ignore)
              ("g3"                . evil-backward-word-end)
              ("ge"                . end-of-visual-line)
              ("C-c u"                . my-hlt-unhighlight-region)
              ("C-c h"                . my-hlt-highlight-region)
              ("gf"                . evil-find-char)
              ("gF"                . evil-find-char-backward)
              ("C-r" . undo-fu-only-redo)
              ("zb" . evil-scroll-line-to-bottom)
              ;; ("u" . evil-downcas)
              ("<mouse-2>" . my-kill-this-buffer)
              ("k"             . evil-previous-visual-line)
              ("j"             . evil-next-visual-line)
              ("C-c r"             . eval-region)
              ;; ("M-i"               . delete-frame)
              ("M-o"               . evil-jump-backward)
              ("M-i"               . evil-jump-forward)
              ("\\"                . toggle-truncate-lines)
              ("Ç"                 . git-timemachine)
              ("z0"                . flyspell-correct-wrapper)
              ("F"                 . avy-goto-word-1-above)
              ("f"                 . avy-goto-word-1-below)
              ("."                 . counsel-org-capture)
              (","                 .  hydra-org-agenda/body)
              ("gx"                . evil-exchange)
              ("gX"                . evil-exchange-cancel)
              ("gr"                . my-sel-to-end)
              ("<XF86Explorer>"  . my-quick-calc-from-visual)
              ("'"                 . evil-goto-mark)
              ("`'"                . evil-goto-mark-line)
              ;; ("C-s"               . helm-occur)
              ("M-s"               . last-buffer)
              ("C-h"               . hydra-help/body)
              ("zi"                . outline-show-all)
              ("M-RET"             . my-indent-buffer)
              ("M-,"               . nswbuff-switch-to-previous-buffer)
              ("M-."               . nswbuff-switch-to-next-buffer)
              ("C-S-x"             . evil-numbers/dec-at-p)
              ("C-S-a"             . evil-numbers/inc-at-pt)
              ("g."               . evil-repeat))

  :bind (:map evil-insert-state-map
              ("C-8" . my-insert-square-brackets)
              ("C-(" . my-insert-curly-braces)
              ("C-r" . undo-fu-only-redo)
              ("<mouse-2>" . my-kill-this-buffer)
              ("C-."               . nil)
              ("M-."               . nswbuff-switch-to-next-buffer)
              ("M-,"               . nswbuff-switch-to-previous-buffer)
              ("M-d"               . kill-word)
              ("<XF86Explorer>"  . quick-calc)
              ("M-s"               . last-buffer)
              ("C-d"               . delete-char)
              ("M-f"               . forward-word)
              ("M-b"               . backward-word)
              ("C-n"               . next-line)
              ("C-p"               . previous-line)
              ("C-k"               . kill-line)
              ("C-h"               . backward-delete-char)
              ("C-u"               . my-backward-kill-line)
              ("C-e"               . move-end-of-line)
              ("C-a"               . move-beginning-of-line)
              ("C-S-x"             . evil-numbers/dec-at-p)
              ("C-S-a"             . evil-numbers/inc-at-pt))

  :bind (:map evil-ex-completion-map
              ("<insert>"          . yank)
              ("C-8" . my-insert-square-brackets)
              ("C-(" . my-insert-curly-braces)
              ("C-h"               . delete-backward-char)
              ("C-k"               . kill-line)
              ("C-d"               . delete-char)
              ("C-a"               . beginning-of-line)
              ("C-b"               . backward-char)
              ("C-u"               . my-backward-kill-line))

  :config

  (general-define-key
   :keymaps 'evil-ex-search-keymap
   "C-s"    'previous-history-element)


  (general-unbind '(evil-normal-state-map
                    evil-insert-state-map
                    evil-visual-state-map)
    :with 'ignore
    [remap evil-emacs-state])

  (evil-set-initial-state 'completion-list-mode 'emacs)
  (evil-set-initial-state 'pomidor-mode 'emacs)
  (evil-set-initial-state 'chess-display-mode 'emacs)
  (evil-set-initial-state 'undo-propose-mode 'normal)
  (evil-set-initial-state 'completion-list-mode 'normal)
  (evil-set-initial-state 'Info-mode 'normal)
  (evil-set-initial-state 'with-editor-mode 'insert)
  (evil-set-initial-state 'term-mode 'insert)
  (evil-set-initial-state 'atomic-chrome-edit-mode 'insert)
  (evil-set-initial-state 'vc-git-log-edit-mode 'insert)
  (evil-set-initial-state 'org-journal-mode 'insert)
  (evil-set-initial-state 'shell-mode 'insert)
  (evil-set-initial-state 'racket-repl-mode 'insert)

  (defun my-no-insert-message ()
    (interactive)
    (message " evil insert disabled"))

  (defun my-quick-calc-from-visual ()
    (interactive)
    (evil-exit-visual-state)
    (quick-calc))

  (defun my-evil-delete-visual-line ()
    (interactive)
    (kill-line)
    (evil-insert-state))

  (defun my-kill-line ()
    (interactive)
    (kill-line)
    (evil-insert-state))

  (defun my-kill-visual-line-and-insert ()
    (interactive)
    (kill-visual-line)
    (evil-insert-state))

  ;; next-history-element
  (evil-mode +1))

(use-package evil-collection
  :after evil
  :config

  (general-define-key
    :keymaps  'evil-collection-lispy-mode-map
    :states '(normal visual insert)
    "M-r"     'ivy-switch-buffer)

  (evil-collection-init))

(use-package evil-commentary
  :after evil
  :ensure t
  :config
  (evil-commentary-mode 1))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package evil-org
  :config

  ;; (general-nvmap
  ;;   :keymaps 'evil-org-mode-map
  ;;   "C-c l" 'evil-org-org-insert-heading-respect-content-below)

  (evil-org-set-key-theme '(navigation insert textobjects additional calendar))
  (global-evil-surround-mode 1))

(use-package evil-exchange
  :after evil
  :config
  (setq evil-exchange-key "gx")
  (evil-exchange-cx-install))

(use-package evil-numbers
  :ensure t)

(use-package evil-matchit
  :ensure t
  :config
  (global-evil-matchit-mode 1))

(use-package evil-visualstar
  :after evil
  :config
  (setq evil-visualstar/persistent t)
  (global-evil-visualstar-mode +1))

(use-package evil-swap-keys
  :after evil
  :config

  (defun evil-swap-keys-swap-dash-emdash ()
    "Swap the underscore and the dash."
    (interactive)
    (evil-swap-keys-add-pair "-" "—"))

  (defun evil-swap-keys-swap-emdash-dash ()
    "Swap the underscore and the dash."
    (interactive)
    (evil-swap-keys-add-pair "—" "-"))

  (defun evil-swap-keys-swap-eight-asterisk ()
    "Swap the underscore and the dash."
    (interactive)
    (evil-swap-keys-add-pair "8" "*"))

  (defun evil-swap-keys-dollar-sign-four ()
    "Swap the underscore and the dash."
    (interactive)
    (evil-swap-keys-add-pair "$" "4"))

  (defun evil-swap-keys-three-curly-braces ()
    (interactive)
    (evil-swap-keys-add-pair "3" "{"))

  (defun evil-swap-keys-comma-semicolon ()
    (interactive)
    (evil-swap-keys-add-pair "," ";"))

  (defun evil-swap-keys-equal-zero ()
    (interactive)
    (evil-swap-keys-add-pair "=" "0"))

  (defun evil-swap-keys-swap-equal-plus ()
    "Swap the underscore and the dash."
    (interactive)
    (evil-swap-keys-add-pair "=" "+")))

(use-package general
  :config

  (general-translate-key nil 'override "<pause>" "SPC")

  (general-evil-setup t)

  (general-define-key
   :keymaps  'global
   "M-q" 'eyebrowse-prev-window-config
   "M-w" 'eyebrowse-next-window-config
   "M-7" 'make-frame
   "M-8" 'other-frame
   "M-9"     'delete-other-windows
   "M-0"     'quit-window
   "C-c P" 'counsel-projectile-mode
   "C-c f"   'font-lock-mode
   "C-x d"   'toggle-debug-on-error
   "C-_" 'undo-fu-only-undo
   "<mouse-8>" 'nswbuff-switch-to-next-buff
   "<mouse-2>" 'my-kill-this-buffer
   "C-c S"   'my-emacs-session
   "C-c -"   'my-recenter-window
   "C-;"     'helpful-at-point
   "C-:"     'helpful-variable
   "C-c C-o" 'org-open-at-point-global
   "C-x p"   'my-goto-package)

  (general-define-key
   :keymaps  'override
   "C-c s" 'my-shell-full
   "C-c v"   'yank
   "C-x r" 'kill-ring-save
   "C-x c" 'quick-calc
   "C-c i" 'pbcopy
   "§" 'helm-resume
   "C-S-s" 'helm-resume
   "C-s" 'helm-swoop-without-pre-input
   "C--" 'helm-swoop
   "C-c u" 'revert-buffer
   "M-'"    'delete-window
   "M-r" 'ivy-switch-buffer
   "M-;" 'counsel-projectile-switch-to-buffer
   "M-s" 'last-buffer
   "C-x s" 'my-shell-below
   "M-ç" 'insert-char
   "C-0"     'evil-execute-macro
   "C-c 0"     'evil-execute-macro
   "M-y" 'my-yank-pop
   "C-,"     'evil-window-prev
   "C-."     'evil-window-next
   "C-/"     'my-term-below
   "C-c F s" 'my-show-server
   "C-x P"   'hydra-python-mode/body
   "C-c j"   'org-journal-new-entry
   "C-c ç"   'my-bash-shebang
   "C-c k"   'kill-buffer-and-window
   "C-9"     'evil-commentary-line)

  (defun my-insert-checkmark ()
    (interactive)
    (insert ""))

  (general-define-key
   :keymaps  'override
   :states   '(normal visual)
   "C-SPC" 'fix-word-upcase
   "X" 'whack-whitespace)

  (general-define-key
   :states   '(insert)
   :keymaps   'override
   "C-SPC" 'fix-word-upcase
   "C-@" 'fix-word-upcase
   "C-S-SPC" 'fix-word-capitalize
   "C-c u" 'universal-argument)

  (general-define-key
   :states   '(insert)
   :keymaps   'override
   "C-c u" 'universal-argument)

  (general-define-key
   :states   '(normal visual insert)
   "<f12>"   'man
   "M-9"     'delete-other-windows
   "M-0"     'quit-window
   "C-c a"   'align-regexp
   "C-c e"   'my-eval-buffer
   ;; "C-c o"    'helm-org-in-buffer-headings
   )
    ;;;; LEADER ;;;;
  (general-create-definer leader
    :prefix "SPC")

  (leader
    :states  '(normal visual)
    :keymaps 'override
    ";"      'hydra-magit-main/body
    "u"      'hydra-projectile-mode/body
    "p"      'hydra-packages/body
    "h"      'my-org-hooks
    "e"      'visible-mode
    ","      'olivetti-mode
    "\\"     'org-babel-tangle
    "."      'my-tangle-py-init.org-only
    "-"      'my-tangle-py-init.org-only-and-quit-window
    "d"      'my-dup-line
    "m"      'hydra-modes/body
    "s"      'hydra-search/body
    "c"      'hydra-commands/body
    "SPC"    'hydra-text-main/body
    "z"      'hydra-window/body
    "i"      'hydra-find-file/body
    "0"      'delete-window
    "a"      'counsel-M-x
    "f"      'counsel-find-file
    "j"      'hydra-org-clock/body
    "w"      'recursive-widen
    "g"      'counsel-grep
    "R"      'eyebrowse-rename-window-config
    "r"      'my-ranger-deer
    "k"      'hydra-kill/body
    "q"      'my-kill-this-buffer
    "o"      'hydra-org-mode/body
    "F"      'my-reopen-killed-file
    "t"      'counsel-buffer-or-recentf
    "T"      'my-reopen-killed-file-fancy
    "l"      'hydra-tangle/body
    "w"      'widenToCenter
    "W"      'widenToCenter
    ;; "n"      'recursive-narrow-or-widen-dwim
    "n"      'org-narrow-to-subtree)

  (general-unbind 'global
    :with 'undo-tree-redo
    [remap redo]))

;; (use-package org-plus-contrib)

(use-package org
  :defer t
  :init

  ;; (add-hook 'org-cycle-hook 'org-toggle-tag-visibility)
  (add-hook 'org-mode-hook 'my-org-hooks)
  (add-hook 'org-src-mode-hook 'my-only-indent-buffer)
  (add-hook 'org-agenda-mode-hook 'my-org-agenda-hooks)

  (remove-hook 'org-cycle-hook #'org-optimize-window-after-visibility-change)

  :bind (:map org-src-mode-map
              ("C-c DEL" . org-edit-src-exit)
              ("C-c RET" . my-eval-buffer-and-leave-org-source))
  :config

  (defun my-org-agenda-goto ()
    (interactive)
    (org-agenda-goto)
    (delete-windows-on "*Org Agenda*"))

  (defun my-org-agenda-hooks ()
    (interactive)
    (hl-line-mode +1)
    (olivetti-mode +1))

  (defun my-org-hooks ()
    (interactive)
    ;; (evil-org-mode +1)
    (org-bullets-mode +1)
    (visual-line-mode +1)
    ;; (tab-jump-out-mode +1)
    (setq-local doom-modeline-enable-word-count nil))

  (general-unbind 'org-columns-map
    :with 'org-columns-quit
    [remap org-columns]
    [remap save-buffer])

  (general-define-key
   :keymaps 'org-mode-map
   "C-x <up>"   'org-shiftup
   "C-x <down>"   'org-shiftdown
   "C-x <left>"   'org-shiftleft
   "C-x <right>"   'org-shiftright
   "C-c l" 'evil-org-org-insert-heading-respect-content-below
   "C-x ;" 'org-timestamp-down
   "C-x ." 'org-timestamp-up
   "M-p" 'org-backward-paragraph
   "M-n" 'org-forward-paragraph
   "C-c -" 'my-insert-em-dash-space
   "C-c C-n" 'org-add-note
   "C-c n" 'org-add-note
   "C-c y" 'org-evaluate-time-range
   "C-c C-s" 'org-emphasize
   "C-c o" 'counsel-outline
   "C-ç" 'counsel-outline
   "C-c q" 'org-columns
   "C-M-k" 'org-metaup
   "C-M-j" 'org-metadown
   "C-<" 'org-priority-up
   "C->" 'org-priority-down
   "C-c C-s" 'org-emphasize
   "<C-S-up>" 'org-priority-up
   "<C-S-down>" 'org-priority-down)

  (general-nvmap
    :keymaps 'org-mode-map
    "zb" 'evil-scroll-line-to-bottom
    "C-k" 'my-kill-line)

  (general-nmap
    :keymaps 'org-mode-map
    "C-c -" 'my-insert-em-dash-space)

  (general-define-key
   :keymaps 'org-agenda-mode-map
   "<S-left>" 'org-agenda-date-earlier
   "<S-right>" 'org-agenda-date-later
   "<escape>" 'org-agenda-quit)

  (general-unbind 'org-agenda-mode-map
    :with 'windmove-up
    [remap org-agenda-drag-line-backward])

  (general-unbind 'org-agenda-mode-map
    :with 'windmove-down
    [remap org-agenda-drag-line-forward])

  (general-unbind 'org-agenda-mode-map
    :with 'my-org-agenda-goto
    [remap org-agenda-switch-to]
    [remap evil-ret])

  (general-unbind 'org-agenda-mode-map
    :with 'org-agenda-quit
    [remap evil-repeat-find-char-reverse]
    [remap org-agenda-goto-today])

  (general-unbind 'org-agenda-mode-map
    :with 'org-agenda-previous-item
    [remap org-agenda-previous-line]
    [remap evil-previous-visual-line])

  (general-unbind 'org-agenda-mode-map
    :with 'org-agenda-next-item
    [remap org-agenda-next-line]
    [remap evil-next-visual-line])

  (general-unbind 'org-agenda-mode-map
    :with 'org-todo-list
    [remap evil-find-char-to-backward])

  (general-unbind 'org-agenda-mode-map
    :with 'org-agenda-quit
    [remap minibuffer-keyboard-quit])

  (general-unbind 'org-mode-map
    :with 'org-emphasize
    [remap pyenv-mode-set])

  (general-unbind 'org-mode-map
    :with 'cool-moves-line-backward
    [remap org-shiftcontrolup])

  (general-unbind 'org-mode-map
    :with 'cool-moves-line-forward
    [remap org-shiftcontroldown])

  (general-define-key
   :keymaps 'org-mode-map
   :states   '(normal visual)
   "TAB"   'org-cycle)

  (general-unbind 'org-mode-map
    :with 'delete-char
    [remap org-metaleft])

  (general-define-key
   :keymaps 'org-mode-map
   :states '(normal visual)
   "DEL" 'org-edit-special)

  (general-nvmap
    :keymaps 'org-src-mode-map
    "DEL" 'my-eval-buffer-and-leave-org-source
    "<backspace>" 'my-eval-buffer-and-leave-org-source)

  (general-define-key
   :keymaps 'org-mode-map
   :states '(normal visual)
   "<insert>" 'org-insert-link
   "DEL" 'org-edit-special)

  (defun my-org-started-with-clock ()
    (interactive)
    (org-todo "STRT")
    (org-clock-in))

  (defun my-org-started-with-pomodoro ()
    (interactive)
    (org-todo "STRT")
    (org-pomodoro))

  (defun my-org-goto-clock-and-start-pomodoro ()
    (interactive)
    (org-clock-goto)
    (org-todo "STRT")
    (org-pomodoro))

  (defun my-org-started-no-clock ()
    (interactive)
    (org-todo "STRT"))

  (defun my-org-todo-done ()
    (interactive)
    (org-todo "DONE"))

  (defun my-org-todo-done-pomodoro ()
    (interactive)
    (org-todo "DONE")
    (org-pomodoro))

  (defun my-org-todo ()
    (interactive)
    (org-todo "TODO")
    (org-clock-out))

  (defun my-org-agenda ()
    (interactive)
    (org-agenda t "a"))

  (defun my-org-todos-agenda ()
    (interactive)
    (org-agenda t "T"))

  (defun org-today-agenda ()
    (interactive)
    (let ((current-prefix-arg 1)
          (org-deadline-warning-days 0))
      (org-agenda t "a")))

  (defun org-1-day-agenda ()
    (interactive)
    (let ((current-prefix-arg 1)
          (org-deadline-warning-days -1))
      (org-agenda t "a")))

  (defun org-2-days-agenda ()
    (interactive)
    (let ((current-prefix-arg 2)
          (org-deadline-warning-days 0))
      (org-agenda t "a")))

  (defun org-3-days-agenda ()
    (interactive)
    (let ((current-prefix-arg 3)
          (org-deadline-warning-days 0))
      (org-agenda t "a")))

  (defun org-4-days-agenda ()
    (interactive)
    (let ((current-prefix-arg 4)
          (org-deadline-warning-days 0))
      (org-agenda t "a")))

  (defun org-5-days-agenda ()
    (interactive)
    (let ((current-prefix-arg 5)
          (org-deadline-warning-days 0))
      (org-agenda t "a")))

  (defun org-6-days-agenda ()
    (interactive)
    (let ((current-prefix-arg 6)
          (org-deadline-warning-days 0))
      (org-agenda t "a")))

  (defun org-7-days-agenda ()
    (interactive)
    (let ((current-prefix-arg 7)
          (org-deadline-warning-days 0))
      (org-agenda t "a")))

  (defun org-30-days-agenda ()
    (interactive)
    (let ((current-prefix-arg 30)
          (org-deadline-warning-days 0))
      (org-agenda t "a")))

  ;; "TODO(t)" "STRT(s)" "|" "DONE(d)"
  ;; MAKES SOURCE BUFFER NAMES NICER ;;
  (defun org-src--construct-edit-buffer-name (org-buffer-name lang)
    (concat "[S] "org-buffer-name""))

  ;; https://emacs.stackexchange.com/a/32039
  (defun org-toggle-tag-visibility (state)
    "Run in `org-cycle-hook'."
    (interactive)
    (message "%s" state)
    (cond
     ;; global cycling
     ((memq state '(overview contents showall))
      (org-map-entries
       (lambda ()
         (let ((tagstring (nth 5 (org-heading-components)))
               start end)
           (when tagstring
             (save-excursion
               (beginning-of-line)
               (re-search-forward tagstring)
               (setq start (match-beginning 0)
                     end (match-end 0)))
             (cond
              ((memq state '(overview contents))
               (outline-flag-region start end t))
              (t
               (outline-flag-region start end nil))))))))
     ;; local cycling
     ((memq state '(folded children subtree))
      (save-restriction
        (org-narrow-to-subtree)
        (org-map-entries
         (lambda ()
           (let ((tagstring (nth 5 (org-heading-components)))
                 start end)
             (when tagstring
               (save-excursion
                 (beginning-of-line)
                 (re-search-forward tagstring)
                 (setq start (match-beginning 0)
                       end (match-end 0)))
               (cond
                ((memq state '(folded children))
                 (outline-flag-region start end t))
                (t
                 (outline-flag-region start end nil)))))))))))

  ;; REMOVE LINK
  ;; https://emacs.stackexchange.com/a/21945
  (defun my-org-remove-link  ()
    "Replace an org link by its description or if empty its address"
    (interactive)
    (if (org-in-regexp org-bracket-link-regexp 1)
        (save-excursion
          (let ((remove (list (match-beginning 0) (match-end 0)))
                (description (if (match-end 3)
                                 (match-string-no-properties 3)
                               (match-string-no-properties 1))))
            (apply 'delete-region remove)
            (insert description)))))

  ;; (setq org-agenda-files '("~/org/agenda.org"))
  (setq org-agenda-files '("~/org/Agenda"))

  ;; ORG FONTIFICATION AND SRC BLOCKS ;;
  (setq org-fontify-done-headline t
        org-src-fontify-natively t
        org-odt-fontify-srcblocks t
        org-src-tab-acts-natively t
        org-fontify-whole-heading-line nil
        org-fontify-quote-and-verse-blocks nil)

  (setq org-indent-mode nil
        org-clock-persist t
        org-tags-column -77
        org-clock-in-resume t
        org-pretty-entities t
        org-log-into-drawer t
        org-lowest-priority 73
        org-startup-indented t
        org-clock-into-drawer t
        org-default-priority 65
        org-export-with-toc nil
        org-cycle-level-faces t
        org-export-with-tags nil
        org-use-speed-commands t
        require-final-newline nil
        org-return-follows-link t
        org-image-actual-width nil
        org-agenda-tags-column -80
        org-id-link-to-org-use-id t
        org-clock-history-length 10
        org-clock-update-period 240
        org-footnote-auto-adjust 't
        org-export-preserve-breaks t
        org-hide-emphasis-markers t
        org-replace-disputed-keys t
        org-timer-display 'mode-line
        org-deadline-warning-days 14
        org-agenda-show-all-dates nil
        calendar-date-style 'european
        org-export-html-postamble nil
        mode-require-final-newline nil
        org-export-with-broken-links t
        org-export-time-stamp-file nil
        org-src-preserve-indentation t
        org-confirm-babel-evaluate nil
        org-clock-mode-line-total 'auto
        org-agenda-hide-tags-regexp "."
        org-agenda-show-outline-path nil
        org-export-with-todo-keywords nil
        org-show-notification-handler nil
        org-refile-use-outline-path 'file
        org-link-file-path-type 'relative
        org-clock-persist-query-resume t
        org-agenda-skip-archived-trees nil
        org-edit-src-content-indentation 1
        org-export-with-archived-trees nil
        org-agenda-skip-deadline-if-done t
        org-agenda-skip-timestamp-if-done t
        org-agenda-skip-scheduled-if-done t
        org-clock-auto-clock-resolution nil
        org-edit-src-persistent-message nil
        org-edit-src-auto-save-idle-delay 1
        org-src-window-setup 'current-window
        org-clock-sound "~/Sounds/cuckoo.au"
        org-agenda-show-future-repeats 'next
        org-agenda-skip-unavailable-files 't
        org-babel-no-eval-on-ctrl-c-ctrl-c t
        org-src-window-setup 'current-window
        org-outline-path-complete-in-steps nil
        org-clock-out-remove-zero-time-clocks t
        org-clock-report-include-clocking-task t
        org-clock-clocked-in-display nil
        org-allow-promoting-top-level-subtree nil
        org-enforce-todo-checkbox-dependencies t
        org-refile-allow-creating-parent-nodes nil
        org-src-ask-before-returning-to-edit-buffer nil
        org-agenda-skip-timestamp-if-deadline-is-shown t
        org-pretty-entities-include-sub-superscripts nil
        org-agenda-skip-additional-timestamps-same-entry 't)

  (setq org-ellipsis ".")
  (setq org-timer-format "%s ")
  (setq-default org-export-html-postamble nil)
  (setq org-refile-targets '((projectile-project-buffers :maxlevel . 3)))
  (setq org-blank-before-new-entry '((heading . nil) (plain-list-item . nil)))
  (setq org-global-properties
        '(("Effort_ALL" .
           "00:04 00:08 00:12 00:16 00:20 00:24 00:28")))
  (setq org-html-htmlize-output-type 'css)

  ;; (setq org-modules '(ol-w3m ol-bbdb ol-bibtex ol-docview ol-gnus ol-info ol-irc ol-mhe ol-rmail ol-eww ol-habit))
  ;; (setq org-modules '(ol-w3m ol-bbdb ol-bibtex ol-docview ol-gnus ol-info ol-irc ol-mhe ol-rmail ol-eww))

  (setq org-babel-temporary-directory (concat user-emacs-directory "babel-temp"))

  (setq org-archive-location ".%s::datetree/")
  (setq org-drawers (quote ("PROPERTIES" "LOGBOOK"))) ;; Separate drawers for clocking and logs
  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 1.3))

  (setq org-todo-keywords
        '((sequence "TODO(t!)" "STRT(s!)" "|" "DONE(d!)")))

  (setq org-file-apps (quote ((auto-mode . emacs)
                              ("\\.mm\\'" . default)
                              ("\\.x?html?\\'" . default)
                              ("\\.jpg\\'" . "viewnior %s")
                              ("\\.mp4\\'" . "vlc %s")
                              ("\\.webm\\'" . "vlc %s")
                              ("\\.pdf\\'" . "zathura %s")
                              ("\\.epub\\'" . "ebook-viewer %s")
                              ;; ("\\.pdf\\'" . "org-pdfview-open %s")
                              )))
  (add-to-list 'org-src-lang-modes '("i3" . i3wm-config))

  ;; CAPTURE TEMPLATES ;;
  (setq org-capture-templates
        '(("a" "Agenda" entry
           (file+headline
            "~/org/Agenda/agenda.org" "Tasks")
           "* TODO %i%^{1|Title}\nDEADLINE: \%^t\n%^{2}" :immediate-finish t)

          ("t" "Tech" entry
           (file+headline "~/org/Agenda/agenda.org" "Tech")
           "* TODO %i%^{1|Title}\n\%u\n%^{2}"
           :immediate-finish t)

          ("e" "Emacs" entry
           (file+headline
            "~/org/Agenda/agenda.org" "Emacs")
           "* TODO %i%^{1|Title}\n\%u\n%^{2}" :immediate-finish t)

          ))

  ;; https://emacs.stackexchange.com/a/41685
  ;; Requires org-plus-contrib (above)
  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines)))

(use-package org-bullets
  :after org
  :config
  (setq org-bullets-bullet-list (quote ("◐" "◑" "◒" "◓" "☉" "◉"))))

(use-package toc-org
  :defer t
  :config
  (setq toc-org-max-depth 5))

(use-package ox-epub
  :after org
  :ensure t)

(use-package org2blog
  :disabled
  :config

  (setq org2blog/wp-show-post-in-browser 'show)

  (setq org2blog/wp-blog-alist
        '(("daviramos-en"
           :url "http://daviramos.com/en/xmlrpc.php"
           :username "daviramos"
           :default-title "Hello World"
           :default-categories ("sci-fi")
           :tags-as-categories nil)
          ("daviramos-br"
           :url "http://daviramos.com/br/xmlrpc.php"
           :username "daviramos"
           :default-title "Hello World"
           :default-categories ("sci-fi")
           :tags-as-categories nil))))

(use-package org-pdfview
  :after org)

(use-package org-pomodoro
  :after org
  :init
  ;; (add-hook 'org-pomodoro-finished-hook 'org-clock-goto)
  ;; (add-hook 'org-pomodoro-long-break-finished-hook 'org-clock-goto)
  ;; (add-hook 'org-pomodoro-short-break-finished-hook 'org-clock-goto)
  :config
  (setq org-pomodoro-length 25
        org-pomodoro-long-break-length 20
        org-pomodoro-short-break-length 8
        org-pomodoro-long-break-frequency 4
        org-pomodoro-ask-upon-killing t
        org-pomodoro-manual-break 't
        org-pomodoro-keep-killed-pomodoro-time nil
        org-pomodoro-time-format "%.2m"
        org-pomodoro-short-break-format "SHORT: %s"
        org-pomodoro-long-break-format "LONG: %s"
        org-pomodoro-format "P: %s"))

(straight-use-package '(apheleia :host github :repo "raxod502/apheleia"))
(setq apheleia-formatters '((black "black" "-") (brittany "brittany" file) (prettier npx "prettier" file) (gofmt "gofmt") (terraform "terraform" "fmt" "-")))
;; (apheleia-global-mode +1)

(use-package yequake)

(use-package w3m
  :defer t)

(use-package better-defaults
  :config
  (setq visible-bell nil))

(use-package auto-package-update
  :config
  (setq auto-package-update-interval 14
        auto-package-update-delete-old-versions t
        auto-package-update-hide-results t
        auto-package-update-prompt-before-update t)
  ;; (auto-package-update-maybe)
  )

(define-derived-mode scratch-mode
  text-mode "scratch")

(general-unbind 'scratch-mode-map
  :with 'evil-ex-nohighlight
  [remap my-save-buffer]
  [remap save-buffer])

(use-package restart-emacs
  :config
  (setq restart-emacs-restore-frames nil))

(use-package recursive-narrow)

(use-package no-littering)

(use-package saveplace
  :init
  (setq save-place-file (concat udir "var/save-place.el"))
  :config
  (setq save-place-limit 50)
  (save-place-mode 1))

(use-package benchmark-init
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

(use-package beacon
  ;; :if window-system
  :init (add-hook 'beacon-dont-blink-predicates
                  (lambda () (bound-and-true-p centered-cursor-mode)))
  :config
  (setq beacon-dont-blink-commands '(next-line
                                     org-edit-special
                                     org-edit-src-exit
                                     evil-forward-word-begin
                                     evil-backward-word-begin
                                     beginning-of-visual-line
                                     evil-goto-first-line
                                     evil-goto-line
                                     evil-end-of-visual-line
                                     end-of-visual-line
                                     evil-indent
                                     previous-line
                                     forward-line
                                     find-packs
                                     find-keys
                                     find-misc
                                     helpful-at-point
                                     quit-window
                                     find-functions
                                     find-macros
                                     evil-scroll-page-up
                                     evil-scroll-page-down
                                     find-hydras
                                     find-file
                                     counsel-find-file
                                     scroll-up-command
                                     scroll-down-command
                                     last-buffer))
  (setq beacon-size 30
        beacon-blink-delay 0.1
        beacon-blink-duration 0.06
        beacon-blink-when-focused nil
        beacon-blink-when-window-scrolls t
        beacon-blink-when-window-changes t
        beacon-blink-when-point-moves-vertically nil
        beacon-blink-when-point-moves-horizontally nil)
  (beacon-mode +1))

(use-package unkillable-scratch
  :config
  (setq unkillable-scratch-behavior 'bury
        unkillable-buffers '("^\\*scratch\\*$"
                             "^init.org$"
                             "^agenda.org$"
                             "^pytasks.org$"
                             "^pynotes.org$"
                             "*Racket REPL*"

                             ))

  ;; http://bit.ly/332kLj9
  (defun my-create-scratch-buffer nil
    (interactive)
    (switch-to-buffer (get-buffer-create "*scratch*"))
    (lisp-interaction-mode))

  (unkillable-scratch))

(use-package undo-tree
  :config
  (global-undo-tree-mode -1)
  (undo-tree-mode -1))

(use-package undo-fu
  :defer 5)

(use-package undo-fu-session
  :config
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  (global-undo-fu-session-mode))

(use-package vlf
  :disabled
  :ensure t
  :init
  (add-hook 'vlf-mode-hook 'my-vlf-hooks)
  :config

  (setq vlf-save-in-place t)

  (defun my-vlf-hooks ()
    (interactive)
    (font-lock-mode -1)
    (setq-local super-save-mode nil))

  (setq vlf-tune-enabled nil
        vlf-application 'dont-ask)

  (require 'vlf-setup))

(use-package sudo-edit
  :defer t
  :ensure t)

(use-package caps-lock
  :defer t
  :bind (("C-c c" . caps-lock-mode)))

(use-package elmacro
  ;; :if window-system
  :defer t
  :config
  (elmacro-mode +1))

(use-package helpful
  :defer 5
  :init
  (add-hook 'helpful-mode-hook 'my-helpful-hooks)
  :config
  (setq helpful-max-buffers 2)

  (defun my-helpful-hooks ()
    (interactive)
    (hl-line-mode +1))

  ;; https://stackoverflow.com/a/10931190
  (defun my-kill-help-buffers ()
    (interactive)
    (helpful-kill-buffers)
    (cl-flet ((kill-buffer-ask (buffer) (kill-buffer buffer)))
      (kill-matching-buffers "*Help*")))

  ;; https://stackoverflow.com/a/10931190
  (defun my-kill-matching-buffers (regexp)
    "Kill buffers matching REGEXP without asking for confirmation."
    (interactive "sKill buffers matching this regex: ")
    (cl-flet ((kill-buffer-ask (buffer) (kill-buffer buffer)))
      (kill-matching-buffers regexp)))

  (general-nvmap
    :keymaps 'helpful-mode-map
    "q" 'quit-window
    "C-r" 'helpful-update
    "gr" 'sel-to-end)

  (general-nmap
    :keymaps 'helpful-mode-map
    ;; "<escape>" 'evil-ex-nohighlight
    "<escape>" 'quit-window)

  (general-define-key
   :keymaps 'helpful-mode-map
   "q" 'quit-window
   "<tab>"     'forward-button
   "<backtab>" 'backward-button
   "C-r" 'helpful-update
   "M-p" 'my-paragraph-backwards
   "M-n" 'my-paragraph-forward)

  )

(use-package shut-up
  :disabled)

(use-package bug-hunter
  :defer t)

;; (setq auto-capitalize-ask nil)
;; (autoload 'auto-capitalize-mode "auto-capitalize" "Toggle `auto-capitalize' minor mode in this buffer." t)
;; (autoload 'turn-on-auto-capitalize-mode "auto-capitalize"
;;   "Turn on `auto-capitalize' minor mode in this buffer." t)
;; (autoload 'enable-auto-capitalize-mode "auto-capitalize" "Enable `auto-capitalize' minor mode in this buffer." t)

(use-package helm
  ;; :disabled
  :init
  (add-hook 'helm-occur-mode-hook 'previous-history-element)
  :config
  (setq helm-split-window-default-side 'same
        helm-full-frame t)
  ;; (helm-autoresize-mode +1)

  (general-define-key
   :keymaps   'helm-map
   "<insert>" 'yank
   "C-s"      'previous-history-element
   "C-w"      'backward-kill-word))

(use-package helm-org
  ;; :after helm org
  :disabled
  :config

  (defun my/helm-org-in-buffer-headings ()
    (interactive)
    (widen)
    (helm-org-in-buffer-headings)
    (org-narrow-to-subtree)))

(use-package helm-org-rifle
  ;; :after helm org
  :disabled)

(use-package helm-swoop
  :after helm
  :config
  (general-define-key
   :keymaps  'helm-swoop-map
   "C-c i"     'helm-swoop-yank-thing-at-point
   "C-w"     'backward-kill-word))

(use-package ivy
  :defer 5
  :init
  (add-hook 'ivy-occur-mode-hook 'hl-line-mode)

  (setq ivy-ignore-buffers '(".*elc"
                             "^#.*#$"
                             "^\\*.*\\*"
                             "archive.org$"
                             "^init.org$"
                             "^agenda.org$"
                             "*slime-repl sbcl"
                             "magit"
                             "*org-src-fontification.\\*"))
  :config
  (setq counsel-describe-function-function #'helpful-callable)
  (setq counsel-describe-variable-function #'helpful-variable)

  (ivy-set-actions
   'counsel-M-x
   `(("d" counsel--find-symbol "definition")
     ("h" ,(lambda (x) (helpful-callable (intern x))) "help")))

  (defun my-enable-ivy-counsel ()
    (interactive)
    (ivy-mode +1)
    (counsel-mode +1)
    (message " ivy on"))

  (defun my-disable-ivy-counsel ()
    (interactive)
    (ivy-mode -1)
    (counsel-mode -1)
    (message " ivy off"))

  (defun ivy-with-thing-at-point (cmd)
    (let ((ivy-initial-inputs-alist
           (list
            (cons cmd (thing-at-point 'symbol)))))
      (funcall cmd)))

  (defun counsel-ag-thing-at-point ()
    (interactive)
    (ivy-with-thing-at-point 'counsel-ag))

  (defun counsel-projectile-ag-thing-at-point ()
    (interactive)
    (ivy-with-thing-at-point 'counsel-projectile-ag))

  (setq ivy-wrap t)
  (setq ivy-on-del-error-function #'ignore)

  ;; from https://stackoverflow.com/a/36165680
  (setq counsel-ag-base-command "ag --filename --nocolor --nogroup --smart-case --skip-vcs-ignores --silent --ignore '*.html' --ignore '*.el' --ignore '*.elc' %s")

  (setq ivy-use-virtual-buffers nil)
  (setq ivy-count-format "(%d/%d) ")
  (setq counsel-bookmark-avoid-dired t)
  (setq counsel-find-file-at-point t)
  (setq counsel-outline-display-style 'title)
  (setq counsel-find-file-ignore-regexp (regexp-opt '( "log")))
  (setq counsel-find-file-ignore-regexp nil)
  (setq ivy-extra-directories nil)
  (ivy-mode 1)

          ;;;; KEYBINDINGS ;;;;

  (general-unbind 'ivy-occur-mode-map
    :with 'evil-ex-nohighlight
    [remap my-quiet-save-buffer])

  (general-unbind 'ivy-minibuffer-map
    :with 'ignore
    [remap windmove-up]
    [remap windmove-left]
    [remap windmove-right])

  ;; (general-unbind 'ivy-minibuffer-map
  ;;   :with 'ivy-kill-ring-save
  ;;   [remap eyebrowse-next-window-config])

  (general-unbind 'ivy-minibuffer-map
    :with 'ivy-alt-done
    [remap windmove-down])

  (general-unbind 'ivy-minibuffer-map
    :with 'ivy-next-line
    [remap counsel-projectile-switch-to-buffer]
    [remap ivy-switch-buffer]
    [remap transpose-chars]
    [remap transpose-words]
    [remap counsel-bookmark])

  (general-unbind 'ivy-minibuffer-map
    :with 'ivy-next-line
    [remap counsel-projectile-switch-to-buffer])

  (general-define-key
   :keymaps 'ivy-minibuffer-map
   "C-," 'ivy-next-line
   "C-c ," nil
   "<insert>" 'clipboard-yank
   "C-j" 'ivy-immediate-done
   "<C-return>" 'ivy-immediate-done
   ;; "<C-return>" 'ivy-alt-done
   "C-h" 'ivy-backward-delete-char
   "TAB" 'ivy-alt-done
   "C-c -" 'my-ivy-done-and-narrow
   "M-m" 'ivy-done
   "C-m" 'ivy-done
   "C-c o" 'ivy-kill-ring-save
   "<escape>" 'abort-recursive-edit
   "C-0" 'my-ivy-done-trim-color
   "M-r" 'ivy-next-line
   "C--" 'ivy-next-line
   "C-=" 'ivy-previous-line
   "M-d" 'ivy-next-line
   "C-t" 'ivy-next-line
   "M-u" 'ivy-previous-line
   "C-w" 'ivy-backward-kill-word
   "C-u" 'my-backward-kill-line
   "<XF86Calculator>" 'abort-recursive-edit)

  (general-define-key
   :states '(normal visual)
   :keymaps 'ivy-mode-map
   "M-u" 'ivy-yasnippet)

  (general-nvmap
    :keymaps 'override
    "M-t" 'counsel-projectile-switch-to-buffer)

  (ivy-mode +1))

(use-package ivy-hydra
  :after hydra)

(use-package counsel
  :defer 5
  :config

  (general-define-key
   :keymaps 'counsel-mode-map
   "C-c b" 'counsel-bookmark
   ;; "C-7" 'counsel-bookmark
   "M-y" 'my-yank-pop)

  (defun my-counsel-ag-python ()
    (interactive)
    (counsel-ag nil "~/Python/code"))

  (defun my-yank-pop ()
    (interactive)
    ;; (evil-insert-state)
    (counsel-yank-pop))

  (defun my-benchmark-init-commands ()
    (interactive)
    (counsel-M-x "^benchmark-init/"))

  (ivy-set-actions
   'counsel-colors-emacs
   '(("h" counsel-colors-action-insert-hex "insert hex")
     ("H" counsel-colors-action-kill-hex "kill hex")
     ("t" my-counsel-colors-action-insert-hex-and-trim "insert trimmed hex")
     ("c" my-counsel-colors-action-insert-hex-in-css "insert in css")))

  (ivy-set-actions
   'counsel-colors-web
   '(("h" counsel-colors-action-insert-hex "insert hex")
     ("H" counsel-colors-action-kill-hex "kill hex")
     ("t" my-counsel-colors-action-insert-hex-and-trim "insert trimmed hex")
     ("c" my-counsel-colors-action-insert-hex-in-css "insert in css")))

  (defun my-counsel-colors-action-insert-hex-and-trim (color)
    (insert (get-text-property 0 'hex color))
    (end-of-line)
    (delete-char 6)
    (upcase-word -1))

  (defun my-counsel-colors-action-insert-hex-in-css (color)
    (just-one-space)
    (insert (get-text-property 0 'hex color))
    (end-of-line)
    (delete-char 6)
    (upcase-word -1)
    (insert ";")
    (backward-char 1)
    (evil-normal-state))

  (counsel-mode 1))

(use-package engine-mode
  ;; :if window-system
  :config
  (defun engine/search-prompt (engine-name default-word)
    (if (string= default-word "")
        (format "Search %s: " (capitalize engine-name))
      (format "Search %s (%s): " (capitalize engine-name) default-word)))

  (defadvice browse-url (after browse-url-after activate) (my-focus-chrome-delayed))
  ;; (advice-remove 'browse-url 'my-focus-chrome-delayed)

  (defengine Google
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s")

  (defengine Python-3
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q=Python 3 %s")

  ;; (defengine Python-3-docs
  ;;   "http://www.google.com/search?ie=utf-8&oe=utf-8&q=Python 3.8 documentation %s")

  (defengine Python-3-docs
    "https://docs.python.org/3/search.html?q= %s")

  (defengine google-bootstrap
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q=bootstrap 4 %s")

  (defengine google-flexbox
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q=flexbox %s")

  (defengine google-css
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q=css %s")

  (defengine google-css-grid
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q=css grid %s")

  (defengine devdocs-io
    "https://devdocs.io/#q=%s")
  (defengine emacs-wiki
    "https://duckduckgo.com/?q=%s site:emacswiki.org")
  (defengine github
    "https://github.com/search?ref=simplesearch&q=%s")
  (defengine stack-overflow
    "https://stackoverflow.com/search?q=%s")
  (defengine reddit
    "https://old.reddit.com/search?q=%s")

  (defengine dic-informal
    "https://www.dicionarioinformal.com.br/sinonimos/%s")

  (defun my-engine-search-dic-informal ()
    (interactive)
    (engine/search-dic-informal (current-word)))

  (defengine michaelis
    "https://michaelis.uol.com.br/moderno-portugues/busca/portugues-brasileiro/%s")

  (defun my-engine-search-michaealis ()
    (interactive)
    (engine/search-michaelis (current-word)))

  (defengine rhymezone
    "https://www.rhymezone.com/r/rhyme.cgi?Word=%s&typeofrhyme=adv&loc=advlink")

  (defengine wiki-en
    "https://en.wikipedia.org/wiki/%s")
  (defengine wiki-pt
    "https://pt.wikipedia.org/wiki/%s")
  (defengine plato
    "https://plato.stanford.edu/search/searcher.py?query=%s")
  (defengine translate
    "https://translate.google.com/?source=osdd#view=home&op=translate&sl=auto&tl=pt&text=%s")

  (defengine urban-dictionary
    "https://www.urbandictionary.com/define.php?term=%s")

  (defun my-engine-urban-dict ()
    (interactive)
    (engine/search-urban-dictionary (current-word)))

  (defengine the-free-dictionary
    "https://www.thefreedictionary.com/%s")

  (defengine MDN
    "https://developer.mozilla.org/en-US/search?q=%s")
  (engine-mode t))

(use-package google-translate
  :defer t
  :config
  (setq google-translate-pop-up-buffer-set-focus t
        google-translate-default-source-language "pt"
        google-translate-default-target-language "en"
        google-translate-translation-directions-alist
        '(("pt" . "en") ("en" . "pt"))))

(use-package hydra
  :config

  (general-define-key
   :keymaps 'override
   "C-c ," 'hydra-yasnippet/body
   "<f1>" 'hydra-help/body)

  (general-unbind 'hydra-base-map
    "0" "1" "2" "3" "4" "5" "6" "7" "8" "9")

  (setq hydra-amaranth-warn-message " *amaranth hydra*"))

(defhydra hydra-python-mode (:color blue :hint nil :foreign-keys run)
  "
    ^
    ^Python^
    ^^^^^-------------------------------------------
    _r_: run term    _c_: copy eror  _B_: pdb
    _s_: quickshell  _d_: goto def   _a_: scratch
    _P_: prev error  _b_: go back    _o_: doc
    _n_: next error  _D_: docs       _RET_: flycheck

"

  ("<escape>" nil)
  ("q" nil)

  ("r" my-run-on-terminal)
  ("s" quickrun-shell)
  ("P" flymake-goto-prev-error)
  ("n" flymake-goto-next-error)

  ("c" flycheck-copy-errors-as-kill)

  ("d" elpy-goto-definition)
  ("b" pop-tag-mark)
  ("<C-return>" dumb-jump-back)

  ("g" engine/search-python-3)
  ("D" engine/search-python-3-docs)
  ("B" my-pdb)
  ("a" my-goto-python-scratch)
  ("o" elpy-doc)
  ("RET" hydra-flycheck-mode/body)

  )

(defhydra hydra-racket-mode (:color blue :hint nil :foreign-keys run)
  "
    ^
    ^Racket^
    ^^^--------------------------
    _d_...doc       _g_..goto def
    _e_...describe  _m_..goto module
    _s_...send sexp _b_..go back
    _RET_.eval sexp _r_..quickrun

"
  ("<escape>" nil)

  ("q" nil)
  ("d" racket-doc)
  ("e" racket-describe)
  ("RET" racket-eval-last-sexp)
  ("v" racket-eval-last-sexp)
  ("s" racket-send-last-sexp)
  ("g" racket-visit-definition)
  ("m" racket-visit-module)
  ("b" racket-unvisit)
  ("r" quickrun))

(defhydra hydra-prog-mode (:color blue :hint nil :foreign-keys run)
  "
^
    ^Flycheck^        ^Others^
    ^^^---------------------------------
    _f_: first error  _m_: flycheck mode
    _p_: prev  error  _k_: flymake prev
    _n_: next  error  _j_: flymake next
    _c_: copy  error  _q_: quickrun

"
  ("<escape>" nil)

  ("f" flycheck-first-error)
  ("j" flymake-goto-prev-error)
  ("k" flymake-goto-next-error)

  ("n" flycheck-next-error)
  ("p" flycheck-previous-error)
  ("c" flycheck-copy-errors-as-kill)
  ("m" flycheck-mode)
  ("q" quickrun)
  ("RET" quickrun))

(defhydra hydra-flycheck-mode (:color blue :hint nil :foreign-keys run)
  "
^
    ^Flycheck^
    ^^^--------------------------------------
    _a_: check buffer    _e_: error at point
    _b_: first error     _f_: clear errors
    _c_: previous error  _h_: flycheck mode

"
  ("q" nil)
  ("<escape>" nil)
  ("M-m" nil)
  ("RET" flycheck-list-errors)

  ("a" flycheck-buffer)
  ("b" flycheck-first-error)
  ("c" flycheck-previous-error)
  ("d" flycheck-next-error)
  ("e" flycheck-display-error-at-point)
  ("f" flycheck-clear)
  ("h" flycheck-mode))

(defhydra hydra-prog-modes (:color blue :hint nil :foreign-keys run)
  "
^
    ^Prog Modes^
    -----------
    _c_: company
    _s_: smparens
    _t_: tab jump
    _e_: operator
    _r_: rainbow "

  ("<escape>" nil)
  ("<C-return>" nil)
  ("RET" nil)

  ("m" flycheck-mode)
  ("c" company-mode)
  ("s" smartparens-mode)
  ("t" tab-jump-out-mode)
  ("e" electric-operator-mode)
  ("r" rainbow-delimiters-mode))

(defhydra hydra-yasnippet (:color blue :hint nil :exit nil :foreign-keys nil)
  "
^
    ^YASnippet^
    ^^^^^^^^--------------------------------
    _;_: load  _r_: reload all  _q_: quit
    _n_: new   _v_: visit       _k_: kill
                            ^^^^_c_: commit

"

  (";" my-yas-load-other-window)
  ("M-;" my-yas-load-other-window)

  ("v" yas-visit-snippet-file)
  ("M-v" yas-visit-snippet-file)

  ("n" yas-new-snippet)
  ("M-n" yas-new-snippet)

  ("r" yas-reload-all)
  ("M-r" yas-reload-all)

  ("q" quit-window)
  ("M-q" quit-window)

  ("k" kill-buffer-and-window)
  ("c" yas-load-snippet-buffer-and-close))

;; (defhydra hydra-shell (:color blue :hint nil :exit nil :foreign-keys nil)
;;   "
;; ^
;; ^Shells^
;; ----------------------------
;; _s_: small     _p_: python shell
;; _j_: bellow    _a_: python async
;; _h_: far left
;; _l_: far right
;; _k_: far top
;; "

;;   ("<escape>" nil)
;;   (";" kill-buffer-and-window)
;;   ("s" my-shell-botright)
;;   ("j" my-shell-bellow)
;;   ("h" my-shell-far-left)
;;   ("l" my-shell-far-right)
;;   ("k" my-shell-very-top)
;;   ("p" my-python-botright)
;;   ("a" my-execute-python-program-shell))

(defhydra hydra-projectile-mode (:color blue :hint nil :foreign-keys run)
  "

  Projectile
  ^^^^^----------------------------------------------------
  _a_: ag             _f_: file dwin    _k_: kill buffers
  _g_: ag at point    _i_: file         _p_: switch project
  _c_: counsel proj.  _d_: file in dir  _b_: switch buffer

"
  ("q" nil)
  ("<escape>" nil)

  ("a" counsel-projectile-ag)
  ("g" counsel-ag-thing-at-point)
  ("c" counsel-projectile)

  ("f" counsel-projectile-find-file-dwim)
  ("i" counsel-projectile-find-file)
  ("d" projectile-find-file-in-directory)

  ("k" projectile-kill-buffers)
  ("p" counsel-projectile-switch-project)
  ("b" counsel-projectile-switch-to-buffer)
  ("." counsel-org-capture))

(defhydra hydra-tangle (:color blue :hint nil :exit nil :foreign-keys nil)
  "
    ^Tangle^
    --------------------------
    _l_: tangle only
    _d_: tangle and debug
    _o_: tangle and load
    _s_: tangle, load and show
    _f_: tangle default
    _r_: tangle and restart

"

  ("l" my-tangle-py-init.org-only)
  ("d" my-tangle-py-init.org-and-debug)
  ("o" my-tangle-py-init.org-and-load)
  ("s" my-tangle-py-init.org-load-and-show)
  ("f" org-babel-tangle)
  ("r" my-tangle-restart-emacs))

(defhydra hydra-spell (:color blue :hint nil)
  "
^
  _e_: prose en   _W_: wordnut search    _c_: dic. informal
  _b_: prose br   _w_: wordnut at point  _u_: urban dic. at point
  _n_: ispell en  _g_: google translate  _f_: free. dic.
  _r_: ispell br  _m_: michaelis         _l_: google
  _o_: flyspell   _i_: write insert      _t_: write edit

^^
"
  ("<escape>" nil)

  ("e" my-prose-english)
  ("b" my-prose-brasileiro)
  ("n" my-ispell-english)
  ("r" my-ispell-brasileiro)
  ("o" flyspell-mode)

  ("W" wordnut-search)
  ("w" wordnut-lookup-current-word)

  ("g" google-translate-smooth-translate)

  ("m" my-engine-search-michaealis)
  ("M" engine/search-michaelis)

  ("c" my-engine-search-dic-informal)
  ("C" engine/search-dic-informal)

  ("u" my-engine-urban-dict)
  ("U" engine/search-urban-dictionary)

  ("f" engine/search-the-free-dictionary)
  ("l" engine/search-google)

  ("i" my-write-insert-mode)
  ("t" my-write-edit-mode))

(defhydra hydra-evil-swap (:color blue :hint nil)
  "
^
   _m_: swap mode           _p_: equal w/ plus
   _d_: dash w/ emdash      _8_: 8 w/ asterisk
   _e_: emdash w/ dash      _c_: colon w/ semicolon
   _u_: underscore w/ dash  _q_: double quotes w/ single
^^
"
  ("<escape>" nil)
  ("m" evil-swap-keys-mode)
  ("d"  evil-swap-keys-swap-dash-emdash)
  ("e"  evil-swap-keys-swap-emdash-dash)
  ("u"  evil-swap-keys-swap-underscore-dash)

  ("p"  evil-swap-keys-swap-equal-plus)
  ("8"  evil-swap-keys-swap-eight-asterisk)
  ("c"  evil-swap-keys-swap-colon-semicolon)
  ("q"  evil-swap-keys-swap-double-single-quotes))

(defhydra hydra-kill (:color blue :hint nil :exit nil :foreign-keys nil)
  "
^
    ^Kill^
    ---------------------------------------------------
    _a_: buffer     _d_: +all    _m_: +matching  _s_: server
    _b_: +window    _e_: +others _q_: my-quit
    _c_: +workspace _h_: +help   _g_: w.delete

"

  ("<escape>" nil)

  ("a" my-kill-this-buffer)
  ("b" kill-buffer-and-window)
  ("c" my-kill-buffer-and-workspace)
  ("d" my-kill-all-buffers)
  ("D" my-kill-all-buffers-except-treemacs)
  ("e" my-kill-other-buffers)
  ("h" my-kill-help-buffers)
  ("m" my-kill-matching-buffers)

  ("f" quit-window)
  ("q" my-quit-window)
  ("g" delete-window)
  ("s" save-buffers-kill-emacs))

(defhydra hydra-window (:color blue :hint nil :exit nil :foreign-keys nil)
  "

  ^Resize                 ^^^Split
  ^^^^^^^^^---------------------------------------------------------------------
  _h_: width+  _k_: height+  _b_: balance    _gh_: left  _gk_: up    _gb_: botright
  _l_: width-  _j_: height-  _z_: zoom mode  _gl_: righ  _gj_: down




  "
  ("<escape>" nil)
  ("RET" nil)

  ("H" my-evil-inc-width :exit nil)
  ("L" my-evil-dec-width :exit nil)
  ("J" my-evil-dec-height :exit nil)
  ("K" my-evil-inc-height :exit nil)

  ("h" my-evil-inc-width-small :exit nil)
  ("l" my-evil-dec-width-small :exit nil)
  ("j" my-evil-dec-height-small :exit nil)
  ("k" my-evil-inc-height-small :exit nil)

  ("gh" split-window-horizontally)
  ("gj" my-split-vertically)
  ("gk" split-window-below)
  ("gl" my-split-right)

  ("b" balance-windows :exit t)
  ("gb" my-evil-botright)

  ("z" zoom-mode))

(defhydra hydra-modes (:color blue :hint nil :exit nil :foreign-keys nil)
  "
^
    ^Modes^
    ^^^^^^^^^-------------------------------------------------------------------------
    _c_: company    ^_q_: elec operator   _u_: unkill. scratch  _z_: capitalize
    _o_: \" options  _s_: hl-sentence     _w_: evil swap keys   _i_: lisp interaction
    _l_: hl-line    ^_v_: visible         _k_: which-key        _f_: fundamental
    _g_: olivetti   ^_h_: hide mode-line  _t_: text

"
  ("<escape>" nil)
  ("c" #'company-mode)
  ("o" #'my-company-show-options)
  ("l" #'hl-line-mode)
  ("g" #'olivetti-mode)

  ("q" #'electric-operator-mode)
  ("s" #'hl-sentence-mode)
  ("v" #'visible-mode)
  ("h" #'hide-mode-line-mode)

  ("u" #'unkillable-scratch)
  ("w" #'hydra-evil-swap/body)
  ("k" #'which-key-mode)
  ("t" #'text-mode)
  ("z" #'auto-capitalize-mode)
  ("i" #'lisp-interaction-mode)
  ("f" #'fundamental-mode))

(defhydra hydra-eval (:color blue :hint nil :exit nil :foreign-keys nil)
  "
^
^Eval^
------------------------
_b_: region
_c_: buffer
_d_: line
_h_: l.&show
_i_: i3
_z_: NEW
_n_: next sexp

"
  ("<escape>" nil)
  ("z" my-yank-region)
  ("b" eval-region)
  ("c" my-eval-buffer)
  ("d" my-eval-line-function)
  ("h" my-eval-line-function-and-show)
  ("i" i3-reload)
  ("n" my-eval-next-sexp-macro))

(defhydra hydra-packages (:color blue :hint nil :exit nil :foreign-keys nil)
  "
    ^
    ^Packages^
    -------------------
    _l_: list
    _r_: refresh
    _d_: delete
    _e_: describe
    _i_: install
    _f_: install file

"
  ("<escape>" nil)

  ("l" package-list-packages)
  ("r" package-refresh-contents)
  ("d" package-delete)
  ("i" package-install)
  ("f" package-install-file)
  ("e" describe-package))

(defhydra hydra-commands (:color blue :hint nil :exit nil :foreign-keys nil)
  "
^
    ^Main Commands^
    ^^^^^^^^^-------------------------------------------------------------------------------------------
    _g_: copy dir         _i_: i3 reload     _a_: global abbrev  _c_: clone buffer _u_: update packages
    _f_: copy filepath    _3_: i3 restart    _m_: mode abbrev    _W_: write file
    _n_: copy filename    _e_: edit abbrevs   _d_: desktop
    _E_: lines by length  _w_: count words   _s_: check parens   _l_: load theme


"
  ("<escape>" nil)

  ("g" my-copy-dir)
  ("f" prelude-copy-file-name-to-clipboard)
  ("n" my-copy-file-only-name-to-clipboard)
  ("E" my-sort-lines-by-length)

  ("i" my-i3-reload)
  ("3" my-i3-restart)
  ("w" count-words)

  ("a" define-global-abbrev)
  ("m" define-mode-abbrev)
  ("e" edit-abbrevs)
  ("s" check-parens)
  ("c" clone-indirect-buffer-other-window)
  ("W" write-file)
  ("d" hydra-desktop/body)

  ("l" load-theme)
  ("L" disable-theme)

  ("u" auto-package-update-now))

(defhydra hydra-desktop (:color blue :hint nil :exit nil :foreign-keys nil)
  "
^
  ^Desktop^
  ^^^^------------------------------
  _r_: read   _v_: revert  _m_: mode
  _s_: save   _e_: remove
  _c_: clear  _h_: chdir

"

  ("<escape>" nil)

  ("r" desktop-read)
  ("s" desktop-save-in-desktop-dir)
  ("c" desktop-clear)
  ("v" desktop-revert)
  ("e" desktop-remove)
  ("h" desktop-change-dir)
  ("m" desktop-save-mode))

(defhydra hydra-text-main (:color blue :hint nil :exit nil :foreign-keys nil)
  "
^
  _e_: clean spaces  _l_: lorem par _v_: visible mode
  _i_: dup. par      _s_: lorem sen
  _t_: truncate      _Y_: copy line
  _d_: com & dup     _y_: move line
"

  ("<escape>" nil)

  ("e" xah-clean-whitespace)
  ("SPC" hydra-text-commands/body)
  ("i" duplicate-inner-paragraph)

  ("t" toggle-truncate-lines)

  ("l" lorem-ipsum-insert-paragraphs)
  ("s" lorem-ipsum-insert-sentences)
  ("y" avy-move-line)
  ("Y" avy-copy-line)
  ("d" my-comm-dup-line)
  ("v" visible-mode))

(defhydra hydra-text-motions (:color amaranth :hint nil :foreign-keys nil)
  "
   ^
   ^Motions^
   -------------------------
   _l_: line ↓      _w_: word →
   _L_: line ↑      _W_: word ←
   _p_: par  ↓      _c_: char →
   _P_: par  ↑      _C_: char ←
   _s_: sentence →  _x_: sexp →
   _S_: sentence ←  _X_: sexp ←

"

  ("<escape>" nil)
  ("m" nil)
  ("u" undo-tree-undo :exit t)

  ("l" cool-moves-line-forward)
  ("L" cool-moves-line-backward)

  ("p" cool-moves-paragraph-forward)
  ("P" cool-moves-paragraph-backward)

  ("w" cool-moves-word-forward)
  ("W" cool-moves-word-backwards)

  ("c" cool-moves-character-forward)
  ("C" cool-moves-character-backward)

  ("s" cool-moves-sentence-forward)
  ("S" cool-moves-sentence-backward)

  ("x" cool-moves-sexp-forward)
  ("X" cool-moves-sexp-backward))

(defhydra hydra-text-commands (:color blue :hint nil)
  "
^
    ^More Text^
    ---------------------------------------------
    _s_: setq         _m_: move line      _g_: agg fill
    _f_: hydra key    _l_: copy line      _i_: auto fill
    _a_: text adju    _z_: show fill      _p_: insert par
    _e_: enable fills _d_: disable fills
    _c_: to chrome

^^
"
  ("<escape>" nil)
  ("C-;" nil)
  ("SPC" nil)
  (";" nil)
  ("<menu>" nil)

  ("s" create-setq)
  ("f" format-hydra-binding)
  ("p" Lorem-ipsum-insert-paragraphs)
  ("m" avy-move-line)
  ("l" avy-copy-line)
  ("a" text-scale-adjust)
  ("w" copy-to-messenger)
  ("c" copy-to-chrome)
  ("g" aggressive-fill-paragraph-mode)
  ("i" auto-fill-mode)
  ("z" show-fill-column)
  ("e" my-enable-auto-agg-fill)
  ("d" my-disable-auto-agg-fill))

(defhydra hydra-search (:hint nil :color blue :exit nil :foreign-keys nil)
  "
  _s_: evil search      _p_: counsel processes
  _w_: grep or swiper   _u_: substitute
  _g_: counsel grep     _G_: google
  _o_: counsel outline  _e_: en-wikipedia
                      ^^_r_: rhymezone
"

  ("<escape>" nil nil)

  ("C-s" evil-search-forward)
  ("s" evil-search-forward)
  ("w" counsel-grep-or-swiper)
  ("g" counsel-grep)
  ("o" counsel-outline)

  ("p" counsel-list-processes)
  ("u" my-evil-substitute)
  ("G" engine/search-google)
  ("e" engine/search-wiki-en)
  ("r" engine/search-rhymezone))

(defhydra hydra-org-mode (:color blue :hint nil :exit nil :foreign-keys nil)
  "

    _a_: archive     _d_: deadline  _U_: unlink  _t_: todos     _e_: sparse tree
    _p_: goto last   _s_: schedule  _g_: tag     _c_: toc mode  _b_: bulles mode  _t_: cycle list
    _l_: store link  _u_: ins link  _i_: indent  _r_: refile    _2_: org2blog
                                                                        ^^^^^^^^^^


"

  ("<escape>" nil)

  ("a" org-archive-subtree-default)
  ("b" org-bullets-mode)
  ("p" org-capture-goto-last-stored)

  ("d" org-deadline)
  ("s" org-schedule)
  ("l" org-store-link)

  ("g" counsel-org-tag)
  ("u" org-web-tools-insert-link-for-url)
  ("U" my-org-remove-link)

  ("t" org-todo)

  ("c" toc-org-mode)
  ("i" org-indent-mode)
  ("r" org-refile)
  ("2" org2blog--hydra-main/body)
  ("e" org-sparse-tree))

(defhydra hydra-org-clock (:color blue :hint nil :exit nil :foreign-keys nil)
  "

    _i_: in    _m_: recent   _e_: set effort  ^_r_: timer
    _o_: out   _c_: cancel   _a_: change \"    _ps_: pomo strt
    _l_: last  _s_: started  _d_: done        ^_pg_: pomo goto
    _y_: show  _t_: todo     _g_: goto        ^_po_: pomo only
"

  ("q" nil)
  ("<escape>" nil)

  ("i" org-clock-in)
  ("o" org-clock-out)
  ("l" org-clock-in-last)
  ("c" org-clock-cancel)
  ("y" org-clock-display)
  ("m" org-mru-clock-in)
  ("e" org-set-effort)
  ("a" org-clock-modify-effort-estimate)
  ("s" my-org-started-with-clock)
  ("S" my-org-started-no-clock)
  ("d" my-org-todo-done)
  ("t" my-org-todo)
  ("g" org-clock-goto)
  ("r" hydra-org-timer/body)
  ("ps" my-org-started-with-pomodoro)
  ("pg" my-org-goto-clock-and-start-pomodoro)
  ("pd" my-org-todo-done-pomodoro)
  ("po" org-pomodoro))

(defhydra hydra-org-agenda (:color blue :hint nil :exit nil :foreign-keys nil)
  "

    ^Org Agenda^
    ^^^^----------------------
    _a_: agenda  _._: 30 days
    _1_: days    _l_: lock
    _2_: days    _u_: unlock
    _3_: days    _f_: goto file
    _7_: days    _o_: todos

"

  ("q" nil)
  ("<escape>" nil)

  ("a" my-org-agenda)

  ("1" org-1-day-agenda)
  ("," org-1-day-agenda)

  ("2" org-2-days-agenda)
  ("3" org-3-days-agenda)
  ("7" org-7-days-agenda)

  ("t" org-30-days-agenda)
  ("." org-30-days-agenda)

  ("o" my-org-todos-agenda)
  ("l" org-agenda-set-restriction-lock)
  ("u" org-agenda-remove-restriction-lock)
  ("f" my-goto-agenda))

(defhydra hydra-org-timer (:color blue :hint nil :exit nil :foreign-keys nil)
  "

    ^Org Timer^
    -----------------------------^^
    _e_: set timer   _r_: remaining
    _s_: start       _c_: change
    _t_: stop        _i_: insert
    _p_: play/pause  _d_: \" desc.

"

  ("q" nil)
  ("<escape>" nil)

  ("e" org-timer-set-timer)
  ("s" org-timer-start)
  ("t" org-timer-stop)
  ("p" org-timer-pause-or-continue)
  ("r" org-timer-show-remaining-time)
  ("c" org-timer-change-times-in-region)

  ;; insert
  ("i" org-timer)
  ("d" org-timer-item))

;; (defhydra hydra-org-todo-ballantines (:color blue :hint nil :exit nil :foreign-keys nil)
;;   "

;;     _t_: todo    _n_: next                         ^^^^|  _d_: done    _e_: remove
;;     _r_: repeat  _w_: wait                         ^^^^|  _p_: paused  _c_: cancelled
;;     _i_: idea    _m_: maybe _k_: working  _s_: staged  |  _u_: used
;; "

;;   ("q" nil)
;;   ("<escape>" nil)

;;   ("t" my-org-todo)
;;   ("i" my-org-todo-idea)
;;   ("n" my-org-todo-next)
;;   ("d" my-org-todo-done)

;;   ("r" my-org-todo-repeate)
;;   ("w" my-org-todo-wait)
;;   ("p" my-org-todo-paused)
;;   ("c" my-org-todo-cancelled)

;;   ("m" my-org-todo-maybe)
;;   ("s" my-org-todo-staged)
;;   ("k" my-org-todo-working)
;;   ("u" my-org-todo-used)
;;   ("e" my-org-remove-todo))


(defhydra hydra-info-mode (:color blue :hint nil :foreign-keys nil)
"
^
    _p_: node ←  _k_: ref ←  _u_: info ↑ _s_: search _t_: toc
    _n_: node →  _j_: ref →  _m_: menu   _g_: goto   _i_: index "

("<escape>" nil)
("q" nil)

("u" Info-up)
("p" Info-backward-node)
("n" Info-forward-node)
("t" Info-toc)
("i" Info-inde )
("g" Info-goto-node)
("s" Info-search)
("m" Info-menu)
("j" Info-next-reference)
("k" Info-prev-reference))

(defhydra hydra-help (:color blue :hint nil :exit t :foreign-keys nil)

  "

    ^^Help
    ----------------------------------------
    _f_: callable  _k_: key       _i_: info
    _v_: variable  _l_: key long
    _e_: package   _w_: where is
    _p_: at point  _a_: apropos
    _m_: major     _d_: docs
    _o_: modes     _c_: command

"

  ("<escape>" nil)
  ("C-h" helpful-variable)
  ("C-f" helpful-callable)

  ("f" helpful-callable)
  ("F" helpful-function)
  ("e" describe-package)
  ("v" helpful-variable)
  ("p" helpful-at-point)
  ("m" show-major-mode)
  ("o" describe-mode)

  ("k" describe-key-briefly)
  ("l" helpful-key)
  ("w" where-is)

  ("a" counsel-apropos)
  ("c" helpful-command)
  ("d" apropos-documentation)
  ("i" info))

(defhydra hydra-find-file (:hint nil :color blue)

  "

    ^Dotfiles                    ^^^Scratchs
    ^^^^^------------------------------------------------
    _a_: agenda      _3_: i3        _s_: *scratch*
    _b_: bash        _h_: hydra     _o_: org scratch
    _c_: config      _f_: function  _e_: el scratch
    _i_: init.org    _n_: info      _m_: md scractch
    _u_: \" outline

  "
  ("<escape>" nil)

  ("b" my-ranger-find-bashdot)
  ("c" my-ranger-find-config)

  ("I" my-goto-init.el)
  ("i" my-goto-init)
  ("u" my-goto-init-outline)


  ("a" my-goto-agenda)

  ("3" my-goto-i3-config)
  ("h" my-goto-hydra)
  ("f" my-goto-my-function)
  ("n" info)

  ("s" my-goto-scratch-buffer)
  ("o" my-goto-scratch-org)
  ("e" my-goto-scratch-elisp)
  ("m" my-goto-scratch-markdown))

;; (defhydra hydra-scratches (:hint nil :color blue)

;;   "
;;     ^Scratches
;;     ^^-----------
;;     _s_: initial
;;     _o_: org
;;     _e_: elisp
;;     _m_: markdown
;;     _p_: python

;; "
;;   ("<escape>" nil)

;;   ("s" my-goto-scratch-buffer)
;;   ("o" my-goto-scratch-org)
;;   ("e" my-goto-scratch-elisp)
;;   ("m" my-goto-scratch-markdown)
;;   ("p" my-goto-python-scratch))

(defhydra hydra-web-mode (:exit nil :hint nil :foreign-keys run)
  "

    Web Mode
    ^^^^--------------------------------------
    _b_: beautify html  _d_: dumb jump
    _c_: beautify css   _C_: search css
    _w_: colors web     _f_: search flexbox
    _e_: colors emacs
    _r_: rename
"

  ("q" nil)
  ("<escape>" nil)
  ("<return>" nil)

  ("b" my-web-beautify-html :exit t)
  ("c" web-beautify-css :exit t)

  ("w" counsel-colors-web :exit t)
  ("e" counsel-colors-emacs :exit t)

  ("f" engine/search-google-flexbox :exit t)
  ("C" engine/search-google-css :exit t)


  ("r" web-mode-element-rename :exit t)
  ("d" dumb-jump-go-prefer-external :exit t)

  ("f" flycheck-first-error)

  ("<return>" counsel-css :exit t))

(defhydra hydra-css-mode (:color blue :hint nil :exit nil :foreign-keys nil)
  "
    ^
    ^CSS^
    ^^^----------------------------
    _m_: MDN      _w_: web colors
    _g_: Grid     _o_: emacs colors
    _c_: CSS
    _i_: indent
    _b_: beautify "


  ("<escape>" nil)
  ("q" nil)

  ("m" engine/search-mdn)
  ("<return>" engine/search-mdn)
  ("g" engine/search-google-css-grid)
  ("c" engine/search-google-css)

  ("b" web-beautify-css)
  ("i" indent-buffer)

  ("w" counsel-colors-web)
  ("o" counsel-colors-emacs)
  )

(defhydra hydra-git-timemachine (:color amaranth :hint nil :foreign-keys run)
  "
    _C-p_: prev rev  _C-r_: current rev
    _C-n_: next rev  _C-l_: latest rev "

  ("C-q" git-timemachine-quit :exit t)
  ("<escape>" git-timemachine-quit :exit t)
  ("q" git-timemachine-quit :exit t)

  ("C-p" git-timemachine-show-previous-revision)
  ("C-n" git-timemachine-show-next-revision)

  ("C-r" git-timemachine-show-current-revision)
  ("C-l" git-timemachine-show-latest-revision-in-branch)

  ("C-o" olivetti-mode))

(defhydra hydra-vc-mode (:color blue :hint nil :foreign-keys run)
  "
^
    ^VC Mode^
    ---------------------------------------------
    _v_: next      _d_: diff    _t_: time
    _r_: revert    _u_: pull      _m_: merge
    _g_: register  _a_: annotate  _e_: resolve
"

  ("<escape>" nil)

  ("v" vc-next-action)
  ("r" vc-revert)
  ("g" vc-register)

  ("u" vc-pull)
  ("a" vc-annotate)

  ("d" vc-diff)
  ("m" vc-merge)
  ("e" vc-resolve-conflicts)
  ("t" hydra-git-timemachine/body))

(defhydra hydra-magit-main (:color blue :hint nil :exit nil :foreign-keys nil)
  "

    ^Magit^
    --------------------------------------------------------------------------
    _s_: stage modified    _d_: dispatch       _M_: commit dispatch  _t_: status
    _ç_: stage and commit  _f_: file dispatch  _p_: push to remote   _i_: time machine
    _c_: stage at point    _m_: create commit  _P_: push dispatch    _a_: add

"
  ("<escape>" nil)
  ("q" nil)

  ("s" magit-stage-modified)
  ("ç" my-magit-stage-modified-and-commit)
  ("c" magit-stage)

  ("d" magit-dispatch)
  ("f" magit-file-dispatch)
  ("m" magit-commit-create)

  ("M" hydra-magit-commit/body)
  ("p" magit-push-current-to-pushremote)
  ("P" magit-push)

  ("t" magit-status)
  ("i" git-timemachine)
  ("a" my-magit-stage-untracked))

(defhydra hydra-magit-commit (:color blue :hint nil :exit nil :foreign-keys nil)
"
^
    ^Magit Commit^
    -------------------------------------------------------------
    _A_: augment _F_: instant fixup   _c_: commit    _x_: absorb changes
    _a_: amend   _s_: squash          _e_: extend
    _f_: fixup   _S_: instant squash  _n_: reshelve

"
("<escape>" nil)
("q" nil)

("A" magit-commit-augment)
("a" magit-commit-amend)
("f" magit-commit-fixup)
("F" magit-commit-instant-fixup)
("s" magit-commit-squash)
("S" magit-commit-instant-squash)
("c" magit-commit-create)
("e" magit-commit-extend)
("n" magit-commit-reshelve)
("w" magit-commit-reword)
("x" magit-commit-absorb))

(defhydra hydra-magit-transient (:color blue :hint nil :exit nil :foreign-keys nil)
"
^
    ^Transient and dwim commands^
    --------------------------------------------------------------------------------
    _b_: branch  _e_: ediff  _m_: merge      _r_: rebase         _y_: show refs  _%_: worktree
    _c_: commit  _f_: fetch  _o_: submodule  _t_: tag            _z_: stash
    _d_: diff    _l_: log    _p_: push       _w_: apply patches  _!_: run
"

("<escape>" nil)
("q" nil)

("b"  magit-branch)
("c"  magit-commit)
("d"  magit-diff)
("e"  magit-ediff-dwim)

("f"  magit-fetch)
("l"  magit-log)
("m"  magit-merge)
("o"  magit-submodule)

("p"  magit-push)
("r"  magit-rebase)
("t"  magit-tag)
("w"  magit-am)

("y"  magit-show-refs)
("z"  magit-stash)
("!"  magit-run)
("%"  magit-worktree))

(defhydra hydra-text-motions (:color amaranth :hint nil :foreign-keys nil)
  "
    ^
        ^Motions^
        -------------------------
        _l_: line ↓      _w_: word →
        _L_: line ↑      _W_: word ←
        _p_: par  ↓      _c_: char →
        _P_: par  ↑      _C_: char ←
        _s_: sentence →  _x_: sexp →
        _S_: sentence ←  _X_: sexp ←

    "

  ("<escape>" nil)
  ("u" nil)

  ("l" cool-moves-line-forward)
  ("L" cool-moves-line-backward)

  ("p" cool-moves-paragraph-forward)
  ("P" cool-moves-paragraph-backward)

  ("w" cool-moves-word-forward)
  ("W" cool-moves-word-backwards)

  ("c" cool-moves-character-forward)
  ("C" cool-moves-character-backward)

  ("s" cool-moves-sentence-forward)
  ("S" cool-moves-sentence-backward)

  ("x" cool-moves-sexp-forward)
  ("X" cool-moves-sexp-backward))

(use-package hercules
  :disabled
  :config

  (hercules-def
   :toggle-funs #'org-babel-mode
   :keymap 'org-babel-map
   :transient t)

  (general-define-key
   :keymaps 'org-mode-map
   :states '(normal visual insert)
   "C-x C-v" #'org-babel-mode)

  (hercules-def
   :toggle-funs #'racket
   :keymap 'racket-mode-map
   :transient t)

  (general-define-key
   :keymaps 'racket-mode-map
   :states '(normal visual insert)
   "C-ç" #'racket)

  (hercules-def
   :toggle-funs #'lispyville
   :keymap 'lispyville-mode-map
   :transient t)

  (general-define-key
   :keymaps 'lispyville-mode-map
   :states '(normal visual insert)
   "C--" #'lispyville))

(use-package buffer-move
:defer nil
:ensure t)

(use-package avy
  :defer nil
  :ensure t
  :config
  (setq avy-case-fold-search 't
        avy-style 'at-full
        avy-timeout-seconds 0.5
        avy-highlight-first t
        avy-single-candidate-jump t
        avy-background t
        avy-styles-alist '((avy-goto-line . at))
        avy-keys (nconc (number-sequence ?a ?z)
                        (number-sequence ?0 ?9)))

  (setq avy-all-windows nil)

  (custom-set-faces
   '(avy-background-face ((t (:foreground "SkyBlue"))))))

(use-package evil-easymotion
:after avy
:ensure t)

(use-package windmove
  :config
  (setq windmove-wrap-around t)
  (general-nvmap
    :keymaps 'override
    "M-h" 'windmove-left
    "M-l" 'windmove-right
    "M-j" 'windmove-down
    "M-k" 'windmove-up
    "s-u" 'windmove-up)

  (general-define-key
   :keymaps 'override
   "M-h" 'windmove-left
   "M-l" 'windmove-right
   "M-j" 'windmove-down
   "M-k" 'windmove-up)

  (general-define-key
   :keymaps 'override
   "<M-up>" 'windmove-up
   "<M-left>" 'windmove-left
   "<M-down>" 'windmove-down
   "<M-right>" 'windmove-right))

(use-package eyebrowse
  :ensure t
  ;; :init
  ;; (remove-hook 'eyebrowse-pre-window-switch-hook 'save-buffer)
  :config

  (setq eyebrowse-wrap-around t)
  (setq eyebrowse-new-workspace nil)
  (setq eyebrowse-mode-line-style 'smart)
  (setq eyebrowse-switch-back-and-forth t)
  (setq eyebrowse-mode-line-left-delimiter " [ ")
  (setq eyebrowse-mode-line-right-delimiter " ]  ")
  (setq eyebrowse-mode-line-separator " | ")

  (general-nvmap
    :prefix "SPC"
    :keymaps 'eyebrowse-mode-map
    "v" 'eyebrowse-create-window-config
    "x" 'eyebrowse-close-window-config)

  (general-unbind 'eyebrowse-mode-map
    "C-c C-w")

  (defun my-setup-eyebrowse-web ()
    (interactive)
    (eyebrowse-create-window-config)
    (eyebrowse-rename-window-config 2 "2. HTML")
    (eyebrowse-create-window-config)
    (eyebrowse-rename-window-config 3 "3. Tasks")
    (find-file "~/Studying/Prog/WebDev/webdev.org")
    (eyebrowse-switch-to-window-config-1)
    (eyebrowse-rename-window-config 1 "1. CSS")
    (eyebrowse-switch-to-window-config-3)
    (org-next-visible-heading 1))

  (defun my-setup-eyebrowse-html ()
    (interactive)
    (eyebrowse-create-window-config)
    (eyebrowse-rename-window-config 2 "2. Tasks")
    (find-file "~/Studying/Prog/WebDev/webdev.org")
    (eyebrowse-switch-to-window-config-1)
    (eyebrowse-rename-window-config 1 "1. HTML"))

  (defun eyebrowse--fixup-window-config (window-config)
    "Walk through WINDOW-CONFIG and fix it up destructively.
If a no longer existent buffer is encountered, it is replaced
with the scratch buffer."
    (eyebrowse--walk-window-config
     window-config
     (lambda (item)
       (when (eq (car item) 'buffer)
         (let* ((buffer-name (cadr item))
                (buffer (get-buffer buffer-name)))
           (when (not buffer)
             (message "Replaced deleted %s buffer with *scratch*" buffer-name)
             (setf (cadr item) "*scratch*")))))))

  (eyebrowse-mode t))

(use-package winner
  :defer nil
  :ensure nil
  :config

  (general-define-key
   :states '(visual normal insert)
   "M--" 'winner-undo
   "M-=" 'winner-redo
)

  (winner-mode 1))

(use-package ivy-hydra
:after hydra
:ensure t)

(use-package targets
  :defer 5
  :load-path "~/emacs-profiles/my-emacs/etc/custom_lisp"
  :config
  (targets-setup t))

(use-package i3wm-config-mode
  :defer nil
  :load-path "~/emacs-profiles/my-emacs/etc/custom_lisp"
  :init
  (add-hook 'i3wm-config-mode-hook 'my-prog-mode-hooks)
  :config
  (general-nvmap
    :keymaps 'i3wm-config-mode-map
    "<backspace>" 'my-eval-buffer-and-leave-org-source))

(use-package cool-moves
  :load-path "~/emacs-profiles/my-emacs/etc/custom_lisp/cool-moves"
  :config
  (general-define-key
   :keymaps 'override
   "<C-down>" 'cool-moves-paragraph-forward
   "<C-up>" 'cool-moves-paragraph-backward
   "C-S-j" 'cool-moves-line-forward
   "C-S-k" 'cool-moves-line-backward))

(use-package atomic-chrome
  ;; :if window-system
  :defer 3
  :init
  (add-hook 'atomic-chrome-edit-mode-hook 'my-atomic-chrome-hooks)
  (add-hook 'atomic-chrome-edit-done-hook 'my-atomic-chrome-done-hooks)

  :config
  (setq atomic-chrome-default-major-mode 'markdown-mode)
  (setq atomic-chrome-buffer-open-style 'frame)


  (general-define-key
   :keymaps 'atomic-chrome-edit-mode-map
   "<escape>" 'ignore)

  (defun my-kill-buffer-and-frame ()
    (interactive)
    (my-kill-this-buffer)
    (delete-frame))

  (general-nvmap
    :keymaps 'atomic-chrome-edit-mode-map
    "q" 'atomic-chrome-close-current-buffer)

  (general-unbind 'atomic-chrome-edit-mode-map
    :with 'atomic-chrome-close-current-buffer
    [remap my-kill-this-buffer])

  (defun my-atomic-chrome-hooks ()
    (interactive)
    (olivetti-mode +1)
    (evil-insert-state)
    (electric-operator-mode)
    (flyspell-mode +1))

  (defun my-atomic-chrome-done-hooks ()
    (interactive)
    (focus-chrome))

  (atomic-chrome-start-server))

(use-package nswbuff
  :ensure t
  :config

  (setq nswbuff-left "  "
        nswbuff-clear-delay 2
        nswbuff-delay-switch nil
        nswbuff-this-frame-only 't
        nswbuff-recent-buffers-first t
        nswbuff-start-with-current-centered t
        nswbuff-display-intermediate-buffers t
        nswbuff-buffer-list-function 'nswbuff-projectile-buffer-list)

  (setq nswbuff-exclude-mode-regexp "Buffer-menu-mode\\|Info-mode\\|Man-mode\\|calc-mode\\|calendar-mode\\|compilation-mode\\|completion-list-mode\\|dired-mode\\|fundamental-mode\\|gnus-mode\\|help-mode\\|helpful-mode\\|ibuffer-mode\\|lisp-interaction-mode\\|magit-auto-revert-mode\\|magit-blame-mode\\|magit-blame-read-only-mode\\|magit-blob-mode\\|magit-cherry-mode\\|magit-diff-mode\\|magit-diff-mode\\|magit-file-mode\\|magit-log-mode\\|magit-log-select-mode\\|magit-merge-preview-mode\\|magit-mode\\|magit-process-mode\\|magit-reflog-mode\\|magit-refs-mode\\|magit-repolist-mode\\|magit-revision-mode\\|magit-stash-mode\\|magit-stashes-mode\\|magit-status-mode\\|magit-submodule-list-mode\\|magit-wip-after-apply-mode\\|magit-wip-after-save-local-mode\\|magit-wip-after-save-mode\\|magit-wip-before-change-mode\\|magit-wip-initial-backup-mode\\|magit-wip-mode\\|minibuffer-inactive-mode\\|occur-mode\\|org-agenda-mode\\|org-src-mode\\|ranger-mode\\|special-mode\\|special-mode\\|term-mode\\|treemacs-mode\\|messages-buffer-mode")

  (setq nswbuff-exclude-buffer-regexps '(".*elc"
                                         "^#.*#$"
                                         "^\\*.*\\*"
                                         "^init.org$"
                                         "^agenda.org$"
                                         "archive.org$"
                                         "*slime-repl sbcl"
                                         "org-src-fontification"
                                         "*org-src-fontification:emacs-lisp-mode*"
                                         "*org-src-fontification\\.\\*")))

(use-package centered-cursor-mode
:defer t
:ensure t
:config
(setq ccm-recenter-at-end-of-file t))

(use-package dired
  :ensure nil
  :config
  (setq dired-use-ls-dired nil
        delete-by-moving-to-trash t
        dired-listing-switches "-lsh"
        dired-hide-details-mode t))

(use-package dired+
  :quelpa (dired+ :fetcher url :url "https://www.emacswiki.org/emacs/download/dired+.el")
  :after dired
  :config
  (setq diredp-hide-details-initially-flag t)
  (setq diredp-hide-details-propagate-flag t)
  (diredp-toggle-find-file-reuse-dir t))

(use-package ranger
  :init
  (add-hook 'ranger-mode-hook 'my-ranger-options)
  (add-hook 'ranger-parent-dir-hook 'my-ranger-options-parent)

  (defun my-ranger-deer ()
    (interactive)
    (deer)
    (olivetti-mode +1)
    (olivetti-set-width 70))

  :bind (:map ranger-mode-map
              ("i"          . ranger-go)
              (";"          . evil-ex)
              ("SPC" . my-ranger-toggle-mark)
              ("tp"         . delete-file)
              ("<escape>"   . ranger-close)
              ("r"          . ranger-close)
              ("gg"         . ranger-goto-top)
              ("C-h"        . hydra-help/body)
              ("C-n"        . ranger-next-file)
              ("C-p"        . ranger-prev-file)
              ("m"          . ranger-find-file)
              ("C-l"        . ranger-find-links-dir)
              ("zi"         . ranger-toggle-details)
              ("zp"         . ranger-preview-toggle)
              ("çcm"        . dired-create-directory)
              ("<insert>"   . counsel-find-file)
              ("C-c n"      . counsel-find-file)
              ("D"          . dired-do-flagged-delete)
              ("x"          . diredp-delete-this-file)
              ("d"          . dired-flag-file-deletion)
              ("<C-return>" . dired-do-find-marked-files)
              ("<S-return>" . ranger-find-file-in-workspace))
  :config

  (general-define-key
   :keymaps 'ranger-mode-map
   :prefix "SPC"
   "f" 'counsel-find-file
   "SPC" 'my-ranger-toggle-mark
   "q" 'ranger-close
   "r" 'ranger-close
   ";" 'evil-ex
   "c" 'hydra-commands/body
   "o" 'hydra-org-mode/body
   "i" 'counsel-outline
   "a" 'counsel-M-x
   "b" 'my-evil-botright)

  (general-create-definer leader
    :prefix "SPC")

  (general-unbind 'ranger-mode-map
    :with 'ranger-prev-file
    [remap ranger-to-dired])

  (general-unbind 'ranger-mode-map
    :with 'ignore
    [remap windmove-left]
    [remap windmove-right])

  (leader
    :states '(normal visual)
    :keymaps 'override
    ;; "SPC" 'ranger-find-links-dir
    "r" 'my-ranger-deer)

    ;;;; SETTINGS ;;;;

  (setq ranger-max-tabs 0
        ranger-minimal nil
        ranger-footer-delay 0
        ranger-parent-depth 1
        ranger-footer-delay nil
        ranger-preview-file nil
        ranger-override-dired t
        ranger-persistent-sort t
        ranger-cleanup-eagerly t
        ranger-dont-show-binary t
        ranger-width-preview 0.65
        ranger-width-parents 0.12
        ranger-max-preview-size 0.5
        ranger-cleanup-on-disable t
        ranger-return-to-ranger nil
        ranger-max-parent-width 0.42
        ranger-deer-show-details nil
        ranger-excluded-extensions '("mkv" "iso" "mp4" "bin" "exe" "msi" "pdf" "doc" "docx"))

    ;;;; FUNCTIONS ;;;;

  (defun ranger-preview-toggle ()
    "Toggle preview of selected file."
    (interactive)
    (if (r--fget ranger-minimal)
        (message "Currently in deer mode. Previews are disabled.")
      (setq ranger-preview-file (not ranger-preview-file))
      (if ranger-preview-file
          (progn
            (ranger-hide-details)
            (ranger-setup-preview))
        (progn
          (when (and ranger-preview-window
                     (eq (selected-frame) (window-frame ranger-preview-window))
                     (window-live-p ranger-preview-window)
                     (window-at-side-p ranger-preview-window 'right))
            (ignore-errors
              (delete-window ranger-preview-window)))
          (ranger-hide-details)))))

  (defun ranger (&optional path)
    (interactive)
    (let* ((file (or path (buffer-file-name)))
           (dir (if file (file-name-directory file) default-directory)))
      (when dir
        (r--fset ranger-minimal nil)
        (ranger-find-file dir))))

  (defun my-ranger-go (path)
    (interactive
     (list
      (read-char-choice
       "
    d : dotfiles  o : org        r: creative   q: quit
    e : emacs     s : scripts    c: documents  f: config
    h : home      n : downloads  t: study
  > "
       '(?a ?b ?c ?d ?e ?f ?g ?h ?i ?j ?l ?m ?n ?o ?p ?q ?r ?s ?t ?v ?z ?w))))
    (message nil)
    (let* ((c (char-to-string path))
           (new-path
            (cl-case (intern c)
              ('d "~/dotfiles")
              ('e "~/.emacs.d")
              ('h "~")
              ('o "~/org")
              ('s "~/scripts")
              ('c "~/Documents")
              ('t "~/Documents/Study")
              ('n "~/Downloads")
              ('r "~/creative")
              ('f "~/.config")

              ('q nil)))
           (alt-option
            (cl-case (intern c)
              ;; Subdir Handlng
              ('j 'ranger-next-subdir)
              ('k 'ranger-prev-subdir)
              ;; Tab Handling
              ('n 'ranger-new-tab)
              ('T 'ranger-prev-tab)
              ('t 'ranger-next-tab)
              ('c 'ranger-close-tab))))
      (when (string-equal c "q")
        (keyboard-quit))
      (when (and new-path (file-directory-p new-path))
        (ranger-find-file new-path))
      (when (eq system-type 'windows-nt)
        (when (string-equal c "D")
          (ranger-show-drives)))
      (when alt-option
        (call-interactively alt-option))))

  (advice-add 'ranger-go :override #'my-ranger-go)

  ;;;; OPTIONS ;;;

  (defun my-ranger-options ()
    (interactive)
    (line-no-numbers)
    (olivetti-mode +1)
    (dired-hide-details-mode +1)
    (hide-mode-line-mode +1))

  (defun my-ranger-options-parent ()
    (interactive)
    (line-no-numbers)
    (dired-hide-details-mode +1)
    (toggle-truncate-lines +1)
    (hide-mode-line-mode +1))

  ;;;; COMMANDS ;;;;
  (defun my-ranger-toggle-mark ()
    (interactive)
    (ranger-toggle-mark)
    (ranger-next-file 1))

  (defun ranger-find-file-in-workspace ()
    (interactive)
    (ranger-find-file)
    (duplicate-workspace-buffer))

  (defun my-ranger ()
    (interactive)
    (my-copy-dir)
    (start-process-shell-command "my-show-ranger" nil "~/scripts/emacs_scripts/show-ranger")))

(use-package which-key
  :disabled
  :config
  (setq which-key-idle-delay 0.5))

(use-package super-save
  ;; :disabled
  :config

  (setq super-save-exclude '("\\.pdf" "\\.py" "+new-snippet+"))
  (setq-default super-save-exclude '("\\.pdf" "\\.py" "+new-snippet+"))

  (setq super-save-exclude '("\\.pdf" "+new-snippet+"))
  (setq-default super-save-exclude '("\\.pdf" "+new-snippet+"))


  (setq auto-save-default nil
        super-save-idle-duration 5
        super-save-auto-save-when-idle nil
        auto-save-file-name-transforms `((".*" "~/emacs-profiles/my-emacs/var/temp" t)))

  (setq super-save-hook-triggers '(mouse-leave-buffer-hook focus-out-hook))

  (setq super-save-triggers
        '(
          undo
          quickrun
          last-buffer
          windmove-up
          windmove-down
          windmove-left
          windmove-right
          balance-windows
          switch-to-buffer
          eyebrowse-close-window-config
          eyebrowse-create-window-config
          eyebrowse-next-window-config
          eyebrowse-prev-window-config
          eyebrowse-switch-to-window-config-1
          eyebrowse-switch-to-window-config-2
          eyebrowse-switch-to-window-config-3
          eyebrowse-switch-to-window-config-4
          eyebrowse-switch-to-window-config-5
          eyebrowse-switch-to-window-config-6
          eyebrowse-switch-to-window-config-7
          eyebrowse-switch-to-window-config-8
          eyebrowse-switch-to-window-config-9))

  (auto-save-mode -1)
  (super-save-mode +1))

(use-package wordnut
  ;; :if window-system
  :defer t
  :init
  (add-hook 'wordnut-mode-hook 'hl-line-mode)
  :config
  (setq wordnut-cmd "/usr/local/bin/wn"))

(use-package aggressive-fill-paragraph
  :defer t)

(use-package pabbrev
  :defer t
  :ensure t
  :config
  (setq pabbrev-idle-timer-verbose nil)
  (general-imap
    :keymaps 'pabbrev-mode-map
    "C-l" 'pabbrev-expand-maybe))

(use-package lorem-ipsum
  :defer t
  :ensure t
  :config
  (setq lorem-ipsum-paragraph-separator "\n\n"))

(use-package hl-sentence
  :defer t
  :init
  (add-hook 'hl-sentence-mode-hook 'my-disable-hl-line-mode)
  :ensure t
  :config
  (defun my-disable-hl-line-mode ()
    (interactive)
    (hl-line-mode -1))
  (custom-set-faces
   '(hl-sentence ((t (:inherit hl-line))))))

(use-package flyspell
  :defer t
  :init
  (add-hook 'flyspell-mode-hook 'flyspell-buffer)
  :config
  (setq flyspell-abbrev-p t)
  (setq flyspell-issue-message-flag nil)
  (setq flyspell-issue-welcome-flag nil)
  (setq flyspell-default-dictionary "english")

  (defun my-ispell-show-dictionary ()
    (interactive)
    (describe-variable 'ispell-current-dictionary))

  (general-define-key
   :keymaps 'flyspell-mode-map
   "C-c d" 'my-ispell-show-dictionary))

(use-package flyspell-correct-ivy
  :after flyspell
  :init
  (setq flyspell-correct-interface #'flyspell-correct-ivy))

(use-package ispell
  :defer t
  :ensure nil
  :init
  ;; https://github.com/company-mode/company-mode/issues/912#issuecomment-532016905
  (advice-add 'ispell-lookup-words :around
              (lambda (orig &rest args)
                (apply orig args)))

  (setq ispell-program-name "/usr/local/bin/aspell"))

(use-package fix-word
  :defer t)

(use-package olivetti
  :defer t
  :init
  (setq-default olivetti-body-width 95)
  :config
  (defun my-olivetti-narrow ()
    (interactive)
    (olivetti-mode +1)
    (olivetti-set-width 70)))
;; (add-hook 'olivetti-mode-hook 'my-set-fill-120)

(use-package markdown-mode
  :defer t
  :init
  (add-hook 'markdown-mode-hook 'my-markdown-hooks)
  (setq markdown-hide-urls 't)
  (setq-default markdown-hide-markup nil)
  (setq markdown-enable-wiki-links t)
  :config
  (defun my-markdown-forward-paragraph ()
    (interactive)
    (markdown-forward-paragraph)
    (forward-to-indentation))

  (defun my-markdown-hooks ()
    (interactive)
    (let ((inhibit-message t))
      (olivetti-mode +1)
      (emmet-mode +1)
      (pabbrev-mode +1)
      (tab-jump-out-mode +1)))

  (defun my-markdown-copy-buffer ()
    (interactive)
    (save-excursion
      (my-markdown-copy-buffer-macro)
      (message " buffer yanked without title")))

  (setq markdown-css-paths '("/home/mrbig/org/Creative/Web/md_themes/retro/css/retro.css"))

  (defun my-counsel-markdown-commands ()
    (interactive)
    (counsel-M-x "^markdown- "))

  (general-nvmap
    :keymaps 'markdown-mode-map
    ">" 'markdown-promote-subtree
    "<" 'markdown-demote-subtree
    "}" 'markdown-forward-paragraph
    "RET" 'hydra-spell/body
    "[" 'markdown-previous-link
    "]" 'markdown-next-link
    "<tab>" 'markdown-cycle
    "<insert>" 'markdown-insert-link)

  (general-define-key
   :keymaps 'markdown-mode-map
   "C-c h" 'markdown-insert-header-dwim
   "C-c -" 'my-insert-em-dash-space
   "C-c s" 'my-markdown-insert
   "C-x y" 'my-markdown-copy-buffer
   "C-c l" 'markdown-toc-generate-or-refresh-toc
   "M-p" 'markdown-backward-paragraph
   "M-n" 'my-markdown-forward-paragraph
   "<tab>" 'markdown-cycle
   "<insert>" 'markdown-insert-link))

(defun my-markdown-insert ()
  (interactive)
  (counsel-M-x "^markdown-insert- "))

(use-package markdown-toc
  :after markdown
  :ensure t)

(use-package emmet-mode
  :defer t
  :ensure t
  :config

  (setq emmet-insert-flash-time 0.1)
  (setq emmet-move-cursor-between-quotes t)

  (general-define-key
   :keymaps 'emmet-mode-keymap
   "C-S-p" 'my/emmet-prev
   "C-S-n" 'my/emmet-next)

  (defun my/emmet-prev ()
    (interactive)
    (emmet-prev-edit-point 1)
    (evil-insert-state))

  (defun my/emmet-next ()
    (interactive)
    (emmet-next-edit-point 1)
    (evil-insert-state))

  (emmet-mode +1))


(use-package adoc-mode
  ;; :if window-system
  :defer t
  :init
  (add-hook 'adoc-mode-hook 'my-disable-variable-pitch)
  (add-to-list 'auto-mode-alist '("\\.adoc\\'" . adoc-mode)))

(use-package all-the-icons
  ;; :if window-system
  :defer t)

(use-package typo
  :defer t
  :config
  (defun typo-insert-cycle (cycle)
    "Insert the strings in CYCLE"
    (let ((i 0)
          (repeat-key last-input-event)
          repeat-key-str)
      (insert (nth i cycle))
      (setq repeat-key-str (format-kbd-macro (vector repeat-key) nil))
      (while repeat-key
        (message "(inserted %s)"
                 (typo-char-name (nth i cycle))
                 repeat-key-str)
        (if (equal repeat-key (read-event))
            (progn
              (clear-this-command-keys t)
              (delete-char (- (length (nth i cycle))))
              (setq i (% (+ i 1)
                         (length cycle)))
              (insert (nth i cycle))
              (setq last-input-event nil))
          (setq repeat-key nil)))
      (when last-input-event
        (clear-this-command-keys t)
        (setq unread-command-events (list last-input-event)))))


  (define-typo-cycle typo-cycle-dashes
    "Cycle through various dashes."
    ("—"   ; EM DASHH
     "-"   ; HYPHEN-MINUS
     "–"   ; EN DASH
     "−"   ; MINUS SIGN
     "‐"   ; HYPHEN
     "‑")) ; NON-BREAKING HYPHEN
  (setq typo-language "brasileiro"))

(use-package fountain-mode
  :defer t
  :init
  (add-hook 'fountain-mode-hook 'my-fountain-hooks)
  :ensure t
  :config

  (defun my-fountain-hooks ()
    (interactive)
    ;; (auto-capitalize-mode +1)
    (electric-operator-mode +1)
    (olivetti-mode +1)
    (outline-minor-mode +1))

  (defun my-fountain-insert-note ()
    (interactive)
    (fountain-insert-note)
    (evil-insert-state))

  (general-define-key
   :keymaps 'fountain-mode-map
   "C-c t" 'my-tangle-fountain
   "C-c C-n" 'my-fountain-insert-note
   "C-c n" 'my-fountain-insert-note
   "C-;"   'fountain-upcase-line-and-newline
   "M-p"   'fountain-backward-scene
   "M-n"   'fountain-forward-scene
   "C-M-k"  'fountain-shift-up
   "C-M-j"  'fountain-shift-down
   "C-M-p" 'my-paragraph-backwards
   "C-M-n" 'my-paragraph-forward)

  (general-nvmap
    :keymaps 'fountain-mode-map
    "C-;"   'fountain-upcase-line-and-newline
    "zi" 'fountain-outline-show-all
    "gk" 'fountain-outline-previous
    "gj" 'fountain-outline-next
    "gl" 'fountain-backward-scene
    "gh"  'fountain-forward-scene
    "M-p"   'fountain-backward-scene
    "M-n"   'fountain-forward-scene
    "C-p" 'fountain-backward-character
    "C-n" 'fountain-forward-character
    "<tab>" 'fountain-dwim)

  (general-imap
    :keymaps 'fountain-mode-map
    "M-/" 'my-complete-at-point
    "C-;"   'fountain-upcase-line-and-newline)

  )

(use-package url-shortener
  ;; :if window-system
  :defer t
  :config
  (setq bitly-access-token "3026d7e8b1a0f89da10740c69fd77b4b3293151e"))

(use-package pdf-tools
  ;; :defer t
  :init

  (add-hook 'pdf-view-mode-hook 'my-pdf-view-settings)
  (add-hook 'pdf-tools-enabled-hook 'my-pdf-view-settings)

  (add-hook 'pdf-outline-buffer-mode-hook 'my-pdf-outline-settings)

  :config
  (setq pdf-view-continuous t)
  (setq pdf-view-resize-factor 1.15)
  (setq pdf-view-display-size 'fit-page)
  (setq pdf-misc-size-indication-minor-mode t)
  (setq pdf-annot-activate-created-annotations t)

  (defun my-call-ranger-from-pdf ()
    (interactive)
    (last-buffer)
    (ranger))

  (defun pdf-occur-goto-quit ()
    (interactive)
    (pdf-occur-goto-occurrence)
    (quit-windows-on "*PDF-Occur*"))

  (defun my-pdf-delete-occur-window ()
    (interactive)
    (quit-windows-on "*PDF-Occur*"))

  (defun my-pdf-view-settings ()
    (interactive)
    (pdf-annot-minor-mode 1)
    (pdf-links-minor-mode 1)
    ;; (line-no-numbers)
    (pdf-history-minor-mode 1)
    (tab-jump-out-mode -1))

  (defun my-pdf-outline-settings ()
    (interactive)
    (outline-minor-mode 1)
    (hl-line-mode 1))

  (general-define-key
   :keymaps 'pdf-outline-minor-mode-map
   "<escape>" 'pdf-outline-quit)

  (general-define-key
   :keymaps 'pdf-outline-buffer-mode-map
   "gh" 'pdf-outline-up-heading
   "<tab>" 'pdf-outline-toggle-subtree
   "<escape>" 'pdf-outline-quit)

  (general-nmap
    :keymaps 'pdf-outline-buffer-mode-map
    "<escape>" 'pdf-outline-quit)

  ;; (general-nmap
  ;;   :keymaps 'pdf-view-mode-map
  ;;   "<escape>" 'last-buffer)

  (general-unbind 'pdf-outline-buffer-mode-map
    :with 'pdf-outline-quit
    [remap my-quiet-save-buffer])

  (general-unbind 'pdf-view-mode-map
    :with 'my-call-ranger-from-pdf
    [remap ranger])


  (general-unbind 'pdf-view-mode-map
    :with 'ignore
    [remap save-buffer]
    [remap my-save-buffer]
    [remap my-ranger-deer])

  (general-unbind 'pdf-view-mode-map
    :with 'my-kill-this-buffer
    "Q")

  (general-nvmap
    :keymaps 'pdf-annot-list-mode-map
    "q" 'pdf-outline-quit-and-kill
    "<escape>" 'pdf-outline-quit)

  (general-nvmap
    :keymaps 'pdf-occur-buffer-mode-map
    "go" 'pdf-occur-goto-occurrence
    "<return>" 'pdf-occur-goto-quit)

  (general-define-key
   :keymaps 'pdf-view-mode-map
   "w" 'pdf-view-fit-width-to-window
   "<return>" 'quick-calc
   "<kp-enter>" 'quick-calc
   "J" 'pdf-view-next-page
   "j" 'pdf-view-next-line-or-next-page
   "K" 'pdf-view-previous-page
   "k" 'pdf-view-previous-line-or-previous-page
   "p" 'pdf-view-previous-page
   "n" 'pdf-view-next-page

   "C-x i" 'org-noter-insert-precise-note

   "C-c V v" 'pdf-view-set-slice-using-mouse
   "C-c V r" 'pdf-view-reset-slice
   "C-c C-c" 'pdf-annot-add-highlight-markup-annotation
   "M-o" 'pdf-history-backward
   "M-i" 'pdf-history-forward
   "H" 'pdf-history-backward
   "L" 'pdf-history-forward)

  (general-unbind 'pdf-view-mode-map
    :with 'pdf-view-fit-page-to-window
    [remap evil-beginning-of-visual-line])

  (general-unbind 'pdf-view-mode-map
    :with 'pdf-outline
    [remap evil-toggle-fold])

  (general-define-key
   :keymaps 'pdf-annot-edit-contents-minor-mode-map
   "C-c C-c" 'pdf-annot-edit-contents-abort
   "<C-return>" 'pdf-annot-edit-contents-commit)

  (general-nvmap
    :keymaps 'pdf-annot-edit-contents-minor-mode-map
    "c" 'pdf-annot-edit-contents-abort)

  (general-nvmap
    :keymaps 'pdf-view-mode-map
    "<kp-enter>" 'quick-calc
    "i" 'org-noter-insert-note
    "I" 'org-noter-insert-precise-note
    "C-l" 'counsel-bookmark
    "C-c C-c" 'pdf-annot-add-highlight-markup-annotation
    "c" 'pdf-annot-add-highlight-markup-annotation
    "H" 'pdf-history-backward
    "L" 'pdf-history-forward
    "S" 'pdf-occur
    "C-s" 'pdf-occur
    "ss" 'my-pdf-delete-occur-window
    "M-s" 'last-buffer
    "q" 'last-buffer
    "gf" 'find-pdf-keys
    "TAB" 'pdf-outline
    "D" 'pdf-annot-delete
    "gp" 'pdf-view-goto-page
    ";" 'hydra-org-noter/body
    "f" 'pdf-links-action-perform
    "gr" 'pdf-view-jump-to-register
    "t" 'pdf-annot-add-text-annotation
    "gm" 'pdf-view-position-to-register
    "h" 'pdf-view-scroll-up-or-next-page
    "l" 'pdf-view-scroll-down-or-previous-page
    "<down>" 'pdf-view-next-line-or-next-page
    "<up>" 'pdf-view-previous-line-or-previous-page
    "J" 'pdf-view-next-page
    "j" 'pdf-view-next-line-or-next-page
    "K" 'pdf-view-previous-page
    "k" 'pdf-view-previous-line-or-previous-page
    "p" 'pdf-view-previous-page
    "n" 'pdf-view-next-page
    "w" 'pdf-view-fit-width-to-window
    "C-0" 'pdf-view-fit-height-to-window
    ;; "<left>" 'eyebrowse-prev-window-config
    ;; "<right>" 'eyebrowse-next-window-config
    "C-c h" 'pdf-annot-add-highlight-markup-annotation)

  (pdf-loader-install))

(defun my-write-insert-mode ()
  (interactive)
  (general-unbind '(org-mode-map evil-org-mode-map)
    :with 'ignore
    ;; [remap evil-delete-backward-word]
    [remap undo-fu-only-redo]
    [remap undo-fu-only-undo]
    [remap evil-org-open-below]
    [remap evil-org-open-above]
    [remap delete-backward-char]
    [remap delete-char]
    [remap evil-change-line]
    [remap evil-change-to-initial-state]
    [remap evil-change-to-previous-state]
    [remap evil-change-whole-line]
    [remap evil-change]
    [remap evil-delete-backward-char-and-join]
    [remap evil-delete-backward-char]
    [remap evil-delete-buffer]
    [remap evil-delete-char]
    [remap evil-delete-line]
    [remap evil-delete-marks]
    [remap evil-delete-whole-line]
    [remap evil-delete]
    [remap evil-join-space]
    [remap evil-join]
    [remap evil-org-delete-backward-char]
    [remap evil-org-delete-char]
    [remap evil-org-delete]
    [remap kill-line]
    [remap kill-paragraph]
    [remap kill-rectangle]
    [remap kill-region]
    [remap kill-ring-save]
    [remap kill-sentence]
    [remap kill-visual-line]
    [remap kill-whole-line]
    [remap kill-word]
    [remap my/backward-kill-line]
    [remap org-delete-backward-char]
    [remap org-delete-char]
    [remap org-delete-indentation]
    [remap org-delete-property-globally]
    [remap org-delete-property]
    [remap undo])
  (evil-define-key 'insert org-mode-map (kbd "C-k") 'ignore)
  (evil-define-key 'insert org-mode-map (kbd "DEL") 'ignore)
  (message " insert only"))

(defun my-write-edit-mode ()
  (interactive)
  (general-unbind '(org-mode-map evil-org-mode-map)
    :with nil
    [remap undo-fu-only-redo]
    [remap undo-fu-only-undo]
    [remap evil-delete-backward-word]
    [remap evil-org-open-below]
    [remap evil-org-open-above]
    [remap delete-backward-char]
    [remap delete-char]
    [remap evil-change-line]
    [remap evil-change-to-initial-state]
    [remap evil-change-to-previous-state]
    [remap evil-change-whole-line]
    [remap evil-change]
    [remap evil-delete-backward-char-and-join]
    [remap evil-delete-backward-char]
    [remap evil-delete-buffer]
    [remap evil-delete-char]
    [remap evil-delete-line]
    [remap evil-delete-marks]
    [remap evil-delete-whole-line]
    [remap evil-delete]
    [remap evil-join-space]
    [remap evil-join]
    [remap evil-org-delete-backward-char]
    [remap evil-org-delete-char]
    [remap evil-org-delete]
    [remap kill-line]
    [remap kill-paragraph]
    [remap kill-rectangle]
    [remap kill-region]
    [remap kill-ring-save]
    [remap kill-sentence]
    [remap kill-visual-line]
    [remap kill-whole-line]
    [remap kill-word]
    [remap my/backward-kill-line]
    [remap org-delete-backward-char]
    [remap org-delete-char]
    [remap org-delete-indentation]
    [remap org-delete-property-globally]
    [remap org-delete-property]
    [remap undo])
  (evil-define-key 'insert org-mode-map (kbd "C-k") 'kill-visual-line)
  (evil-define-key 'insert org-mode-map (kbd "DEL") 'evil-delete-backward-char-and-join)
  (message " insert and edit"))

(use-package json-mode
  :defer t
  :ensure t)

(use-package company
  :defer t
  :config
  (general-define-key
   :keymaps   'company-active-map
   "C-n"      'company-select-next
   "S-SPC" 'company-select-next
   "C-p"      'company-select-previous
   "C-j"      nil
   "C-k"      'company-abort
   "M--"      'my-company-comp-first-with-dash
   "M-="      'my-company-comp-first-with-equal
   "M-q"      'my-company-comp-first
   "M-w"      'my-company-comp-first-with-paren
   "M-e"      'my-company-comp-with-paren
   "M-."      'my-company-comp-with-dot
   "M-f"      'my-company-comp-first-with-square-bracket
   "M-j"      'my-company-comp-first-space
   "C-j"      'company-complete
   "<return>" 'company-complate
   "C-l"      nil
   "M-r"      'company-filter-candidates
   "RET"      nil
   "<escape>" 'company-abort
   ;; "<escape>" nil
   "<tab>"    'my-company-yasnippet
   "C-h"      'delete-backward-char

   "M-1"      'company-complete-number
   "M-2"      'company-complete-number
   "M-3"      'company-complete-number
   "M-4"      'company-complete-number
   "M-5"      'company-complete-number
   "M-6"      'company-complete-number
   "M-7"      'company-complete-number
   "M-8"      'company-complete-number
   "M-9"      'company-complete-number
   "M-0"      'company-complete-number

   "C-1"      'company-complete-number
   "C-2"      'company-complete-number
   "C-3"      'company-complete-number
   "C-4"      'company-complete-number
   "C-5"      'company-complete-number
   "C-6"      'company-complete-number
   "C-7"      'company-complete-number
   "C-8"      'company-complete-number
   "C-9"      'company-complete-number
   "C-0"      'company-complete-number
   "C-w"      'evil-delete-backward-word)

  (general-define-key
   :keymaps   'company-filter-map
   "C-n"      nil
   "C-p"      nil
   "M-q"      'company-complete
   "M-w"      'company-complete
   "M-e"      'company-complete
   "M-r"      'company-complete
   "M-d"      'company-complete
   "<return>" 'company-complete
   "RET"      'company-complete
   "<tab>"    'company-complete
   "<escape>" 'company-abort
   "C-h"      'delete-backward-char

   "M-1"      'company-complete-number
   "M-2"      'company-complete-number
   "M-3"      'company-complete-number
   "M-4"      'company-complete-number
   "M-5"      'company-complete-number
   "M-6"      'company-complete-number
   "M-7"      'company-complete-number
   "M-8"      'company-complete-number
   "M-9"      'company-complete-number
   "M-0"      'company-complete-number

   "C-1"      'company-complete-number
   "C-2"      'company-complete-number
   "C-3"      'company-complete-number
   "C-4"      'company-complete-number
   "C-5"      'company-complete-number
   "C-6"      'company-complete-number
   "C-7"      'company-complete-number
   "C-8"      'company-complete-number
   "C-9"      'company-complete-number
   "C-0"      'company-complete-number
   "C-w"      'evil-delete-backward-word)

  (general-imap
    :keymaps 'company-mode-map
    "S-SPC" 'company-complete
    "M-/" 'hippie-expand)

  (setq company-show-numbers t
        company-idle-delay 0.3
        company-tooltip-limit 10
        company-auto-complete nil
        company-auto-complete-chars '(46)
        company-dabbrev-other-buffers t
        company-selection-wrap-around t
        company-minimum-prefix-length 2
        company-dabbrev-code-everywhere nil
        company-dabbrev-downcase nil
        company-dabbrev-code-ignore-case t
        company-tooltip-align-annotations 't
        company-dabbrev-ignore-case 'keep-prefix
        company-begin-commands '(self-insert-command)
        company-dabbrev-ignore-buffers "\\`[ *]")

;;;; BACKENDS ;;;;

  (setq-default company-backends '(company-semantic
                                   company-clang
                                   company-cmake
                                   company-capf
                                   company-files
                                   (company-dabbrev-code company-keywords)
                                   company-dabbrev
                                   company-shell))

;;;; FUNCTIONS ;;;;

  (defun my-company-comp-space ()
    (interactive)
    (company-complete)
    (insert " "))

  (defun my-company-comp-first-space
      (interactive)
    (company-select-next)
    (company-complete)
    (insert " "))

  (defun my-company-comp-first-with-paren ()
    (interactive)
    (company-select-next)
    (company-complete)
    (insert "()")
    (backward-char))

  (defun my-company-comp-first-with-equal ()
    (interactive)
    (company-select-next)
    (company-complete)
    (insert " = ")
    (company-complete))

  (defun my-company-comp-first-with-dash ()
    (interactive)
    (company-select-next)
    (company-complete)
    (insert "-")
    (company-complete))

  (defun my-company-comp-with-dot ()
    (interactive)
    (company-select-next)
    (company-complete)
    (insert ".")
    (company-complete))

  (defun my-company-comp-with-paren ()
    (interactive)
    (company-complete)
    (insert "()")
    (backward-char))

  (defun my-company-comp-first-with-square-bracket ()
    (interactive)
    (company-select-next)
    (company-complete)
    (insert "[\"\"]")
    (backward-char 2))

  (defun my-company-comp-with-square-bracket ()
    (interactive)
    (company-complete)
    (insert "[]")
    (backward-char))

  (defun my-company-comp-colon ()
    (interactive)
    (company-select-next)
    (company-complete)
    (insert ": "))

  (defun my-company-comp-colon-semicolon ()
    (interactive)
    (company-select-next)
    (company-complete)
    (insert ": ;")
    (backward-char))

  (defun my-company-comp-first ()
    (interactive)
    (company-select-next)
    (company-complete))

  (defun my-company-comp-first-space ()
    (interactive)
    (company-select-next)
    (company-complete)
    (insert " "))

  (defun my-company-comp-first-comint ()
    (interactive)
    (company-select-next)
    (company-complete)
    (comint-send-input))

  (defun my-company-comp-comint ()
    (interactive)
    (company-complete)
    (comint-send-input))

  (defun my-company-yasnippet ()
    (interactive)
    (company-abort)
    (yas-expand))

  (defun my-company-abort-tab ()
    (interactive)
    (company-abort)
    (forward-char))

;;;; TOGGLES ;;;;

  (defun my-company-show-options ()
    (interactive)
    (counsel-M-x "^my-company-idle-"))

  (defun my-company-show-delay ()
    (interactive)
    (describe-variable 'company-idle-delay))

  (defun my-company-show-prefix-length ()
    (interactive)
    (describe-variable 'company-minimum-prefix-length))

  (defun my-company-idle-zero-prefix-one ()
    (interactive)
    (setq-local company-idle-delay 0.0)
    (setq-local company-minimum-prefix-length 1)
    (message "idle delay: 0, minimun prefix length: 1"))

  (defun my-company-idle-zero-prefix-one-quiet ()
    (interactive)
    (setq-local company-idle-delay 0.0)
    (setq-local company-minimum-prefix-length 1))

  (defun my-company-idle-zero-prefix-two ()
    (interactive)
    (setq-local company-idle-delay 0.0)
    (setq-local company-minimum-prefix-length 2)
    (message "idle delay: 0, minimun prefix length: 2"))

  (defun my-company-idle-zero-prefix-two-quiet ()
    (interactive)
    (setq-local company-idle-delay 0.0)
    (setq-local company-minimum-prefix-length 2))

  (defun my-company-idle-one-prefix-one ()
    (interactive)
    (setq-local company-idle-delay 0.1)
    (setq-local company-minimum-prefix-length 1)
    (message "idle delay: 0.1, minimun prefix length: 1"))

  (defun my-company-idle-one-prefix-one-quiet ()
    (interactive)
    (setq-local company-idle-delay 0.1)
    (setq-local company-minimum-prefix-length 1))

  (defun my-company-idle-one-prefix-two ()
    (interactive)
    (setq-local company-idle-delay 0.1)
    (setq-local company-minimum-prefix-length 2)
    (message "idle delay: 0.1, minimun prefix length: 2"))

  (defun my-company-idle-one-prefix-two-quiet ()
    (interactive)
    (setq-local company-idle-delay 0.1)
    (setq-local company-minimum-prefix-length 2))

  (defun my-company-idle-two-prefix-one ()
    (interactive)
    (setq-local company-idle-delay 0.2)
    (setq-local company-minimum-prefix-length 1)
    (message "idle delay: 0.2, minimun prefix length: 1"))

  (defun my-company-idle-two-prefix-two ()
    (interactive)
    (setq-local company-idle-delay 0.2)
    (setq-local company-minimum-prefix-length 2)
    (message "idle delay: 0.2, minimun prefix length: 2"))

  (defun my-company-idle-two-prefix-two-quiet ()
    (interactive)
    (setq-local company-idle-delay 0.2)
    (setq-local company-minimum-prefix-length 2))

  (defun my-company-idle-two-prefix-one-quiet ()
    (interactive)
    (setq-local company-idle-delay 0.2)
    (setq-local company-minimum-prefix-length 1))

  (defun my-company-idle-three-prefix-one ()
    (interactive)
    (setq-local company-idle-delay 0.3)
    (setq-local company-minimum-prefix-length 1)
    (message "idle delay: 0.3, minimun prefix length: 1"))

  (defun my-company-idle-three-prefix-one-quiet ()
    (interactive)
    (setq-local company-idle-delay 0.3)
    (setq-local company-minimum-prefix-length 1))

  (defun my-company-idle-three-prefix-two ()
    (interactive)
    (setq-local company-idle-delay 0.3)
    (setq-local company-minimum-prefix-length 2)
    (message "idle delay: 0.3, minimun prefix length: 2"))

  (defun my-company-idle-three-prefix-three-quiet ()
    (interactive)
    (setq-local company-idle-delay 0.3)
    (setq-local company-minimum-prefix-length 3))

  (defun my-company-idle-four-prefix-two ()
    (interactive)
    (setq-local company-idle-delay 0.4)
    (setq-local company-minimum-prefix-length 2)
    (message "idle delay: 0.4, minimun prefix length: 2"))

  (defun my-company-idle-four-prefix-two-silent ()
    (interactive)
    (setq-local company-idle-delay 0.4)
    (setq-local company-minimum-prefix-length 2))

  (defun my-company-idle-five-prefix-two ()
    (interactive)
    (setq-local company-idle-delay 0.5)
    (setq-local company-minimum-prefix-length 2)
    (message "idle delay: 0.5, minimun prefix length: 2"))

  (defun my-company-idle-five-prefix-two-silent ()
    (interactive)
    (setq-local company-idle-delay 0.5))

  (defun my-company-idle-five-prefix-three-silent ()
    (interactive)
    (setq-local company-idle-delay 0.5)
    (setq-local company-minimum-prefix-length 3))

  (defun my-company-idle-five-prefix-four ()
    (interactive)
    (setq-local company-idle-delay 0.5)
    (setq-local company-minimum-prefix-length 4)
    (message "idle delay: 0.5, minimun prefix length: 2"))

  (defun my-company-idle-five-prefix-four-silent ()
    (interactive)
    (setq-local company-idle-delay 0.5)
    (setq-local company-minimum-prefix-length 4))

  (defun my-company-idle-five-prefix-three ()
    (interactive)
    (setq-local company-idle-delay 0.5)
    (setq-local company-minimum-prefix-length 3)
    (message "idle delay: 0.5, minimun prefix length: 2")))

(use-package company-shell
  :after company
  :ensure t
  :init
  (add-to-list 'company-backends 'company-shell t)
  (setq company-shell-modes '(sh-mode fish-mode shell-mode eshell-mode text-mode prog-mode lisp-interaction-mode markdown-mode))
  :config
  (setq company-shell-delete-duplicates t)
  (setq company-fish-shell-modes nil))

(use-package pos-tip
  :defer t
  :ensure t
  :config
  (setq pos-tip-border-width 3)
  (setq pos-tip-internal-border-width 3)
  (setq pos-tip-background-color "grey9")
  (setq pos-tip-foreground-color "yellow1"))

(use-package company-web
  :after company
  :ensure t)

(use-package company-tern
  :after company
  :ensure t
  :config
  ;; (add-to-list 'company-backends 'company-tern)
  (setq company-tern-meta-as-single-line t))

(use-package prescient
  :defer t
  :config
  (prescient-persist-mode +1))

(use-package ivy-prescient
  :after ivy
  :config
  ;; (setq ivy-prescient-sort-commands '(:not swiper ivy-switch-buffer))
  (setq ivy-prescient-sort-commands '(:not nil))

  ;; (setq ivy-prescient-sort-commands '(counsel-projectile-find-file-dwim
  ;;                                     counsel-projectile-find-file
  ;;                                     counsel-projectile-switch-to-buffer
  ;;                                     counsel-find-library
  ;;                                     counsel-find-file
  ;;                                     counsel-ag
  ;;                                     counsel-org-tag
  ;;                                     org-set-tags-command
  ;;                                     counsel-org-capture))

  ;; (setq ivy-prescient-sort-commands '(counsel-find-library))

  (ivy-prescient-mode +1))

(use-package company-prescient
  :after company
  :config
  (company-prescient-mode +1)
  (prescient-persist-mode +1))

(use-package yasnippet
  :defer 5
  :init
  (add-hook 'snippet-mode-hook (lambda () (super-save-mode -1)))
  (add-hook 'yas-before-expand-snippet-hook 'evil-insert-state)

  :config
  (setq yas--default-user-snippets-dir (concat udir "etc/yasnippet"))
  (setq yas-also-auto-indent-first-line t
        yas-indent-line 'auto
        yas-triggers-in-field nil)

  (defun my-yas-after-exit-hooks ()
    (interactive)
    (org-babel-execute-src-block)
    (org-babel-remove-result)
    (evil-force-normal-state))

  (defun my-company-yas-snippet ()
    (interactive)
    (company-abort)
    (evil-insert-state)
    (yas-expand))

  (general-unbind 'yas-keymap
    :with 'my-jump-out
    [remap kill-ring-save])

  (defun my-jump-out ()
    (interactive)
    (evil-append 1))

  (defun my-yas-load-other-window ()
    (interactive)
    (yas-load-snippet-buffer '## t)
    (other-window -1))

  (defun my-yas-load-other-kill-contents-other-window ()
    (interactive)
    (yas-load-snippet-buffer '## t)
    (other-window -1)
    (kill-buffer-contents)
    (evil-insert-state))

  (defun my-yas-before-hooks ()
    (interactive)
    (electric-operator-mode -1))

  (defun my-yas-after-hooks ()
    (interactive)
    (electric-operator-mode +1))

  (general-imap
    :keymaps 'yas-minor-mode-map
    "M-u" 'ivy-yasnippet)

  (general-nmap
    :keymaps 'yas-minor-mode-map
    "M-u" 'ivy-yasnippet)

  (general-unbind 'snippet-mode-map
    :with 'ignore
    [remap my-quiet-save-buffer]
    [remap save-buffer]
    [remap my-save-buffer])

  (general-define-key
   :keymaps 'snippet-mode-map
   "<C-return>" 'yas-load-snippet-buffer-and-close
   "<M-return>" 'my-yas-load-other-window
   "<C-M-return>" 'my-yas-load-other-kill-contents-other-window
   "C-c ," 'hydra-yasnippet/body
   "M-;" 'hydra-yasnippet/body)

  (general-imap
    :keymaps 'snippet-mode-map
    "C-c ," 'hydra-yasnippet/body
    "M-;" 'hydra-yasnippet/body
    "DEL" 'evil-delete-backward-char-and-join)

  (yas-global-mode +1)
  )

(use-package yasnippet-snippets
  :after yasnippet)

(use-package ivy-yasnippet
  :after yasnippet)

(use-package elisp-mode
  :ensure nil
  :init
  (add-hook 'lisp-mode-hook 'my-elisp-hooks)
  (add-hook 'emacs-lisp-mode-hook 'my-elisp-hooks)
  (add-hook 'lisp-interaction-mode 'my-elisp-hooks)
  :config

  (general-unbind 'lisp-interaction-mode-map
    :with 'evil-ex-nohighlight
    [remap my-save-buffer]
    [remap save-buffer])

  (general-unbind 'emacs-lisp-mode-map
    :with 'my-goto-package-elisp-file
    [remap my-goto-package])

  (defun my-elisp-hooks ()
    (interactive)
    (evil-smartparens-mode -1)
    (lispy-mode +1)
    (lispyville-mode +1)
    (hs-minor-mode +1)
    (electric-operator-mode -1)))

(use-package lispy
  :defer t
  :config
  (setq lispy-safe-threshold 375)

  (defun my-lispy-kill ()
    (interactive)
    (lispy-kill)
    (evil-insert-state))

  (general-define-key
   :keymaps 'lispy-mode-map
   "M-y" 'my-yank-pop
   "C-:"     'helpful-variable
   "C-;" 'helpful-at-point
   )

  (general-define-key
   :keymaps 'lispy-mode-map
   :states '(normal visual)
   ";" 'evil-ex)

  (general-define-key
   :keymaps 'lispy-mode-map
   :states '(normal insert visual)
   "M-y" 'my-yank-pop
   "M-r" 'ivy-switch-buffer
   "M-s" 'last-buffer
   "C-:"     'helpful-variable
   "C-;" 'helpful-at-point
   "M-p" 'my-paragraph-backwards
   "M-n" 'my-paragraph-forward)

  (general-unbind 'lispy-mode-map
    :states '(insert)
    :with 'self-insert-command
    "["
    "]")

  (general-unbind 'lispy-mode-map
    :states '(insert)
    :with 'tab-to-tab-stop
    "M-i")

  (general-unbind 'lispy-mode-map
    :states '(normal visual insert)
    :with 'last-buffer
    "M-s")

  (general-unbind 'lispy-mode-map
    :with 'last-buffer
    [remap lispy-splice])

  (general-unbind 'lispy-mode-map
    :with 'indent-buffer
    [remap lispy-meta-return])

  (general-unbind 'lispy-mode-map
    :with 'eyebrowse-prev-window-config
    "M-q")

  (general-unbind 'lispy-mode-map
    :with 'my-eval-buffer-and-leave-org-source
    [remap lispy-mark-symbol])

  (general-unbind 'lispy-mode-map
    :states '(normal visual)
    :with 'my-eval-buffer-and-leave-org-source
    "<backspace>"))

(use-package lispyville
  :after lispy
  :config
  (general-define-key
   :keymaps 'lispyville-mode-map
   "C-M-h" 'lispyville-beginning-of-defun
   "C-M-l" 'lispyville-end-of-defun
   "C-M-k" 'lispy-up-slurp
   "C-M-j" 'lispy-down-slurp)

  (general-nmap
    :keymaps 'lispyville-mode-map
    "<" 'lispyville-barf
    ">" 'lispyville-slurp)

  (general-unbind 'lispyville-mode-map
    :with 'lispyville-comment-or-uncomment
    [remap evil-commentary])

  (general-unbind 'lispyville-mode-map
    :with 'evil-jump-backward
    [remap lispy-string-oneline])

  (with-eval-after-load 'lispyville
    (lispyville-set-key-theme
     '(operators
       c-w
       (escape insert)
       (additional-movement normal visual motion)))))

(use-package lisp-mode
  :ensure nil
  :init
  (add-to-list 'auto-mode-alist '("\\.cl\\'" . lisp-mode)))

(use-package racket-mode
  :disabled
  :init
  (add-to-list 'auto-mode-alist '("\\rkt\\'" . racket-mode))
  (add-hook 'racket-mode-hook 'my-racket-hooks)
  (add-hook 'racket-repl-mode-hook 'my-racket-repl-hooks)

  ;; https://stackoverflow.com/a/6141681
  ;; (add-hook 'racket-mode-hook
  ;;           (lambda ()
  ;;             (add-hook 'write-contents-functions (lambda() (delete-trailing-whitespace)) nil t)))

  :config
  (setq racket-program "/usr/local/bin/racket")
  ;; (advice-add 'racket-repl-switch-to-edit :after #'evil-insert-state)
  (advice-add 'racket-repl-and-switch-to-repl :after #'evil-insert-state)

  (setq racket-command-startup +1)

  (defun my-racket-repl-switch-to-edit ()
    (interactive)
    (comint-clear-buffer)
    (racket-repl-switch-to-edit))

  (defun my-racket-delete-repl ()
    (interactive)
    (delete-windows-on "*Racket REPL*"))

  (defun my-racket-hooks ()
    (interactive)
    (smartparens-mode -1)
    (smartparens-strict-mode -1)
    (evil-smartparens-mode -1)
    (rainbow-delimiters-mode +1)
    (aggressive-indent-mode +1)
    (lispyville-mode +1)
    (racket-smart-open-bracket-mode +1)
    (flycheck-mode +1)
    (my-company-idle-two-prefix-one)
    )

  (defun my-racket-repl-hooks ()
    (interactive)
    (evil-smartparens-mode -1)
    (smartparens-mode -1)
    (hide-mode-line-mode +1)
    (racket-smart-open-bracket-mode +1)
    (tab-jump-out-mode +1)
    (rainbow-delimiters-mode +1)
    (company-mode +1)
    (lispyville-mode +1)
    (my-company-idle-one-prefix-one-quiet))

  (general-define-key
   :keymaps 'racket-mode-map
   :states   '(normal visual)
   "RET" 'hydra-racket-mode/body)

  (general-define-key
   :keymaps 'racket-describe-mode-map
   "<escape>" 'delete-window
   "q" 'delete-window)

  (general-nvmap
    :keymaps 'racket-describe-mode-map
    "<escape>" 'delete-window)

  (general-define-key
   :keymaps 'racket-mode-map
   :states   '(normal visual insert)
   "C-ç" 'racket-doc
   "C-c d" 'racket-doc
   "C-x e" 'racket-send-definition
   "C-x C-x" 'racket-send-definition
   "M-[" 'racket-repl
   "C-k" 'my-lispy-kill
   "C-c l" 'racket-insert-lambda
   "C-c ESC" 'my-racket-delete-repl
   "<C-return>" 'racket-run-and-switch-to-repl
   "C-c RET" 'racket-repl
   "C-;" 'racket-repl
   "C-/"   'racket-repl)

  (general-nmap
    :keymaps 'racket-repl-mode-map
    "<escape>" 'ignore)

  ;; (general-nmap
  ;;   :keymaps 'racket-mode-map
  ;;   "<escape>" 'my-other-window)

  (general-define-key
   :keymaps 'racket-repl-mode-map
   :states   '(normal visual insert)
   "M-," 'nswbuff-switch-to-previous-buffer
   "M-." 'nswbuff-switch-to-next-buffer
   "C-ç" 'racket-doc
   "C-k" 'my-lispy-kill
   "C-c C-p" 'racket-cycle-paren-shapes
   "C-;" 'my-racket-repl-switch-to-edit
   "<C-return>" 'my-racket-repl-switch-to-edit
   "C-l" 'comint-clear-buffer
   "C-/"   'racket-repl-switch-to-edit)

  (general-define-key
   :keymaps 'racket-mode-map
   :states   '(normal)
   "8" 'my-insert-*-space
   "*" 'my-insert-8
   "="   'my-insert-plus-space
   "-"   'my-insert-minus-space
   "9" 'my-racket-open-bracket)

  (defun my-racket-open-bracket ()
    (interactive)
    (evil-insert-state)
    (racket-smart-open-bracket))

  (defun my-insert-close-paren ()
    (interactive)
    (evil-insert-state)
    (insert ")"))

  (defun my-insert-paren ()
    (interactive)
    (evil-insert-state)
    (insert "()")
    (backward-char 1))

  (defun my-insert-9 ()
    (interactive)
    (evil-insert-state)
    (insert "9"))

  (defun my-insert-0 ()
    (interactive)
    (evil-insert-state)
    (insert "0"))

  (general-define-key
   :keymaps 'racket-mode-map
   :states   '(insert)
   "8" 'my-insert-*-space
   "*" 'my-insert-8
   "9" 'racket-smart-open-bracket
   "(" 'my-insert-9
   "0" 'my-insert-close-paren
   "C-ç" 'racket-doc
   ")" 'my-insert-0)

  (general-define-key
   :keymaps 'racket-repl-mode-map
   :states   '(insert)
   "C-ç" 'racket-doc
   "C-i" 'evil-normal-state
   "C-u" 'kill-whole-line
   "8" 'my-insert-*-space
   "*" 'my-insert-8
   "9" 'racket-smart-open-bracket
   "(" 'my-insert-9
   "0" 'my-insert-close-paren
   ")" 'my-insert-0
   "C-n" 'comint-next-input
   "C-p" 'comint-previous-input)

  (general-unbind 'racket-repl-mode-map
    "C-w"))

(use-package flycheck
  ;; :defer t
  ;; :init
  ;; (eval-after-load 'flycheck
  ;;   '(flycheck-add-mode 'html-tidy 'html-mode))

  ;; (eval-after-load 'flycheck
  ;;   '(flycheck-add-mode 'css-stylelint 'css-mode))
  ;; (add-hook 'flycheck-mode-hook 'flycheck-buffer)
  :ensure t
  :config
  (general-define-key
   :keymaps 'flycheck-mode-map
   :states '(normal visual insert)
   "ç" 'flycheck-display-error-at-point)

  (setq-local flycheck-idle-change-delay 0.5)

  (setq flycheck-mode-line nil
        flycheck-gcc-warnings nil
        flycheck-clang-warnings nil
        flycheck-display-errors-delay 0.3
        flycheck-idle-change-delay 0.5
        flycheck-clang-pedantic t
        flycheck-gcc-pedantic t
        ;; flycheck-python-mypy-executable "~/.pyenv/shims/mypy"
        flycheck-check-syntax-automatically '(idle-change mode-enabled)
        flycheck-sh-shellcheck-executable "/usr/local/bin/shellcheck"))

(use-package flymake
  :defer t
  :ensure nil
  :init
  (setq-default flymake-no-changes-timeout 0.2))

(use-package tab-jump-out
  :defer t
  :ensure t
  :config
  (tab-jump-out-mode t))

(use-package electric-operator
  :defer t
  :ensure t
  :config
  (electric-operator-add-rules-for-mode 'python-mode
                                        (cons "+" " + ")
                                        (cons "-" " - ")
                                        (cons "ndd" " and ")
                                        (cons "ntt" " not "))

  (electric-operator-add-rules-for-mode 'text-mode
                                        (cons "." #'electric-operator-docs-.)
                                        (cons "," ", ")
                                        (cons ";" "; ")
                                        (cons ":" ": ")))

(use-package aggressive-indent
  :defer t
  :ensure t
  :config
  (setq aggressive-indent-sit-for-time 0.05))

(use-package elec-pair
  :defer t
  :config
  (electric-pair-mode +1))

(use-package highlight-numbers
  ;; :if window-system
  :defer t
  :ensure t)

(use-package highlight-operators
  ;; :if window-system
  :defer t
  :ensure t)

(use-package rainbow-delimiters
  :defer t
  :ensure t)

(use-package with-editor
  :disabled
  :ensure nil
  :init
  (add-hook 'with-editor-mode-hook #'my-with-editor-hooks)
  :config
  (defun my-with-editor-hooks ()
    (interactive)
    (my-prose-enable)
    (flyspell-mode -1)
    (evil-insert-state))

  (general-define-key
   :keymaps 'with-editor-mode-map
   "<C-return>" 'with-editor-finish)

  (general-unbind 'with-editor-mode-map
    :with 'with-editor-cancel
    [remap my-ex-noh])

  )

(use-package magit
  :disabled
  :init
  (add-hook 'magit-post-stage-hook 'my-magit-after-stage-hooks)
  :config
  (defun my-magit-stage-untracked ()
    (interactive)
    (progn
      (magit-status-setup-buffer)
      (goto-char (point-min))
      (magit-section-forward-sibling)
      (magit-stage)
      (magit-mode-bury-buffer)))

  (defun my-magit-stage-modified-and-commit ()
    (interactive)
    (progn
      (let ((current-prefix-arg '(4))) (magit-stage-modified))
      (magit-commit-create)))

  ;; (defun my/magit-stage-this-file-and-commit ()
  ;;   (interactive)
  ;;   (progn
  ;;     (my/tangle-this-file-quiet)
  ;;     (magit-stage-modified)
  ;;     (magit-commit-create)))

  (defun my-magit-after-stage-hooks ()
    (interactive)
    (message " staging complete"))

  (add-to-list 'magit-no-confirm 'stage-all-changes)

  (global-magit-file-mode +1))

(use-package evil-magit
  :disabled
  :after magit)

(use-package gitignore-mode
  :defer t
  :init
  (add-hook 'gitignore-mode-hook 'my-prog-mode-hooks)
  :ensure t)

(use-package git-timemachine
  ;; :if window-system
  :defer t
  ;; :init
  ;; (add-hook 'git-timemachine-mode-hook 'hydra-git-timemachine/body)
  :config

  (general-define-key
   :states '(normal visual insert)
   :keymaps 'git-timemachine-mode-map
   "r" 'write-file)

  (general-unbind 'git-timemachine-mode-map
    :with 'git-timemachine-show-next-revision
    [remap evil-paste-pop-next])

  (general-unbind 'git-timemachine-mode-map
    :with 'git-timemachine-show-previous-revision
    [remap evil-paste-pop])

  (general-unbind 'git-timemachine-mode-map
    :with 'hydra-git-timemachine/body
    [remap org-open-at-point-global])

  (general-define-key
   :keymaps 'git-timemachine-mode-map
   "C-c s" 'git-timemachine-show-commit
   "C-c b" 'git-timemachine-switch-branch
   "C-c k" 'git-timemachine-kill-revision
   "C-c n" 'git-timemachine-show-nth-revision
   "C-c r" 'git-timemachine-show-current-revision))

(use-package quickrun
  :defer nil
  :init
  (add-hook 'quickrun--mode-hook   'my-quickrun-hooks)

  :config
  (defun my-quickrun-hooks ()
    (interactive)
    (hide-mode-line-mode +1)
    (hl-line-mode +1)
    (rainbow-delimiters-mode +1))

  (defun my-quickrun-quit ()
    (interactive)
    (quit-window)
    (my-recenter-window)
    ;; (my-evil-bottom)
    (redraw-display))

  (general-nvmap
    :keymaps 'quickrun--mode-map
    "M-p" 'my-paragraph-backwards
    "M-n" 'my-paragraph-forward
    "i" 'my-quickrun-quit
    "<C-return>" 'my-quickrun-quit
    "RET" 'my-quickrun-quit
    ";" 'my-quickrun-quit)

  (general-nmap
    :keymaps 'quickrun--mode-map
    "<escape>" 'my-quickrun-quit
    "RET" 'my-quickrun-quit)

  (defun my-quickrun ()
    (interactive)
    (save-buffer)
    (quickrun))

  (general-unbind 'quickrun--mode-map
    :with 'my-quickrun-quit
    [remap my-quiet-save-buffer])

  (general-unbind 'compilation-mode-map
    :with 'my-quickrun-quit
    [remap my-quiet-save-buffer]))

(use-package dumb-jump
  :defer t
  :ensure t
  :config
  (defun my-dumb-jump-go ()
    (interactive)
    (save-buffer)
    (dumb-jump-go))
  (setq dumb-jump-quiet 't
        dumb-jump-aggressive 't
        dumb-jump-selector 'ivy))

(use-package evil-smartparens
  :after evil
  :config
  (general-unbind 'evil-smartparens-mode-map
    :with 'exchange-point-and-mark
    [remap evil-sp-override]))

(use-package smartparens
  :defer t)

(use-package csv-mode
  :defer t
  :init
  (add-hook 'csv-mode-hook 'my-prog-mode-hooks)
  (add-hook 'csv-mode-hook 'auto-revert-mode))

(use-package projectile
  :defer t
  :init
  (defvaralias 'projectile-globally-ignored-buffers 'nswbuff-exclude-buffer-regexps)
  :config
  ;;;; SETTINGS ;;;;
  (setq projectile-globally-ignored-directories '(".hg"
                                                  ".git"
                                                  ".old"
                                                  ".bzr"
                                                  ".tox"
                                                  ".svn"
                                                  ".idea"
                                                  "~/.e/"
                                                  "~/org"
                                                  ".eunit"
                                                  "_darcs"
                                                  "~/maps"
                                                  "~/.fzf/"
                                                  "~/.tmux/"
                                                  "_FOSSIL_"
                                                  "~/.pyenv/"
                                                  "~/.irssi/"
                                                  ".fslckout"
                                                  "~/scripts/"
                                                  "~/.config/"
                                                  "~/dotfiles"
                                                  "~/.emacs.d"
                                                  ".stack-work"
                                                  ".ensime_cache"
                                                  "~/Studying/UFBA"
                                                  "~/.emacs.d/quelpa"
                                                  "~/.emacs_anywhere/"
                                                  "~/.PyCharmCE2019.1/"
                                                  "*PyCharmCE2019*"
                                                  "~/maps/.emacs_anywhere"
                                                  "/home/dotfiles/.emacs.d/"
                                                  "~/Studying/Unifacs/Segundo_Semestre"))

  (setq projectile-enable-caching 't)
  (setq projectile-mode-line-prefix " <p>")
  (setq projectile-mode-line-function
        '(lambda () (format " <p> [%s]" (projectile-project-name))))

;;;; FUNCTIONS ;;;;

  (defun my-projectile-ranger ()
    "Open `ranger' at the root of the project."
    (interactive)
    (ranger (projectile-ensure-project (projectile-project-root))))

  (defun my-counsel-projectile-commands ()
    (interactive)
    (counsel-M-x "^counsel-projectile "))

  (defun my-projectile-show-commands ()
    (interactive)
    (counsel-M-x "^projectile- "))

;;;; KEYBINDINGS ;;;;

  (general-define-key
   :keymaps 'projectile-command-map
   "ESC" 'keyboard-quit
   "TAB" 'projectile-project-buffers-other-buffer)

  ;; (general-nvmap
  ;;   :keymaps 'override
  ;;   "M-r" 'ivy-switch-buffer)
  (projectile-mode +1))

(use-package counsel-projectile
  :defer 3
  :config
  (counsel-projectile-mode 1))

(define-generic-mode 'xmodmap-mode
  '(?!)
  '("add" "clear" "keycode" "keysym" "pointer" "remove")
  nil
  '("[xX]modmap\\(rc\\)?\\'")
  nil
  "Simple mode for xmodmap files.")
(add-to-list 'auto-mode-alist '("\\xmodmaps?\\'" . xmodmap-mode))

(use-package elpy
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  (add-hook 'elpy-mode-hook 'my/elpy-hooks)
  :config
  ;; (setq highlight-indentation-blank-lines 't)
  (setq elpy-rpc-python-command "/Users/davi/.pyenv/shims/python")
  (setq elpy-autodoc-delay 3)
  (setq elpy-rpc-virtualenv-path 'current)
  (general-unbind 'normal elpy-mode-map
    :with 'yafolding-toggle-element
    [remap elpy-folding-toggle-at-point])

  (defun my/elpy-hooks ()
    (interactive)
    (my/disable-eldoc)
    (pyenv-mode +1))

  (defun my/disable-eldoc ()
    (interactive)
    (eldoc-mode -1))

  (defun elpy-goto-definition ()
    (interactive)
    (elpy-rpc-warn-if-jedi-not-available)
    (let ((location (elpy-rpc-get-definition)))
      (if location
          (elpy-goto-location (car location) (cadr location))
        (error "No definition found")))
    (save-excursion
      (evil-scroll-line-to-center 1)))

  (general-define-key
   :keymaps 'elpy-mode-map
   "C-x m" 'elpy-multiedit
   "C-x ESC" 'elpy-multiedit-stop
   "C-c d" 'elpy-doc)

  (defun my/elpy-switch-to-buffer ()
    (interactive)
    (elpy-shell-switch-to-buffer)
    (quit-windows-on "*Python*")))

(use-package pyenv-mode
  :after pyenv
  :config
  (pyenv-mode))

(use-package jedi
  :after python)

(use-package python
  :defer t
  :ensure nil
  :init
  (add-hook 'python-mode-hook 'my/python-hooks)
  ;; https://stackoverflow.com/a/6141681
  ;; (add-hook 'python-mode-hook
  ;;           (lambda ()
  ;;             (add-hook 'write-contents-functions (lambda() (elpy-black-fix-code)) nil t)))

  :config
  (font-lock-add-keywords 'python-mode
                          '(("cls" . font-lock-keyword-face)))
  (setq python-shell-interpreter "python3")
  (setq python-shell-interpreter-args "-i -q")

  (setq python-shell-completion-native-enable nil)

  (defun my/python-hooks ()
    (interactive)
    (electric-operator-mode +1)
    (flycheck-mode +1)
    (yafolding-mode +1)
    (rainbow-delimiters-mode +1)
    (highlight-operators-mode +1)
    (evil-swap-keys-swap-double-single-quotes)
    (evil-swap-keys-swap-underscore-dash)
    (smartparens-strict-mode +1)
    (my-company-idle-two-prefix-one-quiet)
    (highlight-numbers-mode +1)
    (blacken-mode +1)
    ;; (importmagic-mode +1)
    (elpy-enable +1)
    (flymake-mode -1))
  (add-to-list 'company-backends 'company-jedi)
  ;; (setq-local company-backends '(company-jedi
  ;;                                company-dabbrev-code
  ;;                                company-files
  ;;                                (company-semantic
  ;;                                 company-capf
  ;;                                 company-keywords
  ;;                                 company-dabbrev
  ;;                                 company-shell)))

  (defun my/olivetti-narrow ()
    (interactive)
    (olivetti-mode +1)
    (setq-local olivetti-body-width 60))

  (defun my/inferior-python-mode-hooks ()
    (interactive)
    (line-numbers)
    (subword-mode 1)
    (electric-operator-mode)
    (company-mode))
  ;; PYTHON KEYS ;;
  (general-define-key
   :keymaps 'inferior-python-mode-map
   "M-e" 'counsel-shell-history
   "C-c j" 'my/evil-shell-bottom
   "C-c u" 'universal-argument
   "C-u" 'comint-kill-input
   "C-l" 'comint-clear-buffer
   "C-;" 'my/elpy-switch-to-buffer
   "C-n" 'comint-next-input
   "C-p" 'comint-previous-input)

  (general-unbind 'inferior-python-mode-map
    :with 'ignore
    [remap save-buffer]
    [remap evil-normal-state])

  (general-unbind 'python-mode-map
    :with 'elpy-folding-toggle-at-point
    [remap hs-toggle-hiding])

  (general-unbind 'python-mode-map
    :with 'my-python-shebang
    [remap my-bash-shebang])

  (general-define-key
   :keymaps 'python-mode-map
   "<escape>" 'my-save-buffer-only
   "<M-return>" 'blacken-buffer
   "M-a" 'python-nav-backward-statement
   "M-e" 'python-nav-forward-statement
   "C-S-p" 'python-nav-backward-sexp
   "C-S-n" 'python-nav-forward-sexp
   "C-x o" 'my/olivetti-narrow
   "C-x m" 'elpy-multiedit-python-symbol-at-point
   "C-x M" 'elpy-multiedit-stop
   "C-c g" 'my/counsel-ag-python
   "M-m" 'flycheck-first-error
   "C-c p" 'my/python-make-print
   "C-c f" 'my/python-make-fstring
   "C-c DEL" 'my/erase-python-file
   "C-c =" 'my/erase-python-file-and-yank
   )

  (general-unbind 'python-mode-map
    :with 'yafolding-hide-all
    [remap evil-close-folds])

  (general-nmap
    :keymaps 'python-mode-map
    "<escape>" 'save-buffer)

  (general-nvmap
    :keymaps 'python-mode-map
    "M-a" 'python-nav-backward-statement
    "M-e" 'python-nav-forward-statement
    "C-S-p" 'python-nav-backward-sexp
    "C-S-n" 'python-nav-forward-sexp
    "C-ç" 'my/python-newline-beg
    "zi" 'hs-show-all
    "<backspace>" 'my-eval-buffer-and-leave-org-source
    "<C-return>" 'quickrun
    "<tab>" 'elpy-folding-toggle-at-point
    "<tab>" 'elpy-folding-toggle-at-point
    "RET" 'hydra-python-mode/body
    "zm" 'evil-close-folds
    "gh" 'outline-up-heading
    "gl" 'outline-next-heading
    "zl" 'outline-show-subtree
    "<" 'python-indent-shift-left
    ">" 'python-indent-shift-right
    "gj" 'outline-forward-same-level
    "gk" 'outline-backward-same-level)

  (defun my/python-newline-beg ()
    (interactive)
    (evil-insert-state)
    (newline)
    (beginning-of-line))

  (defun my/python-colon-newline ()
    (interactive)
    (end-of-line)
    (insert ":")
    (newline-and-indent))

  (general-imap
    :keymaps 'python-mode-map
    "C-="   'my/python-colon-newline
    "C-ç" 'my/python-newline-beg
    "<C-return>" 'quickrun
    "C-h" 'python-indent-dedent-line-backspace
    "M-a" 'python-nav-backward-statement
    "M-e" 'python-nav-forward-statement
    "C-S-p" 'python-nav-backward-sexp
    "C-S-n" 'python-nav-forward-sexp
    )

  ;; PYTHON FUNCTIONS;;

  (defun execute-python-program ()
    (interactive)
    (my/window-to-register-91)
    (my/quiet-save-buffer)
    (defvar foo-execute-python)
    (setq foo-execute-python (concat "python3 " (buffer-file-name)))
    (other-window 1)
    (switch-to-buffer-other-window "*Async Shell Command*")
    (shell-command foo))

  (defun my/execute-python-program-shell-simple  ()
    (interactive)
    (my/window-to-register-91)
    (my/quiet-save-buffer)
    (defvar foo-execute-python-simple)
    (setq foo-execute-python-simple (concat "python3 " (prelude-copy-file-name-to-clipboard)))
    (shell-command foo))

  (defun my/ex-python-run ()
    (interactive)
    (evil-ex "w !python3"))

  (defun my/execute-python-program-shell ()
    (interactive)
    (progn
      (my/quiet-save-buffer)
      (prelude-copy-file-name-to-clipboard)
      (shell)
      (sit-for 0.3)
      (insert "source ~/scripts/cline_scripts/smallprompt.sh")
      (comint-send-input)
      (insert "python3 ")
      (yank)
      (comint-send-input)
      (evil-insert-state)
      (sit-for 0.3)
      (comint-clear-buffer)
      (company-mode -1)))

  (general-unbind 'python-mode-map
    :with 'elpy-doc
    [remap helpful-at-point])

  (defun my/run-python-external ()
    (interactive)
    (progn
      (prelude-copy-file-name-to-clipboard)
      (start-process-shell-command
       "call term" nil
       "~/scripts/i3_scripts/show_term_right")))

  (defun my/erase-python-file ()
    (interactive)
    (erase-buffer)
    (insert "#!/usr/bin/env python3\n\n")
    (evil-insert-state)
    (flycheck-clear))

  (defun my/erase-python-file-and-yank ()
    (interactive)
    (erase-buffer)
    (insert "#!/usr/bin/env python3\n\n")
    (yank))

  (defun my/kill-python-file ()
    (interactive)
    (kill-region (point-min) (point-max))
    (insert "#!/usr/bin/env python3\n\n")
    (evil-insert-state)
    (flycheck-clear))

  (defun my/python-save-buffer ()
    (interactive)
    (evil-ex-nohighlight)
    (let ((inhibit-message t))
      (delete-trailing-whitespace)
      (save-buffer)))

  ;; PYTHON SETTINGS

  (setq comment-auto-fill-only-comments t
        python-indent-offset 4
        python-indent-guess-indent-offset nil)

  (auto-fill-mode 1))

(use-package blacken
  ;; :pin melpa-stable
  :defer t
  :config
  (setq blacken-fast-unsafe nil)
  (setq blacken-line-length 79))

(use-package importmagic
  ;; :after python
  :disabled
  :config
  (setq importmagic-python-interpreter "~/.pyenv/shims/python")
  (setq importmagic-be-quiet t)
  (remove-hook 'python-mode-hook 'importmagic-mode))

(use-package anaconda-mode
  :disabled
  :after python)

(use-package company-jedi
  :after python
  :ensure t
  :config
  (add-to-list 'company-backends 'company-jedi))

(use-package py-autopep8
  :after python
  :ensure t)

(use-package live-py-mode
  :defer t
  :ensure t
  :config
  (setq live-py-update-all-delay 1))

(use-package yafolding
  :defer t)

(use-package clipmon
  :defer nil
  :config
  ;; https://github.com/bburns/clipmon/issues/11
  (setq clipmon-transform-trim nil)
  (setq selection-coding-system 'utf-8-unix)
  (clipmon-mode +1))

(use-package delight
  ;; :if window-system
  :after doom-modeline
  :config
  (delight '((projectile-mode nil)
             (sh-mode "[SH]" "Shell-script[bash]")
             (js2-mode "[JS2]" "Javascript-IDE")
             (org-mode "[O]" "Org")
             (fountain-mode "[F]" "Fountain")
             (racket-mode "[RKT]" "Racket")
             (apt-sources-list-mode "[APT]" "apt/sources.list")
             (overwrite-mode " Ovl" t)
             (special-mode "[SPE]" "special")
             (message-mode "[MSG]" "Messages")
             (markdown-mode "[MD]" "Markdown")
             (emacs-lisp-mode "" "*Org.**")
             (fundamental-mode "[FUN]" "Fundamental")
             (python-mode "[PY]" " Python")
             (emacs-lisp-mode "[EL]" "Emacs-Lisp")
             (lisp-interaction-mode "[LIN]" "Lisp Interaction")

             (Org-Src "" "OrgSrc")
             (ivy-mode "" "ivy")
             (undo-tree-mode " " "Undo-Tree")
             (super-save-mode "" "super-save")
             (counsel-mode "" "counsel")
             (abbrev-mode "" "Abbrev")
             (evil-org-mode "" " EvilOrg")
             (elmacro-mode " " "elmacro"))))

(use-package dimmer
  :config
  (setq dimmer-buffer-exclusion-regexps '("*LV*" "^ \\*Minibuf-[0-9]+\\*$" "^ \\*Echo.*\\*$")
        dimmer-fraction 0.2)
  (dimmer-mode +1))

(use-package doom-modeline
  :after doom-themes
  :init
  (add-hook 'doom-modeline-mode-hook 'setup-custom-doom-modeline)
  ;; Resolve lag:
  ;; https://github.com/seagle0128/doom-modeline#faq
  (setq inhibit-compacting-font-caches t)
  (setq auto-revert-check-vc-info nil)

  :config
  (defun my-doom-modeline-settings ()
    (interactive)
    (setq doom-modeline-icon nil))

  (setq doom-modeline-icon t
        find-file-visit-truename t
        doom-modeline-minor-modes nil
        doom-modeline-indent-info nil
        doom-modeline-env-version nil
        doom-modeline-vcs-max-length 12
        doom-modeline-env-enable-go nil
        doom-modeline-major-mode-icon t
        doom-modeline-buffer-state-icon nil
        doom-modeline-buffer-encoding nil
        doom-modeline-enable-word-count t
        doom-modeline-env-enable-ruby nil
        doom-modeline-env-enable-perl nil
        doom-modeline-env-enable-rust nil
        doom-modeline-env-load-string "."
        doom-modeline-env-enable-python nil
        doom-modeline-env-enable-elixir nil
        doom-modeline-major-mode-color-icon t
        doom-modeline-checker-simple-format t
        doom-modeline-buffer-modification-icon nil
        doom-modeline-buffer-file-name-style 'buffer-name)

  (doom-modeline-def-modeline 'my-simple-modeline
                              '(bar
                                workspace-name
                                window-number
                                modals
                                matches
                                buffer-info
                                remote-host
                                buffer-position
                                selection-info
                                " "
                                bar
                                word-count
                                )

                              '(objed-state
                                misc-info
                                persp-name
                                ;; fancy-battery
                                irc
                                mu4e
                                github
                                debug
                                lsp
                                minor-modes
                                input-method
                                indent-info
                                buffer-encoding
                                major-mode
                                "    "))

  (defun setup-custom-doom-modeline ()
    (interactive)
    (doom-modeline-set-modeline 'my-simple-modeline 'default))

  (doom-modeline-def-modeline 'my-minimal-modeline
                              '("")

                              '(misc-info))

  (defun setup-minimal-doom-modeline ()
    (interactive)
    (doom-modeline-set-modeline 'my-minimal-modeline nil))

  (doom-modeline-mode +1))

(use-package hide-mode-line
:defer t
:ensure t)

(use-package telephone-line
  :disabled
  :config
  (telephone-line-mode +1))

(use-package smart-mode-line
  :disabled
  :config
  (setq sml/no-confirm-load-theme t)
  (sml/setup))

(use-package doom-themes
  ;; :disabled
  :config
  (doom-themes-org-config)
  (load-theme 'doom-dracula t)
  ;; (load-theme 'doom-gruvbox t)
  )

(use-package dracula-theme
  :disabled
  :config
  (setq dracula-enlarge-headings nil)
  (load-theme 'dracula t))

(defun text-scale-reset ()
  (interactive)
  (text-scale-adjust 0)
  (message ""))

(defun my-previous-window ()
  (interactive)
  (other-window -1))

(defun my-split-below ()
  (interactive)
  (split-window-below)
  (other-window 1))

(defun my-split-right ()
  (interactive)
  (split-window-right)
  (other-window 1))

(defun my-split-vertically ()
  (interactive)
  (split-window-vertically)
  (other-window 1))

(defun my-evil-botright ()
  (interactive)
  (evil-window-new 1 "*scratch*")
  (evil-window-move-very-bottom))

(defalias 'my-evil-very-bottom 'my-evil-botright)

(defun my-evil-very-right ()
  (interactive)
  (split-window-right)
  (other-window 1)
  (evil-window-move-far-right))

(defun my-evil-very-left ()
  (interactive)
  (split-window-right)
  (other-window 1)
  (evil-window-move-far-left))

(defun my-evil-very-top ()
  (interactive)
  (split-window-right)
  (other-window 1)
  (evil-window-move-very-top))

(defun my-evil-inc-width-small ()
  (interactive)
  (let ((current-prefix-arg 6))
    (call-interactively 'evil-window-increase-width)))

(defun my-evil-dec-width-small ()
  (interactive)
  (let ((current-prefix-arg 6))
    (call-interactively 'evil-window-decrease-width)))

(defun my-evil-inc-height-small ()
  (interactive)
  (let ((current-prefix-arg 6))
    (call-interactively 'evil-window-increase-height)))

(defun my-evil-dec-height-small ()
  (interactive)
  (let ((current-prefix-arg 6))
    (call-interactively 'evil-window-decrease-height)))

(defun my-evil-inc-witdh-large ()
  (interactive)
  (let ((current-prefix-arg 12))
    (call-interactively 'evil-window-increase-witdh-large)))

(defun my-evil-dec-witdh-large ()
  (interactive)
  (let ((current-prefix-arg 12))
    (call-interactively 'evil-window-decrease-witdh-large)))

(defun my-evil-inc-height-large ()
  (interactive)
  (let ((current-prefix-arg 12))
    (call-interactively 'evil-window-increase-height-large)))

(defun my-evil-dec-height-large ()
  (interactive)
  (let ((current-prefix-arg 12))
    (call-interactively 'evil-window-decrease-height-large)))

(defun my-evil-inc-width ()
  (interactive)
  (let ((current-prefix-arg 8))
    (call-interactively 'evil-window-increase-width)))

(defun my-evil-dec-width ()
  (interactive)
  (let ((current-prefix-arg 8))
    (call-interactively 'evil-window-decrease-width)))

(defun my-evil-dec-width-narrower ()
  (interactive)
  (let ((current-prefix-arg 30))
    (call-interactively 'evil-window-decrease-width)))

(defun my-evil-inc-height ()
  (interactive)
  (let ((current-prefix-arg 8))
    (call-interactively 'evil-window-increase-height)))

(defun my-evil-dec-height ()
  (interactive)
  (let ((current-prefix-arg 8))
    (call-interactively 'evil-window-decrease-height)))

(defun my-enlarge-window ()
  (interactive)
  (let ((current-prefix-arg 10))
    (call-interactively 'enlarge-window)))

(defun my-enlarge-window-horizontally ()
  (interactive)
  (let ((current-prefix-arg 10))
    (call-interactively 'enlarge-window-horizontally)))

(defun my-shrink-window ()
  (interactive)
  (let ((current-prefix-arg 10))
    (call-interactively 'shrink-window)))

(defun my-shrink-window-horizontally ()
  (interactive)
  (let ((current-prefix-arg 10))))

(defun my-left-margin-ten ()
  (interactive)
  (set-window-margins (selected-window) 10 1))

(defun my-left-margin-one ()
  (interactive)
  (set-window-margins (selected-window) 1 1))

(use-package zoom
  :defer t
  :custom
  (zoom-size '(0.618 . 0.618)))

;; (run-with-timer 0 (* 2 60) 'redraw-display)

(use-package server
  :ensure nil
  :config
  (defun my-show-server ()
    (interactive)
    (describe-variable 'server-name)))

(setq startup-screen-inhibit-startup-screen t)

(use-package autorevert
  :ensure nil
  :config
  (global-auto-revert-mode 1))

(use-package files
  :init
  ;; (add-hook 'before-save-hook 'delete-trailing-whitespace)
  ;; (add-to-list 'write-file-functions 'redraw-display)
  ;; (setq write-file-functions '(recentf-track-opened-file ))
  :ensure nil
  :config
  ;; (setq write-file-functions '(recentf-track-opened-file undo-tree-save-history-hook))
  (setq save-silently t
        version-control t
        kept-new-versions 5
        kept-old-versions 2
        bookmark-save-flag 1
        delete-old-versions t
        vc-make-backup-files t
        buffer-save-without-query t
        backup-by-copying-when-linked t
        large-file-warning-threshold nil
        backup-directory-alist '(("." . "~/emacs-profiles/my-emacs/var/backup"))
        find-file-suppress-same-file-warnings t)

  (setq auto-save-timeout 30)
  (setq auto-save-interval 150)
  (auto-save-mode -1)
  (auto-save-visited-mode -1)
  (setq-default auto-save-visited-mode nil)
  )

(use-package prog-mode
  :ensure nil
  :init
  (add-to-list 'auto-mode-alist '("\\prog\\'" . prog-mode))
  (add-hook 'prog-mode-hook 'my-prog-mode-hooks)
  :config

  (defun my-prog-mode-hooks ()
    (interactive)
    (let ((inhibit-message t))
      (company-mode +1)
      (hl-line-mode +1)
      (comment-auto-fill)
      (show-paren-mode +1)
      (company-mode +1)
      (toggle-truncate-lines +1)
      (evil-smartparens-mode +1)
      (yas-minor-mode +1)))

  (defun my-prog-save-buffer ()
    (interactive)
    (delete-trailing-whitespace)
    (save-buffer))

  (defun my-insert-* ()
    (interactive)
    (evil-insert-state)
    (insert "*"))

  (defun my-insert-*-space ()
    (interactive)
    (evil-insert-state)
    (insert "* "))

  (defun my-insert-plus-space ()
    (interactive)
    (evil-insert-state)
    (insert "+ "))

  (defun my-insert-equal-space ()
    (interactive)
    (evil-insert-state)
    (insert "= "))

  (defun my-insert-minus-space ()
    (interactive)
    (evil-insert-state)
    (insert "- "))

  (defun my-insert-0-space ()
    (interactive)
    (evil-insert-state)
    (insert "0 "))

  (defun my-insert-8 ()
    (interactive)
    (evil-insert-state)
    (insert "8"))

  (defun my-insert-1-space ()
    (interactive)
    (evil-insert-state)
    (insert "1 "))

  (defun my-insert-2-space ()
    (interactive)
    (evil-insert-state)
    (insert "2 "))

  (defun my-insert-2-space ()
    (interactive)
    (evil-insert-state)
    (insert "2 "))

  (defun my-insert-3-space ()
    (interactive)
    (evil-insert-state)
    (insert "3 "))

  (defun my-insert-4-space ()
    (interactive)
    (evil-insert-state)
    (insert "4 "))

  (defun my-insert-5-space ()
    (interactive)
    (evil-insert-state)
    (insert "5 "))

  (defun my-insert-6-space ()
    (interactive)
    (evil-insert-state)
    (insert "6 "))

  (defun my-insert-7-space ()
    (interactive)
    (evil-insert-state)
    (insert "7 "))

  (defun my-insert-8-space ()
    (interactive)
    (evil-insert-state)
    (insert "8 "))

  (defun my-insert-9-space ()
    (interactive)
    (evil-insert-state)
    (insert "9 "))

  (general-unbind 'prog-mode-map
    :with 'my-prog-save-buffer
    [remap save-buffer])

  ;; https://www.emacswiki.org/emacs/autofillmode
  (defun comment-auto-fill ()
    (setq-local comment-auto-fill-only-comments t)
    (auto-fill-mode 1))

  (general-imap
    :keymaps 'prog-mode-map
    "<M-return>" 'my-only-indent-buffer)

  (general-nmap
    :keymaps 'prog-mode-map
    "M-p" 'my-paragraph-backwards
    "M-n" 'my-paragraph-forward)

  (general-define-key
   :keymaps 'prog-mode-map
   ;; "C-c 9" 'my-comment-and-format-code-macro
   ;; "C-c y" 'my-company-show-options
   "<C-return>" nil
   "<M-return>" 'my-only-indent-buffer)

  (general-define-key
   :keymaps 'prog-mode-map
   "<M-return>" 'my-only-indent-buffer))

(use-package eldoc
  :defer t
  :ensure nil
  :config
  (setq eldoc-idle-delay 0.5)
  (global-eldoc-mode -1))

(use-package text-mode
  :init
  (add-hook 'text-mode-hook 'my-text-hooks)
  :ensure nil
  :config

  (defun my-text-hooks ()
    (interactive)
    (let ((inhibit-message t))
      ;; (auto-capitalize-mode +1)
      (electric-pair-local-mode +1)
      (show-paren-mode +1)
      (smartparens-mode +1)
      (yas-minor-mode +1)
      (visual-line-mode +1)
      ;; (evil-swap-keys-swap-double-single-quotes)
      )

    (defun my-paragraph-backwards ()
      (interactive)
      (backward-paragraph))

    (defun my-paragraph-forward ()
      (interactive)
      (forward-paragraph)
      (forward-line)
      (back-to-indentation))

    (defun my-enable-auto-agg-fill ()
      (interactive)
      (auto-fill-mode +1)
      (aggressive-fill-paragraph-mode +1)
      (message " both fills enabled"))

    (defun my-disable-auto-agg-fill ()
      (interactive)
      (auto-fill-mode -1)
      (aggressive-fill-paragraph-mode -1)
      (message " both fills disabled"))

    (defun my-prose-enable ()
      (interactive)
      ;; (auto-capitalize-mode 1)
      (electric-operator-mode 1)
      (pabbrev-mode +1)
      (olivetti-mode +1))

    (defun my-prose-english ()
      (interactive)
      (my-prose-enable)
      (flyspell-mode +1)
      (ispell-change-dictionary "english")
      (flyspell-buffer)
      (message " prose english"))

    (defun my-prose-brasileiro ()
      (interactive)
      (my-prose-enable)
      (ispell-change-dictionary "brasileiro")
      (flyspell-mode +1)
      (message " prosa brasileira"))

    (defun my-ispell-english ()
      (interactive)
      (ispell-change-dictionary "english")
      (flyspell-mode +1)
      (message " english"))

    (defun my-ispell-brasileiro ()
      (interactive)
      (ispell-change-dictionary "brasileiro")
      (flyspell-mode +1)
      (message " português"))

    (defun my-ispell-dict-options ()
      (interactive)
      (counsel-M-x "^my-ispell-ask-dict "))

    (defun my-ispell-ask-dict-br ()
      (interactive)
      (ispell-change-dictionary "brasileiro"))

    (defun my-ispell-ask-dict-en ()
      (interactive)
      (ispell-change-dictionary "english"))

    (general-nvmap
      :keymaps 'text-mode-map
      "RET" 'hydra-spell/body)

    (general-define-key
     :keymaps 'text-mode-map
     "C-c -" 'my-insert-em-dash-space
     "C-c C-k" 'pdf-annot-edit-contents-abort
     "M-p" 'my-paragraph-backwards
     "M-n" 'my-paragraph-forward)))

(use-package hideshow
  :defer t
  :ensure nil
  :config

  (general-nvmap
    :keymaps 'hs-minor-mode-map
    "<tab>" 'hs-toggle-hiding)

  (general-unbind 'hs-minor-mode-map
    :with 'hs-toggle-hiding
    [remap evil-toggle-fold])

  (general-unbind 'hs-minor-mode-map
    :with 'hs-hide-all
    [remap evil-close-folds])

  (general-unbind 'hs-minor-mode-map
    :with 'hs-show-all
    [remap outline-show-all]))

;; (use-package select
;;   :ensure nil
;;   :config
;;   (setq x-select-enable-primary nil))

(use-package ibuffer
  :ensure nil
  :init
  (add-hook 'ibuffer-hook 'my-ibuffer-hooks)
  :general
  (general-nvmap
    :keymaps 'ibuffer-mode-map
    "<escape>" 'quit-window
    "C-p" 'ibuffer-backward-line
    "C-n" 'ibuffer-forward-line
    "k" 'ibuffer-backward-line
    "j" 'ibuffer-forward-line
    "C-j" 'my-ibuffer-forward-group
    "C-k" 'my-ibuffer-backward-group)
  :custom
  (ibuffer-expert t)
  (ibuffer-default-shrink-to-minimum-size t)
  (ibuffer-always-show-last-buffer t)
  (ibuffer-saved-filter-groups
   (quote (("default"
            ("org" (mode . org-mode))
            ("elisp" (mode . emacs-lisp-mode))
            ("markdown" (mode . markdown-mode))
            ("emacs" (or
                      (name . "^\\*scratch\\*$")
                      (name . "^\\*Messages\\*$")
                      (name . "^\\*Warnings\\*$") (name . "^\\*info\\*$")))
            ("help" (or
                     (name . "^\\*Help\\*$")
                     (name . "^\\*helpful.*\\*$")))))))

  (ibuffer-directory-abbrev-alist '(("\\`/home/dotfiles/emacs/em/modules/packages/misc/" . "*misc*/")
                                    ("\\`/home/Documents/Studying/Prog/WebDev/" . "*web*/")
                                    ("\\`/home/Documents/Studying/" . "*study*/")
                                    ("\\`/home/Documents/Org/Agenda/" . "*agenda*/")
                                    ("\\`/home/Documents/Org/" . "*org*/")
                                    ("\\`/home/dotfiles/emacs/em/tmp/scratches/" . "*scratches*/")
                                    ("\\`/home/dotfiles/emacs/em/modules/packages/" . "*packages*/")))

  (ibuffer-formats '((" "
                      (name 18 18 :left :elide) "   "
                      (mode 16 16 :left :elide) "   " filename)
                     (mark " " (name 16 -1) " " filename)))

  :config
  (defun my-ibuffer-forward-group ()
    (interactive)
    (ibuffer-forward-filter-group)
    (ibuffer-forward-line))

  (defun my-ibuffer-backward-group ()
    (interactive)
    (ibuffer-backward-filter-group)
    (ibuffer-backward-filter-group)
    (ibuffer-forward-line))

  (defun my-ibuffer-hooks ()
    (interactive)
    (hl-line-mode +1)
    (ibuffer-switch-to-saved-filter-groups "default")
    (olivetti-mode +1))

  (general-unbind 'ibuffer-mode-map
    :with 'ignore
    [remap evil-forward-char]
    [remap evil-forward-word-begin]
    [remap evil-backward-char]
    [remap evil-end-of-visual-line]))

(use-package info
  :ensure nil
  :init
  (add-hook 'Info-mode-hook 'my-info-hook-commands)
  :config

  (defun my-eval-next-sexp-function ()
    (interactive)
    (my-eval-next-sexp-macro))

  (defun my-info-hook-commands ()
    (interactive)
    (line-no-numbers)
    (hl-line-mode +1)
    (centered-cursor-mode +1)
    (hl-sentence-mode)
    (message ""))

  (defun my-info-commands ()
    (interactive)
    (counsel-M-x "^Info- "))

  (general-unbind 'Info-mode-map
    :with 'ignore
    [remap evil-exit-emacs-state])

  (general-unbind 'Info-mode-map
    :with 'evil-ex-nohighlight
    [remap my-quiet-save-buffer])

  (general-unbind 'Info-mode-map
    :with 'last-buffer
    [remap Info]
    ;; [remap Info-exit]
    [remap info])

  (general-unbind 'Info-mode-map
    :with 'ignore
    [remap evil-normal-state])

  (general-nvmap
    :keymaps 'Info-mode-map
    "F"  'avy-goto-word-1-above
    "f"  'avy-goto-word-1-below
    "gf" 'evil-find-char
    "gF" 'evil-find-char-backward
    "C-c C-c" 'eval-last-sexp
    "<C-return>" 'my-eval-next-sexp-function
    "<left>" 'evil-backward-sentence-begin
    "<right>" 'evil-forward-sentence-begin
    "<up>" 'my-paragraph-backwards
    "<down>" 'my-paragraph-forward
    "C-n" 'Info-forward-node
    "C-p" 'Info-backward-node
    "<backspace>" 'link-hint-open-link
    "M-p" 'backward-paragraph
    "M-n" 'forward-paragraph
    "H" 'Info-history-back
    "L" 'Info-history-forward
    "m" 'Info-menu
    "c" 'my-info-commands)

  (general-define-key
   :keymaps 'Info-mode-map
   "<left>" 'evil-backward-sentence-begin
   "<right>" 'evil-forward-sentence-begin
   "H" 'Info-history-back
   "L" 'Info-history-forward
   "c" 'my-info-commands)

  (general-define-key
   :keymaps 'Info-mode-map
   "m" 'Info-menu
   "C-q" 'my-cheat-sheet))

;; (use-package bs
;;   :ensure nil
;;   :init
;;   (setq bs-configurations '(("all" nil nil nil nil nil)

;; 			    ("files" nil nil nil bs-visits-non-file bs-sort-buffer-interns-are-last)

;; 			    ("files-and-scratch" "^\\*scratch\\*$" "^info_keys.org$" nil bs-visits-non-file bs-sort-buffer-interns-are-last)

;; 			    ("all-intern-last" nil nil nil nil bs-sort-buffer-interns-are-last))))

(use-package cc-mode
  :defer t
  ;; :ensure cc-mode
  :init
  (setq-default c-default-style "linux")
  (add-hook 'c-mode-hook 'my-prog-mode-hooks)
  :config
  (defun my-execute-c-program ()
    (interactive)
    (defvar foo-execute-c)
    (setq foo (concat "gcc " (buffer-name) " && ./a.out" ))
    (shell foo))

  (defun my-execute-c-program-shell ()
    (interactive)
    (progn
      (prelude-copy-file-name-to-clipboard)
      (shell)
      (insert "sp")
      (comint-send-input)
      (insert "gcc ")
      (yank)
      (insert " && ./a.out")
      (comint-send-input)
      (sit-for 0.3)
      (comint-clear-buffer)))

  (general-imap
    :keymaps 'c-mode-map
    "<M-return>" 'my-emacs-indent-buffer
    "C-;" 'my-c-semicolon-del-blank-lines)

  (general-nvmap
    :keymaps 'c-mode-map
    "zk" 'flycheck-previous-error
    "zj" 'flycheck-next-error
    "$" 'c-end-of-statement
    "0" 'c-beginning-of-statement
    "M-v" 'c-goto-vars
    "<escape>" 'my-quiet-save-buffer-c
    "<M-return>" 'my-emacs-indent-buffer))

(use-package shell
  :defer t
  :ensure nil
  :init
  (setq comint-terminfo-terminal "ansi")
  (add-hook 'after-save-hook 'my-after-save-hooks)
  (add-hook 'shell-mode-hook 'my-shell-mode-hooks)
  (add-hook 'shell-mode-hook
            (lambda ()
              (face-remap-set-base 'comint-highlight-prompt :inherit nil)))
  :config

  (defun my-shell-below ()
    (interactive)
    (split-window-below)
    (shell)
    (hide-mode-line-mode +1))

  (defun my-shell-full ()
    (interactive)
    (shell)
    ;; (hide-mode-line-mode +1)
    (delete-other-windows))

  (defun my-after-save-hooks ()
    (interactive)
    (executable-make-buffer-file-executable-if-script-p)
    ;; (redraw-display)
    )
  ;; (magit-stage-modified)

  (defun my-shell-mode-hooks ()
    (interactive)
    (subword-mode 1)
    (company-mode 1)
    (tab-jump-out-mode 1)
    (electric-pair-local-mode 1)
    (setq-local company-auto-complete nil)
    (evil-swap-keys-dollar-sign-four)
    (evil-swap-keys-comma-semicolon)
    (evil-swap-keys-swap-double-single-quotes)
    (evil-swap-keys-equal-zero))

  (defun my-shell-go-up ()
    (interactive)
    (insert "cd ..")
    (comint-send-input)
    (comint-clear-buffer)
    (insert "ls")
    (comint-send-input))

  (defun my-shell-go-back ()
    (interactive)
    (comint-clear-buffer)
    (insert "cd - && ls")
    (comint-send-input))

  (defun my-shell-fasd-start ()
    (interactive)
    (insert "jj "))

  (defun my-shell-fasd-complete ()
    (interactive)
    (comint-send-input)
    (comint-clear-buffer)
    (insert "ls")
    (comint-send-input))

  (defun my-shell-go-previous ()
    (interactive)
    (comint-clear-buffer)
    (insert "my-shell-go-previous")
    (comint-send-input)
    (comint-clear-buffer)
    (insert "ls")
    (comint-send-input))
;;; shell_extras.el ends here

  (general-imap
    :keymaps 'shell-mode-map
    "C-u" 'comint-kill-input
    "C-p" 'comint-previous-input
    "C-n" 'comint-next-input
    "C-c u" 'universal-argument
    "C-l" 'comint-clear-buffer
    "C-M-l" 'recenter-top-bottom
    ;; "M-u" 'my-shell-go-up
    "M-u" 'yas-expand
    "M-i" 'my-shell-go-back
    "C-\\" 'my-shell-clear-and-list
    "M-p" 'my-shell-go-previous
    "C-c j" 'my-evil-shell-bottom)

  (nvmap
    :keymaps 'shell-mode-map
    "C-c u" 'universal-argument
    "C-l" 'comint-clear-buffer
    "C-M-l" 'recenter-top-bottom
    "M-u" 'my-shell-go-up
    "M-i" 'my-shell-go-back
    "M-p" 'my-shell-go-previous
    "C-\\" 'my-shell-clear-and-list)

  (general-define-key
   :keymaps 'shell-mode-map
   "C-z" 'evil-normal-state
   "C-u" 'comint-kill-input
   "<M-return>" nil
   "C-t" 'my-shell-go-back
   "C-c 0" 'my-jump-to-register-91
   "C-r" 'counsel-shell-history
   "C-n" 'comint-next-input
   "C-l" 'comint-clear-buffer
   "C-M-l" 'recenter-top-bottom
   "C-c u" 'universal-argument
   "M-p" 'my-shell-go-previous
   "C-p" 'comint-previous-input
   "C-c j" 'my-evil-shell-bottom)

  (general-unbind 'shell-mode-map
    :with 'quit-window
    [remap my-no-highlight])

  (general-unbind 'shell-mode-map
    :with nil
    [remap evil-normal-state]
    [remap evil-exit-emacs-state])

  (general-unbind 'shell-mode-map
    :with 'ignore
    [remap my-save-buffer])

  (general-unbind 'shell-mode-map
    :with nil
    [remap hydra-text-main/body])

  (general-unbind 'shell-mode-map
    :with 'my-shell-resync
    [remap shell-resync-dirs])

  (general-unbind 'shell-mode-map
    :with 'yas-expand
    [remap ivy-yasnippet])

  (defun my-shell-resync ()
    (interactive)
    (comint-kill-whole-line 1)
    (shell-resync-dirs)
    (comint-clear-buffer)
    (insert "ls")
    (comint-send-input))

  (defun my-shell-list ()
    (interactive)
    (insert "ls")
    (comint-send-input))

  (defun my-shell-clear-and-list ()
    (interactive)
    (comint-clear-buffer)
    (insert "ls")
    (comint-send-input))

  (defun my-shell-source-bashrc ()
    (interactive)
    (insert "source ~/.bashrc")
    (comint-send-input)
    (comint-clear-buffer))

  (general-define-key
   :keymaps 'company-active-map
   "<return>" nil))

(use-package eshell
  :defer t
  :ensure nil
  :init
  (setq eshell-banner-message "")
  (setq comint-terminfo-terminal "ansi"))

(use-package calc
  :defer t
  :ensure nil
  :config

  ;; (general-vmap
  ;;   :keymaps 'override
  ;;   "<XF86Calculator>" nil
  ;;   "X" 'my-calc-region)

  (general-nmap
    :keymaps 'override
    ;; "C-c p" 'quick-calc
    "<XF86Calculator>" 'quick-calc)

  (general-nvmap
    :keymaps 'calc-mode-map
    "C-l" 'calc-reset
    "<escape>" 'calc-quit))

(use-package compile
  :ensure nil
  :config

  (setq-default compilation-window-height 30)
  (setq compilation-window-height 30)

  (general-unbind 'compilation-mode-map
    :with 'quit-window
    [remap my-save-buffer])

  (general-nvmap
    :keymaps 'compilation-mode-map
    "i" 'quit-window
    ;; "<escape>" 'quit-window
    "<C-return>" 'quit-window
    "RET" 'quit-window
    "C-/" 'quit-window
    ";" 'quit-window))

(use-package conf-mode
  :defer t
  :ensure nil
  :init
  (add-hook 'conf-space-mode-hook 'my-conf-hooks)
  (add-hook 'conf-unix-mode-hook 'my-conf-hooks)
  :config
  (defun my-conf-hooks ()
    (interactive)
    (subword-mode 1)
    (company-mode 1)
    (flycheck-mode 1)
    (hl-line-mode +1)
    ;; (tab-jump-out-mode 1)
    (electric-operator-mode 1)
    (electric-pair-local-mode 1)
    (highlight-numbers-mode 1)
    (highlight-operators-mode 1)
    (subword-mode 1)
    (highlight-indentation-mode +1)
    (tab-jump-out-mode 1))

  (electric-pair-local-mode 1)
  (general-define-key
   :keymaps 'conf-mode-map
   "M-p" 'my-paragraph-backwards
   "M-n" 'my-paragraph-forward))

(use-package Custom-mode
  :defer t
  :ensure nil
  :config
  (general-nvmap
    :keymaps 'custom-mode-map
    "q" 'Custom-buffer-done)
  (general-nvmap
    :keymaps 'custom-mode-map
    "M-p" 'my-paragraph-backwards
    "M-n" 'my-paragraph-forward)
  (general-define-key
   :keymaps 'custom-mode-map
   "M-p" 'my-paragraph-backwards
   "M-n" 'my-paragraph-forward))

(use-package hippie-exp
  :defer t
  :ensure nil
  :config
  (general-imap
    "M-/" 'hippie-expand))

(use-package term
  :defer nil
  :init
  (add-hook 'term-mode-hook 'my-term-mode-hooks)
  (setq comint-terminfo-terminal "ansi")
  :ensure nil
  :config

  (defun my-term-delete-window ()
    (interactive)
    (delete-windows-on "*terminal*"))

  (defun my-term ()
    (interactive)
    (term "/bin/bash"))

  (defun my-term-below ()
    (interactive)
    (split-window-below)
    (other-window 1)
    (term "/bin/bash")
    (hide-mode-line-mode +1))

  (defun my-term-mode-hooks ()
    (interactive)
    (subword-mode 1)
    ;; (dimmer-mode 1)
    (tab-jump-out-mode 1)
    (electric-pair-local-mode 1))

  (general-unbind 'term-mode-map
    :with 'ignore
    [remap my-quiet-save-buffer]
    [remap save-buffer]
    [remap evil-normal-state])

  (general-unbind 'term-mode-map
    :with 'kill-buffer-and-window
    [remap my-no-highlight])

  (general-unbind 'term-raw-map
    :with 'term-send-raw
    [remap delete-backward-char]
    [remap evil-delete-backward-word]
    [remap delete-backward-word]
    [remap evil-paste-from-register]
    [remap backward-kill-word])

  (general-define-key
   :keymaps 'term-mode-map
   ;; "M-]" 'evil-window-next
   "C-l" 'term-send-raw
   "C-/" 'my-term-delete-window
   "C-p" 'term-send-raw
   "C-n" 'term-send-raw
   "C-a" 'term-send-raw
   "C-e" 'term-send-raw
   "C-k" 'kill-line
   "C-u" 'term-send-raw
   "C-w" 'term-send-raw)

  (general-imap
    :keymaps 'term-mode-map
    ;; "M-]" 'evil-window-next
    "C-l" 'term-send-raw
    "C-/" 'my-term-delete-window
    "C-p" 'term-send-raw
    "C-n" 'term-send-raw
    "C-a" 'term-send-raw
    "C-e" 'term-send-raw
    "C-k" 'kill-line
    "C-u" 'term-send-raw
    "C-w" 'term-send-raw)

  (general-nvmap
    :keymaps 'term-mode-map
    "C-l" 'term-send-raw
    "C-p" 'term-send-raw
    "C-n" 'term-send-raw
    "C-/" 'my-term-delete-window
    "C-u" 'term-send-raw
    "C-w" 'term-send-raw)

  (general-imap
    :keymaps 'term-raw-map
    ;; "M-]" 'evil-window-next
    "C-h" 'term-send-backspace
    "C-/" 'my-term-delete-window
    "M-r" nil))

(use-package sane-term
  :ensure t
  :bind (("C-x t" . sane-term)
    ("C-x T" . sane-term-create)))

(use-package abbrev
  :defer t
  :ensure nil
  :config
  (defun abbrev-edit-save-close ()
    (interactive)
    (abbrev-edit-save-buffer)
    (my-kill-this-buffer))
  (setq-default abbrev-mode t)
  (setq save-abbrevs 'silently)
  (general-define-key
   :keymaps 'edit-abbrevs-map
   "<C-return>" 'abbrev-edit-save-close)
  (general-nvmap
    :keymaps 'edit-abbrevs-mode-map
    [escape] 'abbrev-edit-save-buffer
    "q" 'my-kill-this-buffer))

(use-package help-mode
  :ensure nil
  :init
  (add-hook 'help-mode-hook 'hl-line-mode)
  :config

  (add-to-list 'display-buffer-alist
               '("*Help*" display-buffer-same-window))

  (setq help-window-select t)

  ;; (general-unbind 'org-mode-map
  ;;   :with 'cool-moves-line-backward
  ;;   [remap evil-jump-forward])

  (general-nmap
    :keymaps 'help-mode-map
    "gr" 'sel-to-end
    "<escape>" 'quit-window)

  (general-nvmap
    :keymaps    'help-mode-map
    "<tab>"     'forward-button
    "<backtab>" 'backward-button
    "M-p"       'my-paragraph-backwards
    "M-n"       'my-paragraph-forward
    "gs"        'evil-ex-nohighlight)

  (general-define-key
   :keymaps 'help-mode-map
   ;; "<escape>" 'quit-window
   "M-p" 'my-paragraph-backwards
   "M-n" 'my-paragraph-forward
   "gs" 'evil-ex-nohighlight))

(use-package man
  :defer 5
  :ensure nil
  :init
  (add-hook 'Man-mode-hook 'my-man)

  :config
  (set-face-attribute 'Man-overstrike nil :inherit 'bold :foreground "orange ed")
  (set-face-attribute 'Man-underline nil :inherit 'underline :foreground "forest green")

  (defun my-man ()
    (interactive)
    (other-window -1)
    (hl-line-mode +1)
    (delete-other-windows))

  (general-nvmap
    :keymaps 'Man-mode-map
    "C-x n" 'recursive-narrow-or-widen-dwim
    "q" 'quit-window
    "RET" 'man-follow
    "M-n" 'forward-paragraph
    "M-p" 'backward-paragraph
    "C-p" 'Man-previous-section
    "C-n" 'Man-next-section
    "C-c RET" 'Man-follow-manual-reference)

  (general-define-key
   :keymaps 'Man-mode-map
   "C-'" 'my-reload-theme-macro
   "q" 'quit-window)

  (general-unbind 'Man-mode-map
    :with 'sel-to-end
    [remap Man-update-manpage])


  (general-unbind 'Man-mode-map
    :with 'evil-ex-nohighlight
    [remap my-quiet-save-buffer])

  (general-unbind 'Man-mode-map
    :with 'ignore
    [remap evil-insert]))

(use-package scroll-bar
  :ensure nil
  :config
  (horizontal-scroll-bar-mode -1)
  (scroll-bar-mode -1))

(use-package tool-bar
  :ensure nil
  :config
  (setq tool-bar-mode nil)
  (tool-bar-mode -1))

(use-package paren
  :ensure nil
  :config
  (setq blink-matching-paren-dont-ignore-comments t
        show-paren-ring-bell-on-mismatch nil
        show-paren-style 'parenthesis
        show-paren-when-point-in-periphery t
        show-paren-when-point-inside-paren t)

  (custom-set-faces '(show-paren-match ((t(
                                           :background "#292929"
                                           :foreground "dark orange"
                                           :inverse-video nil
                                           :underline nil
                                           :slant normal
                                           :weight ultrabold))))))

(use-package mouse
  :defer t
  :ensure nil
  :config
  (setq mouse-yank-at-point t))

;; (use-package paragraphs
;;   :defer t
;;   :ensure nil
;;   :config
;;   (setq sentence-end-double-space nil)
;;   (setq sentence-end nil))
(setq sentence-end-double-space nil)
(setq sentence-end nil)

;; (use-package hl-line
;;   ;; :defer t
;;   :ensure nil
;;   :config
;;   (global-hl-line-mode nil))

(use-package warnings
  :ensure nil
  :config
  (setq warning-minimum-level :emergency))

(use-package custom
  :defer t
  :ensure nil
  :init
  (add-hook 'after-load-theme-hook 'my-disable-variable-pitch)
  :config

  ;; http://bit.ly/2rrNnWr
  (defvar after-load-theme-hook nil
    "Hook run after a color theme is loaded using `load-theme'.")

  (defadvice load-theme (after run-after-load-theme-hook activate)
    "Run `after-load-theme-hook'."
    (run-hooks 'after-load-theme-hook))

  ;; http://bit.ly/2WmnClo
  (defadvice load-theme (before disable-before-load)
    "Disable loaded themes before enabling a new theme"
    (dolist (theme custom-enabled-themes)
      (disable-theme theme)))
  (ad-activate 'load-theme)

  (setq custom-safe-themes t)
  ;; (load-theme 'tango-dark t)
  )

(use-package comint
  :defer t
  :ensure nil
  :config
  (setq comint-prompt-read-only t))

(use-package sh-script
  :defer t
  :ensure nil
  :init
  (add-hook 'sh-mode-hook  'my-sh-script-hooks)

  (add-hook 'sh-mode-hook
            (lambda ()
              (add-hook 'write-contents-functions (lambda() (my-indent-buffer)) nil t)))

  :config

  (general-define-key
   :keymaps 'sh-mode-map
   "M-RET" 'my-shfmt-fix-file-and-revert)

  (general-nvmap
    :keymaps 'sh-mode-map
    "RET" 'hydra-prog-mode/body)

  (setq sh-basic-offset 2
        sh-indentation 2
        smie-indent-basic 2)

  (defun my-sh-script-hooks ()
    (interactive)
    (subword-mode 1)
    (company-mode 1)
    (tab-jump-out-mode 1)
    (electric-pair-local-mode 1)
    (evil-swap-keys-dollar-sign-four)
    (evil-swap-keys-comma-semicolon)
    (evil-swap-keys-swap-double-single-quotes)
    (evil-swap-keys-equal-zero))

  (add-to-list 'auto-mode-alist '("\\.inputrc\\'" . sh-mode))
  (add-to-list 'auto-mode-alist '("\\.bash_aliases\\'" . sh-mode)))

(use-package vc-mode
  :defer t
  :ensure nil
  :config

  (setq vc-follow-symlinks t)

  (defun my-vc-push ()
    (interactive)
    (vc-push)
    (other-window 1))

    (general-define-key
     :keymaps 'vc-git-log-edit-mode-map
     "<C-return>" 'log-edit-done)

    (general-nmap
      :keymaps 'vc-git-log-edit-mode-map
      "<escape>" 'log-edit-kill-buffer))

(use-package doc-view
  :defer t
  :ensure nil
  :config
  (setq doc-view-continuous t))

(use-package loaddefs
  :defer t
  :ensure nil
  :config
  ;; (setq browse-url-generic-program "google-chrome-stable")
  (setq browse-url-generic-program nil)
  (setq browse-url-browser-function 'browse-url-generic))

(use-package message
  :ensure nil
  :config

  (general-unbind 'messages-buffer-mode-map
    :with 'last-buffer
    [remap my-quiet-save-buffer]
    [remap save-buffer])

  (general-unbind 'messages-buffer-mode-map
    :with 'my-no-insert-message
    [remap evil-insert])

  (general-unbind 'message-mode-map
    :with 'ivy-switch-buffer
    [remap transpose-words]))

(use-package rmail
  :disabled)

(use-package face-remap
  :disabled)

(use-package diff-mode
  :ensure nil
  :defer t)

(use-package recentf
  :disabled
  :ensure nil
  :config
  (setq recentf-max-menu-items '10
        recentf-auto-cleanup 'mode

        recentf-save-file (expand-file-name "recentf" (concat udir "var/"))
        recentf-exclude   '("Dired"
                            "*.tex"
                            "*slime-repl sbcl"
                            "erc-mode" "help-mode"
                            "completion-list-mode"
                            "/home/dotfiles/emacs/em/var/*.*"
                            "custom.el"
                            "Buffer-menu-mode"
                            "gnus-.*-mode"
                            "occur-mode"
                            "*.Log.*"
                            "*.*log.*"
                            ".*help.*"
                            "^#.*#$"
                            "*Shell Command Output*"
                            "*Calculator*"
                            "*Calendar*"
                            "*Help*"
                            "*Calc Trail*"
                            "magit-process"
                            "magit-diff"
                            "*Org-Babel Error Output*"
                            "\\`\\*helm"
                            "\\`\\*Echo Area"
                            "\\`\\*Minibuf"
                            "Ibuffer"
                            "epc con"
                            "*Shell Command Output*"
                            "*Calculator*"
                            "*Calendar*"
                            "*cheatsheet*"
                            "*Help*"
                            "*Echo Area 0*"
                            "*Echo Area 1"
                            "*Minibuf 0*"
                            "*Minibuf-1*"
                            "info-history"
                            "bookmark-default.el"
                            "company-shell-autoloads.el"
                            "company.el"
                            "pos-tip-autoloads.el"
                            "bookmark-default.el"
                            "company-shell-autoloads.el"
                            "company.el"
                            "pos-tip-autoloads.el"
                            "*scratch*"
                            "*Warning*"
                            "*Messages*"
                            "^init.org$"
                            "^packs.org$"
                            "^functions.org$"
                            "^keys.org$"
                            "^misc.org$"
                            "^macros.org$"
                            "^hydras.org$"
                            "^links.org$"
                            "^custom.el$"
                            "*Flycheck error messages*"
                            "*Flymake log*"
                            "*company-documentation*"
                            "^.archive.org$"
                            ".*magit.*"
                            ".*elc"
                            "*shell*"
                            "*new*"
                            "*Flycheck error messages*"
                            "*clang-output*"
                            "*Bongo Playlist*"
                            "*eclim: problems*"
                            "*eclimd*"
                            "*compilation*"
                            "*Bongo Library*"
                            ;; ".*pdf"
                            "*Outline.*"
                            "*blacken*"
                            "*server*"
                            "*code-conversion-work*"
                            "*blacken-error*"
                            "*quickrun*"
                            "~/.emacs.d/var/*"))

  ;; (recentf-load-list)
  ;; (recentf-mode +1)
  )

(use-package time-date
  :defer nil
  :ensure nil
  :config
  ;;  measure time
  ;;  https://stackoverflow.com/q/23622296

  (defmacro my-measure-time (&rest body)
    "Measure the time it takes to evaluate BODY."
    (interactive)
    `(let ((time (current-time)))
       ,@body
       (message "%.06f" (float-time (time-since time))))))

(use-package simple
  :ensure nil
  :init
  (add-to-list 'auto-mode-alist '("\\fund\\'" . fundamental-mode))
  ;; (add-hook 'after-init-hook 'my-quit-warning-window)
  (add-hook 'completion-list-mode-hook 'my-completion-mode-hooks)
  :config
  (defun my-clone-buffer ()
    (interactive)
    (split-window-below)
    (clone-indirect-buffer-other-window (buffer-name) "1" nil)
    (evil-window-move-far-right))

  (defun my-other-window ()
    (interactive)
    (other-window -1))

  (defun my-completion-mode-hooks ()
    (interactive)
    (forward-paragraph)
    (switch-to-buffer-other-window "*Completions*")
    (hl-line-mode +1))

  (setq pcomplete-help 't
        pcomplete-autolist 't
        pcomplete-ignore-case 't)

  ;; https://www.emacswiki.org/emacs/QuotedInsert
  (setq read-quoted-char-radix 10)

  (setq use-dialog-box nil)
  (setq kill-whole-line 't)

  ;;;; WINDOWS ;;;;
  (setq window-resize-pixelwise t)
  (setq recenter-positions '(top middle bottom))

  (defun my-kill-whole-buffer ()
    (interactive)
    (read-only-mode -1)
    (kill-region (point-min) (point-max))
    (quit-window))

  (defun my-set-fill-120 ()
    (interactive)
    (set-fill-column 120))

  (defun my-set-fill-70 ()
    (interactive)
    (set-fill-column 70))

  (defun my-set-fill-89 ()
    (interactive)
    (set-fill-column 89))

  (fset 'yes-or-no-p 'y-or-n-p)

  (setq-default fringe-indicator-alist (assq-delete-all 'truncation fringe-indicator-alist))
  (setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function kill-buffer-query-functions))

  ;; (setq fill-column 69)
  (setq-default display-line-numbers nil)
  (line-number-mode +1)
  (setq auto-fill-mode t)
  (setq-default auto-fill-mode t)

  (defun my-eval-buffer ()
    (interactive)
    (progn
      (save-excursion
        (eval-buffer)
        (indent-buffer)
        (my-save-all)
        (message " buffer evaluated"))))

  (defun my-eval-buffer-no-save ()
    (interactive)
    (save-excursion
      (indent-buffer)
      (eval-buffer)
      (message " buffer evaluated")))

  (defun my-move-file-to-trash ()
    (interactive)
    (move-file-to-trash (buffer-name))
    (kill-buffer)
    (delete-window))

  (defun my-move-file-to-trash-close-ws ()
    (interactive)
    (move-file-to-trash (buffer-name))
    (kill-buffer)
    (eyebrowse-close-window-config))

  (defun delete-file-and-buffer ()
    (interactive)
    (let ((filename (buffer-file-name)))
      (when filename
        (if (vc-backend filename)
            (vc-delete-file filename)
          (progn
            (delete-file filename)
            (message "Deleted file %s" filename)
            (kill-buffer))))))

  (defun show-fill-column ()
    (interactive)
    (describe-variable 'fill-column))

  (defun show-major-mode ()
    (interactive)
    (describe-variable 'major-mode))

  (defun my-buffer-name ()
    (interactive)
    (message (buffer-name)))

  (setq save-interprogram-paste-before-kill 't)
  (setq backward-delete-char-untabify-method 'hungry)

  (general-unbind 'special-mode-map
    :with 'ignore
    [remap my-quiet-save-buffer]
    [remap save-buffer])

  (setq indent-tabs-mode nil)
  (setq-default indent-tabs-mode nil)

  (global-visual-line-mode +1)

  (auto-save-mode -1)
  (auto-save-visited-mode -1))

(use-package eval
  :defer t
  :ensure nil
  :config
  (setq debug-on-error nil))

(use-package dispnew
  :defer t
  :ensure nil
  :config
  (setq visible-bell nil))

(use-package editfns
  :defer t
  :ensure nil
  :config
  (put 'narrow-to-region 'disabled nil))

(use-package image
  :ensure nil
  :config
  (general-nvmap
    :keymaps 'image-mode-map
    "-" 'image-decrease-size
    "C--" 'image-decrease-size
    "C-=" 'image-increase-size
    "=" 'image-increase-size
    "0" 'image-transform-fit-to-width
    "RET" 'image-transform-fit-to-width
    "q" 'image-kill-buffer))
;; "<escape>" 'my-quit-window

(use-package time
  :ensure nil
  :config
  ;; (setq-default display-time-format "| %a, %H:%M |")
  (setq-default display-time-format "| %a, %B %d | %H:%M |")
  (setq-default display-time-default-load-average nil)
  ;; (display-time)
  ;; (display-time-mode +1)
  )

(use-package minibuffer
  :ensure nil
  :config
  (defun my-complete-at-point ()
    (interactive)
    (completion-at-point)
    (insert "\n"))

  (general-define-key
   :keymaps 'minibuffer-inactive-mode-map
   "<S-insert>" 'yank
   "C-h" 'delete-backward-char)

  (general-define-key
   :keymaps 'minibuffer-local-map
   "<escape>" 'abort-recursive-edit
   "C-u" 'my-backward-kill-line
   "C-w" 'backward-kill-word
   "C-h" 'delete-backward-char))

(use-package debug
  :ensure nil
  :config
  (general-nmap
    :keymaps 'debugger-mode-map
    "<escape>" 'ignore)

  (setq debug-on-error nil))

(use-package fringe
  :ensure nil
  :config
  (fringe-mode -1))

;; (use-package avoid
;;   :defer nil
;;   :ensure nil
;;   :config
;;   (setq mouse-avoidance-banish-position '((frame-or-window . frame)
;;                                           (side . right)
;;                                           (side-pos . 3)
;;                                           (top-or-bottom . top)
;;                                           (top-or-bottom-pos . 10)))
;;   (mouse-avoidance-mode 'banish))

(use-package disable-mouse
  :defer t
  :config
  (mapc #'disable-mouse-in-keymap
        (list evil-motion-state-map
              evil-normal-state-map
              evil-visual-state-map
              evil-insert-state-map))
  (global-disable-mouse-mode))

(use-package savehist
  :disabled
  :init
  (setq history-length 500)
  (setq savehist-autosave-interval (* 1 30))
  (setq savehist-file (concat udir "var/savehist.el"))
  (setq savehist-additional-variables '(kill-ring search-ring filesets-data))
  :config
  (savehist-mode t))

(use-package subword
  :defer 3
  :ensure nil
  :config
  (global-subword-mode +1))

(use-package gud
  :defer t
  :ensure nil
  :config
  (defun my-pdb ()
    (interactive)
    (pdb (buffer-file-name))))

(use-package midnight
  :defer 120
  :ensure nil
  :config
  (setq midnight-period 10800)
  (midnight-mode +1))

(use-package gnutls
  :disabled)

(use-package rmail
  :disabled)

(defalias 'sp 'start-process-shell-command)
(defalias 'spc 'start-process)

;;; my aliases

(defalias 'l  'load-file)
(defalias 'org  'org-mode)
(defalias 'evil 'evil-mode)
(defalias 'pad   'package-delete)
(defalias 'par  'package-delete)
(defalias 'pai   'package-install)
(defalias 'cug  'customize-group)

;; buffer-move

(defalias 'buffer-move-left 'buf-move-left)
(defalias 'buffer-move-down 'buf-move-down)
(defalias 'buffer-move-up 'buf-move-up)
(defalias 'buffer-move-right 'buf-move-right)

;; macro
(defalias 'eval-line 'my-eval-line-macro)

(defun my-tangle-fountain ()
  (interactive)
  (my-save-all)
  (sp "tangle-fountain" nil "~/scripts/cline_scripts/aw" (buffer-file-name))
  (message " script pdfed"))

(defun my-i3-reload ()
  (interactive)
  (my-save-all)
  (sp "tangle-i3" nil "~/scripts/i3_scripts/tangle-i3-reload")
  (message " i3 reloaded"))

(defun my-i3-restart ()
  (interactive)
  (my-save-all)
  (sp "tangle-i3" nil "~/scripts/i3_scripts/tangle-i3-restart"))

(defun my-tangle-py-init.org-only ()
  (interactive)
  (my-quiet-save-buffer-only)
  (sp "tangle init.org" nil "~/scripts/emacs_scripts/nt-init")
  (message " init tangled"))

(defun my-tangle-py-init.org-only-and-quit-window ()
  (interactive)
  (my-quiet-save-buffer-only)
  (sp "tangle init.org" nil "~/scripts/emacs_scripts/nt-init")
  (quit-windows-on "init.org"))

(defun my-commit-init ()
  (interactive)
  (my-quiet-save-buffer-only)
  (sp "git-emacs" nil "~/.e/git-commit-emacs")
  (message " init commited"))

(defun my-push-init ()
  (interactive)
  (my-quiet-save-buffer-only)
  (sp "git-emacs" nil "~/.e/git-push-emacs")
  (message " emacs pushed"))

(defun my-tangle-py-init.org-only-quiet ()
  (interactive)
  (my-quiet-save-buffer-only)
  (sp "tangle init.org" nil "~/.e/nt-init"))

(defun my-tangle-restart-emacs (&optional args)
  (interactive "P")
  (org-babel-tangle-file (concat udir "init.org"))
  (restart-emacs--ensure-can-restart)
  (let* ((default-directory (restart-emacs--guess-startup-directory))
         (translated-args (if (called-interactively-p 'any)
                              (restart-emacs--* TODO Ato I [0/3]   translate-prefix-to-args args)
                            args))
         (restart-args (append translated-args
                               (unless (member "-Q" translated-args)
                                 (restart-emacs--frame-restore-args))))
         (kill-emacs-hook (append kill-emacs-hook
                                  (list (apply-partially #'restart-emacs--launch-other-emacs
                                                         restart-args)))))
    (save-buffers-kill-emacs)))

(defun my-tangle-py-init.org-and-debug ()
  (interactive)
  (my-quiet-save-buffer-only)
  (sp "tangle init.org" nil "~/.e/tangle-debug"))

(defun my-tangle-py-init.org-and-load ()
  (interactive)
  (my-quiet-save-buffer-only)
  (sp "tangle init.org" nil "~/.e/nt-init")
  (load-file user-init-file)
  (message " file tangled and loaded"))

(defun my-tangle-py-init.org-load-and-show ()
  (interactive)
  (progn
    (my-quiet-save-buffer-only)
    (sp "tangle init.org" nil "~/.e/nt-init")
    (load-file user-init-file)
    (find-file user-init-file))
  (message " file tangled and loaded"))

(defun my-insert-curly-braces (&optional arg)
  (interactive "P")
  (insert-pair arg ?\{?\}))

(defun my-insert-square-brackets (&optional arg)
  (interactive "P")
  (insert-pair arg ?\[?\]))

(defun my-insert-ordinal-masculine ()
  (interactive)
  (evil-insert-state)
  (insert "º"))

(defun my-text-double-increase ()
  (interactive)
  (text-scale-increase 2))

(defun my-text-double-decrease ()
  (interactive)
  (text-scale-decrease 2))

(defun my-insert-em-dash-space ()
  (interactive)
  (insert "— "))

;; https://stackoverflow.com/a/998472
(defun my-comm-dup-line (arg)
  (interactive "*p")
  (setq buffer-undo-list (cons (point) buffer-undo-list))
  (let ((bol (save-excursion (beginning-of-line) (point)))
        eol)
    (save-excursion
      (end-of-line)
      (setq eol (point))
      (let ((line (buffer-substring bol eol))
            (buffer-undo-list t)
            (count arg))
        (while (> count 0)
          (newline)
          (insert line)
          (setq count (1- count))))
      (setq buffer-undo-list (cons (cons eol (point)) buffer-undo-list))))
  (save-excursion
    (comment-line 1))
  (backward-char 3)
  (forward-line 1))

;; https://stackoverflow.com/a/998472
(defun my-dup-line (arg)
  (interactive "*p")
  (setq buffer-undo-list (cons (point) buffer-undo-list))
  (let ((bol (save-excursion (beginning-of-line) (point)))
        eol)
    (save-excursion
      (end-of-line)
      (setq eol (point))
      (let ((line (buffer-substring bol eol))
            (buffer-undo-list t)
            (count arg))
        (while (> count 0)
          (newline)
          (insert line)
          (setq count (1- count))))
      (setq buffer-undo-list (cons (cons eol (point)) buffer-undo-list))))
  (forward-line arg))

(defun my-sel-to-end ()
  (interactive)
  (evil-visual-char)
  (evil-last-non-blank))

(defun my-save-buffer ()
  (interactive)
  (evil-ex-nohighlight)
  (delete-trailing-whitespace)
  (save-buffer))

(defun my-save-buffer-only ()
  (interactive)
  (evil-ex-nohighlight)
  (save-buffer))

(defun my-quiet-save-buffer ()
  (interactive)
  (let ((inhibit-message t))
    (evil-ex-nohighlight)
    (save-buffer)))

(defun my-save-redraw ()
  (interactive)
  (save-buffer)
  (redraw-display))

(defun my-quiet-save-buffer-only ()
  (interactive)
  (let ((inhibit-message t))
    (save-buffer)))

(defun my-save-all ()
  (interactive)
  (let ((current-prefix-arg 4))
    (call-interactively 'save-some-buffers)))

(defun my-paragraph-backwards ()
  (interactive)
  (forward-line -1)
  (backward-paragraph)
  (forward-line)
  (back-to-indentation))

(defun my-paragraph-forward ()
  (interactive)
  (forward-paragraph)
  (forward-line)
  (back-to-indentation))

(defun widenToCenter ()
  (interactive)
  (save-excursion
    (widen)
    (recenter)))

(defun my-indent-buffer ()
  (interactive)
  (save-excursion
    (let ((inhibit-message t))
      (evil-indent
       (point-min)
       (point-max))
      (xah-clean-empty-lines))))

(defun indent-buffer-no-excursion ()
  (interactive)
  (let ((inhibit-message t))
    (evil-indent
     (point-min)
     (point-max))
    (xah-clean-empty-lines)))

;; https://stackoverflow.com/a/30697761
(defun my-sort-lines-by-length (reverse beg end)
  "Sort lines by length."
  (interactive "P\nr")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (let ;; To make `end-of-line' and etc. to ignore fields.
          ((inhibit-field-text-motion t))
        (sort-subr reverse 'forward-line 'end-of-line nil nil
                   (lambda (l1 l2)
                     (apply #'< (mapcar (lambda (range) (- (cdr range) (car range)))
                                        (list l1 l2)))))))))

(defun endless/simple-get-word ()
  (car-safe (save-excursion (ispell-get-word nil))))

(defun endless/ispell-word-then-abbrev (p)
  "Call `ispell-word', then create an abbrev for it.
      With prefix P, create local abbrev. Otherwise it will
      be global.
      If there's nothing wrong with the word at point, keep
      looking for a typo until the beginning of buffer. You can
      skip typos you don't want to fix with `SPC', and you can
      abort completely with `C-g'."
  (interactive "P")
  (let (bef aft)
    (save-excursion
      (while (if (setq bef (endless/simple-get-word))
                 ;; Word was corrected or used quit.
                 (if (ispell-word nil 'quiet)
                     nil ; End the loop.
                   ;; Also end if we reach `bob'.
                   (not (bobp)))
               ;; If there's no word at point, keep looking
               ;; until `bob'.
               (not (bobp)))
        (backward-word)
        (backward-char))
      (setq aft (endless/simple-get-word)))
    (if (and aft bef (not (equal aft bef)))
        (let ((aft (downcase aft))
              (bef (downcase bef)))
          (define-abbrev
            (if p local-abbrev-table global-abbrev-table)
            bef aft)
          (message "\"%s\" now expands to \"%s\" %sally"
                   bef aft (if p "loc" "glob")))
      (user-error "No typo at or before point"))))

(defun my-erase-kill-ring ()
  (interactive)
  (setq kill-ring nil))

(defun my-insert-space ()
  (interactive)
  (insert " "))

(defun my-capitalize ()
  (interactive)
  (fix-word-capitalize)
  (insert " "))

(defun my-emacs-indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (save-excursion
    (let ((inhibit-message t))
      (evil-indent
       (point-min)
       (point-max))
      (xah-clean-empty-lines))))

(defun my-only-indent-buffer ()
  (interactive)
  (save-excursion
    (let ((inhibit-message t))
      (evil-indent
       (point-min)
       (point-max)))))

(defun copy-whole-buffer ()
  "Copy entire buffer to clipboard"
  (interactive)
  (clipboard-kill-ring-save
   (point-min)
   (point-max)))

(defun copy-to-messenger ()
  (interactive)
  (copy-whole-buffer)
  (let ((inhibit-message t))
    (shell-command "~/scripts/i3_scripts/paste_to_im.sh")))

;; Stefan Monnier <foo at acm.org>. It is the opposite of fill-paragraph
;; https://www.emacswiki.org/emacs/UnfillParagraph
(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
        ;; This would override `fill-column' if it's an integer.
        (emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))

(defun unfill-buffer ()
  (interactive)
  (save-excursion
    (mark-whole-buffer)
    (unfill-paragraph t)))

(defun fill-buffer ()
  (interactive)
  (fill-region
   (point-min)
   (point-max)))

(defun my-evil-substitute ()
  (interactive)
  (evil-ex "%s/"))

(defun del-dup-lines-region (start end)
  "Find duplicate lines in region START to END keeping first occurrence."
  (interactive "*r")
  (save-excursion
    (let ((end (copy-marker end)))
      (while
          (progn
            (goto-char start)
            (re-search-forward "^\\(.*\\)\n\\(\\(.*\n\\)*\\)\\1\n" end t))
        (replace-match "\\1\n\\2")))))

(defun del-dup-lines-buffer ()
  "Delete duplicate lines in buffer and keep first occurrence."
  (interactive "*")
  (uniquify-all-lines-region (point-min) (point-max)))

(defun sel-to-end ()
  (interactive)
  (evil-visual-char)
  (evil-last-non-blank))

(defun my-bash-shebang ()
  (interactive)
  (erase-buffer)
  (insert "#!/usr/bin/env bash\n\n")
  (sh-mode)
  (sh-set-shell "bash")
  (xah-clean-empty-lines)
  (forward-to-indentation)
  (evil-insert-state))

(defun my-python-shebang ()
  (interactive)
  (kill-region (point-min) (point-max))
  (insert "#!/usr/bin/env python3\n\n")
  ;; (insert "\"\"\" Docstring \"\"\"")
  ;; (insert "\n\n")
  (evil-insert-state))

(defun whack-whitespace (arg)
  "Delete all white space from point to the next word.  With prefix ARG
    delete across newlines as well.  The only danger in this is that you
    don't have to actually be at the end of a word to make it work.  It
    skips over to the next whitespace and then whacks it all to the next
    word."
  (interactive "P")
  (let ((regexp (if arg "[ \t\n]+" "[ \t]+")))
    (re-search-forward regexp nil t)
    (replace-match "" nil nil)))

(setq save-abbrevs 'silently)
(setq-default abbrev-mode t)

(defun my-backward-kill-line (arg)
  "Kill ARG lines backward."
  (interactive "p")
  (kill-line (- 1 arg)))



(defun my-profiler-start ()
  (interactive)
  (profiler-start 'cpu+mem))

(defun my-profiler-stop-and-reset ()
  (interactive)
  (profiler-stop)
  (profiler-reset))

(defun my-doom-Iosvkem ()
  (interactive)
  (load-theme 'doom-Iosvkem))

(defun my-load-monokai ()
  (interactive)
  (load-theme 'monokai))

(defun my-emacs-session ()
  (interactive)
  (sp "init-keys" nil "~/scripts/keyboard/init_keys.sh")
  (toggle-frame-fullscreen))

(defun my-recenter-window ()
  (interactive)
  (recenter-top-bottom
   `(4)))

(defun my-evil-bottom ()
  (interactive)
  (save-excursion
    (evil-scroll-line-to-bottom 1)))

(defun my-eval-buffer ()
  (interactive)
  (eval-buffer)
  (message " buffer evaluated"))

(defun my-eval-buffer-and-leave-org-source ()
  (interactive)
  (eval-buffer)
  (org-edit-src-exit))

(defun last-buffer ()
  (interactive)
  (switch-to-buffer nil))

(defun focus-emacs ()
  (interactive)
  (let ((inhibit-message t))
    (shell-command "~/scripts/i3_scripts/focus_emacs.sh")))

(defun emacs-launcher ()
  (interactive)
  (sp "tangle init" nil "~/scripts/emacs_scripts/eclauncher-light"))

(defun focus-chrome ()
  (interactive)
  (let ((inhibit-message t))
    (shell-command "~/scripts/i3_scripts/focus_chrome.sh")))

(defun my-run-on-terminal ()
  (interactive)
  (prelude-copy-file-name-to-clipboard-quiet)
  (let ((inhibit-message t))
    (shell-command "~/scripts/i3_scripts/run_on_term")))

(defun my-focus-chrome-delayed ()
  (interactive)
  (let ((inhibit-message t))
    (progn
      (evil-exit-visual-state)
      (sit-for 1)
      (shell-command "~/scripts/i3_scripts/focus_chrome.sh"))))

(defun copy-to-chrome ()
  "Paste buffer on Chrome"
  (interactive)
  (copy-whole-buffer)
  (let ((inhibit-message t))
    (shell-command "~/scripts/i3_scripts/paste_to_chrome.sh")))

(defun my-blog-post ()
  (interactive)
  (my-quiet-save-buffer)
  (disable-theme 'noctilux)
  (org2blog/wp-post-buffer)
  (load-theme 'noctilux)
  (delete-other-windows)
  (start-process-shell-command "chrome-reload-focus" nil "~/scripts/i3_scripts/chrome_reload.sh"))

(defun my-blog-publish ()
  (interactive)
  (my-quiet-save-buffer)
  (disable-theme 'noctilux)
  (org2blog/wp-post-buffer-and-publish)
  (load-theme 'noctilux)
  (delete-other-windows)
  (start-process-shell-command "chrome-reload-focus" nil "~/scripts/i3_scripts/chrome_reload.sh"))

(defun my-goto-i3-screen-configs ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/.config/i3/config.org")
    (widen)
    (swiper "strachpads main")))

(defun my-pdf-view--rotate (&optional counterclockwise-p page-p)
  "Rotate PDF 90 degrees.  Requires pdftk to work.\n
Clockwise rotation is the default; set COUNTERCLOCKWISE-P to
non-nil for the other direction.  Rotate the whole document by
default; set PAGE-P to non-nil to rotate only the current page.
\nWARNING: overwrites the original file, so be careful!"
  ;; error out when pdftk is not installed
  (if (null (executable-find "pdftk"))
      (error "Rotation requires pdftk")
    ;; only rotate in pdf-view-mode
    (when (eq major-mode 'pdf-view-mode)
      (let* ((rotate (if counterclockwise-p "left" "right"))
             (file   (format "\"%s\"" (pdf-view-buffer-file-name)))
             (page   (pdf-view-current-page))
             (pages  (cond ((not page-p)                        ; whole doc?
                            (format "1-end%s" rotate))
                           ((= page 1)                          ; first page?
                            (format "%d%s %d-end"
                                    page rotate (1+ page)))
                           ((= page (pdf-info-number-of-pages)) ; last page?
                            (format "1-%d %d%s"
                                    (1- page) page rotate))
                           (t                                   ; interior page?
                            (format "1-%d %d%s %d-end"
                                    (1- page) page rotate (1+ page))))))
        ;; empty string if it worked
        (if (string= "" (shell-command-to-string
                         (format (concat "pdftk %s cat %s "
                                         "output %s.NEW "
                                         "&& mv %s.NEW %s")
                                 file pages file file file)))
            (pdf-view-revert-buffer nil t)
          (error "Rotation error!"))))))

(defun my-pdf-view-rotate-clockwise (&optional arg)
  "Rotate PDF page 90 degrees clockwise.  With prefix ARG, rotate
entire document."
  (interactive "P")
  (pdf-view--rotate nil (not arg)))

(defun my-pdf-view-rotate-counterclockwise (&optional arg)
  "Rotate PDF page 90 degrees counterclockwise.  With prefix ARG,
rotate entire document."
  (interactive "P")
  (pdf-view--rotate :counterclockwise (not arg)))

(defun my-quit-window ()
  (interactive)
  (quit-window t))

(defun my-kill-buffer-and-workspace ()
  (interactive)
  (widen)
  (my-save-all)
  (my-kill-this-buffer)
  (eyebrowse-close-window-config))

(defun my-kill-this-buffer ()
  "Kill the current buffer."
  (interactive)
  (kill-buffer (current-buffer)))

(defun my-kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (my-save-all)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
  (delete-other-windows)
  (message " other buffers killed"))

(defun my-kill-all-buffers ()
  "Kill all buffers."
  (interactive)
  (progn
    (my-save-all)
    (mapc 'kill-buffer (buffer-list))
    (message " all buffers killed")))

(defun my-kill-all-buffers-except-treemacs ()
  "Kill all buffers."
  (interactive)
  (progn
    (my-save-all)
    (mapc 'kill-buffer (delq (treemacs-get-local-buffer) (buffer-list)))
    (message " all killed expect treemacs")))
(current-buffer)

(defun my-kill-all-buffers-quiet ()
  "Kill all buffers."
  (interactive)
  (progn
    (my-save-all)
    (mapc 'kill-buffer (buffer-list))))

(defun xah-clean-whitespace ()
  "Delete trailing whitespace, and replace repeated blank lines to just 1.
Only space and tab is considered whitespace here.
Works on whole buffer or text selection, respects `narrow-to-region'.

URL `http://ergoemacs.org/emacs/elisp_compact_empty_lines.html'
Version 2017-09-22"
  (interactive)
  (let ($begin $end)
    (if (region-active-p)
        (setq $begin (region-beginning) $end (region-end))
      (setq $begin (point-min) $end (point-max)))
    (save-excursion
      (save-restriction
        (narrow-to-region $begin $end)
        (progn
          (goto-char (point-min))
          (while (re-search-forward "[ \t]+\n" nil "move")
            (replace-match "\n")))
        (progn
          (goto-char (point-min))
          (while (re-search-forward "\n\n\n+" nil "move")
            (replace-match "\n\n")))
        (progn
          (goto-char (point-max))
          (while (equal (char-before) 32) ; char 32 is space
            (delete-char -1))))
      (message "white space cleaned"))))

(defun xah-clean-empty-lines ()
  "Replace repeated blank lines to just 1.
Works on whole buffer or text selection, respects `narrow-to-region'.

URL `http://ergoemacs.org/emacs/elisp_compact_empty_lines.html'
Version 2017-09-22"
  (interactive)
  (let ($begin $end)
    (if (region-active-p)
        (setq $begin (region-beginning) $end (region-end))
      (setq $begin (point-min) $end (point-max)))
    (save-excursion
      (save-restriction
        (narrow-to-region $begin $end)
        (progn
          (goto-char (point-min))
          (while (re-search-forward "\n\n\n+" nil "move")
            (replace-match "\n\n")))))))

(defun xah-upcase-sentence ()
  "Upcase first letters of sentences of current text block or selection.

URL `http://ergoemacs.org/emacs/emacs_upcase_sentence.html'
Version 2019-06-21"
  (interactive)
  (let ($p1 $p2)
    (if (region-active-p)
        (setq $p1 (region-beginning) $p2 (region-end))
      (save-excursion
        (if (re-search-backward "\n[ \t]*\n" nil "move")
            (progn
              (setq $p1 (point))
              (re-search-forward "\n[ \t]*\n"))
          (setq $p1 (point)))
        (progn
          (re-search-forward "\n[ \t]*\n" nil "move")
          (setq $p2 (point)))))
    (save-excursion
      (save-restriction
        (narrow-to-region $p1 $p2)
        (let ((case-fold-search nil))
          (goto-char (point-min))
          (while (re-search-forward "\\. \\{1,2\\}\\([a-z]\\)" nil "move") ; after period
            (upcase-region (match-beginning 1) (match-end 1))
            ;; (overlay-put (make-overlay (match-beginning 1) (match-end 1)) 'face '((t :background "red" :foreground "white")))
            (overlay-put (make-overlay (match-beginning 1) (match-end 1)) 'face 'highlight))

          ;;  new line after period
          (goto-char (point-min))
          (while (re-search-forward "\\. ?\n *\\([a-z]\\)" nil "move")
            (upcase-region (match-beginning 1) (match-end 1))
            (overlay-put (make-overlay (match-beginning 1) (match-end 1)) 'face 'highlight))

          ;; after a blank line, after a bullet, or beginning of buffer
          (goto-char (point-min))
          (while (re-search-forward "\\(\\`\\|• \\|\n\n\\)\\([a-z]\\)" nil "move")
            (upcase-region (match-beginning 2) (match-end 2))
            (overlay-put (make-overlay (match-beginning 2) (match-end 2)) 'face 'highlight))

          ;; for HTML. first letter after tag
          (goto-char (point-min))
          (while (re-search-forward "\\(<p>\n?\\|<li>\\|<td>\n?\\|<figcaption>\n?\\)\\([a-z]\\)" nil "move")
            (upcase-region (match-beginning 2) (match-end 2))
            (overlay-put (make-overlay (match-beginning 2) (match-end 2)) 'face 'highlight))

          (goto-char (point-min)))))))

(use-package xah-math-input
  :defer t)

(defun my-copy-filename-only ()
  (interactive)
  (let ((filename (buffer-name)))
    (setq kill-ring nil)
    (when filename
      (with-temp-buffer
        (insert filename)
        (clipboard-kill-region (point-min) (point-max)))
      (message filename))))

;;;; https://stackoverflow.com/a/9414763

(defun prelude-copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename))
    (message filename)))

(defun prelude-copy-file-name-to-clipboard-quiet ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename))))

(defun my-copy-file-only-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-name))))
    (when filename
      (kill-new (abbreviate-file-name filename)))

    (message filename)))

(defun my-copy-python-path ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename))))

(defun rename-file-and-buffer ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)))))))

(defun my-bash-completion ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/.bash_completion.sh")))

(defun my-agenda ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/org/Planning/agenda.org")))

(defun my-i3-keys ()
  (interactive)
  (let ((inhibit-message t))
    (find-file (concat udir "tmp/i3keys.org"))))

(defun my-goto-pt-spell ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/.aspell.pt_BR.pws")))

(defun my-goto-en-spell ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/.aspell.en.pws")))

(defun my-scratch-buffer ()
  (interactive)
  (evil-save-state
    (switch-to-buffer "*scratch*")))

(defun my-messages-buffer ()
  (interactive)
  (evil-save-state
    (switch-to-buffer "*Messages*")))

(defun my-warnings-buffer ()
  (interactive)
  (evil-save-state
    (switch-to-buffer "*Warnings*")))

(defun my-scratch-markdown ()
  (interactive)
  (let ((inhibit-message t))
    (find-file (concat udir "tmp/scratches/scratch.md"))))

(defun my-scratch-elisp ()
  (interactive)
  (let ((inhibit-message t))
    (find-file (concat udir "tmp/scratches/scratch.el"))))

(defun my-scratch-org ()
  (interactive)
  (let ((inhibit-message t))
    (find-file (concat udir "tmp/scratches/scratch.org"))))

(defun my-python-scratch ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/Python/code/scratch.py")))

(defun my-bash-aliases ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/.bash_aliases")))

(defun my-bashrc ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/.bashrc")))

(defun my-profile ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/.profile")))

(defun my-inputrc ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/.inputrc")))

(defun my-tmux-conf ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "/home/files/dotfiles/tmux/tmuxconf")))

(defun my-custom-file ()
  (interactive)
  (let ((inhibit-message t))
    (find-file (concat udir ".emacs-custom.el"))))

(defun my-goto-init ()
  (interactive)
  (find-file (concat udir "init.org"))
  (widen))

(defun my-goto-init-outline ()
  (interactive)
  (find-file (concat udir "init.org"))
  (counsel-outline))

(defun my-goto-init.el ()
  (interactive)
  (let ((inhibit-message t))
    (find-file (concat udir "init.el"))))

(defun my-goto-package ()
  (interactive)
  (progn
    (my-goto-init)
    (swiper "(use-package ")))

(defun my-goto-hydra ()
  (interactive)
  (progn
    (my-goto-init)
    (swiper "(defhydra hydra- ")))

(defun my-goto-function ()
  (interactive)
  (progn
    (my-goto-init)
    (swiper "(defun ")))

(defun my-goto-my-function ()
  (interactive)
  (progn
    (my-goto-init)
    (swiper "(defun my- ")))

(defun my-goto-package-elisp-file ()
  (interactive)
  (my-goto-init.el)
  (swiper "(use-package "))

(defun my-goto-bash-completion ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/.bash_completion.sh")))

(defun my-goto-agenda ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/org/Agenda/agenda.org")))

(defun my-goto-i3-keys ()
  (interactive)
  (let ((inhibit-message t))
    (find-file (concat udir "tmp/i3keys.org"))))

(defun my-goto-scratch-buffer ()
  (interactive)
  (evil-save-state
    (switch-to-buffer "*scratch*")))

(defun my-goto-messages-buffer ()
  (interactive)
  (evil-save-state
    (switch-to-buffer "*Messages*")))

(defun my-goto-warnings-buffer ()
  (interactive)
  (evil-save-state
    (switch-to-buffer "*Warnings*")))

(defun my-goto-i3-config ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/.config/i3/config.org")))

(defun my-goto-scratch-markdown ()
  (interactive)
  (let ((inhibit-message t))
    (find-file (concat udir "tmp/scratches/scratch.md"))))

(defun my-goto-scratch-elisp ()
  (interactive)
  (let ((inhibit-message t))
    (find-file (concat udir "tmp/scratches/scratch.el"))))

(defun my-goto-scratch-org ()
  (interactive)
  (let ((inhibit-message t))
    (find-file (concat udir "tmp/scratches/scratch.org"))))

(defun my-goto-python-scratch ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/Python/code/scratch.py")))

(defun my-goto-racket-scratch ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/Racket/code/sct.rkt")))

(defun my-goto-bash-aliases ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/.bash_aliases")))

(defun my-goto-bashrc ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/.bashrc")))

(defun my-goto-profile ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/.profile")))

(defun my-goto-inputrc ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "~/.inputrc")))

(defun my-goto-env_variables ()
  (interactive)
  (let ((inhibit-message t))
    (find-file (concat udir "variables.sh"))))

(defun my-goto-tmux-conf ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "/home/files/dotfiles/tmux/tmuxconf")))

(defun my-goto-zathurarc ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "/home/files/dotfiles/zathura/zathurarc")))

(defun my-goto-custom-file ()
  (interactive)
  (let ((inhibit-message t))
    (find-file "/home/files/dotfiles/emacs/em/etc/custom.el")))

(defun my-goto-abbrevs ()
  (interactive)
  (let ((inhibit-message t))
    (find-file (concat udir "etc/abbrev_defs"))))

(defun my-goto-emacs-custom ()
  (interactive)
  (let ((inhibit-message t))
    (find-file (concat udir "etc/custom.el"))))

(defun my-copy-dir ()
  "Put the current dir name on the clipboard"
  (interactive)
  (let ((filename default-directory))
    (setq kill-ring nil)
    (when filename
      (with-temp-buffer
        (insert filename)
        (clipboard-kill-region (point-min) (point-max)))
      (message filename))))

(defvar killed-file-list nil
  "List of recently killed files.")

(defun add-file-to-killed-file-list ()
  "If buffer is associated with a file name, add that file to the
`killed-file-list' when killing the buffer."
  (when buffer-file-name
    (push buffer-file-name killed-file-list)))

(add-hook 'kill-buffer-hook #'add-file-to-killed-file-list)

(defun reopen-killed-file ()
  "Reopen the most recently killed file, if one exists."
  (interactive)
  (when killed-file-list
    (find-file (pop killed-file-list))))

;; Reopen Killed File
;; https://emacs.stackexchange.com/a/3334

(defvar killed-file-list nil
  "List of recently killed files.")

(add-hook 'kill-buffer-hook #'add-file-to-killed-file-list)

(defun my-reopen-killed-file ()
  "Reopen the most recently killed file, if one exists."
  (interactive)
  (when killed-file-list
    (find-file (pop killed-file-list))))

(defun my-reopen-killed-file-fancy ()
  "Pick a file to revisit from a list of files killed during this
Emacs session."
  (interactive)
  (if killed-file-list
      (let ((file (completing-read "Reopen killed file: " killed-file-list
                                   nil nil nil nil (car killed-file-list))))
        (when file
          (setq killed-file-list (cl-delete file killed-file-list :test #'equal))
          (find-file file)))
    (error "No recently-killed files to reopen")))

(defun my-ranger-find-bashdot ()
  (interactive)
  (let ((inhibit-message t))
    (ranger-find-file "~/dotfiles/bash/unhidden/macos")))

(defun my-ranger-find-texpander ()
  (interactive)
  (let ((inhibit-message t))
    (ranger-find-file "~/.texpander")))

(defun my-ranger-find-nvim-dir ()
  (interactive)
  (let ((inhibit-message t))
    (ranger-find-file "~/.config/nvim")))

(defun my-ranger-find-config ()
  (interactive)
  (let ((inhibit-message t))
    (ranger-find-file "~/.config/")))

(defun my-ranger-find-scripts-dir ()
  (interactive)
  (let ((inhibit-message t))
    (ranger-find-file "~/scripts")))

(defun ranger-find-emacs-dir ()
  (interactive)
  (let ((inhibit-message t))
    (ranger-find-file udir)))

(defun pbcopy ()
  (interactive)
  (let ((deactivate-mark t))
    (call-process-region (point) (mark) "pbcopy"))
  (evil-exit-visual-state))

(defun pbpaste ()
  (interactive)
  (call-process-region (point) (if mark-active (mark) (point)) "pbpaste" t t))

(defun pbcut ()
  (interactive)
  (pbcopy)
  (delete-region (region-beginning) (region-end)))

(fset 'my-reload-theme-macro
   [?  ?c ?L return ?  ?c ?l return])

(fset 'my-org-sparse-tree-strt-macro
      [?\C-c ?/ ?T ?S ?T ?R ?T return])

(fset 'my-python-make-print
      (kmacro-lambda-form [?v ?g ?_ ?S ?\) escape ?' ?< ?i ?p ?r ?i ?n ?t escape ?l] 0 "%d"))

(fset 'my-python-make-fstring
      (kmacro-lambda-form [?v ?i ?w ?S ?\" ?v ?i ?\" ?S ?\} ?h ?i ?f ?\C-f ?\C-f ?\C-b ?  ?\C-b] 0 "%d"))

(fset 'my-python-fix-string-style
      (kmacro-lambda-form [?v ?a ?\" escape ?' ?< ?a ?\\ ?n ?  escape ?' ?> ?i ?\; ?\\ ?b ?  backspace backspace ?n ?  escape ?' ?<] 0 "%d"))

(fset 'my-insert-current-word
      (kmacro-lambda-form [?z ?= ?i ?y] 0 "%d"))

(fset 'my-org-hide-others-macro
      (kmacro-lambda-form [?z ?m tab] 31 "%d"))

(fset 'org-hide-all
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '([3 117 tab] 0 "%d") arg)))

(fset 'my-narrow-to-paren-macro
      (kmacro-lambda-form [escape ?v ?a ?\( ?  ?n escape ?' ?<] 0 "%d"))

(fset 'my-goto-org-src-buffer
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '([134217828 79 114 103 32 83 114 99 return] 0 "%d") arg)))

(fset 'my-markdown-copy-buffer-macro
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '("gg2jyG" 0 "%d") arg)))

(fset 'my-widen-reset-no-switch
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '(" ow wa ml" 0 "%d") arg)))

(fset 'my-widen-reset
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '("nw ml wazz\363" 0 "%d") arg)))

(fset 'insert-link-in-list
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '([48 119 103 114 insert insert return return] 0 "%d") arg)))

(fset 'duplicate-a-paragrah
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '("vapy'>p" 0 "%d") arg)))

(fset 'duplicate-inner-paragraph
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '("vipy'>gop" 0 "%d") arg)))

(fset 'my-show-variable-at-point
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '([8 118 return] 0 "%d") arg)))

(fset 'my-disable-theme
      (kmacro-lambda-form [134217848 ?d ?i ?s ?a ?b ?l ?e ?- ?t ?h ?e ?m ?e return return] 0 "%d"))

(fset 'adjust-server-name
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '([32 74 32 116 106 106 106 escape 118 105 34 24 110 110 escape 24 67108912 61 61 61 201326640] 0 "%d") arg)))

(fset 'eyebrowse-swap-workspace
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '([32 110 return 134217829 32 110 return 134217829] 0 "%d") arg)))

(fset 'show-text-objects
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '([103 103 47 101 118 105 108 32 111 114 103 32 116 101 120 116 return 122 105 122 116 122 110] 0 "%d") arg)))

(fset 'my-dumb-jump-prefer-external-macro
      (kmacro-lambda-form [escape ?\C-c ?M f11 return] 0 "%d"))

(fset 'my-python-paste-exercise
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '([103 111 103 111 112 103 119 97 112 103 99 105 112 escape] 0 "%d") arg)))

(fset 'my-python-make-string
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '([118 103 102 41 104 83 41 105 115 116 114 escape 108] 0 "%d") arg)))

(fset 'my-ex-run-python-macro
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '([134217848 109 121 47 101 120 45 112 121 return return] 0 "%d") arg)))

(fset 'add-hook-macro
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '([73 17 40 97 100 100 45 104 111 111 107 32 17 39 5 32 17 39 41 134217826 6] 0 "%d") arg)))

(fset 'my-eval-next-sexp-macro
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '([118 97 40 escape 24 5] 0 "%d") arg)))

(fset 'c-goto-vars
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '([109 113 103 103 47 115 101 116 108 111 99 97 108 101 return 50 106] 0 "%d") arg)))

(fset 'copy-line-no-newline
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '("g,Z0Y'Z" 0 "%d") arg)))

(fset 'my-duplicate-line-macro
      (kmacro-lambda-form [?m ?Z ?y ?y ?p ?\' ?Z ?j] 0 "%d"))

(fset 'select-next-block
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([47 35 92 43 66 69 71 73 78 95 83 82 67 return 86 47 35 92 43 69 78 68 95 83 82 67 return] 0 "%d")) arg)))

(fset 'select-next-inner-block
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([47 35 92 43 66 69 71 73 78 95 83 82 67 return 106 86 47 35 92 43 69 78 68 95 83 82 67 return 107] 0 "%d")) arg)))

(fset 'my-yank-region
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item '("y" 0 "%d") arg)))
