load("data/corpus.rda")

library(dplyr)

corpus$text <- gsub("(f|ht)(tp)(s?)(://)(.*)[.|/](.*)", "",corpus$text)

if("lang" %in% colnames(corpus)) {
  
} else {
  corpus$lang <- NA
}

save(corpus, file="data/corpus.rda")

