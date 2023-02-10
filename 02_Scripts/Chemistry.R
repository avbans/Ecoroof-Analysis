chemistry <-list()

chemistry[["metals"]] <-read.csv("01_Input/icp.csv")%>%
  clean_names()%>%
  select(-contains("_rsd"))%>%
  pivot_longer(cols = 4:22,
               names_to = "chemical",
               values_to = "ppb")%>%
  mutate(datetime = mdy_hm(datetime),
         roof = clean_strings(roof),
         ppm = ppb / 1000)%>%
  select(-ppb)


chemistry[["nutrients"]] <-read.csv("01_Input/smartchem.csv")%>%
  clean_names()%>%
  mutate(datetime = mdy_hm(datetime),
         roof = clean_strings(roof))%>%
  select(-"nh3")%>%
  pivot_longer(cols = 4:5,
               names_to = "chemical",
               values_to = "ppm")

chemistry[["full"]] <-rbind(chemistry[["metals"]],
                            chemistry[["nutrients"]])


chemistry[["storms"]]<- parse_dates(df = chemistry[["full"]],
                                          df2 = storms)


