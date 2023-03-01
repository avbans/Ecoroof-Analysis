##THE GOAL OF THIS SCRIPT IS TO PERFORM NORMALITY TESTING 
statistics <- list()
#TEST FOR NORMALITY FOR EACH POLUTANT FOR EACH ROOF
statistics[["normality"]] <- load%>%
  group_by(roof,pollutant)%>%
  do(broom::tidy(shapiro.test(.$p_mg_m2)))%>%
  ungroup()%>%
  select(-c("statistic","method"))%>%
  rename(p_value = p.value)%>%
  mutate(p_value = round(p_value,3), 
         normality = ifelse(p_value > 0.05, "normal","nonnormal"))%>%
  filter(normality == "normal")

#AS THERE WAS NO SETS OF NORMAL GROUPS, DATA WAS LOG TRANSFORMED, ONLY SOME WERE NORMAL 
statistics[["log_normality"]]  <- load%>%
  group_by(roof,pollutant)%>%
  mutate(p_log = log10(p_mg_m2+1))%>%
  do(broom::tidy(shapiro.test(.$p_log)))%>%
  ungroup()%>%
  select(-c("statistic","method"))%>%
  rename(p_value = p.value)%>%
  mutate(p_value = round(p_value,3), 
         normality = ifelse(p_value > 0.05, "normal","nonnormal"))%>%
  filter(normality == "normal")

#EXPORT SHAPIRO TEST RESULTS FOR LOG TRANSFOMRED POLLUTANT DATA 
write.csv(statistics[["log_normality"]], "03_Output/log_normality_testing.csv")
