library(dplyr)

load("data/corpus.rda")

if("X" %in% names(corpus)) {
  corpus <- select(corpus,-X)
}

if("lang" %in% names(corpus)) {
  corpus <- select(corpus,-lang)
}

corpus <- corpus %>%
  filter(
    query != "2-pac" & query != "3-pac"
  )

load("data/foreign_index.rda")

foreign_merge <- foreign_merge %>%
  select(tweet_id,lang,translation)

corpus <- merge(corpus,foreign_merge,all.x = TRUE)

load("data/user_info.rda")

places <- read.csv("data/places.csv")

user_info <- user_info %>%
  select(-X,-X.1)
places <- places %>%
  select(-X,-status,-quality,-confidence,-geocoder)

merged_user_info <- merge(user_info,places, by="location",all.x=TRUE) %>%
  rename(user_id = id) 

merged_user_info <- merged_user_info[!duplicated(merged_user_info$user_id),]

merged_corpus <- merge(corpus,merged_user_info,by="user_id",all.x=TRUE,all.Y=FALSE)

load("data/sentiment_index.rda")

index <- index %>%
  filter(!is.na(positive))

merged_corpus <- merge(merged_corpus,index,all.x=TRUE)

merged_corpus_europe <- merged_corpus %>%
  filter(approx_country %in% c("AT","ES","GB","IL","GR","DK","IT","RO","BE","NL","SE","IE","NO","CH","PT","FI","FR","DE",
                               "CR","LT","CZ","ET"))

merged_corpus_europe$stotal <- merged_corpus$positive - merged_corpus$negative

save(merged_corpus_europe,file="data/merged_corpus_europe.rda")


