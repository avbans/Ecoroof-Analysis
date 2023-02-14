#THIS SCRIPT DETERMINES POLLUTANT LOADING FROM DISCHARGE, AND CHEMISTRY DATAFRAMES

#JOIN EMC WITH DISCHARGE DATA 
load<- left_join(discharge,
                 runoff_samples,
                 by = c("storm_id","roof"))%>%
  select(roof,storm_id,datetime,volume_l,pollutant,emc_ppm)

#CALCULATE UNIT AREA MASS LOAD OF POLLUTANTS 
load <- load%>%
  mutate(mass_mg = volume_l * emc_ppm,
         p_mg_m2 = ifelse(roof=="con", 
                          mass_mg/catch_size$con_m2,
                          mass_mg/catch_size$eco_m2))

#SUMMARIZE RESULTS BY STORM AND ROOF TYPE 
load <- load%>%
  group_by(pollutant,roof)%>%
  summarise(p_mg_m2 = sum(p_mg_m2))%>%
  na.omit()

load%>%group_by(roof,pollutant)%>%
ggplot()+
  geom_col(aes(roof,p_mg_m2))+
  facet_wrap(~pollutant, scale ="free")
