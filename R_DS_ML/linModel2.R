library(dplyr)
library(ggplot2)
library(corrplot)
library(caTools)

####################################################################
trainData <- read.csv('./linReg2/train.csv')
testData <- read.csv('./linReg2/test.csv')

head(trainData)
####################################################################
trainData %>% 
  ggplot(aes(x = temp, y = count)) +
  geom_point(alpha = 0.2, aes(color = temp))

trainData %>% 
  ggplot(aes(x = as.Date(trainData$datetime), y = count)) +
  geom_point(alpha = 0.5, aes(color = temp)) +
  scale_color_continuous(low = 'green', high = 'red') +
  theme_bw()

cor(trainData[, c('temp', 'count')])

trainData %>% 
  ggplot(aes(x = factor(season), y = count)) +
  geom_boxplot(aes(fill = factor(season))) +
  theme_bw()

####################################################################
trainData$datetime <- as.POSIXct(trainData$datetime)
trainData$hour <- sapply(trainData$datetime, function(x){format(x, "%H")})

testData$datetime <- as.POSIXct(testData$datetime)
testData$hour <- sapply(testData$datetime, function(x){format(x, "%H")})


trainData %>% 
  filter(workingday == 1) %>% 
  ggplot(aes(x = hour, y = count)) +
  geom_point(aes(color = temp), position = position_jitter(w = 0.3, h = 0), alpha = 0.8) +
  scale_color_gradientn(colours = c('dark blue', 'light blue', 'light green', 'yellow', 'orange', 'red')) +
  theme_bw()
####################################################################

linModel2 <- lm(count ~ . - casual - registered, trainData)

summary(linModel2)
