# THIS SCRIPT UPLOADS FLOW DATA FOR BOTH ROOFS, PROCESSES THEM, AND ID'S WHAT 
# STORM THEY BELONG TO 

discharge <- list()

# UPLOAD DISCHARGE FOR THE CONVENTIONAL ROOF AND CLEAN 
discharge[["con"]] <-fread("01_Input/Discharge/flow_conroof.csv")%>%
  mutate(roof="con")

# UPLOAD DISCHARGE FOR THE ECOROOF AND CLEAN
#REMOVED ONE SINGLE MEASUREMENT OF MISFIRE FROM THE SENSOR 
discharge[["eco"]] <- fread("01_Input/Discharge/flow_ecoroof.csv")%>%
  mutate(roof="eco")%>%
  filter(flow_l_s != max(flow_l_s))


#COMBINE DISCHARGE FOR BOTH ROOFS  
discharge[["full"]]<-rbind(discharge[["con"]],
                           discharge[["eco"]])%>%
  mutate(datetime =mdy_hm(datetime),
         flow_l_s = signif(flow_l_s,3))

#FILTER BY PROJECT DATES AND MONTH THAT CONVENTIONAL ROOF SENSOR WAS BROKEN 
discharge[["storms"]]<- discharge[["full"]]%>%
  filter(datetime < as_date("2019/06/01"),
         datetime > as_date("2018/09/01"),
         month(datetime) != "10")

#INTEGRATE DISCHARGE W/ RESPECT TO DATETIME NUMERICALLY USING TRAPAZOIDAL RULE
discharge[["storms"]] <- discharge[["storms"]]%>%
  mutate(dt = abs(as.numeric(difftime(datetime,lead(datetime), units ="secs"))),
         dt = ifelse(dt != 300, 0, dt),
         volume_l = 0.5*dt*(flow_l_s+lead(flow_l_s)))%>%
  select(-c("dt"))


# IDENTIFY WHAT STORM EACH DISCHARGE OBSERVATION BELONGS TO, REMOVE FLOW NOISE 
discharge[["storms"]]<-crossing(discharge[["storms"]],storms)%>%
  filter(datetime >= eventstart,
         datetime < eventstop)%>%
  select(-c(eventstart,eventstop,total_depth_mm))%>%
  filter(flow_l_s >= 0.04)
