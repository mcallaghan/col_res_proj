library(textcat)
library(dplyr)

load("data/lang_index.rda")

foreign <- index %>%
  filter(lang != "english" & lang != "scots" & lang != "manx" & lang != "middle_frisian")

sum(nchar(foreign$text))
