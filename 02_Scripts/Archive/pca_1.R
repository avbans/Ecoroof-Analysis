#THIS SCRIPT IS FOR PERFORMING A PCA ANALYSIS ON THE FULL DATA 

pca <- list()

#WE WILL PERFORM A PCA ANALYSIS FIRST TO SEE WHAT RESPONSE VARIABLES EFFECT 
#THE OVERALL VARIATION 

#SPREAD THE DATA INTO A MATRIX FOR MODEL BUILDING (RENAME VARIABLE NAME LATER)
pca[["df"]] <- load%>%
  spread(pollutant,p_mg_m2)%>%
  na.omit()


#ADD IN DISCHARGE VALUES 
pca[["df"]] <- left_join(pca[["df"]],
                  discharge[["summary"]],
                  by= c("storm_id","roof"))

#SCALE RESPONSE VARIABLES, CENTER, AND COMPUTE PCA 
pca[["model"]] <- prcomp(pca$df[-c(1:2)], 
                  center = TRUE,
                  scale = TRUE)

#DISPLAY INTIAL BIPLOT OF PC1 AND PC2 (IN THIS CASE ONLY ABOUT 61% OF VARIANCE)
fviz_pca_biplot(pca[["model"]],
                label = "var",
                habillage = pca$df$roof,
                addEllipses = TRUE,
                ellipse.level = 0.95,
                repel = TRUE)+
  theme_classic()+
  labs(title = "Roof Principle Component Analysis")

#GRAPH EIGVENVALUES AND THEIR CUMULATIVE VARIANCE TO DETERMINE HOW MANY 
#PC'S NEED TO BE INTERERATED TO EXPLAIN 95% OF VARIANCE (IN THIS CASE 10)
pca[["eigenvalues"]] <-rownames_to_column(get_eig(pca$model),"diminsion")

pca[["eigenvalues"]]%>%
  mutate(cumulative.variance.percent = round(cumulative.variance.percent))%>%
  filter(cumulative.variance.percent <= 95)%>%
ggplot(aes(x= reorder(diminsion,cumulative.variance.percent),
           y= cumulative.variance.percent))+
  geom_col()+
  theme_classic()

