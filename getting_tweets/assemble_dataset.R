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

save(merged_corpus,file="data/merged_corpus.rda")


