packages <- c("randomForest", "ggplot2", "knitr", "rmarkdown", "digest", "jsonlite", "pROC")
missing <- setdiff(packages, rownames(installed.packages()))
if (length(missing)) install.packages(missing, repos = "https://cloud.r-project.org")
if (!rmarkdown::pandoc_available()) stop("Install Pandoc or use RStudio before rendering.")
