source("R/analysis.R")
checks <- 0L
check <- function(ok) {
    stopifnot(ok)
    checks <<- checks + 1L
}
# Independent hand-calculated metric cases, including ties and reversed ranking.
y <- c(1, 0, 1, 0)
check(isTRUE(all.equal(unname(metrics(y, c(0.9, 0.8, 0.7, 0.6))[1]), 0.75)))
check(isTRUE(all.equal(unname(metrics(y, c(0.9, 0.8, 0.7, 0.6))[2]), 5/6)))
check(isTRUE(all.equal(unname(metrics(y, rep(0.5, 4))[1:2]), c(0.5, 0.5))))
check(isTRUE(all.equal(unname(metrics(c(0, 0, 1, 1), c(0.9, 0.8, 0.2, 0.1))[1]), 0)))
# Compare ROC implementation with an independent library, direction fixed.
p <- read.csv("results/test_predictions.csv")
scores <- read.csv("results/test_metrics.csv")
for (m in scores$Model) {
    computed <- metrics(p$y, p[[m]])
    check(isTRUE(all.equal(unname(computed), as.numeric(scores[scores$Model == m, -1]), tolerance = 1e-12)))
    check(abs(computed["ROC_AUC"] - as.numeric(pROC::auc(pROC::roc(p$y, p[[m]], direction = "<",
        quiet = TRUE)))) < 1e-12)
}
d <- read.csv("data/raw/wildfires_sample_100k.csv", colClasses = c(COUNTY = "character", FIPS_CODE = "character"))
f <- prepare(d)
check(nrow(f) == 1e+05 && sum(f$large) == 1381 && !anyDuplicated(f$FOD_ID))
check(length(intersect(f$FOD_ID[f$FIRE_YEAR <= 2008], p$FOD_ID)) == 0)
check(length(intersect(f$FOD_ID[f$FIRE_YEAR %in% 2009:2011], p$FOD_ID)) == 0)
check(identical(p$FOD_ID, f$FOD_ID[f$FIRE_YEAR >= 2012]))
check(identical(p$y, f$large[f$FIRE_YEAR >= 2012]))
check(!any(c("FIRE_SIZE", "FIRE_SIZE_CLASS", "CONT_DATE", "STAT_CAUSE_CODE", "COUNTY") %in% names(f)))
# Outcome-derived fields and county absence must not change predictors or retention.
d2 <- d
d2$FIRE_SIZE_CLASS <- "G"
d2$COUNTY <- NA
d2$CONT_DATE <- 0
check(identical(prepare(d2), f))
d2 <- d
d2$FIRE_SIZE <- 0
f2 <- prepare(d2)
check(identical(f2[names(f2) != "large"], f[names(f) != "large"]))
# Leap-year day 60 is February; day 366 of a nonleap year is rejected.
z <- d[1:2, ]
z$FIRE_YEAR <- c(2000, 2001)
z$DISCOVERY_DOY <- c(60, 366)
v <- prepare(z)
check(nrow(v) == 1 && abs(v$sin_month - sin(2 * pi * 2/12)) < 1e-12)
z <- d[1:2, ]
z$FOD_ID <- 1
check(inherits(try(prepare(z), silent = TRUE), "try-error"))
check(all(diff(p$Calibrated_forest[order(p$Random_forest)]) >= 0))
cat(checks, "checks passed\n")
