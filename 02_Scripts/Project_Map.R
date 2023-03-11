#CREATE MAP OF PROJECT SITE 
library(tidyverse)
library(urbnmapr)
library(patchwork)

#GET MAPPING DATA 
a = get_urbn_map("counties", sf = TRUE)

#EXTRACT STATE MAPPING DATA 
a = a%>%
  filter(state_name == "Oregon")

#EXTRACT COUNTY MAPPING DATA 
b = a%>% filter(county_name == "Multnomah County")

#CREATE STATE LEVEL MAP 
ggplot()+
  geom_sf(a, mapping = aes(), fill = "grey")+
  geom_sf(b, mapping = aes(), fill = "forestgreen")+
  theme_bw()

#CREATE COUNTY LEVEL MAP 
ggplot(b)+
  geom_sf(mapping = aes(), fill = "forestgreen")+
  theme_bw()
