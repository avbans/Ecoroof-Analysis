#THIS SCRIPT GENERATES THE GRAPHS AND FIGURES FOR THIS ANALYSIS

graphs <- list()

#SAMPLES GATHERED OVER SAMPLING PERIOD (add rain data)
graphs[["sample_collection"]] <- samples[["full"]]%>%
  filter(pollutant == "Al")%>%
  select(datetime,roof,pollutant,ppm)%>%
  left_join(.,discharge[["full"]], by=c("roof","datetime"))%>%
  na.omit()%>%
ggplot()+
  geom_point(aes(datetime, flow_l_s))+
  geom_line(data = discharge[["full"]],aes(datetime,flow_l_s, color = roof))+
  theme_classic()

graphs[["sample_collection"]]

#Z SCORE NORAMLIZED CONCENTRATION OF RUNOFF SAMPLES OVER TIME 
graphs[["concentration_boxplot"]] <-samples[["full"]]%>%
  group_by(roof,pollutant)%>%
  mutate(z_score = scale(ppm))%>%
  ggplot(aes(roof,z_score))+
  geom_boxplot()+
  theme_bw()+
  facet_wrap(~pollutant, scale ="free")

graphs[["concentration_boxplot"]]

#EMC OVER TIME 
graphs[["emc"]] <- ggplot(samples[["storms"]])+
  geom_point(aes(storm_id,emc_ppm, color=roof))+
  facet_wrap(~pollutant,scale="free")+
  theme_classic()

graphs[["emc"]] 

#TOTAL RAIN AND DISCHARGE GRAPH 
graphs[["rain"]] <- left_join(discharge$full,rain$raw, by ="datetime")%>%
  select(datetime,depth_mm)%>%
  ggplot()+
  geom_line(aes(datetime,depth_mm))+
  scale_x_datetime(position = "top")+
  scale_y_reverse()+
  theme_classic()+
  theme(panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line()) +
  theme(axis.title.x = element_blank())

  c = samples[["collection_log"]]%>%
  mutate(roof = ifelse(roof == "we2","eco","con"),
         datetime = round_date(datetime, "5 minutes"))%>%
  select(datetime,roof)%>%
  inner_join(.,discharge[["full"]], by=c("roof","datetime"))

graphs[["discharge"]] <- left_join(discharge$full,rain$raw, by ="datetime")%>% 
  select(datetime,roof,flow_l_s)%>%
  ggplot()+
  geom_line(aes(x=datetime, y=flow_l_s, color = roof))+
  geom_point(data = c, aes( x = datetime, y = flow_l_s))+
  theme_classic()+ 
  theme(panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line() + theme(axis.text.x = element_blank(),
                                           axis.ticks.x = element_blank()))
remove(c)

graphs[["rain/discharge"]] <- (graphs[["rain"]]/graphs[["discharge"]]+
                                 plot_layout(nrow = 2, heights =c(2,8)))

graphs[["rain/discharge"]]

#GRAPH OF ROOF DISCHARGE PER STORM EVENT 
graphs[["discharge_storms"]] <- ggplot(discharge$storms)+
  geom_col(aes(datetime,flow_l_s, color = roof))+
  facet_wrap(~storm_id, scale = "free")+
  theme_classic()

graphs[["discharge_storms"]] 

#GRAPH OF THE UNIT AREA LOADS FOR THE SAMPLE STUDY 
graphs[["load"]] <- ggplot(load)+
  geom_col(aes(roof,p_mg_m2))+
  facet_wrap(~pollutant, scale = "free")+
  theme_classic()

graphs[["load"]]
  
#CUMULATIVE SUM UNIT AREA LOADING FOR SAMPLE STUDY 
graphs[["load_cumsum"]] <- load%>%
  arrange(roof,pollutant,storm_id)%>%
  group_by(roof,pollutant)%>%
  mutate(cumsum = cumsum(p_mg_m2))%>%
  ggplot(aes(storm_id,cumsum, fill = roof))+
  geom_col(position = "dodge2")+
  facet_wrap(~pollutant, scale ="free")+
  theme_classic()

graphs[["load_cumsum"]]
