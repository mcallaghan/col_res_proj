library(textcat)
library(dplyr)
library(translateR)
source("getting_tweets/define_keys.R")

load("data/lang_index.rda")

index$lang_2 <- gsub("(^greek(.*))","greek",index$lang)

foreign <- index %>%
  filter(lang != "english" & lang != "scots" & lang != "manx" & lang != "middle_frisian" & nchar(text) > 10)

foreign_2 <- index %>%
  filter(lang_2 %in% c("french",
                      "german",
                      "spanish",
                      "greek-iso8859-7",
                      "italian",
                      "danish",
                      "swedish",
                      "norwegian",
                      "romanian",
                      "portuguese"))

sum(nchar(foreign$text))

sum(nchar(foreign_2$text))

test <- c("mein hund ist gross","Ich habe zwei Brüder")

lang_table <- data.frame(
  source=c(
    "french",
    "german",
    "spanish",
    "greek-iso8859-7",
    "italian",
    "danish",
    "swedish",
    "norwegian",
    "romanian",
    "portuguese",
    "dutch"
    ),
  microsoft=c(
    "fr",
    "de",
    "es",
    "el",
    "it",
    "da",
    "sv",
    "no",
    "ro",
    "pt",
    "nl"
  )
)

bla <- translate(
  content.vec=test,
  microsoft.client.id=MicrosoftClientId,
  microsoft.client.secret=MicrosoftSecret,
  source.lang="de",
  target.lang="en"
  )


