# THIS SCRIPT UPLOADS FLOW DATA FOR BOTH ROOFS, PROCESSES THEM, AND ID'S WHAT 
# STORM THEY BELONG TO 

discharge <- list()

# UPLOAD DISCHARGE FOR THE CONVENTIONAL ROOF AND CLEAN 
discharge[["con"]]<-read_csv("01_Input/flow_conroof.csv")%>%
  mutate(roof="con")%>%
  clean_names()%>%
  rename(datetime = we3datetime,
         flow_l_s = we3flow_l_s)

# UPLOAD DISCHARGE FOR THE ECOROOF AND CLEAN 
discharge[["eco"]]<-read_csv("01_Input/flow_ecoroof.csv")%>%
  select(-c("...1"))%>%
  mutate(roof="eco")%>%
  clean_names()%>%
  rename(datetime = we2datetime,
         flow_l_s = we2flow_l_s)%>%
  filter(flow_l_s <= 13)

#COMBINE ROOF DATA SETS AND FILTER BY DATES. REMOVE OLD DATAFRAMES. Calculate 
#INTEGRATE DISCHARGE W/ RESPECT TO DATETIME NUMERICALLY USING TRAPAZOIDAL RULE (Option 2)
discharge[["full"]]<-rbind(discharge[["con"]],
                           discharge[["eco"]])%>%
  mutate(datetime =mdy_hm(datetime))

discharge[["storms"]]<- discharge[["full"]]%>%
  filter(datetime < as_date("2019/06/01"),
         datetime > as_date("2018/09/01"),
         month(datetime) != "10")%>%
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
