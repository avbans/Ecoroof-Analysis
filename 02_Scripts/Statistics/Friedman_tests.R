#THE GOAL OF THIS SCRIPT IS TO APPLY THE FRIENDMAN TEST 

statistics[["friendman"]] <- load%>%
  pivot_wider(names_from = roof,
              values_from = p_mg_m2)%>%
  na.omit()%>%
  pivot_longer(cols = 3:4,names_to = "roof",
               values_to = "p_mg_m2")

statistics[["friendman"]] <- statistics[["friendman"]] %>%
  group_by(pollutant)%>%
  do(broom::tidy(friedman.test(y = .$p_mg_m2,
                               groups = .$roof,
                               blocks = .$storm_id)))%>%
  ungroup()%>%
  select(-c("parameter","method"))%>%
  rename(p_value = p.value)%>%
  mutate(p_value = round(p_value,4))

write.csv(statistics[["friendman"]],"03_Output/friendman_test_results.csv")
