# THIS SCRIPT UPLOADS FLOW DATA FOR BOTH ROOFS, PROCESSES THEM, AND ID'S WHAT 
# STORM THEY BELONG TO 

# UPLOAD DISCHARGE FOR THE CONVENTIONAL ROOF AND CLEAN 
discharge_con<-read_csv("01_Input/flow_conroof.csv")%>%
  mutate(roof="con")%>%
  clean_names()%>%
  rename(datetime = we3datetime,
         flow_l_s = we3flow_l_s)

# UPLOAD DISCHARGE FOR THE ECOROOF AND CLEAN 
discharge_eco<-read_csv("01_Input/flow_ecoroof.csv")%>%
  select(-c("...1"))%>%
  mutate(roof="eco")%>%
  clean_names()%>%
  rename(datetime = we2datetime,
         flow_l_s = we2flow_l_s)

#COMBINE ROOF DATA SETS AND FILTER BY DATES. REMOVE OLD DATAFRAMES. Calculate 
#INTEGRATE DISCHARGE W/ RESPECT TO DATETIME NUMERICALLY USING TRAPAZOIDAL RULE (Option 2)

discharge<-rbind(discharge_con,
                 discharge_eco)%>%
  mutate(datetime =mdy_hm(datetime))%>%
  filter(datetime < as_date("2019/06/01"),
         datetime > as_date("2018/09/01"),
         month(datetime) != "10")%>%
  mutate(dt = abs(as.numeric(difftime(datetime,lead(datetime), units ="secs"))),
         dt = ifelse(dt != 300, 0, dt),
         volume_l = 0.5*dt*(lead(flow_l_s)+lag(flow_l_s)))%>%
  select(-c("dt"))


remove(discharge_con,discharge_eco)


# IDENTIFY WHAT STORM EACH DISCHARGE OBSERVATION BELONGS TO, REMOVE FLOW NOISE 
discharge<-crossing(discharge,storms)%>%
  filter(datetime >= eventstart,
         datetime < eventstop)%>%
  select(-c(eventstart,eventstop))%>%
  filter(flow_l_s >= 0.04)


