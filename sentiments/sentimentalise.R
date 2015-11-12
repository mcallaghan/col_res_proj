#install.packages("tm.lexicon.GeneralInquirer", repos="http://datacube.wu.ac.at", type="source")
library(tm.lexicon.GeneralInquirer)
#install.packages("tm.plugin.sentiment", repos="http://R-Forge.R-project.org")
library(tm.plugin.sentiment) 
library(tm)
library(dplyr)

corpus <- read.csv("data/corpus.csv")

minicorpus <- corpus[sample(nrow(corpus), 200), ]

unique(corpus$query)

memo_greece <- filter(corpus,
                      query=="memorandum+greece")

sentimentalise <- function(df,q) {
  df <- filter(df,query==q)
  cp <- Corpus(VectorSource(df$text)) 
  pos <- sum(sapply(cp, tm_term_score, terms_in_General_Inquirer_categories("Positiv")))
  neg <- sum(sapply(cp, tm_term_score, terms_in_General_Inquirer_categories("Negativ")))
  pos.score <- tm_term_score(TermDocumentMatrix(cp, control = list(removePunctuation = TRUE)), 
                             terms_in_General_Inquirer_categories("Positiv")) # this lists each document with number below
  
  neg.score <- tm_term_score(TermDocumentMatrix(cp, control = list(removePunctuation = TRUE)), 
                             terms_in_General_Inquirer_categories("Negativ")) 
  
  total.df <- data.frame(text = df$text,
                         positive = pos.score, 
                         negative = neg.score)
}

mg_s <- sentimentalise(corpus,"memorandum+greece")








