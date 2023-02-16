#CALCULATE TOTAL RUNOFF VOLUME AND RUNOFF RETENTION RATE FOR SAMPLING PERIOD 

#PARSE RAIN BY STORM START AND END TIMES AND CONVERT FROM MM TO M 
rain[["summary"]]<-crossing(rain[["full"]],storms)%>%
  filter(datetime >= eventstart,
         datetime < eventstop)%>%
  select(-c(eventstart,eventstop,total_depth_mm))%>%
  group_by(storm_id)%>%
  summarize(depth_mm = sum(depth_mm))

#GROUP DISCHARGE BY STORM AND ROOF
discharge[["summary"]]<- discharge[["storms"]]%>%
  group_by(storm_id, roof)%>%
  summarise(volume_l = sum(volume_l))

#CREATE RETENTION DATA FRAME WITH RAIN AND DISCHARGE, CALCULATE RAINFALL VOLUMES,
#GROUP VALUES BY ROOF TYPE AND CALCULATE RETENTION RATES
retention<- left_join(discharge[["summary"]],rain[["summary"]],by = "storm_id")%>%
  mutate(depth_m = depth_mm*0.001,
         rainfall_l = ifelse(roof == "con", 
                             depth_m * catch_size$con_m2 * 1000,
                             depth_m * catch_size$eco_m2 * 1000))%>%
  group_by(roof)%>%
  summarize(volume_l = sum(volume_l),
            rainfall_l = sum(rainfall_l))%>%
  mutate(retention = (((rainfall_l - volume_l) / rainfall_l) *100))


