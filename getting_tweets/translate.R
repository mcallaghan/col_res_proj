load("data/corpus.rda")

library(textcat)
library(dplyr)

unknown <- corpus %>%
  filter(is.na(lang))

print(paste(as.character(length(unknown$X)),"left"))

corpus$lang <- textcat(as.character(corpus$text))

corpus$tlength <- nchar(corpus$text)

sum(corpus$tlength)

foreign <- corpus %>%
  filter(lang != "english" & lang != "scots")

sum(foreign$tlength)