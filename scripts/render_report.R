stopifnot(file.exists("results/report_data.rds"))
dir.create("docs", showWarnings = FALSE)
dir.create("output/pdf", recursive = TRUE, showWarnings = FALSE)
report <- rmarkdown::render("reports/wildfire_severity.Rmd",
    output_file = "wildfire_severity.pdf", output_dir = "docs",
    knit_root_dir = normalizePath("."), quiet = TRUE)
stopifnot(file.copy(report, "output/pdf/wildfire_severity.pdf", overwrite = TRUE))
writeLines(c(
    "<!doctype html>",
    "<html lang=\"en\"><head><meta charset=\"utf-8\">",
    "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">",
    "<meta http-equiv=\"refresh\" content=\"0; url=wildfire_severity.pdf\">",
    "<title>Wildfire size report</title></head><body>",
    "<p><a href=\"wildfire_severity.pdf\">Open the wildfire size report (PDF)</a></p>",
    "</body></html>"
), "docs/index.html")
