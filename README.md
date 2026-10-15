# Wildfire Patterns in the United States

STA 141A final project by Elijah Chiu. Using R, I explored seasonal and regional patterns in U.S. wildfire records from 1992–2015 and compared two models that classify county-months by whether the sample contained a recorded fire of 300 acres or more.

[Read the original HTML report](https://elijahchiu.github.io/wildfire-size-classification/)

## What’s in the project

- `Final_report.Rmd` — source for the final analysis and report
- `Final_report.html` — knitted final report
- `wildfires_sample_100k.csv` — the 100,000-record dataset used in the analysis
- `Midquarter_description.Rmd` and `Midquarter_description.html` — midquarter project materials
- `Final_report_description.html` — duplicate report file included with the original project files

The report includes logistic regression and random forest models, along with the R code, plots, and results.

## A note on the results

This is the original course analysis. The data are a sample of recorded fires, but the analysis also labels county-months with no sampled fire as if no fire occurred. That means the reported model scores should not be treated as verified estimates of real-world wildfire risk.

## Reproduce the report

Open `Final_report.Rmd` in RStudio with `wildfires_sample_100k.csv` in the same folder, then use **Knit**. The report uses `tidyverse`, `lubridate`, `maps`, `pROC`, and `randomForest`.
