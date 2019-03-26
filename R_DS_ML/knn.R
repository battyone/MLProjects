library(dplyr)
library(ISLR)
library(class)

#########################

Caravan %>% glimpse()
summary(Caravan$Purchase)
any(is.na(Caravan))

purchase <- Caravan[,86]

stand.Caravan <- scale(Caravan[, -86])
var(stand.Caravan[,1:4])

test.index <- 1:1000
test.data <- stand.Caravan[test.index, ]
test.purchase <- purchase[test.index]

train.data <- stand.Caravan[-test.index, ]
train.purchase <- purchase[-test.index]

#########################

set.seed(101)
predicted.purchase <- knn(train.data, test.data, train.purchase, k = 5)
misclass.error <- mean(test.purchase != predicted.purchase)

predicted.purchase <- NULL
error.rate <- NULL

for (i in 1:20){
  set.seed(101)
  predicted.purchase <- knn(train.data, test.data, train.purchase, k = i)
  error.rate[i] <- mean(test.purchase != predicted.purchase)
}

#########################

k.values <- 1:20
error.df <- data.frame(error.rate, k.values)

error.df %>% 
  ggplot(aes(x = k.values, y = error.rate)) +
  geom_point() +
  geom_line(lty = 'dotted')

#########################

