# ifort support for Flycheck

The file `flycheck-ifort.el` defines the `fortran-ifort` checker for
Flycheck, allowing Flycheck to use `ifort` on Fortran code. Because `ifort`
can't output column numbers, a wrapper script is needed to count the length
of the line that points at the error. (It *might* be possible to do this in
Elisp, probably by building a custom parser rather than using the building 
blocks defined by Flycheck, but my Elisp skill level isn't up to that.)
Because of this, and because I haven't made it aware of the Windows `ifort` 
flags, it only works on Linux/Mac currently. 

## Installation

1. Clone the repository to `~/.emacs.d/flycheck-ifort`
2. Edit your `init.el` or `.emacs` to load the module, after Flycheck
   is loaded. I use the following:

```
(add-to-list 'load-path "~/.emacs.d/flycheck-ifort")
(require 'flycheck-ifort)
```

## Activation

`fortran-ifort` doesn't register itself as the default handler for 
Fortran files. Once it is installed, you can activate it via
`M-x flycheck-select-checker fortran-ifort` or `C-c ! s fortran-ifort`.
