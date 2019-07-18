
library(tidyverse)
library(corrplot)

df <- read.csv('data.csv', sep = '\t')

numIncome <- function(x){
  kaka <- sub(',', '', x)
  sub('.','', kaka) %>% as.numeric()
}

numHomes <- function(x){
  sub(',','',x) %>% as.numeric()
}

numPer <- function(x){
  sub('%','',x) %>% as.numeric()
}  

df$Income <-  numIncome(df$Income)
df$Num_Homes <- numHomes(df$Num_Homes)
df$Black <- numPer(df$Black)
df$Asian <- numPer(df$Asian)
df$Hisp <- numPer(df$Hisp)
df$White <- numPer(df$White)

df.numeric <- df[,unlist(lapply(df, is.numeric))]

corr <- round(cor(df.numeric), 2)
corrplot(corr)

df %>%
  ggplot(aes(White, Asian)) + 
  geom_point()

df %>% 
  group_by(MSA) %>% 
  count() %>% 
  arrange(desc(n))

df %>% 
  ggplot(aes(Income)) + 
  geom_histogram(binwidth = 3*10**4)

library('GGally')
ggpairs(df.numeric, aes(alpha = 0.1))
