#THIS SCRIPT GENERATES THE GRAPHS AND FIGURES FOR THIS ANALYSIS

#graphs <- list()

#SAMPLES GATHERED OVER SAMPLING PERIOD 
samples[["full"]]%>%
  filter(pollutant == "al")%>%
  select(datetime,roof,pollutant,ppm)%>%
  left_join(.,discharge[["full"]], by=c("roof","datetime"))%>%
  na.omit()%>%
ggplot()+
  geom_point(aes(datetime, flow_l_s))+
  geom_line(data = discharge[["full"]],aes(datetime,flow_l_s, color = roof))+
  theme_classic()

#CONCENTRATION OF RUNOFF SAMPLES OVER TIME
ggplot(samples[["full"]])+
  geom_point(aes(datetime,ppm, color = roof))+
  facet_wrap(~pollutant, scale ="free")

#EMC OVER TIME 
ggplot(samples[["storms"]])+
  geom_point(aes(storm_id,emc_ppm, color=roof))+
  facet_wrap(~pollutant,scale="free")+
  theme_classic()

#GRAPH OF EACH STORM EVENT 
a = left_join(discharge[["storms"]],rain[["full"]], by = "datetime")%>%
  ggplot()+
  geom_col(aes(datetime,depth_mm))+
  scale_x_datetime(position = "top")+
  scale_y_reverse()+
  theme_classic()+
  theme(panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line()) +
  theme(axis.title.x = element_blank())

  
b = left_join(discharge[["storms"]],rain[["full"]],by = "datetime")%>%
  ggplot()+
  geom_line(aes(x=datetime, y=flow_l_s, color = roof))+
  theme_classic()+ 
  theme(panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line() + theme(axis.text.x = element_blank(),
                                           axis.ticks.x = element_blank()))

a/b+plot_layout(nrow = 2, heights =c(2,8))


#GRAPH OF THE UNIT AREA LOADS FOR THE SAMPLE STUDY 
  ggplot(load)+
  geom_col(aes(roof,p_mg_m2))+
  facet_wrap(~pollutant, scale = "free")+
  theme_classic()
  
#CUMSUM LOADING?
load%>%
  arrange(roof,pollutant,storm_id)%>%
  group_by(pollutant)%>%
  mutate(cumsum = cumsum(p_mg_m2))%>%
  ggplot(aes(storm_id,cumsum, fill = roof))+
  geom_col(position = "dodge2")+
  facet_wrap(~pollutant, scale ="free")+
  theme_classic()

