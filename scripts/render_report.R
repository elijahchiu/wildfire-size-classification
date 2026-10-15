stopifnot(file.exists("results/report_data.rds"))
dir.create("docs", showWarnings = FALSE)
dir.create("output/html", recursive = TRUE, showWarnings = FALSE)
report <- rmarkdown::render("reports/wildfire_severity.Rmd",
    output_file = "wildfire_severity.html", output_dir = "docs",
    knit_root_dir = normalizePath("."), quiet = TRUE)
stopifnot(file.copy(report, "output/html/wildfire_severity.html", overwrite = TRUE))
writeLines(c(
    "<!doctype html>",
    "<html lang=\"en\"><head><meta charset=\"utf-8\">",
    "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">",
    "<meta http-equiv=\"refresh\" content=\"0; url=wildfire_severity.html\">",
    "<title>Wildfire size report</title></head><body>",
    "<p><a href=\"wildfire_severity.html\">Open the wildfire size report (HTML)</a></p>",
    "</body></html>"
), "docs/index.html")
