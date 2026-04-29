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
net install ebalance, from(https://raw.githubusercontent.com/j-hai/ebal-stata/main/) replace
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

## What's new in 1.5.4

* Fixed a leftover `di "test"` debug statement that fired whenever
  `basewt()` was used without `wttreat`.
* Fixed wrong-variable-name in the 3rd-moment-failure diagnostic
  message (was reporting from the 2nd-moment list).
* All `exit` after error messages converted to `exit 198`, so user
  scripts can correctly detect `ebalance` failures via `_rc`.
* Several typos fixed; `version` declaration bumped 11.2 → 13.0.
* No numerical changes — verified byte-for-byte against the 1.5.3
  baseline on the canonical Lalonde example.

See [`NEWS.md`](NEWS.md) for the full change log.

## License

GPL (>= 2).
