#THIS SCRIPT IS FOR PERFORMING A PCA ANALYSIS ON THE FULL DATA 

#WE WILL PERFORM A PCA ANALYSIS FIRST TO SEE WHAT RESPONSE VARIABLES EFFECT 
#THE OVERALL VARIATION 


#SPREAD THE DATA INTO A MATRIX FOR MODEL BUILDING (RENAME VARIABLE NAME LATER)
df <- load%>%
  filter(pollutant != "NH3", 
         pollutant != "PO4",
         pollutant != "NO3")%>%
  mutate(name = paste0(storm_id,roof))%>%
  group_by(name)%>%
  select(name,pollutant,p_mg_m2)%>%
  rename(measurement = pollutant,
         value = p_mg_m2)

#ADD IN DISCHARGE VALUES 
dis <- discharge[["summary"]]%>%
  mutate(name = paste0(storm_id,roof))%>%
  group_by(name)%>%
  select(name,volume_l)%>%
  mutate(measurement = "discharge")%>%
  rename(value = volume_l)%>%
  select(name,measurement,value)

df = rbind(df, dis)

df = df %>%pivot_wider(names_from = name,
              values_from = value)

df = df %>% select_if(~ !any(is.na(.)))


#SCALE RESPONSE VARIABLES, CENTER, AND COMPUTE PCA 
df2 <- df[,-1]
row.names(df2) <- df$measurement


model <- prcomp(t(df2),scale = TRUE)

#DISPLAY INTIAL BIPLOT OF PC1 AND PC2 (IN THIS CASE ONLY ABOUT 61% OF VARIANCE)
fviz_pca_biplot(model,
                repel = TRUE)+
  theme_classic()+
  labs(title = "Roof Principle Component Analysis")

#GRAPH EIGVENVALUES AND THEIR CUMULATIVE VARIANCE TO DETERMINE HOW MANY 
#PC'S NEED TO BE INTERERATED TO EXPLAIN 95% OF VARIANCE (IN THIS CASE 10)
eigenvalues <-rownames_to_column(get_eig(model),"diminsion")

eigenvalues%>%
  ggplot(aes(x= reorder(diminsion,cumulative.variance.percent),
             y= cumulative.variance.percent))+
  geom_col()+
  theme_classic()

eigenvalues
model$rotation

loading_scores<- abs(model$rotation[,1])
loading_scores <- sort(loading_scores,decreasing = TRUE)
loading_scores <- names(loading_scores[1:10])
loading_scores
