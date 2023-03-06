#THE SCRIPT EXPORTS FINAL REPORT INTO 03_OUTPUT FOLDER 

#EXPORT RAIN DATA FOR EACH STORM EVENT 
write.csv(rain[["storms"]], "03_Output/Data_Exports/Storm Precipitation.csv")

#EXPORT DISCHARGE DATA FOR EACH STORM EVEN 
write.csv(discharge[["storms"]], "03_Output/Data_Exports/Storm Discharges.csv")

#EXPORT UNIT AREA LOADS FOR EACH POLLUTANT FOR EACH STORM EVENT 
write.csv(load,"03_Output/Data_Exports/Unit Area Loading.csv")

#EXPORT FINAL HTML REPORT 
report_compiler(input_location = "02_Scripts",
                input_name = "Report.R",
                output_location = "03_Output",
                output_name = "Ecoroof Data Analysis Report.html")


