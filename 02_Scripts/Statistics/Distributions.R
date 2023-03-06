#THE GOAL OF THIS SCRIPT IS TO COMPARE GROUP DISTRUBUTIONS TO SEE IF MIXED 
#EFFECT MODELS CAN BE USED 

#DETERMINE THE N, MIN, MAX, IQR AND MEDIAN VALUES OF EACH POLLUTANT
statistics[["distributions"]] <- load%>%
  mutate(p_mg_m2 = signif(p_mg_m2,3))%>%
  group_by(pollutant,roof)%>%
  summarise(n = n_distinct(storm_id),
            Min = min(p_mg_m2),
            IQR = signif(IQR(p_mg_m2),3),
            Max = max(p_mg_m2),
            Median = median(p_mg_m2))%>%
  mutate(roof = ifelse(roof == "con","con", "eco"))

#SEPERATE MEDIAN BY ROOF AND DETERMINE WHICH MEDIAN IS HIGHER
statistics[["distributions_summary"]] <- statistics[["distributions"]]%>%
  select(pollutant,roof,Median)%>%
  pivot_wider(names_from = roof,
              values_from = Median)%>%
  mutate(roof = ifelse(con < eco,"Ecoroof","Conventional"))

#ADD FRIEDMAN RESULTS TO MEDIAN SUMMARY TABLE 
statistics[["distributions_summary"]] <- left_join(statistics[["distributions_summary"]],
                                                   statistics[["friendman"]],
                                                   by = "pollutant")%>%
  filter(p_value < 0.05)%>%
  select(pollutant,roof,statistic,p_value)%>%
  arrange(roof)%>%
  mutate(statistic = round(statistic,1),
         p_value = round(p_value,3))%>%
  rename( "Q-statistic" = "statistic", 
         "P-value" = "p_value")
