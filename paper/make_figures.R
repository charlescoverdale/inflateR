# Figure generator for the inflateR R Journal paper.
# Run: RSTUDIO_PANDOC=/Applications/quarto/bin/tools Rscript paper/make_figures.R

suppressPackageStartupMessages({
  devtools::load_all(".", quiet = TRUE)
  library(ggplot2)
  library(showtext)
  library(scales)
})

font_add("HelveticaNeue",
         regular = "/System/Library/Fonts/Helvetica.ttc",
         bold = "/System/Library/Fonts/Helvetica.ttc",
         italic = "/System/Library/Fonts/Helvetica.ttc")
showtext_auto()
showtext_opts(dpi = 300)

fig_dir <- "paper/figures"
tab_dir <- "paper/tables"
if (!dir.exists(fig_dir)) dir.create(fig_dir, recursive = TRUE)
if (!dir.exists(tab_dir)) dir.create(tab_dir, recursive = TRUE)

ok_blue   <- "#0072B2"
ok_orange <- "#E69F00"
ok_green  <- "#009E73"
ok_red    <- "#D55E00"
ok_purple <- "#CC79A7"
ok_sky    <- "#56B4E9"
ok_grey   <- "#999999"

fam <- "HelveticaNeue"

theme_wp <- function(base_size = 10) {
  theme_bw(base_size = base_size, base_family = fam) +
    theme(
      plot.title = element_blank(), plot.subtitle = element_blank(),
      plot.caption = element_blank(), panel.border = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(linewidth = 0.25, colour = "grey85"),
      axis.line = element_line(linewidth = 0.35, colour = "grey25"),
      axis.ticks = element_line(linewidth = 0.35, colour = "grey25"),
      axis.ticks.length = unit(2.5, "pt"),
      axis.text = element_text(size = base_size, colour = "grey20"),
      axis.title = element_text(size = base_size, colour = "grey20"),
      legend.position = "bottom", legend.title = element_blank(),
      legend.text = element_text(size = base_size - 1, family = fam),
      legend.key.height = unit(10, "pt"),
      legend.key.width = unit(22, "pt"),
      legend.spacing.x = unit(10, "pt"),
      legend.margin = margin(4, 0, 0, 0),
      plot.margin = margin(6, 10, 6, 6)
    )
}

tex_esc <- function(x) gsub("_", "\\\\_", as.character(x))

# -----------------------------------------------------------------------------
# Figure 1: value of 1 unit of GBP / USD / AUD / EUR / JPY from 1970 to 2024.
# -----------------------------------------------------------------------------
yrs <- 1970:2024
ccy <- c("GBP", "USD", "AUD", "EUR", "JPY")
pal <- setNames(c(ok_blue, ok_red, ok_green, ok_orange, ok_purple), ccy)

df1_rows <- list()
for (c in ccy) {
  vals <- tryCatch(
    sapply(yrs, function(y) adjust_inflation(1, y, c, to_year = 2024)),
    error = function(e) NULL)
  if (is.null(vals)) next
  df1_rows[[c]] <- data.frame(year = yrs, value = as.numeric(vals), currency = c)
}
df1 <- do.call(rbind, df1_rows)
df1 <- df1[!is.na(df1$value), ]
df1$currency <- factor(df1$currency, levels = ccy)

p1 <- ggplot(df1, aes(x = year, y = value,
                       colour = currency, linetype = currency)) +
  geom_line(linewidth = 0.8) +
  scale_colour_manual(values = pal) +
  scale_linetype_manual(values = setNames(
    c("solid", "longdash", "dotted", "dotdash", "twodash"), ccy)) +
  scale_x_continuous(breaks = seq(1970, 2024, 10)) +
  scale_y_log10(labels = function(x) paste0(x, "x")) +
  labs(x = NULL,
       y = "Inflation multiplier to 2024 (log scale)") +
  guides(colour = guide_legend(nrow = 1,
                               override.aes = list(linewidth = 0.8)),
         linetype = guide_legend(nrow = 1)) +
  theme_wp(base_size = 10)

