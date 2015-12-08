places <- read.csv("data/places.csv")

source("getting_tweets/processing_functions.R")
source("getting_tweets/define_keys.R")

error_places <- places[grep("You have exceeded the number", as.character(places$approx_country)),]

r_error_places <- rplaces <- places[sample(nrow(places), 2500), ]

old_places <- places[!(places$X %in% r_error_places$X),] 

new_places <- geocode_corpus(r_error_places,NULL,"google")

places <- rbind(old_places,new_places)

write.csv(places,"data/places.csv", row.names=FALSE)

#new_places <- 

