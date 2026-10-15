# Verification record

Executed locally on 2026-10-15 with R 4.5.2; direct package versions are recorded
in results/dependency-versions.csv and transitive versions in renv.lock.

- Inspected all six coursework uploads and the four-page GitHub snapshot PDF.
- Compared repository source to the supplied final Rmd: byte-identical.
- Compared both final HTML uploads: byte-identical SHA-256.
- Enforced the supplied CSV's SHA-256 before each model run.
- Rebuilt the analysis twice with seed 141. Both test_predictions.csv and
  test_metrics.csv were byte-identical across these two full fits.
- Ran tests/test_analysis.R: 25 checks passed. ROC-AUC agrees with independent
  pROC calculations; AP hand examples include tied and reversed scores.
- Confirmed zero overlapping IDs across fitting, calibration, and test years.
- Confirmed changing county, size-class, or containment fields does not change
  retained rows or predictors; changing final size changes labels only.
- Checked leap-day conversion and rejection of an invalid nonleap day 366.
- Regenerated docs/index.html from the saved results and current R source.
- Opened the HTML in a browser and inspected the introduction, tables, ranking
  curves, reliability, and annual figures. No model-fitting warnings were emitted.
  Pandoc emitted a nonfatal deprecation notice about its mathjax option.

The GitHub workflow independently restores renv.lock, refits, runs the same
checks, compares committed metric tables within numeric tolerance 1e-6, and
renders the report. Its result is available under the repository's Actions tab.
Local repetition verifies reproducibility in this environment; it does not by
itself verify all operating systems or clear the study's sampling limitations.

## Recheck commands

```bash
Rscript scripts/run_analysis.R
Rscript tests/test_analysis.R
Rscript scripts/render_report.R
```

To audit outputs without refitting, inspect results/test_predictions.csv,
results/test_metrics.csv, results/yearly_metrics.csv, and results/data_audit.csv.
