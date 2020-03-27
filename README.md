# EIA_Cleaned_Hourly_Electricity_Demand_Code
Code associated with the U.S. Energy Information Administration (EIA) demand data anomaly screening and imputation project.

Find archived versions of this code at: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3678854.svg)](https://doi.org/10.5281/zenodo.3678854)

Find the resulting cleaned data at: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3517196.svg)](https://doi.org/10.5281/zenodo.3517196)


# Code Description

The notebooks in this repository can be used to reproduce the workflow used to:
 * Step (1) Query the EIA database for raw demand data
 * Step (2) Screen the data for anomalous values
 * Step (3) Impute missing and anomalous values with the Multiple Imputation by Chained Equations (MICE) procedure
 * Step (4) Distribute the imputed results to balancing authority-level files as well as regional, interconnect, and CONUS level aggregates

# Required Packages

Steps (1), (2), and (4) are based on python code, were written in `python3.7`, and use the following additional packages:
 * `pandas`
 * `numpy`

Step (3) is written in the R programming language and relies on the `mice` package

The exact environment used when cleaning and imputing the EIA data is saved in the file `package-list.txt`. The environment was created and managed using Conda.

# Running the Code

 * Step (1): see the Jupyter notebook `step1_get_eia_demand_data.ipynb`. You will need to acquire an API key from the EIA. Additional
documentation is provided in the notebook.
 * Step (2): see the Jupyter notebook `step2_anomaly_screening.ipynb`. For a full description of the algorithms and their motivation see the paper.
 * Step (3): see the Jupyter notebook `step3_MICE_imputation.ipynb` which is a wrapper to call the R Markdown notebook `MICE_step.Rmd`.
 * Step (4): see the Jupyter notebook `step4_distribute_MICE_results.ipynb`. This code distributes and aggregates the results as seen in the published content [here](https://zenodo.org/record/3517197).

# Completing Step (3)

The following three steps will help you to run the MICE imputation Markdown script (MICE_Step.Rmd) if you are unfamiliar with R and RMarkdown.

(a) Download and install R at https://cran.rstudio.com/
(b) Download the free version of RStudio at https://rstudio.com/products/rstudio/download/
(c) Open MICE_Step.Rmd in Rstudio and "Run All"\*


\*lines 167 and 173 control the amount of parallel computing that this code will attempt. Currently the code is set up to compute 4 chains on each of 4 processing cores. If your computer does not have 4 cores available and/or you would like to only use 1 or 2 cores to run this code, then you will need to change the code to one of the following:

- 16 chains on 1 core (no parallel computing):
Change line 167 to "n.imp.core = 16," and line 173 to "n.core = 1,"

- 8 chains on 2 cores:
Change line 167 to "n.imp.core = 8," and line 173 to "n.core = 2,"

# Reproducibility

To achieve exact reproducibility with the published results a user should:
 * Instead of querying EIA for data for Step (1), you will use the files queried on 10 September 2019 used for the original analysis. Step (2) will automatically download the Zenodo repository archived [here](https://zenodo.org/record/3690240) for you
 * Adjust the initial flags in the second code cell of `step2_anomaly_screening.ipynb`
   * Change from `use_step1_files = True` to `use_step1_files = False`
   * Change from `use_10sept2019_files = False` to `use_10sept2019_files = True`
   * then run Step (2)
 * Run Step (3):
   * Running Step (3) using RStudio is probably simpler.  However, we have verified that exact reproduciblity is achieved running `MICE_step.Rmd` from the command line based on the Conda environment saved in `package-list.txt`.
   * From the command line, run: ```R -e "rmarkdown::render('MICE_step.Rmd',output_file='output.html')"```
 * Adjust the initial flags and data path in the second code cell of `step4_distribute_MICE_results.ipynb` to point to the archived files and run Step (4)
 * Compare results against the Zenodo files downloaded automatically in Step (2).
   * `unzip ./data/truggles-EIA_Cleaned_Hourly_Electricity_Demand_Data-1b31ad5/data/release_2019_Oct/imputation_details/imputation_study.zip -d ./original_results`
   * `diff MICE_output/mean_impute_csv_MASTER.csv ./original_results/mean_impute_csv_MASTER.csv`

Because EIA will update historical data values if a balancing authority requests this, it is possible for historical values to change altering the final results. Altered values will change the regressions performend in the MICE step leading to different imputed values for all imputed entries.

