.PHONY: clean

clean:
	rm -rf figures
	rm -rf derived_data
	rm -rf .created-dirs

.created-dirs:
	mkdir -p figures
	mkdir -p derived_data
	touch .created-dirs
	
# Data cleaning 
derived_data/cleaned_data.csv: .created-dirs code/data_cleaning.R source_data/CDC_Drug_Overdose_Deaths.csv source_data/SSP_Data.csv
	Rscript code/data_cleaning.R

# CSV table for regression
derived_data/coefficients_table.csv: .created-dirs code/regression.R source_data/CDC_Drug_Overdose_Deaths.csv source_data/SSP_Data.csv
	Rscript code/regression.R

# Make figures for report
figures/state_overdose_rates_2019.png: .created-dirs source_data/CDC_Drug_Overdose_Deaths.csv code/state_overdose_rates_2019.R
	Rscript code/state_overdose_rates_2019.R

figures/state_poverty_rates_2019.png: .created-dirs source_data/CDC_Drug_Overdose_Deaths.csv code/state_poverty_rates_2019.R
	Rscript code/state_poverty_rates_2019.R
	
figures/us_map_overdose_rates_2013.png: .created-dirs source_data/CDC_Drug_Overdose_Deaths.csv code/us_map_overdose_rates_2013.R
	Rscript code/us_map_overdose_rates_2013.R
	
figures/us_map_overdose_rates_2019.png: .created-dirs source_data/CDC_Drug_Overdose_Deaths.csv code/us_map_overdose_rates_2019.R
	Rscript code/us_map_overdose_rates_2019.R
	
figures/poverty_vs_overdose.png: .created-dirs source_data/CDC_Drug_Overdose_Deaths.csv code/poverty_vs_overdose.R
	Rscript code/poverty_vs_overdose.R
	
figures/correlation_matrix.png: .created-dirs source_data/CDC_Drug_Overdose_Deaths.csv code/correlation.R
	Rscript code/correlation.R
	
figures/us_map_ssp.png: .created-dirs source_data/CDC_Drug_Overdose_Deaths.csv source_data/SSP_Data.csv code/us_map_ssp_legality.R
	Rscript code/us_map_ssp_legality.R
	
figures/required_services_SSPs.png: .created-dirs source_data/CDC_Drug_Overdose_Deaths.csv source_data/SSP_Data.csv code/required_services_SSPs.R
	Rscript code/required_services_SSPs.R
	
figures/roc.png: .created-dirs code/regression.R source_data/CDC_Drug_Overdose_Deaths.csv source_data/SSP_Data.csv
	Rscript code/regression.R
	
report.html: derived_data/coefficients_table.csv figures/us_map_overdose_rates_2013.png figures/us_map_overdose_rates_2019.png figures/poverty_vs_overdose.png figures/correlation_matrix.png figures/us_map_ssp.png figures/required_services_SSPs.png figures/roc.png
	R -e "rmarkdown::render(\"Report.Rmd\", output_format = \"html_document\")"

	

	
