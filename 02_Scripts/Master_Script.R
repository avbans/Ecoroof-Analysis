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

#EXPORT DATA FRAMES 
source("02_Scripts/Outputting.R")
