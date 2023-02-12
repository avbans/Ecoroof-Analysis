#THIS SCRIPT UPLOADS FLOW DATA FOR BOTH ROOFS AND PROCESSES THEM
flow<-list()

flow[["con"]]<-read_csv("01_Input/flow_conroof.csv")%>%
  mutate(roof="con")%>%
  clean_names()%>%
  rename(datetime = we3datetime,
         flow_l_s = we3flow_l_s)

flow[["eco"]]<-read_csv("01_Input/flow_ecoroof.csv")%>%
  select(-c("...1"))%>%
  mutate(roof="eco")%>%
  clean_names()%>%
  rename(datetime = we2datetime,
         flow_l_s = we2flow_l_s)

flow[["roof"]]<-rbind(flow[["con"]],
                      flow[["eco"]])%>%
  mutate(datetime =mdy_hm(datetime),
         flow_l = flow_l_s * 300)%>%
  filter(datetime < as_date("2019/06/01"),
         datetime > as_date("2018/09/01"),
         month(datetime) != "10")

flow[["storms"]]<-crossing(flow$roof,storm_parser)%>%
  filter(datetime >= eventstart,
         datetime <= eventstop)%>%
  select(-c(eventstart,eventstop))

flow[["storms"]]<-flow[["storms"]]%>%
  filter(flow_l_s >= 0.04)

