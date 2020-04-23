;;; xah-math-input-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "xah-math-input" "xah-math-input.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from xah-math-input.el

(defvar global-xah-math-input-mode nil "\
Non-nil if Global Xah-Math-Input mode is enabled.
See the `global-xah-math-input-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-xah-math-input-mode'.")

(custom-autoload 'global-xah-math-input-mode "xah-math-input" nil)

(autoload 'global-xah-math-input-mode "xah-math-input" "\
Toggle Xah-Math-Input mode in all buffers.
With prefix ARG, enable Global Xah-Math-Input mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Xah-Math-Input mode is enabled in all buffers where
`xah-math-input-mode-on' would do it.
See `xah-math-input-mode' for more information on Xah-Math-Input mode.

\(fn &optional ARG)" t nil)

(autoload 'xah-math-input-mode-on "xah-math-input" "\
Turn on `xah-math-input-mode' in current buffer.

\(fn)" t nil)

(autoload 'xah-math-input-mode-off "xah-math-input" "\
Turn off `xah-math-input-mode' in current buffer.

\(fn)" t nil)

(autoload 'xah-math-input-mode "xah-math-input" "\
Toggle xah-math-input minor mode.

A mode for inputting a math and Unicode symbols.

Type “inf”, then press \\[xah-math-input-change-to-symbol] (or M-x `xah-math-input-change-to-symbol'), then it becomes “∞”.

Other examples:
 a → α
 p → π
 /= → ≠ or ne
 >= → ≥ or ge
 -> → → or rarr
 and → ∧
etc.

If you have a text selection, then selected word will be taken as input. For example, type 「extraterrestrial alien」, select the phrase, then press \\[xah-math-input-change-to-symbol], then it becomse 👽.

For the complete list of abbrevs, call `xah-math-input-list-math-symbols'.

Decimal and hexadecimal can also be used. Example:

 945     ← decimal
 #945    ← decimal with prefix #
 &#945;  ← XML entity syntax

 x3b1    ← hexadimal with prefix x
 #x3b1   ← hexadimal with prefix #x
 &#x3b1; ← XML entity syntax

Full Unicode name can also be used, e.g. 「greek small letter alpha」.

If you wish to enter a symbor by full unicode name but do not know the full name, M-x `insert'. Asterisk “*” can be used as a wildcard to find the char. For example, M-x `insert' , then type 「*arrow」 then Tab, then emacs will list all unicode char names that has “arrow” in it. (this feature is part of Emacs 23)

Home page at: URL `http://ergoemacs.org/emacs/xah-math-input-math-symbols-input.html'

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "xah-math-input" '("xah-math-input-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; xah-math-input-autoloads.el ends here
