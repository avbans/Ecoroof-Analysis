#THIS SCRIPT DETERMINES POLLUTANT LOADING FROM DISCHARGE, AND CHEMISTRY DATAFRAMES

# DETERMINE CATCHMENT SIZE FOR BOTH ROOFS 
catch_size<-list()
catch_size[["con_m2"]] = 1462
catch_size[["eco_m2"]] = 1200

#GROUP DISCHARGE BY STORM AND ROOF
discharge[["summary"]] <- discharge[["storms"]]%>%
  group_by(storm_id, roof)%>%
  summarise(volume_l = sum(volume_l))
  

#JOIN EMC WITH DISCHARGE DATA 
load <- left_join(discharge[["summary"]],
                 samples[["storms"]],
                 by = c("storm_id","roof"))%>%
  select(roof,storm_id,volume_l,pollutant,emc_ppm)%>%
  na.omit()

#CALCULATE UNIT AREA MASS LOAD OF POLLUTANTS 
load <- load%>%
  mutate(mass_mg = volume_l * emc_ppm,
         p_mg_m2 = ifelse(roof=="con", 
                          mass_mg/catch_size$con_m2,
                          mass_mg/catch_size$eco_m2))

#SUMMARIZE RESULTS BY STORM AND ROOF TYPE 
load <- load%>%
  group_by(storm_id,pollutant,roof)%>%
  summarise(p_mg_m2 = sum(p_mg_m2))%>%
  mutate(p_mg_m2 = signif(p_mg_m2,3))

#EXPORT LOADING RESULTS FOR EACH POLLUTANT, FOR EACH ROOF, FOR EACH STORM EVENT 
write.csv(load,"03_Output/unit_area_load.csv")
