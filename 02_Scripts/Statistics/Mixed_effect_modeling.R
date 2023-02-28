#THE PURPOSE OF THIS SCRIPT IS TO PERFORM MIXED EFFECT MODELING 
source("02_Scripts/Weatherstation.R")
library(lme4)
#po4, p, zn, nh3, Cr
a <- test%>%
  rename(p = p_mg_m2)%>%
  mutate(p = log(p+1))%>%
  filter(pollutant == "PO4")

#ADD IN TEMPERATURE DATA AND LOG TRANSFORM TO MATCH THE SCALE OF THE POLLUTANT
a <- left_join(a,temperature,by = "storm_id")

model <- lmer(p ~roof  + (1|storm_id) ,data = a)

summary(model)


plot(model)
  
qqnorm(resid(model))
qqline(resid(model))

shapiro.test(resid(model))

(exp(-0.3287))-1
log(-0.2801411+1)
