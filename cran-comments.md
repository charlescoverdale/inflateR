## R CMD check results

0 errors | 0 warnings | 2 notes

The 2 notes are:

* `New submission` — expected for a first-time submission
* `unable to verify current time` — local environment issue, not reproducible on CRAN servers

## Changes since initial submission (0.1.0)

* Fixed LICENSE file format — replaced full MIT text with the required DCF stub (`YEAR` / `COPYRIGHT HOLDER`)
* Added `inst/WORDLIST` and `Language: en-US` to suppress false-positive spell-check notes on currency codes (AUD, CHF, CNY, GBP, JPY)
* Simplified World Bank source URLs in README to remove country-specific query parameters that caused 504 timeouts during URL checks
* Corrected maintainer email address

## Downstream dependencies

None — this is a new package.
