#CALCULATE TOTAL RUNOFF VOLUME AND RUNOFF RETENTION RATE FOR SAMPLING PERIOD 

#PARSE RAIN BY STORM START AND END TIMES AND CONVERT FROM MM TO M 
rain[["summary"]] <- rain[["storms"]]%>%
  group_by(storm_id)%>%
  summarize(depth_mm = sum(depth_mm))%>%
  mutate(depth_mm = signif(depth_mm,3))


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
  mutate(volume_l = signif(volume_l,3),
         rainfall_l = signif(rainfall_l,3),
         retention = (((rainfall_l - volume_l) / rainfall_l) *100),
         retention = signif(retention,3))
  
