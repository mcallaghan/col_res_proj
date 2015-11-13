#install.packages("tm.lexicon.GeneralInquirer", repos="http://datacube.wu.ac.at", type="source")
library(tm.lexicon.GeneralInquirer)
#install.packages("tm.plugin.sentiment", repos="http://R-Forge.R-project.org")
library(tm.plugin.sentiment) 
library(tm)
library(dplyr)
library(knitr)

corpus <- read.csv("data/corpus.csv") %>%
  filter(query != "2-pac" & query != "3-pac")
user_info <- read.csv("data/user_info.csv")
user_info <- rename(user_info,user_id = id)

places <- read.csv("data/places.csv") %>%
  filter(!is.na(geocoder) & !is.na(approx_country))

geo_user_info <- merge(places,user_info,by="location")

geo_corpus <- merge(geo_user_info,corpus,by="user_id")

sentimentalise <- function(df,q=NULL) {
  if(!is.null(q)) {
    df <- filter(df,query==q)
  }
  cp <- Corpus(VectorSource(tolower(df$text))) 
  pos <- sum(sapply(cp, tm_term_score, terms_in_General_Inquirer_categories("Positiv")))
  neg <- sum(sapply(cp, tm_term_score, terms_in_General_Inquirer_categories("Negativ")))
  pos.score <- tm_term_score(TermDocumentMatrix(cp, control = list(removePunctuation = TRUE)), 
                             terms_in_General_Inquirer_categories("Positiv")) # this lists each document with number below
  
  neg.score <- tm_term_score(TermDocumentMatrix(cp, control = list(removePunctuation = TRUE)), 
                             terms_in_General_Inquirer_categories("Negativ")) 
  
  total.df <- data.frame(id = df$tweet_id,
                         text = df$text,
                         positive = pos.score, 
                         negative = neg.score)
}

senti_geo_corpus <- sentimentalise(geo_corpus)

senti_geo_corpus <- merge(senti_geo_corpus,geo_corpus)

saveRDS(senti_geo_corpus,"data/senti_geo_corpus.Rda")

#kable(merkel_s)



