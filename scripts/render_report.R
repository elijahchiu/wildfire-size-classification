stopifnot(file.exists("results/report_data.rds"))
rmarkdown::render("reports/wildfire_severity.Rmd", output_file = "index.html", output_dir = "docs",
    knit_root_dir = normalizePath("."), quiet = TRUE)
