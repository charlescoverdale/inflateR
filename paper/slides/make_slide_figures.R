# make_slide_figures.R (inflateR)
# Prepare slide-ready figures:
#  1. Copy paper figures into the slides figures/ directory
#     (hero: UK wages; gallery: multipliers, rolling, CPI-vs-deflator,
#      coverage; deep-dive: purchasing power)
#  2. Generate a QR code pointing to the paper PDF
#
# Usage:  Rscript make_slide_figures.R

suppressPackageStartupMessages({
  if (!requireNamespace("qrcode", quietly = TRUE)) {
    install.packages("qrcode", repos = "https://cloud.r-project.org")
  }
  library(qrcode)
})

fig_dir <- "figures"
if (!dir.exists(fig_dir)) dir.create(fig_dir, recursive = TRUE)

# ------------------------------------------------------------------
# 1. Copy paper figures
#    Hero:      fig6_uk_wages.pdf   -> hero_figure.pdf
#    Gallery 1: fig1_multipliers.pdf
#    Gallery 2: fig2_rolling.pdf
#    Gallery 3: fig3_cpi_gdp.pdf
#    Gallery 4: fig4_coverage.pdf
#    Deep-dive: fig5_power.pdf
# ------------------------------------------------------------------
copy_one <- function(src_name, dst_name) {
  src <- file.path("..", "figures", src_name)
  dst <- file.path(fig_dir, dst_name)
  if (!file.exists(src)) {
    stop("Source figure not found: ", src,
         ". Run the paper's make_figures.R first.")
  }
  file.copy(src, dst, overwrite = TRUE)
  cat("Copied", src_name, "->", dst, "\n")
}

copy_one("fig6_uk_wages.pdf",   "hero_figure.pdf")
copy_one("fig1_multipliers.pdf", "fig1_multipliers.pdf")
copy_one("fig2_rolling.pdf",     "fig2_rolling.pdf")
copy_one("fig3_cpi_gdp.pdf",     "fig3_cpi_gdp.pdf")
copy_one("fig4_coverage.pdf",    "fig4_coverage.pdf")
copy_one("fig5_power.pdf",       "fig5_power.pdf")

# ------------------------------------------------------------------
# 2. QR code to the paper PDF on the publications page
# ------------------------------------------------------------------
paper_url <- "https://charlescoverdale.github.io/files/coverdale_inflateR_2026.pdf"

qr <- qr_code(paper_url, ecl = "M")
png(
  filename = file.path(fig_dir, "qrcode_paper.png"),
  width = 800, height = 800, res = 300, bg = "white"
)
par(mar = rep(0, 4))
plot(qr)
dev.off()

cat("QR code written to", file.path(fig_dir, "qrcode_paper.png"), "\n")
