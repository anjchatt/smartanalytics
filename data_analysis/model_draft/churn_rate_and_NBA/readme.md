# Churn rate and NBA prediction models #

Five notebooks are used:
1. [1_preprocess_data.ipynb](1_preprocess_data.ipynb) - prepare source data and add simulated data
2. [2_fit_cox_model.ipynb](2_fit_cox_model.ipynb) - fit Cox's proportional hazard model for churn prediction
3. [3_fit_rft_NBA_model.ipynb](3_fit_rft_NBA_model.ipynb) - fit random forest model for NBA prediction
4. [4_apply_trained_cox_model.ipynb](4_apply_trained_cox_model.ipynb) - apply fitted Cox model to make churn prediction
5. [5_apply_trained_rft_NBA_model.ipynb](5_apply_trained_rft_NBA_model.ipynb) - apply fitted RF model to make NBA prediction

Two additional notebooks are used as PoC for applying fitted models within the scope of Spark framework:
1. [spark_streaming_churn.ipynb](spark_streaming_churn.ipynb) - Applies churn prediction model using Spark cluster (Does not work with Python2.6. Python2.7 required)
2. [spark_streaming_NBA.ipynb](spark_streaming_NBA.ipynb) - Applies NBA prediction model using Spark cluster.

### File 1_preprocess_data.ipynb
File [1_preprocess_data.ipynb](1_preprocess_data.ipynb) is used for:
1. Preparing one set of data from nine provided files
2. Adding simulation data for NBA and churn prediction (described below)
3. Saving all data in single file for usage in models

#### Simulation data for churn prediction
Four additional fields are generated for churn prediction - **Sentiment**, **Sentiment_days_passed**, **Event**, and **Day_Observed**.

**Sentiment** is randomly choosen within range [-5; 5]

**Sentiment_days_passed** is randomly choosen within range [1; 365]

Fields **Event** and **Day_Observed** have linear correlation with following set of given and simulated fields:
*is_maried*, *age*, *work_experience*, *children_number*, *has_mortgage*, *loan_products_nii*, *checking_account_balance*, *deposit_balance*, *money_market_balance*, *investable_asset_indicator*, ***Sentiment***, ***Sentiment_days_passed***

**Event** can be "0" or "1" (client leaved/client remained).
**Day_Observed** can be in range [90; 365]. It is day when **Event** was observed.

#### Simulation data for NBA
Field **NBO_choosen** is generated for each records for Next Best Action simulation.

**NBO_choosen** is categorial variable with five possible values:
Value| Meaning
---|---
0|Investment_Discount
1|HI_Deposit
2|HI_MM
3|Premium_account
4|Refuses_all

**NBO_choosen** is dependant variable. It correlate with the same set of fields as **Event** and **Day_Observed** are.

A linear correlation is calculated independently for every possible value of **NBO_choosen** per every record. Then maximum value wins and corresponding category value is saved.

### File 2_fit_cox_model.ipynb
File [2_fit_cox_model.ipynb](2_fit_cox_model.ipynb) trains Cox's proportional hazard model with 'Efron' tie method. Trained model is saved as [pickle](https://docs.python.org/2/library/pickle.html) file.

### File 3_fit_rft_NBA_model.ipynb
File [3_fit_rft_NBA_model.ipynb](3_fit_rft_NBA_model.ipynb) trains Random Forest model. Trained model is saved as [pickle](https://docs.python.org/2/library/pickle.html) file.

### File 4_apply_trained_cox_model.ipynb
File [4_apply_trained_cox_model.ipynb](4_apply_trained_cox_model.ipynb) loads previously trained Cox's model and loads data set. Model being applied to data and predicted churn rate is calculated. Churn rate is calculated for periods of 30, 60, 90, ..., 330, and 365 days (approximately every month).
Calculated values are saved to new file.

### File 5_apply_trained_rft_NBA_model.ipynb
File [5_apply_trained_rft_NBA_model.ipynb](5_apply_trained_rft_NBA_model.ipynb) loads previously trained RF model and loads data set. Model being applied to data and as result we get probability of every possible NBA value. Probability with maximum value are treated as a prediction outcome for every record.
Probabilities and final outcome are saved to new file.
