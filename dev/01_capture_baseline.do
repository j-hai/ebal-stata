*! Capture golden-baseline outputs from ebalance Stata 1.5.3 (frozen).

clear all
set more off
adopath ++ "`c(pwd)'"

which ebalance

use "cps1re74.dta", clear

log using "dev/baseline_1.5.3.log", replace text

ebalance treat age educ black, tar(1) gen(_w_basic)

log close

file open out using "dev/baseline_1.5.3.txt", write replace text
file write out "ebalance Stata baseline -- frozen 1.5.3 reference" _n _n

file write out "---- e(maxdiff) ----" _n
file write out %18.10f (e(maxdiff)) _n _n

file write out "---- e(N_t) (treated) ----" _n
file write out %18.10f (e(N_t)) _n _n

file write out "---- e(N_c) (controls) ----" _n
file write out %18.10f (e(N_c)) _n _n

file write out "---- summary stats of generated weights _w_basic ----" _n
qui sum _w_basic if treat == 0
file write out "min:    " %18.10f (r(min))   _n
file write out "max:    " %18.10f (r(max))   _n
file write out "mean:   " %18.10f (r(mean))  _n
file write out "sd:     " %18.10f (r(sd))    _n
file write out "sum:    " %18.10f (r(mean)*r(N)) _n _n

file write out "---- weighted means of covariates (controls) ----" _n
foreach v of varlist age educ black {
  qui sum `v' if treat == 0 [aweight=_w_basic]
  file write out "`v' weighted mean (control):  " %18.10f (r(mean)) _n
  qui sum `v' if treat == 1
  file write out "`v' mean (treated):           " %18.10f (r(mean)) _n
}
file write out _n

file close out
display "Wrote dev/baseline_1.5.3.txt"
