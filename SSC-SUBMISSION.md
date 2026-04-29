# Submitting ebalance 1.5.4 to SSC

The Stata `ebalance` package is on SSC. To update the SSC copy with
this 1.5.4 release, email Kit Baum at Boston College — but **don't
attach the zip**. Gmail's content filter blocked the synth-stata
submission for that reason. Point Kit at the GitHub release URL
instead.

## Files in the SSC bundle

```
ebalance.ado
ebalance.sthlp
ebalance.pkg
```

(Don't ship `cps1re74.dta` — that's a repo illustration.)

## Email template

To: `kit.baum@bc.edu`
Subject: `ebalance update — version 1.5.4`

```
Dear Kit,

Please find an updated version (1.5.4) of the ebalance package for SSC,
downloadable from:

  https://github.com/j-hai/ebal-stata/releases/download/v1.5.4/ebalance-1.5.4-ssc.zip

This is a bug-fix release relative to 1.5.3 (Jan 2014):

* Removed a leftover 'di "test"' debug print on the basewt() option
  path — was visible to users any time they passed basewt() without
  wttreat.
* Fixed a wrong-variable-name diagnostic when the algorithm fails to
  balance a 3rd-moment constraint (the message was looking up the
  offending variable from the 2nd-moment list).
* All ~14 'exit' statements after error messages converted to
  'exit 198'. Previously the program reported errors but then
  silently exited with success, so user scripts checking _rc could
  not detect failure.
* Several typos in error/comment strings: 'weigthing', 'artifical'
  (×2), 'defination'.
* version declaration bumped 11.2 -> 13.0.

No numerical changes — byte-for-byte against the 1.5.3 baseline on
the canonical Lalonde NSW-CPS example.

Source repository: https://github.com/j-hai/ebal-stata

Best,
Jens Hainmueller
jhain@stanford.edu
```

## How to package the zip

```sh
cd /Users/jhainmueller/Documents/GitHub/ebal-stata
zip ~/Desktop/ebalance-1.5.4-ssc.zip \
  ebalance.ado ebalance.sthlp ebalance.pkg
```

The release on GitHub also has the zip attached at the URL above.

## Test users can do before SSC is live

```stata
net install ebalance, from(https://raw.githubusercontent.com/j-hai/ebal-stata/main/) replace
```
