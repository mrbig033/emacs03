



(defun insert-shebang-get-extension-and-insert (filename)
  (shut-up
    (if (file-name-extension filename)
        (let ((file-extn (replace-regexp-in-string "[\<0-9\>]" ""
                                                   (file-name-extension filename))))
          (if (car (member file-extn insert-shebang-ignore-extensions))
              (progn (message "extension ignored"))
            (progn
              (if (car (assoc file-extn insert-shebang-custom-headers))
                  (let ((val (cdr (assoc file-extn insert-shebang-custom-headers))))
                    (if (= (point-min) (point-max))
                        (insert-shebang-custom-header val)
                      (progn
                        (insert-shebang-scan-first-line-custom-header val))))
                (my/prepare-buffer-after-shebang))
              (progn
                (if (car (assoc file-extn insert-shebang-file-types))
                    (progn
                      (let ((val (cdr (assoc file-extn insert-shebang-file-types))))
                        (if (= (point-min) (point-max))
                            (insert-shebang-eval val)
                          (progn (insert-shebang-scan-first-line-eval val)))))
                  (progn (message "can't guess file type."))))))))))

(defun my/prepare-buffer-after-shebang ()
  (interactive)
  (insert "\n\n")
  (evil-insert-state))