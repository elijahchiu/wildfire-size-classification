# Analysis audit and revision

Reviewed 2026-10-15. This revision renovates the existing repository and preserves
its two original commits. It does not substitute a new repository or claim a new
exhaustive fire database.

## Materials inspected

All six coursework uploads were inspected: Final_report.Rmd, Final_report.html,
Final_report_description.html, Midquarter_description.Rmd,
Midquarter_description.html, and wildfires_sample_100k.csv. The four-page GitHub
snapshot PDF was also inspected. File hashes are in results/input_manifest.json.
The repository's original Rmd is byte-identical to the supplied final Rmd. The two
final HTML uploads are byte-identical. The midquarter is an earlier exploratory
analysis, not a second project. Its source is archived without being executed as
a current model. The PDF's README, file list, two commits, and HTML-only language
classification match the repository's starting state.

## Confirmed defects and decisions

| Finding | Verified evidence | Repair |
|---|---|---|
| Unsupported no-fire labels | The code crosses observed county text labels with 24 years and 12 months, then zero-fills missing sampled events. | Replace occurrence prediction with event-level final-size classification. |
| Inconsistent county identity | 4,232 STATE+COUNTY text groups versus 2,385 nonmissing STATE+FIPS_CODE pairs. Okanogan alone has six county strings. | Remove county dependence; preserve raw identifiers and all missing-county records. Do not present the FIPS count as an authoritative county inventory. |
| Selection on county availability | Original filter excludes 35,991 records. | All 100,000 pass the new modeling checks and are retained. |
| Incorrect geography description | Full sample contains 52 codes, including DC and PR; original filtered panel has 50. | Distinguish state/territory codes from states. |
| Misleading denominator | Original panel has 1,218,816 rows, 764 positive cells, 0.0626838% positive. | New denominator is observed sampled fire events: 1,381 of 100,000 (1.381%). |
| Unequal features | Logistic used seasonality/year; forest additionally used STATE. | Same six inputs for the primary model comparison; reduced seasonal baseline is labeled separately. |
| Resampling obscures probabilities | Original forest used a 3:1 negative/positive subsample. | Fit all training events at their native prevalence and evaluate probability quality. |
| Insufficient evaluation | Old report emphasizes ROC-AUC and combines validation years overlapping the stated test period. | Separate fitting, calibration, and final testing periods; report AP, ROC-AUC, Brier, log loss, reliability, and annual results. |
| Reproduction gap | Repository did not include the required CSV or a functioning acquisition route. | Bundle the exact input, hash it before fitting, record dependencies, provide scripts and checks. |
| Presentation gap | Large generated HTML dominated language statistics and report had no Pages deployment. | Generated/vendored file attributes, focused README, active Rmd/report, Pages hosting. |

The original date conversion was checked against a per-record January 1 plus
DISCOVERY_DOY implementation in the available R version: zero mismatched dates.
No date bug is alleged. The original 0.640/0.755 AUC values were confirmed as
published outputs, not re-estimated as valid occurrence performance. They are
retired. No comparison of new scores to those old scores is meaningful.

## New specification

- Unit: one sampled recorded fire; outcome: final recorded size >= 300 acres.
- Inputs: discovery-month sine/cosine, centered discovery year, state/territory,
  latitude, longitude. No county, cause, containment, final class, names, or IDs.
- Base-model fit: 1992–2008, 71,796 events, 975 positives.
- Forest calibration: 2009–2011, 13,258 events, 195 positives.
- Final test: 2012–2015, 14,946 events, 211 positives (1.41175%).
- Forest: seed 141, 300 trees, mtry 3, nodesize 50, no weighting/downsampling.
- Logistic calibration: intercept and slope of clipped forest log odds; no
  hyperparameter search or threshold selection on the final test set.
- Annual results evaluate fixed models; they are not rolling refits.

## Verified test metrics

| Model | ROC-AUC | AP (step PR area) | Brier | Log loss |
|---|---:|---:|---:|---:|
| Training prevalence | 0.500000 | 0.014117 | 0.013918 | 0.074173 |
| Seasonal logistic | 0.653635 | 0.022635 | 0.013915 | 0.073805 |
| Same-feature logistic | 0.770889 | 0.049451 | 0.014059 | 0.070562 |
| Random Forest | 0.725721 | 0.098974 | 0.013521 | 0.104318 |
| Calibrated forest | 0.725721 | 0.098974 | 0.013687 | 0.069013 |

Logistic ranks better by ROC-AUC; the forest retrieves positives better by pooled
AP. That AP advantage does not hold in every test year (2014 reverses it).
Calibration improves forest log loss but slightly worsens its Brier score.
No model is claimed to dominate all metrics, and no statistical superiority is
claimed from point estimates alone.

## Validation and caveats

The checks cover metric direction and ties, hand-calculated AP, independent
pROC agreement, saved probability-to-metric agreement, leap days, invalid dates,
duplicate IDs, split separation, labels, predictor exclusion, and calibration
monotonicity. Input SHA-256 is enforced before model fitting. See VALIDATION.md
for the executed checks and repeat-run evidence.

Unresolved: the sampling mechanism and exact extract provenance are unavailable;
reporting coverage and discovery-time field snapshots are unverified; repeated
incidents with different IDs cannot be excluded; only four test years and 211
positive events are available; no spatial holdout, newer-period validation,
external weather features, cost-based operating threshold, or operational
validation is supplied. The dataset's separate reuse terms are not replaced by
the code's MIT license. This is a historical portfolio study, not a wildfire
warning service or an estimate of national ignition risk.
