;;; flycheck-ifort.el --- A flycheck parser for ifort  -*- lexical-binding: t; coding: utf-8 -*-
;;; package --- Summary

;;; URL: https://github.com/edbennett/flycheck-ifort
;;; Package-Version: 0.0.1
;;; Package-Requires: ((emacs "24.1"))

;;; Commentary:
;;; Based on the fortran-gfortran checker at https://github.com/flycheck/flycheck/blob/master/flycheck.el

;;; Code:
(require 'flycheck)

(flycheck-def-args-var flycheck-ifort-args fortran-ifort
  :package-version '(flycheck-ifort . "0.01"))

(flycheck-def-option-var flycheck-ifort-include-path nil fortran-ifort
  "A list of include directories for ifort.
The value of this variable is a list of strings, where each
string is a directory to add to the include path of ifort.
Relative paths are relative to the file being checked."
  :type '(repeat (directory :tag "Include directory"))
  :safe #'flycheck-string-list-p
  :package-version '(flycheck-ifort . "0.01"))

(flycheck-def-option-var flycheck-ifort-language-standard "f95" fortran-ifort
  "The language standard to use in Ifort.
The value of this variable is either a string denoting a language
standard, or nil, to use the default standard.  When non-nil,
pass the language standard via the `-std' option."
  :type '(choice (const :tag "Default standard" nil)
                 (string :tag "Language standard"))
  :safe #'stringp
  :package-version '(flycheck-ifort . "0.01"))

(flycheck-def-option-var flycheck-ifort-layout nil fortran-ifort
  "The source code layout to use in ifort.
The value of this variable is one of the following symbols:
nil
     Let ifort determine the layout from the extension
`free'
     Use free form layout
`fixed'
     Use fixed form layout
In any other case, an error is signaled."
  :type '(choice (const :tag "Guess layout from extension" nil)
                 (const :tag "Free form layout" free)
                 (const :tag "Fixed form layout" fixed))
  :safe (lambda (value) (or (not value) (memq value '(free fixed))))
  :package-version '(flycheck-ifort . "0.01"))

(defun flycheck-ifort-option-ifort-layout (value)
  "Option VALUE filter for `flycheck-ifort-layout'."
  (pcase value
    (`nil nil)
    (`free "-free")
    (`fixed "-fixed")
    (_ (error "Invalid value for flycheck-ifort-layout: %S" value))))

(flycheck-def-option-var flycheck-ifort-warnings '("all")
                         fortran-ifort
  "A list of warnings for ifort.
The value of this variable is a list of strings, where each string
is the name of a warning category to enable.
Refer to the ifort manual at URL
`https://software.intel.com/sites/default/files/m/f/8/5/8/0/6366-ifort.txt'
for more information about warnings"
  :type '(choice (const :tag "No additional warnings" nil)
                 (repeat :tag "Additional warnings"
                         (string :tag "Warning name")))
  :safe #'flycheck-string-list-p
  :package-version '(flycheck-ifort . "0.01"))

(defun flycheck-ifort-parse-with-patterns (output checker buffer)
  "Flycheck error parser for ifort. Converts lines which look like ------^ into a number."
  (flycheck-parse-with-patterns
   (replace-regexp-in-string "^-+\\^$"
                             (lambda (s)
                               (number-to-string (length s)))
                             output)
   checker buffer))

(flycheck-define-checker fortran-ifort
  "An Fortran syntax checker using ifort.
Uses Intel's Fortran compiler ifort.  See URL
`https://software.intel.com/sites/default/files/m/f/8/5/8/0/6366-ifort.txt'."
  :command ("ifort"
            "-syntax-only"
            (option "-stand" flycheck-ifort-language-standard)
            (option "" flycheck-ifort-layout concat
                    flycheck-ifort-option-ifort-layout)
            (option-list "-warn" flycheck-ifort-warnings)
            (option-list "-I" flycheck-ifort-include-path concat)
            (eval flycheck-ifort-args)
            source)
  :error-parser flycheck-ifort-parse-with-patterns
  :error-patterns
  ((error line-start (file-name) "(" line "): error " (message) "\n"
          (zero-or-more not-newline) "\n"
          column line-end)
   (warning line-start (file-name) "(" line "): warning " (message) "\n"
            (zero-or-more not-newline) "\n"
            column line-end)
   (info line-start (file-name) "(" line "): remark " (message) "\n"
         (zero-or-more not-newline) "\n"
         column line-end))
  :modes (fortran-mode f90-mode))

(provide 'flycheck-ifort)
;;; flycheck-ifort.el ends here
