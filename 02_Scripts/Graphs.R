#THIS SCRIPT GENERATES THE GRAPHS AND FIGURES FOR THIS ANALYSIS
graphs <- list()

#SUMMARY GRAPH OF PRECIPITATION, ROOF DISCHARGES, AND RUNOFF SAMPLING 
#GRAPH PRECIPITATION DATA 
graphs[["rain"]] <- left_join(discharge$full,rain$raw, by ="datetime")%>%
  select(datetime,depth_mm)%>%
  ggplot()+
  geom_line(aes(datetime,depth_mm))+
  labs(title = "Rain, Roof Discharge, and Runoff Sampling of Roofs",
       x = " ",
       y = "Depth (mm)")+
  scale_x_datetime(position = "top")+
  scale_y_reverse()+
  theme_bw()+
  theme(text = element_text(family = "Helvetica"),
        plot.title = element_text(hjust = 0.5),
    panel.border = element_blank(),
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
  mutate(roof = ifelse(roof == "con","Conventional","Ecoroof"))%>%
  ggplot()+
  geom_line(aes(x=datetime, y=flow_l_s, color = roof))+
  geom_point(data = c, aes( x = datetime, y = flow_l_s))+
  labs(x = "Date Time",
       y = "Discharge (L/s)",
       color = "Roof Type")+
  theme_bw()+
  theme(text = element_text(family = "Helvetica"),
        legend.position = "bottom",
        panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_line()) +
  theme(axis.title.x = element_blank())

#REMOVE COLLECTION DATA FRAME 
remove(c)

#ADD GRAPHS TOGETHER
graphs[["rain/discharge"]] <- (graphs[["rain"]]/graphs[["discharge"]]+
                                 plot_layout(nrow = 2, heights =c(2,8)))

#PRINT GRAPH 
ggsave(plot = graphs[["rain/discharge"]], "03_Output/Figures_Tables/03_rain_discharge_sampling.png",
       unit = "cm", width = 30, height = 20)

#GRAPH OF ROOF DISCHARGE PER STORM EVENT 
graphs[["discharge_storms"]] <-  discharge[["storms"]]%>%
  mutate(roof = ifelse(roof == "con", "Conventional", "Ecoroof"))%>%
  ggplot()+
  geom_col(aes(datetime,flow_l_s, fill = roof))+
  labs(title = "Roof Discharge for Each Storm Event",
       x = "Storm Event",
       y = "Discharge (L/s)",
       fill = "Roof Type")+
  theme_bw()+
  theme(text = element_text(family = "Helvetica"),
        axis.text.x=element_blank(),
        plot.title = element_text(hjust = 0.5),
        legend.position = "bottom")+
  facet_wrap(~storm_id, scale = "free")

ggsave("03_Output/Figures_Tables/02_storm_discharges.png", units = "cm", width = 30, height = 20)


#EMC OVER TIME 
graphs[["emc"]] <- samples[["storms"]]%>%
  mutate(roof = ifelse(roof == "con", "Conventional", "Ecoroof"))%>%
  ggplot()+
  geom_point(aes(storm_id,emc_ppm, color=roof))+
  labs(title = "Event Mean Concentrations Over Time",
       x = "Storm Event",
       y = "EMC (mg/L)",
       color = "Roof Type")+
  theme_bw()+
  theme(text = element_text(family = "Helvetica"),
        plot.title = element_text(hjust = 0.5),
        legend.position = "bottom")+
  facet_wrap(~pollutant, scale="free")

ggsave("03_Output/Figures_Tables/05_EMC.png", units = "cm", height = 20, width = 30)


#CUMULATIVE SUM UNIT AREA LOADING FOR SAMPLE STUDY 
graphs[["load_diff"]] <- load%>%
  pivot_wider(names_from = roof, values_from = p_mg_m2)%>%
  na.omit()%>%
  mutate(dif = eco -con)%>%
  select(storm_id,pollutant,dif)%>%
  group_by(pollutant)%>%
  summarise(mean_dif = mean(dif))%>%
  filter(pollutant != "Ca")%>%
  mutate(scaled_dif = scale(mean_dif))%>%
  ggplot(aes(pollutant,scaled_dif))+
  geom_col(fill = "forestgreen")+
  labs(title = "Scaled Difference of Mean Pollutant Loads", 
       subtitle = "Graph Excludes Ca",
       x = "Pollutant", 
       y = "Z Score Mean Load of Ecoroof - Conventional Roof")+
  theme_bw()+
  theme(text = element_text(family = "Helvetica"),
        plot.title = element_text(hjust = 0.5))

graphs[["load_diff"]]

ggsave("03_Output/Figures_Tables/06_diff_unit_area_load.png", units = "cm", width = 30, height = 20)
