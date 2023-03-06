#' ---
#' title: "Ecoroof Data Analysis Report"
#' author: "By: Alex Vijay Bans"
#' date: "March 5th, 2023"
#' output: html_document
#' font-family: Times New Roman
#' ---

#' ## Introduction 
#' 
#' 
#' 
#' ## Methods 
#' 
#' #### Software and Libraries 
#' 
#' #### Data Processing
#' 
#' #### Precipitation 
#' 
#' #### Roof Discharges
#' 
#' #### Runoff Sampling 
#' 
#' #### Unit Area Loading 
#' 
#' #### Runoff Retention 
#' 
#' #### Statistical Analysis 
#' 
#' 
#' ## Results 
#' 
#' 
#' Refer to **01_storm_events.csv** for details about the storm events during the project period
#+ echo = FALSE
tables[["storms"]]
#' Below is the discharges measured for both roofs during the parsed storm events. 
#' 
#' ![ ](Figures_Tables/02_storm_discharges.png)
#' 
#' 
#' Below is the graphic of precipitation, roof discharges,
#' and runoff sample collection times for the sample period for the project. 
#' 
#' ![ ](Figures_Tables/03_rain_discharge_sampling.png)
#' 
#' 
#' Below is the event mean concentrations for each storm event. 
#' 
#' ![ ](Figures_Tables/05_emc.png)
#' 
#' 
#' Below is the  cumulative unit area loading of each pollutant over the storm events sampled. 
#' 
#' ![ ](Figures_Tables/06_cum_unit_area_load.png)
#' 
#' 
#' Below is the summary of the distribution of the unit area loads of the pollutants. 
#+ echo = FALSE
tables[["load_summary"]]
#' 
#' 
#' Refer to **09_loading_statistics.csv** for the results of the Friedman Tests. 
#+ echo = FALSE
tables[["friedman_results"]]
#' 
#' 
#' 8. Refer to **10_retention.csv** for discharge retention rates for both roofs. 
#+ echo = FALSE 
tables[["retention"]]
#' ## Going Forward 
#' 
#' The next goal of this project is to export the data to create interactive dashboards using PowerBI. 
