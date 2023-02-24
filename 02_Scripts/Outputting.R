#THIS SCRIPT OUTPUTS FILES FOR EXTERNAL DATA ANALYSIS 

#RUNOFF POLLUTANT DATA
write.csv(samples[["full"]], "03_Output/Runoff Samples.CSV")

#ROOF DISCHARGE DATA 
write.csv(discharge[["full"]], "03_Output/Discharge.CSV")

#MASS LOADING DATA 
write.csv(load%>%
            group_by(pollutant,roof)%>%
            summarise(load = sum(p_mg_m2)),
          "03_Output/Load.CSV")