ggsave(file.path(fig_dir, "fig1_multipliers.pdf"),
       p1, width = 5.5, height = 3.4, device = cairo_pdf)

# -----------------------------------------------------------------------------
# Figure 2: rolling 10-year inflation rate across 5 currencies.
# -----------------------------------------------------------------------------
df2_rows <- list()
for (c in ccy) {
  for (y in 1970:2014) {
    r <- tryCatch(inflation_rate(c, from_year = y, to_year = y + 10,
                                  annualised = TRUE),
                  error = function(e) NA)
    df2_rows[[length(df2_rows) + 1L]] <- data.frame(
      year = y, rate = as.numeric(r) * 100, currency = c)
  }
}
df2 <- do.call(rbind, df2_rows)
df2 <- df2[!is.na(df2$rate), ]
df2$currency <- factor(df2$currency, levels = ccy)

p2 <- ggplot(df2, aes(x = year, y = rate,
                       colour = currency, linetype = currency)) +
  geom_hline(yintercept = 2, linewidth = 0.3, colour = "grey60",
             linetype = "dashed") +
  geom_line(linewidth = 0.7) +
  scale_colour_manual(values = pal) +
  scale_linetype_manual(values = setNames(
    c("solid", "longdash", "dotted", "dotdash", "twodash"), ccy)) +
  scale_x_continuous(breaks = seq(1970, 2014, 10)) +
  scale_y_continuous(labels = function(x) paste0(x, "%")) +
  labs(x = "Decade starting",
       y = "Annualised 10-year inflation rate") +
  guides(colour = guide_legend(nrow = 1,
                               override.aes = list(linewidth = 0.8)),
         linetype = guide_legend(nrow = 1)) +
  theme_wp(base_size = 10)

ggsave(file.path(fig_dir, "fig2_rolling.pdf"),
       p2, width = 5.5, height = 3.2, device = cairo_pdf)

# -----------------------------------------------------------------------------
# Figure 3: CPI vs GDP deflator divergence for GBP.
# -----------------------------------------------------------------------------
yrs3 <- 1970:2024
cpi_mult <- sapply(yrs3, function(y) {
  tryCatch(adjust_inflation(1, y, "GBP", to_year = 2024),
           error = function(e) NA)
})
gdp_mult <- sapply(yrs3, function(y) {
  tryCatch(adjust_real(1, y, "GBP", to_year = 2024),
           error = function(e) NA)
})

df3 <- rbind(
  data.frame(year = yrs3, mult = cpi_mult, series = "CPI-adjusted"),
  data.frame(year = yrs3, mult = gdp_mult, series = "GDP deflator-adjusted")
)
df3 <- df3[!is.na(df3$mult), ]
df3$series <- factor(df3$series,
                     levels = c("CPI-adjusted", "GDP deflator-adjusted"))

p3 <- ggplot(df3, aes(x = year, y = mult,
                       colour = series, linetype = series)) +
  geom_line(linewidth = 0.8) +
  scale_colour_manual(values = c("CPI-adjusted" = ok_blue,
                                  "GDP deflator-adjusted" = ok_red)) +
  scale_linetype_manual(values = c("CPI-adjusted" = "solid",
                                    "GDP deflator-adjusted" = "longdash")) +
  scale_x_continuous(breaks = seq(1970, 2024, 10)) +
  scale_y_log10(labels = function(x) paste0(x, "x")) +
  labs(x = NULL,
       y = "Multiplier on GBP 1 to 2024 (log scale)") +
  guides(colour = guide_legend(nrow = 1,
                               override.aes = list(linewidth = 0.8)),
         linetype = guide_legend(nrow = 1)) +
  theme_wp(base_size = 10)

ggsave(file.path(fig_dir, "fig3_cpi_gdp.pdf"),
       p3, width = 5.5, height = 3.2, device = cairo_pdf)

