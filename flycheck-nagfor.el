;;; package --- Summary


;;; Commentary:
;;; Based on the fortran-gfortran checker at https://github.com/flycheck/flycheck/blob/master/flycheck.el

;;; Code:
(require 'flycheck)

(flycheck-def-args-var flycheck-nagfor-args fortran-nagfor
  :package-version '(flycheck-nagfor . "0.01"))

(flycheck-def-option-var flycheck-nagfor-include-path nil fortran-nagfor
  "A list of include directories for nagfor.
The value of this variable is a list of strings, where each
string is a directory to add to the include path of nagfor.
Relative paths are relative to the file being checked."
  :type '(repeat (directory :tag "Include directory"))
  :safe #'flycheck-string-list-p
  :package-version '(flycheck-nagfor . "0.01"))

(flycheck-def-option-var flycheck-nagfor-language-standard "f2008" fortran-nagfor
  "The language standard to use in Nagfor.
The value of this variable is either a string denoting a language
standard, or nil, to use the default standard.  When non-nil,
pass the language standard via the `-std' option."
  :type '(choice (const :tag "Default standard" nil)
                 (string :tag "Language standard"))
  :safe #'stringp
  :package-version '(flycheck-nagfor . "0.01"))

(flycheck-def-option-var flycheck-nagfor-layout nil fortran-nagfor
  "The source code layout to use in nagfor.
The value of this variable is one of the following symbols:
nil
     Let nagfor determine the layout from the extension
`free'
     Use free form layout
`fixed'
     Use fixed form layout
In any other case, an error is signaled."
  :type '(choice (const :tag "Guess layout from extension" nil)
                 (const :tag "Free form layout" free)
                 (const :tag "Fixed form layout" fixed))
  :safe (lambda (value) (or (not value) (memq value '(free fixed))))
  :package-version '(flycheck-nagfor . "0.01"))

(defun flycheck-option-nagfor-layout (value)
  "Option VALUE filter for `flycheck-nagfor-layout'."
  (pcase value
    (`nil nil)
    (`free "-free")
    (`fixed "-fixed")
    (_ (error "Invalid value for flycheck-nagfor-layout: %S" value))))

(flycheck-def-option-var flycheck-nagfor-info "info" fortran-nagfor
  "Whether to suppress informational messages.
The value of this variable is one of the following symbols:
nil
     Suppress informational messages.
`info'
     Show informational messages"
  :type '(choice (const :tag "Suppress informational messages" nil)
                 (const :tag "Show informational messages" free))
  :safe #'stringp
  :package-version '(flycheck-nagfor . "0.01"))

(flycheck-def-option-var flycheck-nagfor-warnings nil
                         fortran-nagfor
  "A list of warnings for nagfor to suppress.
The value of this variable is a list of strings, where each string
is the name of a warning category to suppress.
Refer to the nagfor manual for more information
about warnings"
  :type '(choice (const :tag "No additional warnings" nil)
                 (repeat :tag "Additional warnings"
                         (string :tag "Warning name")))
  :safe #'flycheck-string-list-p
  :package-version '(flycheck-nagfor . "0.01"))

(flycheck-define-checker fortran-nagfor
  "An Fortran syntax checker using nagfor.
Uses NAG's Fortran compiler nagfor."
  :command ("nagfor"
	    "-c"
	    "-o" "/dev/null"
	    "-info"
            (option "-" flycheck-nagfor-language-standard concat)
            (option "" flycheck-nagfor-layout concat
                    flycheck-option-nagfor-layout)
            (option-list "-w=" flycheck-nagfor-warnings concat)
            (option-list "-I" flycheck-nagfor-include-path concat)
	    (option-flag "-info" flycheck-nagfor-info)
            (eval flycheck-nagfor-args)
            source)
  :error-patterns
  ((error line-start "Error: " (file-name) ", line " line ": " (message) line-end)
   (error line-start "Fatal: " (file-name) ", line " line ": " (message) line-end)
   (error line-start "Panic: " (file-name) ", line " line ": " (message) line-end)
   (warning line-start "Warning: " (file-name) ", line " line ": " (message) line-end)
   (warning line-start "Extension: " (file-name) ", line " line ": " (message) line-end)
   (warning line-start "Obsolescent: " (file-name) ", line " line ": " (message) line-end)
   (warning line-start "Deleted feature used: " (file-name) ", line " line ": " (message) line-end)
   (warning line-start "Questionable: " (file-name) ", line " line ": " (message) line-end)
   (info line-start "Info: " (file-name) ", line " line ": " (message) line-end))
  :modes (fortran-mode f90-mode))

(provide 'flycheck-nagfor)
;;; flycheck-nagfor.el ends here
