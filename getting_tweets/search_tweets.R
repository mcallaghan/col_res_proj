library(twitteR)
library(wordcloud)
library(tm)

source("getting_tweets/define_keys.R")


setup_twitter_oauth(
  CONSUMER_KEY,
  CONSUMER_SECRET,
  ACCESS_TOKEN,
  ACCESS_TOKEN_SECRET
)

coup <- searchTwitter("beer",since='2011-01-01',until='2015-08-30')
coup_text <- sapply(coup, function(x) x$getText())
coup_text_corpus <- Corpus(VectorSource(coup_text))

#clean up
coup_text_corpus <- tm_map(coup_text_corpus,
                              content_transformer(function(x) iconv(x, to='UTF-8', sub='byte')),
                              mc.cores=1
)
coup_text_corpus <- tm_map(coup_text_corpus, content_transformer(tolower), mc.cores=1)
coup_text_corpus <- tm_map(coup_text_corpus, removePunctuation, mc.cores=1)
coup_text_corpus <- tm_map(coup_text_corpus, function(x)removeWords(x,stopwords()), mc.cores=1)
wordcloud(coup_text_corpus)