#THE GOAL OF THIS SCRIPT IS TO COMPARE GROUP DISTRUBUTIONS TO SEE IF MIXED 
#EFFECT MODELS CAN BE USED 

statistics <-list()

#DETERMINE THE N, MIN, MAX, IQR, MEDIAN, MEAN, AND SD OF EACH POLLUTANT
statistics[["distributions"]] <- load%>%
  mutate(p_mg_m2 = signif(p_mg_m2,3))%>%
  group_by(pollutant,roof)%>%
  summarise(n = n_distinct(storm_id),
            Min = min(p_mg_m2),
            IQR = signif(IQR(p_mg_m2),3),
            Max = max(p_mg_m2),
            Median = median(p_mg_m2), 
            Mean = mean(p_mg_m2),
            SD = sd(p_mg_m2))%>%
  mutate(roof = ifelse(roof == "con","con", "eco"))
