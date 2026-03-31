Predicting Wildfire Incidence in the United States

This project develops a machine learning pipeline to predict the occurrence of **notable wildfires (≥300 acres)** at the **county–month level** across the United States using historical wildfire data (1992–2015).

---

Overview

Wildfires are rare but high-impact events. This project frames wildfire prediction as a **binary classification problem**, where the goal is to determine whether at least one notable wildfire occurs in a given county during a given month.

To support this, raw wildfire event data was transformed into a **complete panel dataset** covering:

- **4,232 counties**
- **50 states**
- **1992–2015**
- **1.2M+ observations**

---

Modeling Approach

Baseline Model
- **Logistic Regression**
- Features:
  - Seasonal (sin_month, cos_month)
  - Year (FIRE_YEAR)
- AUC: **0.640**

Final Model
- **Random Forest Classifier**
- Features:
  - Seasonal + temporal + geographic (STATE)
- Handles:
  - Nonlinear relationships
  - Spatial variation
- AUC: **0.755**

---

Key Techniques

- **Panel data construction**
  - County × month grid with zero-fill for no-fire months
- **Feature engineering**
  - Cyclical encoding of seasonality using sine/cosine
- **Class imbalance handling**
  - Downsampling (3:1 negative-to-positive ratio)
- **Time-aware validation**
  - Train: 1992–2008  
  - Test: 2009–2015  
  - Rolling validation across years
- **Model evaluation**
  - ROC curves and AUC

---

Key Findings

- Strong **seasonal patterns** (peak in summer months)
- Significant **geographic variation** (higher risk in western states)
- Random Forest substantially improves prediction by incorporating spatial information
- Predicting rare wildfire events remains challenging due to extreme class imbalance (~0.06%)

---

Tech Stack

- **R**
- `tidyverse`, `lubridate`
- `randomForest`
- `pROC`
- `ggplot2`

---

## 📂 Repository Structure
├── wildfire_analysis.Rmd   # Main analysis and modeling pipeline
├── wildfire_analysis.html  # Final report output
├── wildfires_sample_100k.csv (or external link)

---

Reproducibility

To reproduce results:

1. Clone the repository  
2. Open the `.Rmd` file in RStudio  
3. Ensure required packages are installed  
4. Knit the document to HTML  

If the dataset is not included due to size limits, use the provided download link in the report.

---

Future Improvements

- Incorporate weather and climate data (temperature, drought indices)
- Add vegetation and land-use features
- Explore gradient boosting models (e.g., XGBoost)
- Improve handling of extreme class imbalance

---

Author

**Elijah Chiu**  
UC Davis — Statistics & Data Science, Economics  
