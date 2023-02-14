#THIS SCRIPT OUTPUTS FILES FOR EXTERNAL DATA ANALYSIS 

#RUNOFF POLLUTANT DATA
write.csv(runoff_samples, "03_Output/Runoff Samples.CSV")

#ROOF DISCHARGE DATA 
write.csv(discharge, "03_Output/Discharge.CSV")

#MASS LOADING DATA 
write.csv(load, "03_Output/Load.CSV")
