*! Smoke-test the new options added in 1.5.5: quietly, replace for gen().

clear all
set more off
adopath ++ "`c(pwd)'"

file open out using "dev/new_options.txt", write replace text

* ---- quietly suppresses per-iteration & banner output ----
use "cps1re74.dta", clear
local q_lines = 0
log using "dev/q_test.smcl", replace
ebalance treat age educ black, tar(1) gen(_w_q) quietly
log close
* count non-empty lines (rough proxy for output volume)
file open lf using "dev/q_test.smcl", read text
file read lf line
while r(eof) == 0 {
  if length(`"`line'"') > 0 local ++q_lines
  file read lf line
}
file close lf

local l_lines = 0
use "cps1re74.dta", clear
log using "dev/l_test.smcl", replace
ebalance treat age educ black, tar(1) gen(_w_l)
log close
file open lf using "dev/l_test.smcl", read text
file read lf line
while r(eof) == 0 {
  if length(`"`line'"') > 0 local ++l_lines
  file read lf line
}
file close lf

file write out "quietly log lines:    `q_lines'" _n
file write out "loud    log lines:    `l_lines'" _n
file write out "quietly is smaller:   " (cond(`q_lines' < `l_lines',"YES","NO")) _n _n

* ---- replace lets gen() overwrite a custom name ----
use "cps1re74.dta", clear
gen myw = .
capture noisily ebalance treat age educ black, tar(1) gen(myw)
file write out "gen(myw) without replace: rc=" %4.0f (_rc) "  (must be != 0)" _n
capture noisily ebalance treat age educ black, tar(1) gen(myw) replace
file write out "gen(myw) with replace:    rc=" %4.0f (_rc) ", e(convg)=" %4.0f (e(convg)) "  (rc must be 0)" _n _n

* ---- exit-198 detection ----
use "cps1re74.dta", clear
capture noisily ebalance treat age educ black, tar(1 1) gen(_w)
file write out "wrong-target arity:       rc=" %4.0f (_rc) "  (must be 198)" _n

file close out
cap erase "dev/q_test.smcl"
cap erase "dev/l_test.smcl"
display "Wrote dev/new_options.txt"
