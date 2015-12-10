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
    query != "2-pac" & query != "3-pac" & query != "bailout" & query != "athens"
  )

load("data/foreign_index.rda")

foreign_merge <- foreign_merge %>%
  select(tweet_id,lang,translation)

corpus <- merge(corpus,foreign_merge,all.x = TRUE)

corpus$text <- ifelse(
  is.na(corpus$translation),
  corpus$text,
  corpus$translation
)

translated_corpus <- corpus

save(translated_corpus,file="data/translated_corpus.rda")

rm(translated_corpus)

load("data/user_info.rda")

#places <- read.csv("data/places.csv")
load("data/places.rda")

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
  filter(approx_country %in% c("AT","ES","GB","GR","DK","IT","RO","BE","NL","SE","IE","NO","CH","PT","FI","FR","DE",
                               "CR","LT","CZ","ET"))

merged_corpus_europe$stotal <- merged_corpus_europe$positive - merged_corpus_europe$negative

merged_corpus_europe$period <- factor(merged_corpus_europe$period,
                                  levels = c("2010-04-15-2010-05-15.txt", "2012-02-07-2012-03-31.txt", "2015-07-01-2015-08-25.txt"),
                                  labels = c("2010", "2012", "2015"))

merged_corpus_europe$day <- as.Date(substr(as.character(merged_corpus_europe$date),1,10))

save(merged_corpus_europe,file="data/merged_corpus_europe.rda")

by_country_by_year_by_query <- merged_corpus_europe %>%
  group_by(approx_country,period,query) %>%
  summarise(
    sentiment = mean(stotal,na.rm=TRUE),
    sentiment_variance = var(stotal,na.rm=TRUE),
    tweet_count = length(stotal)
  ) %>%
  mutate(query = gsub("\\+","_",query))

library(rjson)
ys <- split(by_country_by_year_by_query,by_country_by_year_by_query$period)
for (y in ys) {
  xs <- split(y,y$approx_country)
  for (x in xs) {
    z <- split(x,x$query)
  }
  x <- toJSON(unname(split(y,y$approx_country)))
  #cat(x)
  #print(unique(as.character(y$period))) 
}
x <- toJSON(unname(split(by_country_by_year_by_query, 1:nrow(by_country_by_year_by_query ))))
write(x, file="map/map_data.JSON")

merged_corpus_europe$day <- substr(as.character(merged_corpus_europe$date),1,10)

merged_corpus_daily <- merged_corpus_europe %>%
  group_by(day,period,approx_country,query) %>%
  summarise(
    sentiment = mean(stotal,na.rm=TRUE),
    sentiment_variance = var(stotal,na.rm=TRUE),
    tweet_count = length(stotal)
  )

merged_corpus_daily$date <- as.Date(merged_corpus_daily$day)

x <- toJSON(unname(split(merged_corpus_daily, 1:nrow(merged_corpus_daily ))))
write(x, file="time/time_data.JSON")


