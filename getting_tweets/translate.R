library(textcat)
library(dplyr)
library(translateR)
source("getting_tweets/define_keys.R")

load("data/lang_index.rda")

index$lang <- gsub("(^greek(.*))","greek",index$lang)

foreign <- index %>%
  filter(lang %in% c("french",
                      "german",
                      "spanish",
                      "greek",
                      "italian",
                      "swedish",
                      "norwegian",
                      "portuguese") &
           nchar(text) > 10
         )

lang_table <- data.frame(
  lang=c(
    "french",
    "german",
    "spanish",
    "greek",
    "italian",
    "swedish",
    "norwegian",
    "portuguese",
    "dutch"
    ),
  microsoft=c(
    "fr",
    "de",
    "es",
    "el",
    "it",
    "sv",
    "no",
    "pt",
    "nl"
  )
)

foreign <- foreign[order(foreign$lang),]

foreign_merge <- foreign %>%
  left_join(lang_table)

foreign_merge$translation <- NA

languages <- unique(foreign_merge$microsoft)

for(i in languages) {
  language <- filter(foreign_merge,microsoft==i)
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
  save(foreign_merge,"data/foreign_index.rda")
  print(i)
}


