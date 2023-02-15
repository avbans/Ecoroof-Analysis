# THIS SCRIPT UPLOADS RAIN DATA AND PARSES STORMS FROM THE DATA 

# DETERMINE CATCHMENT SIZE FOR BOTH ROOFS 
catch_size<-list()
catch_size[["con_m2"]] = 1462
catch_size[["eco_m2"]] = 1200

# UPLOAD DATA, QC BASED ON DOWNTIME, CONVERT INCHES TO MM, TIDY, AND FILTER DATES 
rain <- read_csv("01_Input/rain.csv")%>%
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


# SEPERATE STORMS OUT OF RAIN DATA 
storms <-parse_storms(df=rain,
                        intervals_per_hr = 12,
                        interevent_period_hr = 24,
                        storm_size_minimum = 5.08)

# MAKE EVENTSTOP THE START OF THE NEXT EVENT AND FILL LAST STOP TIME WITH END TIME
storms<-storms%>%
  mutate(eventstop = lead(eventstart,n=1))%>%
  mutate(eventstop = coalesce(eventstop,eventend))%>%
  select(storm_id, eventstart,eventstop,total_depth_mm)

#IDENTIFY WHAT STORM EACH RAIN OBSERVATION BELONGS TO (may not need this)
#rain<-crossing(rain,storms)%>%filter(datetime >= eventstart,datetime < eventstop)%>%select(-c(eventstart,eventstop))

