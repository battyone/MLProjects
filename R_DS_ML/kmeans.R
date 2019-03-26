library(dplyr)
library(ISLR)

iris %>% 
  ggplot(aes(Petal.Length, Petal.Width, color = Species)) +
  geom_point()

set.seed(101)
irisCluster <- kmeans(iris[,1:4], 3, nstart = 20)
table(irisCluster$cluster, iris$Species)

library(cluster)
iris %>% clusplot(irisCluster$cluster, color = T, shade = T, labels = 0, lines = 0)
