---
title: "SuperCon"
author: "Amol Deshmukh"
date: "May 14, 2019"
output: html_document
---

This is an analysis on the critical temperature of various superconducting materials.
```{r}
library(Rtsne)
library(NbClust)
library(tidyverse)
library(plot3D)
```

```{r}
trainData <- read.csv('../train.csv')
uniqueData <- read.csv('../unique_m.csv')
```

```{r}
trainData %>% glimpse()
```

```{r}
trainData %>%
  ggplot(aes(critical_temp)) + 
  geom_histogram()

treeData <- trainData %>% mutate(temp = if_else(critical_temp < 10, 0, 1)) %>% select(-critical_temp)
```

```{r}
library(rpart)
library(rpart.plot)
tree.super <- rpart(temp~., data = treeData, method = 'class', cp=0.005)
rpart.plot(tree.super)
```


```{r}
trainData %>% 
  ggplot(aes(x = std_ElectronAffinity, y = range_fie)) +
  geom_point(aes(color = critical_temp), alpha = 0.1) +
  scale_color_continuous(name = "Critial \nTemperature", low = "green", high = "red") + 
  theme_dark()
```

```{r}
trainScaleData <- trainData %>% scale() %>% as.data.frame()
trainScaleData %>% glimpse()
```

```{r}
kmeansAll <- kmeans(trainScaleData %>% as.matrix(), centers = 2)
```

```{r}
data.frame(kmeansAll$cluster) %>% 
  group_by(kmeansAll.cluster) %>% 
  count()
```

```{r}
trainData$kmean.clust <- kmeansAll$cluster
trainData %>% 
  ggplot(aes(x = std_ElectronAffinity, y = range_fie)) +
  geom_point(aes(color = critical_temp), alpha = 0.9) +
  scale_color_continuous(name = "Critial \nTemperature", low = "blue", high = "red") + 
  theme_dark() +
  facet_grid(.~kmean.clust)
```

```{r}
trainData %>% 
  group_by(kmean.clust) %>% 
  summarise(median(critical_temp))
```

