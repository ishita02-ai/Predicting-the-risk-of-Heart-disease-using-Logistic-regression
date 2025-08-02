# Predicting-the-risk-of-Heart-disease-using-Logistic-regression

## Project overview
This project focuses on predicting heart disease using the **Logistic Regression** algorithm in R.  
It includes **data cleaning**, **exploratory data analysis**, **feature encoding**, **missing value imputation**, **model training**, and **evaluation**.

## Dataset
**The dataset used in this project can be found on Kaggle:**  
[View Dataset](https://www.kaggle.com/datasets/fedesoriano/heart-failure-prediction?resource=download)
The dataset contains 918 patient records with demographic, clinical, and lifestyle-related features:
-	Demographics: Age, Sex
-	Clinical measurements: Resting BP, Cholesterol, Max Heart Rate, Oldpeak
-	Categorical health indicators: Chest Pain Type, Resting ECG, Exercise Induced Angina, Fasting Blood Sugar, ST Slope
-	Target: Heart Disease (0 = No, 1 = Yes)

## Steps Performed
1. **Data Import & Cleaning**
   - Handled missing values using **KNN imputation**.
   - Converted categorical variables to factors.

2. **Exploratory Data Analysis**
   - Distribution plots for numerical features.
   - Bar plots for categorical features vs Heart Disease.
   - Correlation matrix for numerical features for checking Multicollinearity in data.

3. **Feature Engineering**
   - Encoded categorical variables as factors.
   - Standardized numeric variables.

4. **Modeling**
   - Trained **Logistic Regression** model.
   - Tuned classification threshold using ROC curve.

5. **Evaluation**
   - Confusion Matrix, Accuracy, Sensitivity, Specificity.
   - ROC Curve with AUC score.
   - Variable Importance plot.

## Results
- **AUC Score:** 0.94
- **Accuracy**: 89.09% — proportion of total correct predictions.
- **Sensitivity** (Recall for No Heart Disease): 87.80% — correctly identified patients without heart disease.
- **Specificity** (Recall for Heart Disease): 90.13% — correctly identified patients with heart disease.
- **Balanced Accuracy**: 88.97% — average of sensitivity and specificity.
- Top predictors include:
  - Chest Pain Type
  - Sex
  - Fasting Blood Sugar
  - ST Slope

## Conclusion:
The logistic regression model shows high accuracy and performs well for both classes, making it an effective tool for estimating the risk of heart disease.
