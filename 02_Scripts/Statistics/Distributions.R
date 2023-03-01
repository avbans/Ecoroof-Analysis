#THE GOAL OF THIS SCRIPT IS TO COMPARE GROUP DISTRUBUTIONS TO SEE IF MIXED 
#EFFECT MODELS CAN BE USED 

#DETERMINE THE N, MIN, MAX, IQR AND MEDIAN VALUES OF EACH POLLUTANT
statistics[["distributions"]] <- load%>%
  group_by(pollutant,roof)%>%
  summarise(n = n_distinct(storm_id),
            min = min(p_mg_m2),
            iqr = IQR(p_mg_m2),
            max = max(p_mg_m2),
            median = median(p_mg_m2))

#EXPORT SUMMARY DISTRIBUTIONS OF EACH POLLUTANT FOR EACH ROOF 
write.csv(statistics[["distributions"]],
          "03_Output/summary_statistics.csv")

#SEPERATE MEDIAN BY ROOF AND DETERMINE WHICH MEDIAN IS HIGHER
statistics[["distributions_summary"]] <- statistics[["distributions"]]%>%
  select(pollutant,roof,median)%>%
  pivot_wider(names_from = roof,
              values_from = median)%>%
  mutate(roof = ifelse(con<eco,"eco","conventional"))

#ADD FRIEDMAN RESULTS TO MEDIAN SUMMARY TABLE 
statistics[["distributions_summary"]] <- left_join(statistics[["distributions_summary"]],
                                                   statistics[["friendman"]],
                                                   by = "pollutant")%>%
  filter(p_value < 0.05)%>%
  select(pollutant,roof,statistic,p_value)%>%
  arrange(roof)

#EXPORT LOADING ANALYSIS 
write_csv(statistics[["distributions_summary"]],
          "03_Output/loading_statistics.csv")
