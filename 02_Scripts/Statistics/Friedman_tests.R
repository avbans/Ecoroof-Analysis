#THE GOAL OF THIS SCRIPT IS TO APPLY THE FRIENDMAN TEST 

friedman_results<- load%>%
  pivot_wider(names_from = roof,
              values_from = p_mg_m2)%>%
  na.omit()%>%
  pivot_longer(cols = 3:4,names_to = "roof",
               values_to = "p_mg_m2")

friedman_results<- friedman_results%>%
  group_by(pollutant)%>%
  do(broom::tidy(friedman.test(y = .$p_mg_m2,
                               groups = .$roof,
                               blocks = .$storm_id)))%>%
  ungroup()%>%
  select(-c("parameter","method"))%>%
  rename(p_value = p.value)%>%
  mutate(p_value = round(p_value,4))

