#THIS SCRIPT IMPORTS RAW ICP AND SMART CHEM RESULTS, 
#ASSOCIATED THE RESULTS TO A COLLECTION TIME, AND COMBINES THEM
library(data.table)

samples <- list()

#IMPORT COLLECTION TIMES, CREATE DATETIME COLUMN AND RETURN DATETIME AND SAMPLE NAME
samples[["collection_log"]] <- fread("01_Input/newattempt/collection_log.csv")%>%
  mutate(datetime = mdy_hms(paste(date,time)))%>%
  select(datetime,roof,sample_code)

#IMPORT IN ICP RESULTS 
samples[["metals"]] <- fread("01_Input/newattempt/icp.csv")

#ADD COLLECTION TIMES TO ICP RESULTS 
samples[["metals"]] <- inner_join(samples[["collection_log"]],
                                  samples[["metals"]],
                                  "sample_code")

samples[["metals"]]  <- samples[["metals"]] %>%
  gather(pollutant, ppb, 4:26)%>%
  mutate(ppm = ppb *0.001)%>%
  select(-c(ppb, sample_code))

#UPLOAD NEW SMART CHEM RESULTS 
samples[["nutrients"]] <- fread("01_Input/newattempt/smartchem.csv")%>%
  na.omit()
  
samples[["nutrients"]] <- inner_join(samples[["collection_log"]], 
                                     samples[["nutrients"]] , 
                                     "sample_code")

samples[["nutrients"]] <- samples[["nutrients"]]%>%
  gather(pollutant,ppm, 4:6)%>%
  select(-sample_code)

samples[["full"]] <- rbind(samples[["metals"]],
                      samples[["nutrients"]])%>%
  mutate(roof = ifelse(roof == "we2",
                       "eco",
                       "con")) 

samples[["storms"]] <- samples[["full"]]%>%
  filter(datetime < as_date("2019/06/01"),
         datetime > as_date("2018/09/01"),
         month(datetime) != "10")

#IDENTIFY WHICH SAMPLE IS ASSOCIATED WITH WHICH STORM 
samples[["storms"]]<-crossing(samples[["storms"]],storms)%>%
  filter(datetime >= eventstart,
         datetime < eventstop)%>%
  select(-c(eventstart,eventstop,total_depth_mm))

#CALCULATE EVENT MEAN FOR EACH STORM EVENT FOR EACH POLLUTANT
samples[["storms"]] <-samples[["storms"]]%>%
  group_by(storm_id,roof, pollutant)%>%
  summarise(emc_ppm = mean(ppm))
