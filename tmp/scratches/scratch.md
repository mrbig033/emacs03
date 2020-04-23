I have a partial solution:

    (defun my-shfmt-fix-file ()
        (interactive)
        (message "shfmt fix buffer" (buffer-file-name))
        (shell-command (concat "shfmt -i 2 -s -w " (buffer-file-name))))

      (defun my-shfmt-fix-file-and-revert ()
        (interactive)
        (my-shfmt-fix-file)
        (revert-buffer t t))

It does work, but it conflicts with both persistent undo packages I tried — `undohist` and `undo-fu-session`. I would have to give up persistent undo, at least for the time being.

Message from `undo-fu-session`:

    Undo-Fu-Session discarding undo data: file length mismatch

Undohist ask for confirmation to recover the undo file and gives a similar message afterwards.