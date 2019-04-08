---
title: "K-means Clustering after PCA for wine dataset"
author: "Amol Deshmukh"
date: "April 7, 2019"
output: html_document
---

```{r}
library(dplyr)
library(ggplot2)
```

```{r}
wine_kaka %>% 
  ggplot(aes(fixed.acidity, alcohol)) +
  geom_point()

wine_kaka %>% summary()
```

```{r}
wine_kaka %>% 
  ggplot(aes(citric.acid)) +
  geom_histogram()
#  geom_histogram(aes(fill = color, color = good), alpha = 0.5)

data.frame(wine_kaka_scale) %>% 
  ggplot(aes(citric.acid)) + 
  geom_histogram() + 
  xlim(-3.5, 3.5)
```

```{r}
wine_kaka_scale <- scale(wine_kaka %>% select(-color, -good))
```

```{r}
wine_kaka_scale %>% summary()
```

```{r}
sd(data.frame(wine_kaka_scale)$density)
```

```{r}
winePCA <- princomp(wine_kaka_scale)
summary(winePCA)
attributes(winePCA)
```

```{r}
winePCA$loadings

data.frame(winePCA$scores) %>% 
  ggplot(aes(Comp.1, Comp.2)) + 
  geom_point(aes(color = ))

wineComb <- cbind(wine_kaka_scale, winePCA$scores)

data.frame(wineComb) %>% glimpse()

data.frame(wineComb) %>%
  ggplot(aes(Comp.1, Comp.2)) +
  geom_point(aes(color = white), alpha = 0.5)
```

```{r}
data.frame(wineComb) %>% 
  ggplot(aes(volatile.acidity, total.sulfur.dioxide)) + 
  geom_point(aes(color = white), alpha = 0.5) 
```

```{r}
plot(winePCA)
```

```{r}
data.frame(wine_kaka_scale) %>% glimpse()
revWinePCA <- princomp(data.frame(wine_kaka_scale) %>% select(-white))

kmeanWine <- kmeans(revWinePCA$scores[,1:4], 2)

revPCA <- data.frame(revWinePCA$scores)

revPCA$cluster <- kmeanWine$cluster

revPCA %>% glimpse()

revPCA %>%
  ggplot(aes(Comp.1, Comp.2)) +
  geom_point(aes(color = cluster), alpha = 0.5)
```
