;;; hl-sentence-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "hl-sentence" "hl-sentence.el" (0 0 0 0))
;;; Generated autoloads from hl-sentence.el

(defface hl-sentence '((t :inherit highlight)) "\
The face used to highlight the current sentence." :group (quote hl-sentence))

(autoload 'hl-sentence-mode "hl-sentence" "\
Enable highlighting of currentent sentence.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "hl-sentence" '("hl-sentence-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; hl-sentence-autoloads.el ends here
