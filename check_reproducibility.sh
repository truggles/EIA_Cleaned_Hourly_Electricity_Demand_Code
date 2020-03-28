# Script to run the full analysis and compare results against
# the published results.


# runipy was not working with conda install, so use pip
pip install runipy==0.1.5


# Set some environment variables that will be used to steer
# the analysis code
export CHECK_REPRODUCIBILITY=TRUE
echo "CHECK_REPRODUCIBILITY = $CHECK_REPRODUCIBILITY"

echo ""
echo ""

# Run the anomaly screening step on the exact data queried on 10 Sept 2019
echo "Running the anomaly screening step on the exact data queried on 10 Sept 2019"
echo "runipy step2_anomaly_screening.ipynb"
runipy step2_anomaly_screening.ipynb

echo ""
echo ""

# Run the MICE iputation step on the screened data
echo "Running the MICE iputation step on the screened data"
echo "R -e 'rmarkdown::render('MICE_step.Rmd',output_file='output.html')'"
R -e "rmarkdown::render('MICE_step.Rmd',output_file='output.html')"

echo ""
echo ""

# Unzip the exact `original` output from the MICE step
echo "Unzipping the exact `original` output from the MICE step"
echo "unzip ./data/truggles-EIA_Cleaned_Hourly_Electricity_Demand_Data-1b31ad5/data/release_2019_Oct/imputation_details/imputation_study.zip -d ./original_results"
unzip ./data/truggles-EIA_Cleaned_Hourly_Electricity_Demand_Data-1b31ad5/data/release_2019_Oct/imputation_details/imputation_study.zip -d ./original_results

echo ""
echo ""

# Diff the csv files to see if there are any differences
echo "Diff-ing the csv files to see if there are any differences"
echo "diff MICE_output/mean_impute_csv_MASTER.csv ./original_results/mean_impute_csv_MASTER.csv"
diff MICE_output/mean_impute_csv_MASTER.csv ./original_results/mean_impute_csv_MASTER.csv
