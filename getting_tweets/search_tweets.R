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

coup <- searchTwitter("#ThisIsaCoup",n=1500)

coup_text <- sapply(coup, function(x) x$getText())
coup_text_corpus <- Corpus(VectorSource(coup_text))

#clean up
r_stats_text_corpus <- tm_map(r_stats_text_corpus,
                              content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')),
                              mc.cores=1
)
r_stats_text_corpus <- tm_map(r_stats_text_corpus, content_transformer(tolower), mc.cores=1)
r_stats_text_corpus <- tm_map(r_stats_text_corpus, removePunctuation, mc.cores=1)
r_stats_text_corpus <- tm_map(r_stats_text_corpus, function(x)removeWords(x,stopwords()), mc.cores=1)
wordcloud(r_stats_text_corpus)