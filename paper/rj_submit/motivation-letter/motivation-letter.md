---
output: pdf_document
fontsize: 12pt
---

\thispagestyle{empty}
\today

The Editor
The R Journal
\bigskip

Dear Editor,
\bigskip

Please consider the article *InflateR: Inflation Adjustment for Historical Currency Values Across Thirteen Currencies in R* for publication in the R Journal.

The \texttt{inflateR} package converts historical monetary values into their present-day equivalents, and vice versa, across thirteen currencies (GBP, USD, AUD, EUR, CAD, JPY, CNY, CHF, NZD, INR, KRW, BRL, NOK) under two measures, the consumer price index and the GDP deflator. All series come from the World Bank Development Indicators and are bundled inside the package, so it has zero runtime dependencies and requires no API key or network access. Four conversion functions arranged in two symmetric pairs handle the forward and reverse directions under each measure; \texttt{inflation\_rate()} returns cumulative or annualised inflation between any two years; and \texttt{list\_currencies()} reports coverage. Related CRAN packages such as \texttt{priceR}, \texttt{quantmod}, and \texttt{WDI} offer partial building blocks, but none provides a purpose-built, multi-currency, two-measure, offline adjustment toolkit with a uniform interface.

Historical price adjustment is a routine operation in journalism, economic history, public policy, financial reporting, and applied teaching. R Journal readers working on long-horizon empirical studies, cost-benefit analysis, public-finance comparisons, wage-stagnation work, and asset-valuation exercises will find the package a drop-in tool that returns numeric values directly rather than raw index series. The package's CPI-versus-deflator rule (CPI for household budgets, deflator for national-accounts aggregates) surfaces a distinction that applied users frequently get wrong, and the case study on UK real median weekly earnings 1980 to 2024 shows the size of the difference between nominal and real interpretations of the same time series.

The manuscript has not been published in a peer-reviewed journal, is not currently under review elsewhere, and all rights to submit rest with the sole author.

\bigskip
\bigskip

Regards,
\bigskip
\bigskip

Charles Coverdale
London, United Kingdom
charles.f.coverdale@gmail.com
