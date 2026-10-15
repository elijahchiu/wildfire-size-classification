# Which recorded wildfires become large?

Using 100,000 historical wildfire records, I checked whether discovery date and
location help distinguish fires whose final recorded area reached **300 acres**.
I compared logistic regression with Random Forest using the same inputs, trained
on earlier years, and tested on later ones.

**[Read the full report (PDF)](https://elijahchiu.github.io/wildfire-size-classification/wildfire_severity.pdf)**

## Results

The 2012–2015 test set contains **14,946 sampled fires**, including **211 large
fires (1.412%)**. Both models are fit on 1992–2008. I use 2009–2011 to adjust
the forest's predicted probabilities before testing it.

| Model | ROC-AUC | Average precision | Brier score | Log loss |
|---|---:|---:|---:|---:|
| Constant-share reference | 0.500 | 0.014 | 0.01392 | 0.07417 |
| Logistic regression | 0.771 | 0.049 | 0.01406 | 0.07056 |
| Random Forest | 0.726 | 0.099 | 0.01352 | 0.10432 |
| Probability-adjusted Random Forest | 0.726 | 0.099 | 0.01369 | 0.06901 |

ROC-AUC and average precision measure how well a model ranks large fires; higher
is better. Average precision is affected by how rare large fires are, so the
constant-share reference is the test-set share of **1.4%**. Brier score and log
loss measure probability error; lower is better. Logistic regression has the
higher ROC-AUC, while Random Forest has higher average precision. Adjusting the
forest's probabilities lowers its log loss but slightly raises its Brier score,
so neither model leads on every measure. The report also shows results by year.

## Why I changed the question

The original coursework tried to predict whether a county had a fire in a given
month. It treated months with no event in this sample as months with no fire,
although a missing event in a sample does not show that no fire occurred. County
names also varied, and records without county values were dropped. I changed the
question to whether a recorded fire's final area reached 300 acres and kept all
100,000 records. The old AUC claims no longer apply. [Read the audit](AUDIT.md)
for the counts and reasons for these changes.

## Reproduce

Use R 4.5.2, Pandoc, and XeLaTeX. Pandoc is included with RStudio. From the project folder,
restore the recorded package versions once:

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

The CSV is included, so no download or paid service is needed. Before fitting,
the analysis checks that the data file matches its recorded SHA-256 hash. The
render step builds the report PDF and a plain Pages link from saved results; it
does not retrain the models. GitHub Actions reruns the analysis and checks the
results against the saved metrics.

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

These results describe only the supplied sample; its selection method was not
provided. The apparent source is [Short's 1992–2015 Fire Program Analysis
Fire-Occurrence Database (FPA FOD), fourth edition](https://doi.org/10.2737/RDS-2013-0009.4).
This analysis does not estimate where fires will start, confirm that every input
would be available at discovery time, or show how well the models work on current
fires or in new regions. Final area is one measure of fire size, not total damage.
The report discusses these limits alongside the results.

The code is released under the [MIT license](LICENSE). The dataset's source and
reuse terms are described in [data/README.md](data/README.md).

Elijah Chiu · UC Davis · STA 141A portfolio revision
