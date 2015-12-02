#install.packages("tm.lexicon.GeneralInquirer", repos="http://datacube.wu.ac.at", type="source")
library(tm.lexicon.GeneralInquirer)
#install.packages("tm.plugin.sentiment", repos="http://R-Forge.R-project.org")
#library(tm.plugin.sentiment) 
library(tm)
library(dplyr)
library(knitr)

initialise_index <- function(){
  load("data/merged_corpus.rda")
  merged_corpus <- merged_corpus %>%
    filter(query != "2-pac" & query != "3-pac" & query != "athens")
  index <- merged_corpus[!duplicated(merged_corpus$tweet_id),c("tweet_id","text")]
  index$positive <- NA
  index$negative <- NA
  save(index,file="data/sentiment_index.rda")
}
#initialise_index()


sentimentalise <- function() {

  load("data/sentiment_index.rda")  
  
  unknown <- index %>%
    filter(is.na(positive))
  
  print(paste(as.character(length(unknown$tweet_id)),"left"))
  
  index_sample <- unknown[sample(nrow(unknown),2500),]
  
  cp <- Corpus(VectorSource(tolower(index_sample$text))) 
  pos <- sum(sapply(cp, tm_term_score, terms_in_General_Inquirer_categories("Positiv")))
  neg <- sum(sapply(cp, tm_term_score, terms_in_General_Inquirer_categories("Negativ")))
  index_sample$positive <- tm_term_score(TermDocumentMatrix(cp, control = list(removePunctuation = TRUE)), 
                             terms_in_General_Inquirer_categories("Positiv")) # this lists each document with number below
  
  index_sample$negative <- tm_term_score(TermDocumentMatrix(cp, control = list(removePunctuation = TRUE)), 
                             terms_in_General_Inquirer_categories("Negativ")) 
  
  old_index <- index[!(index$tweet_id %in% index_sample$tweet_id),] 
  
  index <- rbind(old_index,index_sample)
  
  save(index,file="data/sentiment_index.rda")
  
  unknown <- index %>%
    filter(is.na(positive))
  
  if(length(unknown$tweet_id)> 500){
    sentimentalise()
  }

}

sentimentalise()

#save(sentimental_merged_corpus,file="data/sentimental_merged_corpus.Rda")

#kable(merkel_s)



