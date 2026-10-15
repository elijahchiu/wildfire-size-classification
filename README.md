# Wildfire Patterns in the United States

STA 141A final project by Elijah Chiu. The report earned a 100% course grade.

[Read the full report](https://elijahchiu.github.io/wildfire-size-classification/)

## Project

Using R, I explored seasonal and regional patterns in a sample of U.S. wildfire records from 1992 to 2015. The report defines a notable fire as one that burned at least 300 acres, then compares logistic regression and random forest models for classifying county-months with a recorded notable fire.

The analysis includes data cleaning, exploratory plots, a time-based train/test split, and a comparison of model ROC AUC. The HTML report shows the R code alongside the analysis and results.

## Files

- `Final_report.Rmd` — source for the final report
- `Final_report.html` — knitted final report
- `wildfires_sample_100k.csv` — 100,000-record wildfire sample used in the analysis
- `Final_report_description.html` — second copy of the final report included with the original files
- `Midquarter_description.Rmd` and `Midquarter_description.html` — midquarter project materials

## Run the report

Open `Final_report.Rmd` in RStudio with `wildfires_sample_100k.csv` in the same folder, then select **Knit**. The report uses `tidyverse`, `lubridate`, `maps`, `pROC`, and `randomForest`.
