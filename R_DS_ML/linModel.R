library(dplyr)
library(ggplot2)
library(corrplot)
library(caTools)

####################################################################
df <- read.csv('./student/student-mat.csv', sep = ';')
summary(df)
any(is.na(df))

num.cols <- sapply(df, is.numeric)
cor.data <- cor(df[,num.cols])

corrplot(cor.data, method = 'color')

df %>% 
  ggplot(aes(x = G3)) +
  geom_histogram(bins = 20, fill = 'blue')
####################################################################

#set.seed(101)
sampleData <- sample.split(df$G3, SplitRatio = 0.7)

train <- df %>% filter(sampleData == T)
test <- df %>% filter(sampleData == F)

linModel <- lm(G3 ~ ., train)

####################################################################
summary(linModel)
res <- residuals(linModel)
res <- as.data.frame(res)

res %>% 
  ggplot(aes(res)) +
  geom_histogram(alpha = 0.5)

plot(linModel)

####################################################################
G3.predictions <- predict(linModel, test)

results <- cbind(G3.predictions, test$G3)
colnames(results) <- c('predicted', 'actual')
results <- as.data.frame(results)

results %>% 
  ggplot(aes(x = predicted, y = actual)) +
  geom_point() +
  geom_smooth(method = 'lm')
####################################################################

to_zero <- function(x){
  if(x < 0){
    return(0)
  }else{
    return(x)
  }
}
####################################################################


results$predicted <- sapply(results$predicted, to_zero)

mse <- mean((results$actual - results$predicted)^2)
rmse <- mse^(1/2)

SSE <- sum((results$actual - results$predicted)^2)
SST <- sum((mean(df$G3) - results$actual)^2)
R2 <- 1 - (SSE/SST)
####################################################################
