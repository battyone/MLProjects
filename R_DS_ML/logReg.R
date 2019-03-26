library(dplyr)
library(ggplot2)
library(corrplot)
library(caTools)
####################################################################
titanicData <- read.csv('./logReg/titanic.csv')
titanicData <- as.data.frame(titanicData)


sampleData <- sample.split(titanicData$Survived, SplitRatio = 0.7)

train <- titanicData %>% filter(sampleData == T)
test <- titanicData %>% filter(sampleData == F)

train %>%
  ggplot(aes(Pclass)) +
  geom_bar(aes(fill = factor(Pclass)))

train %>% 
  ggplot(aes(Age)) +
  geom_histogram()

train %>% 
  ggplot(aes(SibSp)) +
  geom_bar()

train %>% 
  ggplot(aes(x = factor(Pclass), y = Age)) +
  geom_boxplot(aes(fill = factor(Pclass))) +
  theme_bw()

impute_age <- function(age, class){
  out <- age
  for (i in 1:length(age)){
    if (is.na(age[i])){
      if (class[i] == 1){
        out[i] <- 37
      } else if (class[i] == 2){
        out[i] <- 29
      } else{
        out[i] <- 24
      } 
    } else{
      out[i] <- age[i]
    }
  }
  return(out)
}

fixed.train.ages <- impute_age(train$Age, train$Pclass)
fixed.test.ages <- impute_age(test$Age, test$Pclass)

train$Age <- fixed.train.ages
test$Age <- fixed.test.ages
####################################################################

train <- train %>% select(-PassengerId, -Name, -Ticket, -Cabin)
train$Survived <- factor(train$Survived)
train$Pclass <- factor(train$Pclass)
train$Parch <- factor(train$Parch)
train$SibSp <- factor(train$SibSp)

test <- test %>% select(-PassengerId, -Name, -Ticket, -Cabin)
test$Survived <- factor(test$Survived)
test$Pclass <- factor(test$Pclass)
test$Parch <- factor(test$Parch)
test$SibSp <- factor(test$SibSp)

logModel <- glm(Survived ~ ., family = binomial(link = 'logit'), data = train)

summary(logModel)

fitted.prob <- predict(logModel, test, type = 'response')
fitted.results <- ifelse(fitted.prob > 0.5, 1, 0)

####################################################################
misClassError <- mean(fitted.results != test$Survived)
accuracy <- 1 - misClassError
table(test$Survived, fitted.prob > 0.5)

####################################################################