# -----------------------------------------------------------------------------
# Figure 4: coverage heatmap of bundled CPI data by currency and decade.
# -----------------------------------------------------------------------------
currencies_df <- list_currencies()
# currencies_df has currency, name, cpi_start, cpi_end (or similar)
# Check actual column names.
cat("list_currencies colnames: ", colnames(currencies_df), "\n")

# Construct coverage by decade for each currency.
decades <- seq(1960, 2020, 10)
cov_rows <- list()
for (i in seq_len(nrow(currencies_df))) {
  cc <- currencies_df$currency[i]
  start <- suppressWarnings(as.integer(currencies_df$cpi_start[i]))
  end   <- suppressWarnings(as.integer(currencies_df$cpi_end[i]))
  if (is.na(start) || is.na(end)) next
  for (d in decades) {
    cov_rows[[length(cov_rows) + 1L]] <- data.frame(
      currency = cc, decade = d,
      covered = as.integer(start <= d + 9 & end >= d)
    )
  }
}
df4 <- do.call(rbind, cov_rows)
df4$currency <- factor(df4$currency, levels = rev(currencies_df$currency))
df4$decade <- factor(df4$decade,
                     labels = paste0(decades, "s"))
df4$covered <- factor(df4$covered, levels = c(0, 1),
                      labels = c("Not covered", "Covered"))

p4 <- ggplot(df4, aes(x = decade, y = currency, fill = covered)) +
  geom_tile(colour = "white", linewidth = 0.4) +
  scale_fill_manual(values = c(`Not covered` = "grey85",
                                Covered = ok_blue)) +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0)) +
  labs(x = NULL, y = NULL) +
  guides(fill = guide_legend(nrow = 1)) +
  theme_wp(base_size = 10)

ggsave(file.path(fig_dir, "fig4_coverage.pdf"),
       p4, width = 5.5, height = 3.6, device = cairo_pdf)

# -----------------------------------------------------------------------------
# Figure 5: purchasing power over time relative to 1970 for 3 currencies.
# -----------------------------------------------------------------------------
yrs5 <- 1970:2024
df5_rows <- list()
for (c in c("GBP", "USD", "JPY")) {
  # Purchasing power: how much does 1 unit in year X buy relative to 1970?
  # = 1970 CPI / year CPI (value of the currency in 1970 goods)
  # = 1 / adjust_inflation(1, 1970, currency, to_year = X)
  vals <- sapply(yrs5, function(y) {
    tryCatch(1 / adjust_inflation(1, 1970, c, to_year = y),
             error = function(e) NA)
  })
  df5_rows[[c]] <- data.frame(year = yrs5, pp = as.numeric(vals), currency = c)
}
df5 <- do.call(rbind, df5_rows)
df5 <- df5[!is.na(df5$pp), ]
df5$currency <- factor(df5$currency, levels = c("GBP", "USD", "JPY"))

p5 <- ggplot(df5, aes(x = year, y = pp,
                       colour = currency, linetype = currency)) +
  geom_line(linewidth = 0.8) +
  scale_colour_manual(values = c(GBP = ok_blue, USD = ok_red, JPY = ok_purple)) +
  scale_linetype_manual(values = c(GBP = "solid", USD = "longdash",
                                    JPY = "dotted")) +
  scale_x_continuous(breaks = seq(1970, 2024, 10)) +
  scale_y_continuous(labels = percent_format(accuracy = 1),
                     limits = c(0, 1)) +
  labs(x = NULL,
       y = "Purchasing power relative to 1970") +
  guides(colour = guide_legend(nrow = 1,
                               override.aes = list(linewidth = 0.8)),
         linetype = guide_legend(nrow = 1)) +
  theme_wp(base_size = 10)

ggsave(file.path(fig_dir, "fig5_power.pdf"),
       p5, width = 5.5, height = 3.2, device = cairo_pdf)

