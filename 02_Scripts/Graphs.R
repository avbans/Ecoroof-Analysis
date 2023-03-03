#THIS SCRIPT GENERATES THE GRAPHS AND FIGURES FOR THIS ANALYSIS
graphs <- list()

#SUMMARY GRAPH OF PRECIPITATION, ROOF DISCHARGES, AND RUNOFF SAMPLING 
#GRAPH PRECIPITATION DATA 
graphs[["rain"]] <- left_join(discharge$full,rain$raw, by ="datetime")%>%
  select(datetime,depth_mm)%>%
  ggplot()+
  geom_line(aes(datetime,depth_mm), color = "white")+
  labs(title = "Rain, Roof Discharge, and Runoff Sampling of Roofs",
       x = " ",
       y = "Depth (mm)")+
  scale_x_datetime(position = "top")+
  scale_y_reverse()+
  theme_hc(style = "darkunica")+
  theme(panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line()) +
  theme(axis.title.x = element_blank())

#COLLECTION SAMPLE COLLECTION DATA 
c = samples[["collection_log"]]%>%
  mutate(roof = ifelse(roof == "we2","eco","con"),
         datetime = round_date(datetime, "5 minutes"))%>%
  select(datetime,roof)%>%
  inner_join(.,discharge[["full"]], by=c("roof","datetime"))

#GRAPH ROOF DISCHRAGE AND SAMPLING DATA 
graphs[["discharge"]] <- left_join(discharge$full,rain$raw, by ="datetime")%>% 
  select(datetime,roof,flow_l_s)%>%
  ggplot()+
  geom_line(aes(x=datetime, y=flow_l_s, color = roof))+
  geom_point(data = c, aes( x = datetime, y = flow_l_s))+
  labs(x = "Date Time",
       y = "Discharge (L/s)",
       color = "Roof Type")+
  theme_hc(style = "darkunica")+
  theme(panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line() + theme(axis.text.x = element_blank(),
                                         axis.ticks.x = element_blank()))
#REMOVE COLLECTION DATA FRAME 
remove(c)

#ADD GRAPHS TOGETHER
graphs[["rain/discharge"]] <- (graphs[["rain"]]/graphs[["discharge"]]+
                                 plot_layout(nrow = 2, heights =c(2,8)))
#PRINT GRAPH 
ggsave(plot = graphs[["rain/discharge"]], "03_Output/03_rain_discharge_sampling.png",
       unit = "cm", width = 30, height = 20)

#GRAPH OF ROOF DISCHARGE PER STORM EVENT 
graphs[["discharge_storms"]] <-  ggplot(discharge$storms)+
  geom_col(aes(datetime,flow_l_s, color = roof))+
  labs(title = "Roof Discharge for Each Storm Event",
       x = "Storm Event",
       y = "Discharge (L/s)",
       color = "Roof Type")+
  theme_hc(style = "darkunica")+
  facet_wrap(~storm_id, scale = "free")

ggsave("03_Output/02_storm_discharges.png", units = "cm", width = 30, height = 20)

#RUNOFF CHEMISTRY SAMPLE BOX PLOT 
graphs[["chemimstry_boxplot"]] <- samples[["full"]]%>%
  mutate(ppm = log10(ppm+1))%>%
  ggplot(aes(roof,ppm, color = roof, fill = roof))+
  geom_boxplot()+
  labs(x = "Roof",
       y = "Log10 (mg/L + 1)")+
  theme_hc(style = "darkunica")+
  facet_wrap(~pollutant,scale = "free")

ggsave("03_Output/04_runoffsample_boxplot.png",
       units = "cm",
       width = 30, 
       height = 20)


#EMC OVER TIME 
graphs[["emc"]] <- samples[["storms"]]%>%
  ggplot()+
  geom_point(aes(storm_id,emc_ppm, color=roof))+
  labs(title = "Event Mean Concentrations Over Time",
       x = "Storm Event",
       y = "EMC (mg/L)",
       color = "Roof Type")+
  theme_hc(style = "darkunica")+
  facet_wrap(~pollutant, scale="free")

ggsave("03_Output/05_EMC.png", units = "cm", height = 20, width = 30)


#CUMULATIVE SUM UNIT AREA LOADING FOR SAMPLE STUDY 
graphs[["load_cumsum"]] <- load%>%
  arrange(roof,pollutant,storm_id)%>%
  group_by(roof,pollutant)%>%
  mutate(cumsum = cumsum(p_mg_m2))%>%
  ggplot(aes(storm_id,cumsum, fill = roof))+
  geom_col(position = "dodge2")+
  labs(title = "Cumulative Unit Area Load of Pollutant by Storm Event",
       x = "Storm Event",
       y = "Unit Area Load (mg/sq. meter)",
       color = "Roof Type")+
  theme_hc(style = "darkunica")+
  facet_wrap(~pollutant, scale ="free")

ggsave("03_Output/06_cum_unit_area_load.png", units = "cm", width = 30, height = 20)
