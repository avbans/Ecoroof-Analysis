#CALCULATE RUNOFF RETENTION
a = rain$storms
b= flow$storms
c = storms%>%
  select(storm_id,volume_eco_l,volume_con_l)
view(c)

b <-b%>%
  group_by(storm_id,roof)%>%
  summarise(flow_l = sum(flow_l))

ret = merge(b, c, by = "storm_id")

ret = ret%>%
  mutate(retention = ifelse(roof == "conventional",
                            ((volume_con_l-flow_l)/volume_con_l)*100,
                            ((volume_eco_l-flow_l)/volume_eco_l)*100))

#we need to adjust: all discharge from the roof lasted until the start of the next event 