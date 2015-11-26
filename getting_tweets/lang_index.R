library(textcat)
library(dplyr)

initialise_index <- function(){
  load("data/corpus.rda")
  index <- corpus[!duplicated(corpus$tweet_id),c("tweet_id","text","lang")]
  save(index,file="data/lang_index.rda")
}
#initialise_index()

get_language <- function() {
  
  load("data/lang_index.rda")
  
  unknown <- index %>%
    filter(is.na(lang))
  
  print(paste(as.character(length(unknown$tweet_id)),"left"))
  
  index_sample <- unknown[sample(nrow(unknown),2500),]
  
  index_sample$lang <- textcat(as.character(index_sample$text))
  
  old_index <- index[!(index$tweet_id %in% index_sample$tweet_id),] 
  
  index <- rbind(old_index,index_sample)
  
  unknown <- index %>%
    filter(is.na(lang))
  
  save(index,file="data/lang_index.rda")
  
  if(length(unknown$tweet_id)> 200000){
    get_language()
  }
  
  #return (index)
}

get_language()



