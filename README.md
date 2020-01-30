# EIA_Cleaned_Hourly_Electricity_Demand_Code
Code associated with the U.S. Energy Information Administration (EIA) demand data anomaly screening and imputation project.

See the GitHub data repository for additional documentation: <https://github.com/truggles/EIA_Cleaned_Hourly_Electricity_Demand_Data/>

If using the cleaned data, please cite:

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3517197.svg)](https://doi.org/10.5281/zenodo.3517197)


# Code Description

The notebooks in this repository can be used to reproduce the workflow used to:
 * Step (1) Query the EIA database for raw demand data
 * Step (2) Screen the data for anomalous values
 * Step (3) Impute missing and anomalous values with the Multiple Imputation by Chained Equations (MICE) procedure

# Required Packages

Steps (1) and (2) are based on python code, were written in `python3.7`, and use the following additional packages:
 * `pandas`
 * `numpy`

Step (3) is written in the R programming language and relies on the `mice` package

# Running the Code

 * Step (1): see the Jupyter notebook `get_eia_demand_data.ipynb`. You will need to acquire an API key from the EIA. Additional
documentation is provided in the [notebook](https://github.com/truggles/EIA_Cleaned_Hourly_Electricity_Demand_Code/blob/master/get_eia_demand_data.ipynb).
 * Step (2): see the Jupyter notebook `anomaly_screening.ipynb`. For a full description of the algorithms and their motivation see the paper.
 * Step (3): see the R Markdown notebooke `MICE_step.Rmd`

# Reproducibility

Achieving exact reproducibility with the published results is difficult because the EIA continuously update
their database as balancing authorities provide new and updated information. Therefore, querrying the database
today and tomorrow could yield different results not just for the last 24 hours, but for past values
that have been corrected.

To reproduce the exact results of the paper, please see the raw data used in the analysis, which is
retained in the Zenodo repository linked above.
