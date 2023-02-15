#GRAPHS 

ggplot(runoff_samples)+
  geom_col(aes(storm_id,emc_ppm, color=roof))+
  facet_wrap(~pollutant,scale="free")+
  theme_bw()

ggplot(load)+
  geom_col(aes(roof,p_mg_m2))+
  facet_wrap(~pollutant, scale ="free")
