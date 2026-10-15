# Which recorded wildfires become large?

I use a 100,000-event wildfire sample to study whether discovery date and location
can distinguish fires whose final recorded size reaches **300 acres**. The project
compares logistic regression and Random Forest with the same inputs, trains on
earlier years, and evaluates ranking and probability quality on later fires.

**[Read the full report](https://elijahchiu.github.io/wildfire-size-classification/)**

## Results

The 2012–2015 test set contains **14,946 fires**, including **211 large fires
(1.412%)**. Base models use 1992–2008; forest calibration uses 2009–2011.

| Model | ROC-AUC | Average precision | Brier score | Log loss |
|---|---:|---:|---:|---:|
| Training-prevalence reference | 0.500 | 0.014 | 0.01392 | 0.07417 |
| Logistic regression | 0.771 | 0.049 | 0.01406 | 0.07056 |
| Random Forest | 0.726 | 0.099 | 0.01352 | 0.10432 |
| Calibrated Random Forest | 0.726 | 0.099 | 0.01369 | 0.06901 |

Logistic regression has higher ROC-AUC; the forest has higher pooled average
precision. Calibration improves the forest's log loss but slightly worsens its
Brier score. The report includes annual results and calibration plots, including
years where the pooled comparison does not hold.

## Why I changed the question

The original coursework predicted county-month fire occurrence by zero-filling
months absent from this event sample. An event missing from a sample does not
establish that no fire occurred. Inconsistent county names and missing county
values created further problems. I replaced that target with observed event-level
labels and retained all 100,000 records. The old AUC claims are retired.
[Read the audit](AUDIT.md) for reproduced counts and the reasoning behind each fix.

## Reproduce

Use R 4.5.2 and Pandoc (included with RStudio). From the repository root:

```r
# Run once to restore the recorded package environment:
install.packages("renv", repos = "https://cloud.r-project.org")
renv::restore(lockfile = "renv.lock", prompt = FALSE)
```

Then run from a terminal:

```bash
Rscript scripts/run_analysis.R
Rscript tests/test_analysis.R
Rscript scripts/render_report.R
```

The exact CSV is included; no data download, API key, or paid service is needed.
The analysis checks its SHA-256 before fitting. `scripts/install_dependencies.R`
is a convenience installer for a current R environment; use the lockfile for the
recorded versions. The render step reads saved results and writes a self-contained
`docs/index.html`. Rendering alone does not retrain models. GitHub Actions reruns
the full pipeline and compares regenerated metrics to the committed results.

## Files

| Path | Purpose |
|---|---|
| [reports/wildfire_severity.Rmd](reports/wildfire_severity.Rmd) | Current report source |
| [R/analysis.R](R/analysis.R) | Data checks, features, fitting, calibration, metrics |
| [data/README.md](data/README.md) | Source attribution, sample provenance, data reuse caveats |
| [results/](results/) | Test predictions, metrics, audit counts, input hashes, environment |
| [tests/test_analysis.R](tests/test_analysis.R) | Metric and data-integrity checks |
| [AUDIT.md](AUDIT.md) | Findings and methodological changes |
| [VALIDATION.md](VALIDATION.md) | Executed verification |
| [archive/](archive/) | Superseded coursework sources |

## Scope

These results concern sampled recorded fires. The sampling procedure was not
provided, and the apparent parent is [Short's 1992–2015 FPA FOD, fourth
edition](https://doi.org/10.2737/RDS-2013-0009.4). The analysis does not estimate
ignition risk, prove discovery-time input availability, or establish performance
on current fires or unseen regions. Final area is one measure of severity, not
an estimate of damage. The report explains these limits before presenting results.

Original code and writing: [MIT license](LICENSE). Dataset terms and provenance
are documented separately. Generated HTML and data are excluded from GitHub's
language statistics so the repository reflects its R implementation.

Elijah Chiu · UC Davis · STA 141A portfolio revision
