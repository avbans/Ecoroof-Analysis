#THIS SCRIPT CREATES FINAL TABLES FOR THE REPORT 
tables <- list()

#TABLE OF STORM EVENTS AND EXPORT 
tables[["storms"]] <- storms2%>%
  select(-c(wateryear,eventend))%>%
  mutate(duration_hr = round(duration_hr,2),
         total_depth_mm = round(total_depth_mm,2))%>%
  rename("Storm" = "storm_id",
         "Start" = "eventstart",
         "Duration (hr)" = "duration_hr",
         "Depth (mm)" = "total_depth_mm")%>%
  kbl(caption = "<center>Summary of Parsed Storm Events<center>")%>%
  kable_classic(full_width = FALSE, html_font = "Helvetica")
  
save_kable(tables[["storms"]],"03_Output/Figures_Tables/storm summary table.png")

#TABLE SUMMARY OF UNIT AREA LOAD VALUES AND EXPORT 
tables[["load_summary"]] <- statistics$distributions%>%
  mutate(roof = ifelse(roof == "eco", "Ecoroof", "Conventional"))%>%
  rename("Pollutant" = "pollutant",
         "Roof" = "roof")%>%
  kbl(caption = "<center>Summary Table for Pollutant Unit Area Loads<center>")%>%
  kable_classic(full_width = FALSE, html_font = "Helvetica")

save_kable(tables[["load_summary"]],"03_Output/Figures_Tables/load summary table.png")


#TABLE OF FRIEDMAN TEST RESULTS AND EXPORT 
tables[["friedman_results"]] <- statistics[["distributions_summary"]]%>%
rename("Pollutant" = "pollutant",
       "Higher Load" = "roof")%>%
  kbl(caption = "<center>The Comparison of Pollutant Loads Between Roofs Using Friedman Test<center>")%>%
  kable_classic(full_width = FALSE, html_font = "Helvetica")

save_kable(tables[["friedman_results"]],"03_Output/Figures_Tables/friedman results table.png")


#TABLE OF PRECIPITATION, DISCHARGE, AND RETENTION RATES AND EXPORT 
tables[["retention"]] <- retention%>%
  select(roof,rainfall_l,volume_l,retention)%>%
  mutate(roof = ifelse(roof == "con", "Conventional", "Ecoroof"))%>%
  rename("Discharge Volume (L)" = "volume_l",
         "Roof" = "roof",
         "Rainfall Volume (L)" = "rainfall_l",
         "Retention %" = "retention")%>%
  kbl(caption = "<center>Precipitation, Discharge, and Roof Retention Rates<center>")%>%
  kable_classic(full_width = FALSE, html_font = "Helvetica")

save_kable(tables[["retention"]], "03_Output/Figures_Tables/retention table.png")

