library(NbClust)

NbClust(iris %>% select(-Species), method = "ward.D2")

indices <- c("kl", "ch", "hartigan", "ccc", "scott", "marriot", "trcovw", 
             "tracew", "friedman", "rubin", "cindex", "db", "silhouette", 
             "duda", "pseudot2", "beale", "ratkowsky", "ball", "ptbiserial", 
             "gap", "frey", "mcclain", "gamma", "gplus", "tau", "dunn", "hubert", 
             "sdindex", "dindex", "sdbw", "all", "alllong")

for (i in 1:30) {
  m <- c(m, NbClust(iris %>% 
                      select(-Species), method = "ward.D2", index = indices[i])$Best.nc %>% 
            as.data.frame() %>% 
            slice(1:1) %>% 
            as.integer())
}

ggplot() +
  aes(m) +
  geom_histogram()
  
m <- c()

for (i in 1:10) {
  m <- c(m, NbClust(diamonds %>% 
                      sample_n(5000) %>% 
                      select(-cut, -color, -clarity), method = "ward.D2", index = indices[i])$Best.nc %>% 
           as.data.frame() %>% 
           slice(1:1) %>% 
           as.integer())
}

ggplot() +
  aes(m) +
  geom_histogram()
