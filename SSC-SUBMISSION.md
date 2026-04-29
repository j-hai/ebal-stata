# Submitting ebalance 1.5.5 to SSC

The Stata `ebalance` package is on SSC. To update the SSC copy with
this 1.5.5 release, email Kit Baum at Boston College — but **don't
attach the zip**. Gmail's content filter blocked the synth-stata
submission. Point Kit at the GitHub release URL instead.

## Files in the SSC bundle

```
ebalance.ado
ebalance.sthlp
ebalance.pkg
```

(Don't ship `cps1re74.dta` — that's a repo illustration.)

## Email template

To: `kit.baum@bc.edu`
Subject: `ebalance update — version 1.5.5`

```
Dear Kit,

Please find an updated version (1.5.5) of the ebalance package for SSC,
downloadable from:

  https://github.com/j-hai/ebal-stata/releases/download/v1.5.5/ebalance-1.5.5-ssc.zip

This rolls together two release notches relative to the 1.5.3 (Jan 2014)
copy currently on SSC:

1.5.4 — Bug fixes:
  * Removed leftover 'di "test"' debug print on the basewt() option path.
  * Fixed a wrong-variable-name diagnostic when the algorithm fails to
    balance a 3rd-moment constraint (was looking up the variable from
    the 2nd-moment list).
  * All ~14 'exit' statements after error messages converted to
    'exit 198'. Previously the program reported errors but then
    silently exited with success — user scripts checking _rc could
    not detect failure.
  * Several typos in error/comment strings.
  * version 11.2 -> 13.0.

1.5.5 — New options + numerical hardening:
  * 'quietly' option suppresses per-iteration progress, banners, and
    the pre/post balance tables. ~4x quieter logs for production
    scripts; e(preBal) / e(postBal) matrices still ereturned.
  * 'replace' option now also applies to gen(). Previously
    gen(custom_name) errored if the variable already existed; only
    the default _webal was silently overwritten. With replace, any
    name is overwritten cleanly.
  * Mata: cap on exp(coX * coefs') linear predictor at 700 prevents
    Inf -> NaN propagation under ill-conditioned data. No-op for
    well-conditioned fits.

No numerical changes — verified byte-for-byte against the 1.5.3
baseline on the canonical Lalonde NSW-CPS example.

Source repository: https://github.com/j-hai/ebal-stata

Best,
Jens Hainmueller
jhain@stanford.edu
```

## How to package the zip

```sh
cd /Users/jhainmueller/Documents/GitHub/ebal-stata
zip ~/Desktop/ebalance-1.5.5-ssc.zip \
  ebalance.ado ebalance.sthlp ebalance.pkg
```

The release on GitHub also has the zip attached at the URL above.

## Test users can do before SSC is live

```stata
net install ebalance, from(https://raw.githubusercontent.com/j-hai/ebal-stata/main/) replace
```
