;; a simple major mode, mymath-mode

(setq mymath-highlights
      '(("Sin\\|Cos\\|Sum" . font-lock-function-name-face)
        ("Pi\\|Infinity" . font-lock-constant-face)))

(define-derived-mode my fundamental-mode "mymath"
  "major mode for editing mymath language code."
  (setq font-lock-defaults '(mymath-highlights)))
