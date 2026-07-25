
## Test environments

* local R installation, R 4.5.2
* check_win_devel()

## R CMD check results

0 errors | 1 warnings | 0 notes

W  checking whether package ‘rotasym’ can be installed (4s)
   Found the following significant warnings:
     /Library/Frameworks/R.framework/Resources/include/R_ext/Boolean.h:62:36: warning: unknown warning group '-Wfixed-enum-extension', ignored [-Wunknown-warning-option]
   See ‘/private/var/folders/q8/d13pdb9s7b31x54qxcywwy1w0000gn/T/RtmpOH8LUn/file154312a14c26c/rotasym.Rcheck/00install.out’ for details.

## Comments

Submitted after fixing flaky test in polykde that were raising errors in reverse dependencies checks.

Warning is benign and does not show up in the check_win_devel() checks