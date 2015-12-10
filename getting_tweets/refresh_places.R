#places <- read.csv("data/places.csv")
load("data/places.rda")

source("getting_tweets/processing_functions.R")
source("getting_tweets/define_keys.R")

error_places <- places[grep("You have exceeded the number", as.character(places$approx_country)),]

error_places <- places[grep("Error", as.character(places$approx_country)),]

r_error_places <- error_places
r_error_places <- error_places[sample(nrow(error_places), 2500), ]


old_places <- places[!(places$location %in% r_error_places$location),] 

new_places <- geocode_corpus(r_error_places,NULL,"google")

places <- rbind(old_places,new_places)

#write.csv(places,"data/places.csv", row.names=FALSE)

save(places,file="data/places.rda")

#new_places <- 

