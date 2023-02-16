#ECOROOF ANALYSIS MASTER SCRIPT

#LOAD RELEVENT LIBRARIES
source("02_Scripts/Libraries.R")

#UPLOAD RAIN DATA, CLEAN, FILTER, AND PARSE STORMS
source("02_Scripts/Precipitation.R")

#UPLOAD FLOW DATA AND PARSE STORMS
source("02_Scripts/Discharge.R")

#UPLOAD CHEMISTRY DATA 
source("02_Scripts/Chemistry.R")

#CALCULATE LOADING 
source("02_Scripts/Load.R")

#CALCULATE TOTAL RUNOFF VOLUME AND RUNOFF RETENTION RATE FOR SAMPLING PERIOD 
source("02_Scripts/Retention.R")

#CREATE GRAPHS 
source("02_Scripts/Graphs.R")

#EXPORT DATA FRAMES 
source("02_Scripts/Outputting.R")
