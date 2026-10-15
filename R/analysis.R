clip <- function(p) pmin(pmax(p, 1e-06), 1 - 1e-06)
# Step-integrated precision-recall area (average precision), grouped at ties.
pr_curve <- function(y, p) {
    o <- order(p, decreasing = TRUE)
    y <- y[o]
    p <- p[o]
    ends <- c(which(diff(p) != 0), length(p))
    tp <- cumsum(y)[ends]
    data.frame(recall = tp/sum(y), precision = tp/ends)
}
metrics <- function(y, p) {
    stopifnot(length(y) == length(p), all(is.finite(p)), all(p >= 0 & p <= 1), all(y %in% 0:1),
        length(unique(y)) == 2)
    z <- pr_curve(y, p)
    n1 <- sum(y)
    n0 <- length(y) - n1
    c(ROC_AUC = (sum(rank(p)[y == 1]) - n1 * (n1 + 1)/2)/(n1 * n0), PR_AUC_AP = sum(diff(c(0, z$recall)) *
        z$precision), Brier = mean((y - p)^2), Log_loss = -mean(y * log(clip(p)) + (1 - y) * log(1 -
        clip(p))))
}
prepare <- function(d) {
    req <- c("FOD_ID", "FIRE_YEAR", "DISCOVERY_DOY", "STATE", "LATITUDE", "LONGITUDE", "FIRE_SIZE")
    stopifnot(all(req %in% names(d)), !anyDuplicated(d$FOD_ID), !anyNA(d$FOD_ID))
    date <- as.Date(sprintf("%d-01-01", d$FIRE_YEAR)) + d$DISCOVERY_DOY - 1
    valid <- complete.cases(d[, req]) & is.finite(d$FIRE_SIZE) & d$FIRE_SIZE >= 0 & d$LATITUDE >=
        -90 & d$LATITUDE <= 90 & d$LONGITUDE >= -180 & d$LONGITUDE <= 180 & d$DISCOVERY_DOY >= 1 &
        format(date, "%Y") == as.character(d$FIRE_YEAR) & nzchar(d$STATE)
    stopifnot(!anyNA(valid))
    excluded <- sum(!valid)
    d <- d[valid, ]
    date <- date[valid]
    month <- as.integer(format(date, "%m"))
    # Explicit allowlist: final size is a label, never an input predictor.
    out <- data.frame(FOD_ID = d$FOD_ID, FIRE_YEAR = d$FIRE_YEAR, large = as.integer(d$FIRE_SIZE >=
        300), sin_month = sin(2 * pi * month/12), cos_month = cos(2 * pi * month/12), year_centered = d$FIRE_YEAR -
        2000, STATE = d$STATE, LATITUDE = d$LATITUDE, LONGITUDE = d$LONGITUDE)
    attr(out, "excluded") <- excluded
    out
}
run_analysis <- function() {
    path <- "data/raw/wildfires_sample_100k.csv"
    stopifnot(digest::digest(file = path, algo = "sha256") == "4d5c250d32c77a3e522df438fc98074c21815d69536a4ea081f490dc36cfd935")
    raw <- read.csv(path, colClasses = c(COUNTY = "character", FIPS_CODE = "character"))
    d <- prepare(raw)
    train <- d[d$FIRE_YEAR <= 2008, ]
    calibration <- d[d$FIRE_YEAR %in% 2009:2011, ]
    test <- d[d$FIRE_YEAR >= 2012, ]
    states <- sort(unique(train$STATE))
    stopifnot(all(calibration$STATE %in% states), all(test$STATE %in% states))
    for (nm in c("train", "calibration", "test")) {
        part <- get(nm)
        part$STATE <- factor(part$STATE, levels = states)
        assign(nm, part)
    }
    form <- large ~ sin_month + cos_month + year_centered + STATE + LATITUDE + LONGITUDE
    glm_fit <- glm(form, data = train, family = binomial())
    stopifnot(glm_fit$converged, !anyNA(coef(glm_fit)))
    seasonal_fit <- glm(large ~ sin_month + cos_month + year_centered, data = train, family = binomial())
    set.seed(141)
    rf_fit <- randomForest::randomForest(update(form, factor(large) ~ .), data = train, ntree = 300,
        mtry = 3, nodesize = 50)
    predict_rf <- function(x) as.numeric(predict(rf_fit, newdata = x, type = "prob")[, "1"])
    cal_rf <- predict_rf(calibration)
    calibrator <- glm(large ~ score, data = data.frame(large = calibration$large, score = qlogis(clip(cal_rf))),
        family = binomial())
    stopifnot(calibrator$converged, coef(calibrator)[2] > 0)
    rf_test <- predict_rf(test)
    predictions <- data.frame(FOD_ID = test$FOD_ID, year = test$FIRE_YEAR, STATE = test$STATE, y = test$large,
        Prevalence = mean(train$large), Seasonal_logistic = predict(seasonal_fit, test, type = "response"),
        Logistic = predict(glm_fit, test, type = "response"), Random_forest = rf_test, Calibrated_forest = predict(calibrator,
            newdata = data.frame(score = qlogis(clip(rf_test))), type = "response"))
    models <- names(predictions)[5:ncol(predictions)]
    scores <- do.call(rbind, lapply(models, function(m) data.frame(Model = m, as.list(metrics(predictions$y,
        predictions[[m]])))))
    yearly <- do.call(rbind, lapply(sort(unique(test$FIRE_YEAR)), function(yr) {
        z <- predictions[predictions$year == yr, ]
        do.call(rbind, lapply(models, function(m) data.frame(year = yr, n = nrow(z), positives = sum(z$y),
            prevalence = mean(z$y), Model = m, as.list(metrics(z$y, z[[m]])))))
    }))
    splits <- do.call(rbind, lapply(c("train", "calibration", "test"), function(nm) {
        x <- get(nm)
        data.frame(split = nm, start = min(x$FIRE_YEAR), end = max(x$FIRE_YEAR), n = nrow(x), positives = sum(x$large),
            prevalence = mean(x$large))
    }))
    old <- raw[!is.na(raw$STATE) & !is.na(raw$COUNTY) & raw$COUNTY != "", ]
    old$month <- as.integer(format(as.Date(sprintf("%d-01-01", old$FIRE_YEAR)) + old$DISCOVERY_DOY -
        1, "%m"))
    counties <- nrow(unique(old[c("STATE", "COUNTY")]))
    positive_months <- nrow(unique(old[old$FIRE_SIZE >= 300, c("STATE", "COUNTY", "FIRE_YEAR", "month")]))
    fips <- raw[!is.na(raw$FIPS_CODE) & nzchar(raw$FIPS_CODE), c("STATE", "FIPS_CODE")]
    audit <- data.frame(item = c("input_rows", "input_columns", "missing_county", "old_county_string_groups",
        "state_fips_pairs_nonmissing", "old_panel_rows", "old_positive_months", "old_panel_prevalence",
        "geography_codes", "large_events", "duplicate_FOD_ID", "excluded_model_rows"), value = c(nrow(raw),
        ncol(raw), sum(is.na(raw$COUNTY) | raw$COUNTY == ""), counties, nrow(unique(fips)), counties *
            24 * 12, positive_months, positive_months/(counties * 24 * 12), length(unique(raw$STATE)),
        sum(d$large), sum(duplicated(raw$FOD_ID)), attr(d, "excluded")))
    write.csv(scores, "results/test_metrics.csv", row.names = FALSE)
    write.csv(yearly, "results/yearly_metrics.csv", row.names = FALSE)
    write.csv(splits, "results/splits.csv", row.names = FALSE)
    write.csv(audit, "results/data_audit.csv", row.names = FALSE)
    write.csv(predictions, "results/test_predictions.csv", row.names = FALSE)
    write.csv(data.frame(term = names(coef(calibrator)), estimate = coef(calibrator)), "results/calibration_coefficients.csv",
        row.names = FALSE)
    saveRDS(list(raw_summary = audit, splits = splits, scores = scores, yearly = yearly, predictions = predictions,
        annual = aggregate(large ~ FIRE_YEAR, d, mean), month = aggregate(as.integer(raw$FIRE_SIZE >=
            300), list(month = as.integer(format(as.Date(sprintf("%d-01-01", raw$FIRE_YEAR)) + raw$DISCOVERY_DOY -
            1, "%m"))), mean), calibration = coef(calibrator)), "results/report_data.rds")
    writeLines(capture.output(sessionInfo()), "results/session-info.txt")
    print(splits)
    print(scores)
    print(audit)
}
