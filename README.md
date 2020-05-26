# EIA_Cleaned_Hourly_Electricity_Demand_Code
Code associated with the U.S. Energy Information Administration (EIA) demand data anomaly screening and imputation project.

Find archived versions of this code at: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3678854.svg)](https://doi.org/10.5281/zenodo.3678854)

Find the resulting cleaned data at: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3517196.svg)](https://doi.org/10.5281/zenodo.3517196)

Full documentation of the cleaning process has been published in Scientific Data.

Please consider citing:

Ruggles, T.H., Farnham, D.J., Tong, D. et al. Developing reliable hourly electricity demand data through screening and imputation. Sci Data 7, 155 (2020). https://doi.org/10.1038/s41597-020-0483-x

and the code archive:

Ruggles, Tyler H., & Farnham, David J. (2020, April 1). EIA Cleaned Hourly Electricity Demand Code (Version v1.1). Zenodo. http://doi.org/10.5281/zenodo.3737085

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

The exact environment used when cleaning and imputing the EIA data is saved in the file `package-list.txt`. The environment was created and managed using Conda. A more sparse listing of only the high-level packages is provided in the `environment.yml` file.
To recreate the computing environment used in the analysis see the "Reproducibility" section below.

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

## Setting up the compute environment
To achieve exact reproducibility with the published results a user will need to replicate a similar Conda computing environment
 * The analysis was performed on Mac OSX 10.14.6
 * Make sure Conda is installed on your machine
 * Users with Mac OSX should be able to recreate the exact Conda computing environment used for the analysis by unpacking the Conda environment archived with Zenodo 
   * Zenodo archive: https://zenodo.org/record/3736784 
   * See file `data_cleaning_env_OSX_10.14.tar.gz`
   * The versions of all packages incorporated in this environment are documented in `package-list.txt`
 * After downloading the Conda environment archive from Zenodo, move the `data_cleaning_env_OSX_10.14.tar.gz` file to the base of this code repository
 * To set up the environment:

```
mkdir data_cleaning_env
tar -xzf data_cleaning_env_OSX_10.14.tar.gz -C data_cleaning_env
source data_cleaning_env/bin/activate
conda-unpack
```

 * For users without Mac OSX, we include an `environment.yml` file containing the high-level packages used in the analysis. Users can set up a computing environment with this file by executing (again Conda is required):

```
conda env create -f environment.yml
source activate data_cleaning_env
```

## Analysis steps
 * Instead of querying EIA for data for Step (1), you will use the files queried on 10 September 2019 used for the original analysis. Step (2) will automatically download the Zenodo repository archived [here](https://zenodo.org/record/3690240) for you
 * There is a file `check_reproducibility.sh` that executes the steps necessary to check reproducibility
   * To run it execute: `source check_reproducibility.sh`
 * The `check_reproducibility.sh` script will run:
   * Step (2) on the 10 September 2019 files
   * Step (3) on the screened versions of these files
   * Compare the output of Step (3) with the published results by using the `diff` function essentially running: `diff new_results.csv old_results.csv`

The 10 September 2019 files must be used because EIA updates historical data values if a balancing authority requests it.
Therefore, it is possible for historical values to change altering the final results. Altered values will
change the regressions performend in the MICE step leading to different imputed values for all imputed entries.

