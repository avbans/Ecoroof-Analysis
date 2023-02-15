#CALCULATE RUNOFF RETENTION
a = rain$storms
b= flow$storms

a = a%>%
  group_by(storm_id)%>%
  summarise(rainfall_con_l = sum(rainfall_con_l),
            rainfall_eco_l = sum(rainfall_eco_l))

b <-b%>%
  group_by(storm_id,roof)%>%
  summarise(flow_l = sum(flow_l))


ret = merge(a, b, by = "storm_id")
ret = ret%>%
  mutate(retention = ifelse(roof == "con",
                            ((rainfall_con_l-flow_l)/rainfall_con_l)*100,
                            ((rainfall_eco_l-flow_l)/rainfall_eco_l)*100))


#we need to adjust: all discharge from the roof lasted until the start of the next event 

view(ret)

ret%>%
  filter(roof == "eco")%>%
  summarise(mean(retention))
ret%>%
  filter(roof == "con")%>%
  summarise(mean(retention))

a%>%
  select(-c("rainfall_con_l"))%>%
  summarize(sum(rainfall_eco_l))

a%>%
  select(-c("rainfall_eco_l"))%>%
  summarize(sum(rainfall_con_l))
  
b%>%
  group_by(roof)%>%
  summarise(sum(flow_l))
#eco rain
678180
#eco total discharge 
498408
#con rain 
826249
#con total discharge 
713785

total_eco_ret = (678180-498408)/678180*100
total_con_ret = (826249-713785)/826249*100
total_eco_ret
total_con_ret
