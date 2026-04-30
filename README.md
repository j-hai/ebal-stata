# ebal for Stata

Stata implementation of **entropy balancing** — reweights a control
sample so that user-specified covariate moments match those of a
treatment group, or reweights a survey sample to match known
population characteristics.

The method is described in:

> Hainmueller, J. (2012). "Entropy Balancing for Causal Effects: A Multivariate Reweighting Method to Produce Balanced Samples in Observational Studies." *Political Analysis*, 20(1), 25–46.

## Installation

```stata
* From SSC (stable):
ssc install ebalance, replace

* Development version from GitHub:
net install ebalance, from(https://raw.githubusercontent.com/j-hai/ebal-stata/main/e/) replace
```

When net-installing directly from GitHub, Stata installs the command
and help files, but not the bundled example dataset. To download
`cps1re74.dta` into your current working directory, run:

```stata
net get ebalance, from(https://raw.githubusercontent.com/j-hai/ebal-stata/main/e/)
```

## Quick start

```stata
sysuse cps1re74
ebalance treat age educ black, tar(1)

* Higher-order moments (variance, skewness) for age:
ebalance treat age educ black, tar(3 1 1)

* Save the reweighting weights:
ebalance treat age educ black, tar(1) gen(ebw)
regress re78 treat [aweight=ebw]
```

After `ebalance`, the standard ereturned values are available:

* `e(maxdiff)` — maximum constraint violation at the converged solution
* `e(convg)` — 1 if converged, 0 otherwise
* `e(preBal)` / `e(postBal)` — pre- and post-weighting balance matrices
* `e(moments)`, `e(lambdas)` — target moments and Lagrange multipliers

## What's new in 1.5.5

* **`quietly`** option suppresses per-iteration progress, banners, and
  the pre/post balance tables. ~4× quieter logs for production scripts;
  `e(preBal)` / `e(postBal)` matrices still ereturned.
* **`replace`** now also applies to `gen()`. Previously
  `gen(custom_name)` errored if the variable already existed; only the
  default `_webal` was silently overwritten. With `replace`, any name
  is overwritten cleanly.
* **Numerical hardening**: cap on `exp(coX * coefs')` linear predictor
  at 700 prevents `Inf → NaN` propagation under ill-conditioned data.
  No-op for well-conditioned fits.

## What was new in 1.5.4

* Fixed leftover `di "test"` debug print on `basewt()` path.
* Fixed wrong-variable-name in the 3rd-moment-failure diagnostic.
* All ~14 `exit` after error messages converted to `exit 198`, so user
  scripts can detect failures via `_rc`.
* Typos in error/comment strings.
* `version 11.2` → `version 13.0`.

No numerical changes in either release — verified byte-for-byte
against the 1.5.3 baseline on the canonical Lalonde example.

See [`NEWS.md`](NEWS.md) for the full change log.

## License

GPL (>= 2).
