# Wildfire Patterns in the United States

STA 141A final project by Elijah Chiu.

[Read the full report](https://elijahchiu.github.io/wildfire-size-classification/)

## Project overview

This project uses R to explore seasonal and regional patterns in U.S. wildfire records from 1992 to 2015. It defines a notable fire as one that burned at least 300 acres and compares two models for classifying county-months with a notable fire.

The analysis starts with a supplied sample of 100,000 fire records. It groups events by county and month, explores seasonal and state-level patterns, and compares logistic regression with a random forest model. The models are trained on earlier years and evaluated on 2009–2015 using ROC AUC.

## Findings

In this sample, recorded notable fires are more common in summer than in winter, and the report shows differences across states. The linked report includes the plots, R code, and model evaluation from the original project.

## Files

- `Final_report.Rmd` — source for the final report
- `Final_report.html` — knitted report, including code and output
- `wildfires_sample_100k.csv` — the 100,000-record dataset used in the analysis
- `Final_report_description.html` — second copy of the final report included with the original files
- `Midquarter_description.Rmd` and `Midquarter_description.html` — midquarter project materials

## Run the report

Open `Final_report.Rmd` in RStudio with `wildfires_sample_100k.csv` in the same folder, then select **Knit**. The report uses `tidyverse`, `lubridate`, `maps`, `pROC`, and `randomForest`.
