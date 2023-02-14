#GRAPHS 

ggplot(runoff_samples)+
  geom_col(aes(storm_id,emc_ppm, color=roof))+
  facet_wrap(~chemical,scale="free")