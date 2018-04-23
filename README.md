# ifort support for Flycheck

The file `flycheck-ifort.el` defines the `fortran-ifort` and `fortran-nagfor` checkers for
Flycheck, allowing Flycheck to use `ifort` and `nagfor` on Fortran code. It is very closely 
based on the build-in `fortran-gfortran` checker available at [the Flycheck
project](https://github.com/flycheck/flycheck/blob/master/flycheck.el).

Because `ifort`
can't output column numbers, a wrapper script is needed to count the length
of the line that points at the error. (It *might* be possible to do this in
Elisp, probably by building a custom parser rather than using the building 
blocks defined by Flycheck, but my Elisp skill level isn't up to that.)
Because of this, and because I haven't made it aware of the Windows `ifort` 
flags, it only works on Linux/Mac currently. 

Since `nagfor` doesn't or present store column number information at all,
`nagfor`'s output is restricted to highlighting the entire affected line.
NAG have logged this as a feature request.

## Installation

1. Clone the repository to `~/.emacs.d/flycheck-ifort`
2. Edit your `init.el` or `.emacs` to load the module, after Flycheck
   is loaded. I use the following:

```
(add-to-list 'load-path "~/.emacs.d/flycheck-ifort")
(require 'flycheck-ifort)
(require 'flycheck-nagfor)
```

## Activation

`fortran-ifort` and `fortran-nagfor` don't register themselves as the default checker for 
Fortran files. Once they are installed, you can activate one via
`M-x flycheck-select-checker fortran-ifort` or `C-c ! s fortran-ifort` (or the
equivalents with `nagfor` in place of `ifort`).
