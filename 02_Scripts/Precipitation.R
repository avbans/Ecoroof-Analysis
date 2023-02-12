#PRECIPITATION ANALYSIS AND STORM PARSING 
catchment_size<-list()
catchment_size[["con_m2"]] = 1462
catchment_size[["eco_m2"]] = 1200

rain<-list()

rain[["full"]] <- read_csv("01_Input/rain.csv")%>%
  clean_names()%>%
  filter(downtime == FALSE)%>%
  mutate(depth_mm = rainfall_amount_inches* 25.4)%>%
  select(-c("x1",
            "station_name",
            "h2_number",
            "station_start",
            "station_end",
            "x",
            "y",
            "start_local",
            "station_id",
            "sensor_present",
            "downtime",
            "rainfall_amount_inches"))%>%
  rename(datetime = end_local)%>%
  filter(datetime < as_date("2019/06/01"),
         datetime > as_date("2018/09/01"),
         month(datetime) != "10")

storms <-parse_storms(df=rain[["full"]],
                        intervals_per_hr = 12,
                        interevent_period_hr = 24,
                        storm_size_minimum = 5.08)


#rain[["storms"]] <- parse_dates(df=rain[["full"]],df2 =storms)

storm_parser<-storms%>%
  mutate(eventstop = lead(eventstart,n=1))%>%
  mutate(eventstop = coalesce(eventstop,eventend))%>%
  select(storm_id, eventstart,eventstop)

rain[["storms"]]<-crossing(rain$full,storm_parser)%>%
  filter(datetime >= eventstart,
         datetime <= eventstop)%>%
  select(-c(eventstart,eventstop))


rain[["storms"]]<-rain[["storms"]]%>%
  mutate(rainfall_con_l = depth_mm* catchment_size$con_m2,
         rainfall_eco_l = depth_mm* catchment_size$eco_m2)
