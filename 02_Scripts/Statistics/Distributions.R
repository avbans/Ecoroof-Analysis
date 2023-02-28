#THE GOAL OF THIS SCRIPT IS TO COMPARE GROUP DISTRUBUTIONS TO SEE IF MIXED 
#EFFECT MODELS CAN BE USED 

#DETERMINE THE N, MIN, MAX, IQR AND MEDIAN VALUES OF EACH POLLUTANT
table_distribution<- load%>%
  group_by(pollutant,roof)%>%
  summarise(n = n_distinct(storm_id),
            min = min(p_mg_m2),
            IQR = IQR(p_mg_m2),
            max = max(p_mg_m2),
            median = median(p_mg_m2))

#SEPERATE MEDIAN BY ROOF AND DETERMINE WHICH MEDIAN IS HIGHER
table_summary <- table_distribution%>%
  select(pollutant,roof,median)%>%
  pivot_wider(names_from = roof,
              values_from = median)%>%
  mutate(roof = ifelse(con<eco,"eco","conventional"))

#ADD FRIEDMAN RESULTS TO MEDIAN SUMMARY TABLE 
table_summary <- left_join(table_summary,friedman_results,by = "pollutant")%>%
  filter(p_value < 0.05)%>%
  select(pollutant,roof,statistic,p_value)%>%
  arrange(roof)
