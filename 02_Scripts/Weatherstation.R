# THE PURPOSE OF THIS SCRIPT IS TO PROCESS WEATHERSTATION DATA 

#IMPORT WEATHER STATION AIR TEMPERATURE DATA 
temperature <- fread("01_Input/weatherstation.csv")%>%
  clean_names()%>%
  mutate(datetime = mdy_hm(datetime))%>%
  pivot_longer(cols =2:5,
               names_to = "variable",
               values_to = "measurement")

#MATCH TEMPERATURES TO STORM EVENTS 
temperature <- crossing(temperature,storms)%>%
  filter(datetime >= eventstart,
         datetime < eventstop)%>%
  select(-c(eventstart,eventstop,total_depth_mm))

#AGGREGATE TEMPERATURES 
temperature <- temperature%>%
  group_by(storm_id,variable)%>%
  summarise(measurement = mean(measurement))%>%
  mutate(measurement = log(measurement +1))

temperature <- temperature%>%
  pivot_wider(names_from = variable,
              values_from = measurement)
