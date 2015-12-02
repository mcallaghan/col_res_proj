library(textcat)
library(dplyr)
library(translateR)
source("getting_tweets/define_keys.R")

load("data/foreign_index.rda")

languages <- unique(foreign_merge$microsoft)

for(i in languages) {
  language <- filter(foreign_merge,microsoft==i & grepl("TranslateApiExceptionMethod",translation))
  print(length(language$lang))
  language$translation <- translate(
    content.vec = gsub("[[:punct:]]","",language$text),
    microsoft.client.id=MicrosoftClientId,
    microsoft.client.secret=MicrosoftSecret,
    source.lang=i,
    target.lang="en"
  )
  old_foreign <- foreign_merge[!(foreign_merge$tweet_id %in% language$tweet_id),] 
  foreign_merge <- rbind(old_foreign,language)
  save(foreign_merge,file="data/foreign_index.rda")
  print(i)
}


