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
- Rendered the current report source as a plain, seven-page letter PDF and set
  the Pages landing page to open that PDF.
- Inspected all seven rendered pages, including the title, tables, charts, and
  closing page; no clipping or text substitution was visible.
- Ran tests/test_analysis.R after changing the report format: 25 checks passed.

The first independent GitHub run also completed successfully on Linux:
https://github.com/elijahchiu/wildfire-size-classification/actions/runs/38711726253

The GitHub workflow independently restores renv.lock, refits, runs the same
checks, compares committed metric tables within numeric tolerance 1e-6, and
renders the report. Its result is available under the repository's Actions tab.
The local and GitHub runs verify the tested macOS and Linux environments; they
do not verify every operating system or clear the study's sampling limitations.
The workflow pins Ubuntu 24.04 and uses checkout v6 to avoid announced runner
migration and Node.js 20 deprecation notices.

## Recheck commands

```bash
Rscript scripts/run_analysis.R
Rscript tests/test_analysis.R
Rscript scripts/render_report.R
```

To audit outputs without refitting, inspect results/test_predictions.csv,
results/test_metrics.csv, results/yearly_metrics.csv, and results/data_audit.csv.

## PDF output (2026-10-15)

The report now uses standard PDF document formatting with XeLaTeX. The former
web theme, floating contents panel, and custom stylesheet were removed. The report
PDF is published at `docs/wildfire_severity.pdf`; `docs/index.html` redirects to it.
The render script also saves the PDF under `output/pdf/`. The GitHub workflow
installs XeLaTeX packages before rendering the report.
