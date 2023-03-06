# THIS SCRIPT UPLOADS RAIN DATA AND PARSES STORMS FROM THE DATA 

rain<-list()

# UPLOAD DATA, QC BASED ON DOWNTIME, CONVERT INCHES TO MM, SELECT RELEVENT COLUMNS
rain[["raw"]] <- fread("01_Input/rain.csv")%>%
  clean_names()%>%
  filter(downtime == FALSE)%>%
  mutate(depth_mm = rainfall_amount_inches* 25.4)%>%
  select(end_local,depth_mm)%>%
  rename(datetime = end_local)

#FILTER DATA TO SAMPLING PERIOD AND EXCLUDE THE MONTH OF OCTOBER DUE TO 
#FLOW SENSOR MALFUNCTIONING FOR CONVENTIONAL ROOF 
rain[["full"]] <- rain[["raw"]]%>%
  filter(datetime < as_date("2019/06/01"),
         datetime > as_date("2018/09/01"),
         month(datetime) != "10")


#SEPERATE STORMS OUT OF RAIN DATA 
storms_full <- parse_storms(df=rain[["full"]],
                        intervals_per_hr = 12,
                        interevent_period_hr = 24,
                        storm_size_minimum = 5.08)%>%
  mutate(total_depth_mm = signif(total_depth_mm,3))

# MAKE EVENTSTOP THE START OF THE NEXT EVENT AND FILL LAST STOP TIME WITH END TIME
storms <- storms_full%>%
  mutate(eventstop = lead(eventstart,n=1))%>%
  mutate(eventstop = coalesce(eventstop,eventend))%>%
  select(storm_id, eventstart,eventstop,total_depth_mm)

#DETERMINE THE PRECIPITATION THAT BELONGS TO WHAT STORM EVENT 
rain[["storms"]]<-crossing(rain[["full"]],storms)%>%
  filter(datetime >= eventstart,
         datetime < eventstop)%>%
  select(-c(eventstart,eventstop,total_depth_mm))
  


