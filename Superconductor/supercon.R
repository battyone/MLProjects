# This is an analysis on the critical temperature of various superconducting materials.
library(Rtsne)
library(sparklyr)
library(dplyr)
library(ggplot2)
library(plot3D)

# I load the training and test data.
trainData <- read.csv('superconduct/train.csv')
uniqueData <- read.csv('superconduct/unique_m.csv')

# Let's perform some exploratory analysis. 
trainData %>% dim()
uniqueData %>% dim()

# Basically there are 21263 materials which have shown the potential to be superconductors. 
# Let's explore the trainData first.
colnames(trainData) 
trainData %>% glimpse()
plot3D::scatter3D(trainData$mean_atomic_mass, trainData$wtd_mean_Valence, trainData$wtd_std_FusionHeat)

trainData %>% 
  ggplot(aes(x = std_ElectronAffinity, y = std_Valence)) +
  geom_point(aes(color = critical_temp), alpha = 0.1) +
  scale_color_continuous(name = "Critial \nTemperature", low = "green", high = "red") + 
  theme_dark()

superConPCA <- princomp(trainData, scale = T)

attributes(superConPCA)

colnames(trainData)
colnames(data.frame(superConPCA$scores))

data.frame(superConPCA$scores[1,])[,1]

data.frame(superConPCA$loadings[,1])[,1]

attributes(superConPCA)

data.frame(superConPCA$loadings[,3]) %>% 
  ggplot(aes(x = reorder(colnames(trainData), abs(data.frame(superConPCA$loadings[,3])[,1])), 
             y  = abs(data.frame(superConPCA$loadings[,3])[,1]))) + 
  geom_col() +
  coord_flip()  
