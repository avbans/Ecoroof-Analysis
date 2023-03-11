#THIS SCRIPT CREATES FINAL TABLES FOR THE REPORT 
tables <- list()

#TABLE OF STORM EVENTS AND EXPORT 
tables[["storms"]] <- storms_full%>%
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
  kbl(caption = "<center>Summary Table for Pollutant Unit Area Loads (mg/m^2)<center>")%>%
  kable_classic(full_width = FALSE, html_font = "Helvetica")

save_kable(tables[["load_summary"]],"03_Output/Figures_Tables/load summary table.png")


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

#WE CAN REMOVE FULL STORM DATA FRAME 
remove(storms_full)
