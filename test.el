(use-package! nswbuff
  :bind
  ("M-," . nswbuff-switch-to-previous-buffer)
  ("M-." . nswbuff-switch-to-next-buffer))
  :custom
  (nswbuff-left "  ")
  (nswbuff-clear-delay 2)
  (nswbuff-delay-switch nil)
  (nswbuff-this-frame-only 't)
  (nswbuff-recent-buffers-first t)
  (nswbuff-start-with-current-centered t)
  (nswbuff-display-intermediate-buffers t)
  (nswbuff-buffer-list-function 'nswbuff-projectile-buffer-list)
  (nswbuff-exclude-mode-regexp "Buffer-menu-mode\\|Info-mode\\|Man-mode\\|calc-mode\\|calendar-mode\\|compilation-mode\\|completion-list-mode\\|dired-mode\\|fundamental-mode\\|gnus-mode\\|help-mode\\|helpful-mode\\|ibuffer-mode\\|lisp-interaction-mode\\|magit-auto-revert-mode\\|magit-blame-mode\\|magit-blame-read-only-mode\\|magit-blob-mode\\|magit-cherry-mode\\|magit-diff-mode\\|magit-diff-mode\\|magit-file-mode\\|magit-log-mode\\|magit-log-select-mode\\|magit-merge-preview-mode\\|magit-mode\\|magit-process-mode\\|magit-reflog-mode\\|magit-refs-mode\\|magit-repolist-mode\\|magit-revision-mode\\|magit-stash-mode\\|magit-stashes-mode\\|magit-status-mode\\|magit-submodule-list-mode\\|magit-wip-after-apply-mode\\|magit-wip-after-save-local-mode\\|magit-wip-after-save-mode\\|magit-wip-before-change-mode\\|magit-wip-initial-backup-mode\\|magit-wip-mode\\|minibuffer-inactive-mode\\|occur-mode\\|org-agenda-mode\\|org-src-mode\\|ranger-mode\\|special-mode\\|special-mode\\|term-mode\\|treemacs-mode\\|messages-buffer-mode")
  (nswbuff-exclude-buffer-regexps '("^#.*#$" "^\\*.*\\*"))
