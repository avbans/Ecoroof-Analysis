#' ---
#' title: "Ecoroof Data Analysis Report"
#' author: "By: Alex Vijay Bans"
#' date: "March 5th, 2023"
#' output:
#'  html_document:
#' font-family: Times New Roman
#' ---

#' ## Introduction 
#'  There were 3 goals to this project. 
#'  The first goal was to analyze the runoff hydrology and chemistry 
#'  of a seven-year-old ecoroof on top of a commercial building 
#'  compared to a segment of conventional roof on the same 
#'  commercial building. 
#'  The second goal of this project was to create a reproducible reference
#'  for Researchers, Stakeholders, and other interested parties, 
#'  via a Markdown report and exported figures, tables, and data files. 
#'  The third goal of this project was to directly be able to pipe the results 
#'  of this analysis to create interactive dashboards using PowerBI 
#'  for stakeholders to explore the data further. 
#' 
#' 
#' ## Methods 
#' 
#' For the full details of the project, 
#'  including background research, sampling methods, etc. 
#'  please refer to the original report located at 
#'  [title] (https://pdxscholar.library.pdx.edu/open_access_etds/5577/).  
#'  Please note the methods for data analysis and statistical testing, 
#'  as well as assumptions used may be different from the ones 
#'  performed in the original report. While the values may be different, the 
#'  general conclusions reached are similar. Interpretation of the results is not 
#'  in the scope of this particular project. 
#' 
#' 
#' #### Software and Libraries 
#' This project was analyzed exclusively with the R language 
#' and uses the following libraries: 
#' data.table, tidyverse, janitor, lubridate, patchwork, here, kableExtra, 
#' and bansr (my personal library of functions I’ve written). 
#' Dependencies were managed with Renv. 
#' 
#' 
#' #### Data Processing
#' 
#' All data first had to be uploaded and tidied in a form to be able to be processed. 
#' All data was filtered by 
#' the start (09/01/2018) and end (06/01/2019) dates of the project. 
#' Additionally, the month of October was removed due to flow sensor malfunctioning. 
#' Final results were given with 3 significant figures due to the resolution 
#' of the flow meter and rain gauges both being 0.01 inches. 
#' 
#' 
#' #### Precipitation 
#' 
#' First, rain data was imported, and processed before being parsed into discrete storm events (storms). 
#' In this project a storm event was defined as having at least 5.02 mm of rain, with an interevent period 
#' of at least 24 hours from the previously measurable, greater than 5.02 mm rainfall storm event. 
#' Parsing the flow from the roofs was difficult as there was a lag between rainfall and discharge.
#' Thus, all data were separated from the start of the first event, to the start of the next event, 
#' instead of the start of the first event to the end of the first event. 
#' 
#' 
#' #### Roof Discharges
#' 
#' Discharges (Q) from the conventional roof and the eco roof were imported 
#' and processed before being combined together.
#' Discharges were then separated into their associated rain events. 
#' After discharges that were less than 0.04 L/s were removed due to instrument error,
#' it would detect standing water as flow at those levels. 
#' Roof runoff volume (V) was calculated by integrating Q with respect to time 
#' (dt) using the trapezoidal rule (0.5*dt*(Q1+Q2)). 
#' 
#' 
#' #### Runoff Retention 
#' 
#' The percent rainfall retention for the sampling period was calculated by first
#' aggregating and summing all the volume of runoff for both roof catchment sizes 
#' for each storm event,
#' subtracting it by the total discharge from both the roofs, 
#' dividing it by runoff volume and multiplying it by 100. 
#' 
#' 
#' #### Runoff Sampling 
#' 
#' Stormwater metal and nutrient pollutant runoff samples were imported, processed, and joined together. 
#' The accuracy and precision of the calibration curves, and standards of each analysis run were not QA/QC’ed for this analysis.
#' Runoff samples results were however compared to the average field and lab blank results 
#' and determined that in general there were no sources of contamination 
#' from the collection and processing of the runoff samples. 
#' It is important to note that, if there were more formal reporting 
#' then a stricter post-lab analysis QA/QC process will need to be undertaken. 
#'  
#' The runoff samples collected were flow-weight based, 
#' meaning they were collected after certain volumes of discharge occurred. 
#' This is different from time based samples which are collected in intervals of duration. 
#' Flow weighted samples take into account the quantity of discharge. 
#' You can thus assume the concentrations sampled at each discrete volume of discharge 
#' is representative of the average concentration of that discharged volume of water. 
#' For every flow-weighted sample in a storm event, 
#' the mean was taken to determine the flow weighted event mean concentration (EMC). 
#'  
#'  
#' #### Unit Area Loading 
#' 
#' Discharge volume was aggregated for each storm event 
#' before being joined with the EMC value for each storm event, if available. 
#' Taking the EMC * discharge volume / roof catchment size gives us the mass flux (Pa) for each storm event. 
#' Calculating unit area load accounts for both the discharge volume as well as the catchment size, 
#' effectively normalizing the pollutant data to each other. 
#' 
#' 
#' #### Statistical Analysis 
#' 
#' As this was a longitudinal study where water quality was observed between roof catchments via repeated measures, 
#' the observations were considered non-independent. 
#' However, there were only two roof catchments observed and thus because the sample size was very low, we we're limited 
#' in how we can interpret the data. We couldn't use standard statistical inferential testing. 
#' Instead of inferential testing and their results, the summary statistics,
#' and the scaled difference between the mean 
#' unit area loads for the ecoroof and conventional roof were graphed. 
#' 
#' 
#' ## Results 
#' 
#' Below is the visualization of precipitation, roof discharges,
#' and runoff sample collection times for the sample period for the project. 
#+ echo = FALSE, warning = FALSE, fig.width = 10
graphs$`rain/discharge`
#' There were a total of `r n_distinct(samples$collection_log$sample_code)` metal runoff samples with 
#' `r n_distinct(samples$metals$datetime)` samples captured during storm events. 
#' There were about 105 run off samples captures, with 
#' `r n_distinct(samples$nutrients$datetime)` of them being during a storm event. 
#' 
#' Below is the total precipitation, roof discharge, and retention for the sampling period.  
#+ echo = FALSE 
tables[["retention"]]
#' 
#' 
#' There were `r n_distinct(storms$storm_id)` storm events during the project sampling period. 
#' See the table and figure below for the detailed breakdown of each storm event and 
#' the discharge for both roof during the parsed storm events. 
#+ echo = FALSE, warning = FALSE, fig.width = 10, fig.height = 9
graphs$discharge_storms
#'
#+ echo = FALSE
tables[["storms"]]
#' 
#' 
#' Below is the event mean concentrations of pollutants for each storm event. 
#+ echo = FALSE, warning = FALSE, fig.width = 10, fig.height = 9
graphs$emc
#' 
#' 
#' #' Below is the summary of the distribution of the unit area loads of the pollutants. 
#+ echo = FALSE
tables[["load_summary"]]
#' 
#' 
#' Below scaled difference between the mean unit area loads for the ecoroof and conventional roof were graphed.  
#' Positive values and their magnitude indicate ecoroof having larger loads, 
#' while negative values indicate larger Conventional loads. Graph excludes Ca as it was much larger than other values. 
#' 
#+ echo = FALSE, warning = FALSE, fig.width = 10, fig.height = 8
graphs$load_diff
#' 
#' 
#' ## Going Forward 
#' 
#' The next goal of this project is to export the data to create interactive dashboards using PowerBI. 