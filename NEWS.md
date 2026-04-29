# ebal Stata 1.5.4

## Bug fixes

* **Removed leftover `di "test"` debug statement** in the `basewt`
  branch (line 134 of 1.5.3). Previously printed the literal string
  "test" whenever a user supplied `basewt()` without `wttreat`.
* **Wrong variable name in 3rd-moment failure diagnostic.** When the
  algorithm failed to balance a 3rd-moment constraint, the error
  message looked up the offending variable from the 2nd-moment list
  (`constrt2`) instead of the 3rd-moment list (`constrt3`), so the
  reported variable name was wrong.
* **`exit` after error messages didn't propagate failure.** All ~14
  error-handling sites used `exit` (no argument), which silently
  terminates with success. Stata user scripts that check `_rc` after
  `ebalance` would not see the failure. All converted to
  `exit 198` (invalid syntax).
* **Typos** in error/comment strings: `weigthing` → `weighting`;
  `artifical` → `artificial` (×2); `defination` → `definition`.

## Internal cleanup

* Removed a dead commented-out line in the 2nd-moment construction.
* `version` declaration bumped 11.2 → 13.0.

## Verified

The canonical Lalonde NSW-CPS example reproduces byte-for-byte against
the 1.5.3 baseline (`e(maxdiff)` = 0.0003638677, weighted control
means = treated means to 1e-4). 4-scenario integration test suite in
`dev/03_integration_tests.do` covers default, higher-order moments
(`tar(3 1 1)`), single-group `manualtargets`, and `keep()` balance
table — all converge.
