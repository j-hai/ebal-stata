# ebal Stata 1.5.5

## New options

* **`quietly`** suppresses all per-iteration progress output, the
  "Data Setup" / "Optimizing..." banners, and the pre/post balance
  tables. Convergence status (success or failure) is still printed.
  Output volume drops by roughly 4x in production scripts. The
  computed `e(preBal)` / `e(postBal)` matrices are still ereturned
  so balance information is available programmatically.

* **`replace`** now also applies to `gen()`. Previously a
  user-supplied `gen(myvar)` name would error if `myvar` already
  existed in the dataset; only the default `_webal` was silently
  overwritten. With `replace`, the user-supplied name behaves like
  the default (silent overwrite). The keep()-file semantics of
  `replace` are unchanged. As a small side effect, `replace` is no
  longer rejected when used without `keep()`.

## Numerical hardening

* Mata `eb()` and `linesearch()` now cap the linear predictor
  `coX * coefs'` at 700 before applying `exp()`. Previously, with
  ill-conditioned data a single Newton step could push coefficients
  into a regime where `exp(...)` overflowed to `Inf`, propagating
  `NaN` through the next multiplication and silently corrupting the
  result. The cap is inactive (no-op) on well-conditioned problems
  and only kicks in to keep the optimizer numerically afloat.

## Verified

Canonical Lalonde NSW-CPS example reproduces byte-for-byte against
the 1.5.3 baseline. The new `quietly` and `replace` options are
exercised in `dev/05_new_options_test.do`.

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
