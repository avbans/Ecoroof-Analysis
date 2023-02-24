#THIS SCRIPT UPLOADS STORMWATER SAMPLING RESULTS AND CLEANS THEM UP 

samples <- list()

#UPLOAD ICP RESULTS FOR METALS, CLEAN AND PIVOT, CONVERT TO PPM
samples[["metals"]]<-read.csv("01_Input/icp.csv")%>%
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
samples[["nutrients"]] <- read.csv("01_Input/smartchem.csv")%>%
  clean_names()%>%
  mutate(datetime = mdy_hm(datetime),
         roof = clean_strings(roof))%>%
  select(-"nh3")%>%
  pivot_longer(cols = 4:5,
               names_to = "pollutant",
               values_to = "ppm")

#COMBINE DATAFRAMES AND REMOVE OLD DATAFRAMES. RENAME "CONVENTIONAL" TO "CON"
samples[["full"]] <-rbind(samples[["metals"]], 
                            samples[["nutrients"]] )%>%
  mutate(roof = ifelse(roof == "conventional","con","eco"))


samples[["storms"]] <- samples[["full"]]%>%
  filter(datetime < as_date("2019/06/01"),
         datetime > as_date("2018/09/01"),
         month(datetime) != "10")
#IDENTIFY WHICH SAMPLE IS ASSOCIATED WITH WHICH STORM 
samples[["storms"]]<-crossing(samples[["storms"]],storms)%>%
  filter(datetime >= eventstart,
         datetime < eventstop)%>%
  select(-c(eventstart,eventstop))

#CALCULATE EVENT MEAN FOR EACH STORM EVENT FOR EACH POLLUTANT
samples[["storms"]] <-samples[["storms"]]%>%
  group_by(storm_id,roof, pollutant)%>%
  summarise(emc_ppm = geometric.mean(ppm))




