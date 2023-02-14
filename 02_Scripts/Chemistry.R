#THIS SCRIPT UPLOADS STORMWATER SAMPLING RESULTS AND CLEANS THEM UP 

#UPLOAD ICP RESULTS FOR METALS, CLEAN AND PIVOT, CONVERT TO PPM
runoff_metals <-read.csv("01_Input/icp.csv")%>%
  clean_names()%>%
  select(-contains("_rsd"))%>%
  pivot_longer(cols = 4:22,
               names_to = "pollutant",
               values_to = "ppb")%>%
  mutate(datetime = mdy_hm(datetime),
         roof = clean_strings(roof),
         ppm = ppb / 1000)%>%
  select(-ppb)

#UPLOAD SMARTCHEM RESULTS FOR NUTRIENTS,REMOVE NH3, CLEAN AND PIVOT
runoff_nutrients <-read.csv("01_Input/smartchem.csv")%>%
  clean_names()%>%
  mutate(datetime = mdy_hm(datetime),
         roof = clean_strings(roof))%>%
  select(-"nh3")%>%
  pivot_longer(cols = 4:5,
               names_to = "pollutant",
               values_to = "ppm")

#COMBINE DATAFRAMES AND REMOVE OLD DATAFRAMES. RENAME "CONVENTIONAL" TO "CON"
runoff_samples <-rbind(runoff_metals,
                       runoff_nutrients)%>%
  mutate(roof = ifelse(roof == "conventional","con","eco"))%>%
  filter(datetime < as_date("2019/06/01"),
         datetime > as_date("2018/09/01"),
         month(datetime) != "10")

remove(runoff_metals,runoff_nutrients)

#IDENTIFY WHICH SAMPLE IS ASSOCIATED WITH WHICH STORM 
runoff_samples<-crossing(runoff_samples,storms)%>%
  filter(datetime >= eventstart,
         datetime < eventstop)%>%
  select(-c(eventstart,eventstop))

#CALCULATE EVENT MEAN FOR EACH STORM EVENT FOR EACH POLLUTANT
runoff_samples <-runoff_samples%>%
  group_by(storm_id,roof, pollutant)%>%
  summarise(emc_ppm = geometric.mean(ppm))




