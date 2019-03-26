library(dplyr)

details <- function(dataframe){
  for (col_name in names(dataframe)){
  df <- count(dataframe, get(col_name)) %>% arrange(desc(n))
  colnames(df) <- c(col_name, "Frequency")
  print(df)
  }
}