# -----------------------------------------------------------------------------
# Table: currency coverage.
# -----------------------------------------------------------------------------
tab_lines <- c(
  "\\begin{tabular}{llrr}",
  "\\toprule",
  "Currency & Country & CPI start & CPI end \\\\",
  "\\midrule"
)
for (i in seq_len(nrow(currencies_df))) {
  r <- currencies_df[i, ]
  tab_lines <- c(tab_lines,
    sprintf("%s & %s & %s & %s \\\\",
            r$currency,
            tex_esc(r$country),
            r$cpi_start, r$cpi_end))
}
tab_lines <- c(tab_lines, "\\bottomrule", "\\end{tabular}")
writeLines(tab_lines, file.path(tab_dir, "currencies.tex"))

# -----------------------------------------------------------------------------
# Figure 6: UK real median weekly wages 1980-2024, nominal and deflated.
# -----------------------------------------------------------------------------
# ONS Annual Survey of Hours and Earnings, median gross weekly pay,
# all full-time employees, GBR. Published annually by ONS.
# Values are from successive ASHE releases.
ashe <- data.frame(
  year = c(1980, 1985, 1990, 1995, 2000, 2005, 2010, 2015, 2019, 2020, 2022, 2024),
  wage_nominal = c(121.8, 166.3, 237.4, 287.6, 337.1, 419.5, 489.4,
                    528.0, 586.5, 586.0, 641.9, 681.0)
)
ashe$wage_real_2024 <- sapply(seq_len(nrow(ashe)), function(i) {
  adjust_inflation(ashe$wage_nominal[i], from_year = ashe$year[i],
                    currency = "GBP", to_year = 2024)
})

df_wage <- rbind(
  data.frame(year = ashe$year, wage = ashe$wage_nominal,
             series = "Nominal GBP"),
  data.frame(year = ashe$year, wage = ashe$wage_real_2024,
             series = "Real, 2024 GBP")
)
df_wage$series <- factor(df_wage$series,
                          levels = c("Nominal GBP", "Real, 2024 GBP"))

p_wage <- ggplot(df_wage, aes(x = year, y = wage,
                               colour = series, linetype = series)) +
  geom_line(linewidth = 0.85) +
  geom_point(size = 2) +
  scale_colour_manual(values = c("Nominal GBP" = ok_grey,
                                  "Real, 2024 GBP" = ok_blue)) +
  scale_linetype_manual(values = c("Nominal GBP" = "longdash",
                                    "Real, 2024 GBP" = "solid")) +
  scale_x_continuous(breaks = seq(1980, 2024, 5)) +
  scale_y_continuous(labels = function(x) paste0("GBP ", x)) +
  labs(x = NULL,
       y = "Median weekly earnings (full-time employees, UK)") +
  guides(colour = guide_legend(nrow = 1,
                               override.aes = list(linewidth = 0.9)),
         linetype = guide_legend(nrow = 1)) +
  theme_wp(base_size = 10)

ggsave(file.path(fig_dir, "fig6_uk_wages.pdf"),
       p_wage, width = 5.5, height = 3.2, device = cairo_pdf)

# Summary stats for paper text.
cat(sprintf("wages: 1980 real %.0f, 2024 real %.0f, 2010 real %.0f\n",
            ashe$wage_real_2024[ashe$year == 1980],
            ashe$wage_real_2024[ashe$year == 2024],
            ashe$wage_real_2024[ashe$year == 2010]))
cat(sprintf("wages: 1980-2024 %+.1f%%; 2010-2024 %+.1f%%\n",
            100 * (ashe$wage_real_2024[ashe$year == 2024] /
                     ashe$wage_real_2024[ashe$year == 1980] - 1),
            100 * (ashe$wage_real_2024[ashe$year == 2024] /
                     ashe$wage_real_2024[ashe$year == 2010] - 1)))

cat("\n--- done ---\n")
