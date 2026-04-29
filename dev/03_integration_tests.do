*! Integration tests for ebalance — broader coverage than baseline.
*!
*!   t1: default (1st-moment balancing)
*!   t2: targets(3 1 1) (1st/2nd/3rd moments for first var, 1st only for others)
*!   t3: manualtargets(<means>)  — single-group / survey reweighting mode
*!   t4: keep() saves balance table

clear all
set more off
adopath ++ "`c(pwd)'"

log using "dev/integration_tests.log", replace text

file open out using "dev/integration_outputs.txt", write replace text
file write out "ebalance Stata integration tests — current source" _n _n

capture program drop dump
program dump
  args label
  file write out "==== `label' ====" _n
  file write out "convg:    " %14.10f (e(convg)) _n
  file write out "maxdiff:  " %14.10f (e(maxdiff)) _n _n
end

* -------------------- t1: default --------------------
display _newline as txt "=== t1: default ==="
use "cps1re74.dta", clear
ebalance treat age educ black, tar(1) gen(_w_t1)
dump "t1 default"

* -------------------- t2: 3rd moment for age --------------------
display _newline as txt "=== t2: targets(3 1 1) ==="
use "cps1re74.dta", clear
ebalance treat age educ black, tar(3 1 1) gen(_w_t2)
dump "t2 targets 3 1 1"

* -------------------- t3: manualtargets (single-group mode) --------------------
display _newline as txt "=== t3: manualtargets ==="
use "cps1re74.dta", clear
* reweight controls so age=25, educ=10, black=0.84
ebalance age educ black if treat == 0, manualtargets(25 10 0.84) gen(_w_t3)
dump "t3 manualtargets"

* -------------------- t4: keep() balance table --------------------
display _newline as txt "=== t4: keep() ==="
use "cps1re74.dta", clear
tempfile baltab
ebalance treat age educ black, tar(1) gen(_w_t4) keep("`baltab'") replace
dump "t4 keep"
preserve
use "`baltab'", clear
file write out "t4 balance table vars:" _n
foreach v of varlist _all {
  file write out "  `v'" _n
}
file write out _n
restore

file close out
log close
display "Wrote dev/integration_outputs.txt"
