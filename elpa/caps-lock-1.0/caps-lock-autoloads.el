;;; caps-lock-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "caps-lock" "caps-lock.el" (0 0 0 0))
;;; Generated autoloads from caps-lock.el

(defvar caps-lock-mode nil "\
Non-nil if Caps-Lock mode is enabled.
See the `caps-lock-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `caps-lock-mode'.")

(custom-autoload 'caps-lock-mode "caps-lock" nil)

(autoload 'caps-lock-mode "caps-lock" "\
Make self-inserting keys invert the capitalization.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "caps-lock" '("caps-lock-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; caps-lock-autoloads.el ends here
