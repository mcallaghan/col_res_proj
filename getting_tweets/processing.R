read_tweets <- function(folder,name) {
  files <- list.files(folder)
  corpus <- data.frame()
  for (file in files) {
    df <- tryCatch(read.delim(paste0(folder,file),
                     quote=""),error=function(err) NULL)
    if(!is.null(df)) {
      query <- strsplit(file,"_")[[1]][1]
      period <- paste0(strsplit(file,"_")[[1]][2],"-",strsplit(file,"_")[[1]][3])
      df$query <- query
      df$period <- period
      corpus <- rbind(corpus,df)
    }
  }
  write.csv(corpus,file=name)
  return(corpus)
}


get_user_info <- function(df) {
  library(twitteR)
  source("getting_tweets/define_keys.R")
  setup_twitter_oauth(
    CONSUMER_KEY,
    CONSUMER_SECRET,
    ACCESS_TOKEN,
    ACCESS_TOKEN_SECRET
  )
  users <- unique(df$user_id)
  user_info <- data.frame()
  limit <- 15000
  section <- ceiling(length(users) / limit)
  for (i in c(1:section)) {
    print(i)
    s <- (i-1)*limit+1
    if (i < section) {
      e <- i*limit
    } else {
      e <- length(users)
    }
    u <- users[c(s:e)]
    lookup <- lookupUsers(u)
    u_info <- parse_u_info(lookup)
    user_info <- rbind(user_info,u_info)
  }
  return(user_info)
}

parse_u_info <- function(info) {
  u_info <- data.frame()
  for (u in info) {
    info <- data.frame(
      id = u$id, 
      name = u$name,
      created = u$created,
      description = u$description,
      followersCount = u$followersCount,
      location = u$location,
      screenName = u$screenName,
      latitude = NA,
      longtitude = NA
    )
    lt <- u$lastStatus
    if(length(lt$latitude)>0) {
      info$latitude = lt$latitude
      info$longtitude = lt$longitude 
    }
    u_info <- rbind(u_info,info)
  }
  return(u_info)
}

geocode <- function(a,service) {
  source("getting_tweets/define_keys.R")
  library(RCurl)
  library(XML)
  library(jsonlite)
  
  a <- gsub(" ","+",a)
  
  if (service=="texas") {
    #a <- gsub("+","",a)
    url <- paste0("https://geoservices.tamu.edu/Services/Geocode/WebService/GeocoderWebServiceHttpNonParsed_V04_01.aspx?",
                  "apiKey=",
                  texasAPIKey,
                  "&streetAddress=",
                  a,
                  "&version=4.01"
                  )
    print(url)
    txt = getURL(url)
    return(txt)
  }
  if (service=="mapQuest") {
    url <- paste0('http://www.mapquestapi.com/geocoding/v1/address?key=',
                  mapQuestAPIKey,
                  '&location=',
                  a
    )
    txt = getURL(url)
    place <- fromJSON(txt,simplifyDataFrame = FALSE)
    locations <- place$results[[1]]$locations
    if (length(locations) > 5) {
      info <- c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA)
    } else {
      country <- place$results[[1]]$locations[[1]]$adminArea1
      aa3 <- place$results[[1]]$locations[[1]]$adminArea3
      aa4 <- place$results[[1]]$locations[[1]]$adminArea4
      aa5 <- place$results[[1]]$locations[[1]]$adminArea5
      aa6 <- place$results[[1]]$locations[[1]]$adminArea6
      quality <- place$results[[1]]$locations[[1]]$geocodeQuality
      confidence <- place$results[[1]]$locations[[1]]$geocodeQualityCode
      lat <- place$results[[1]]$locations[[1]]$latLng$lat
      lng <- place$results[[1]]$locations[[1]]$latLng$lng
      status <- place$info$statuscode
      geocoder <- "mapQuest"
      info <- c(country,aa3,aa4,aa5,aa6,quality,confidence,lat,lng,status,geocoder)
    }
  }
  
  if (service=="google") {
    url <- paste0("https://maps.googleapis.com/maps/api/geocode/json?address=",a,"&key=",googleAPIKey)
    txt = getURL(url)
    place <- fromJSON(txt,simplifyDataFrame = FALSE)
    if (place$status[1]=="ZERO_RESULTS") {
      info <- c(NA,NA,NA,NA,NA,NA,NA,NA,NA,NA,"google")
    } else {
      results <- place$results
      l <- length(results[[1]]$address_components)
      if(results[[1]]$address_components[[l]]$types[1] != "country") l <- l - 1
      if(results[[1]]$address_components[[l]]$types[1] != "country") l <- l - 1
      if(results[[1]]$address_components[[l]]$types[1] != "country") l <- l - 1
      if(results[[1]]$address_components[[l]]$types[1] != "country") l <- l - 1
      if(results[[1]]$address_components[[l]]$types[1] != "country") l <- l - 1
      country <- results[[1]]$address_components[[l]]$short_name
      aa3 <- try(results[[1]]$address_components[[l-1]]$short_name)
      tryCatch(aa4 <- try(results[[1]]$address_components[[l-2]]$short_name),error=function(err) NA)
      tryCatch(aa5 <- try(results[[1]]$address_components[[l-3]]$short_name),error=function(err) NA)
      tryCatch(aa6 <- try(results[[1]]$address_components[[l-4]]$short_name),error=function(err) NA)
      quality <- NA
      confidence <- NA
      lat <- results[[1]]$geometry$location$lat
      lng <- results[[1]]$geometry$location$lng
      status <- NA
      geocoder <- "google"
      info <- c(country,aa3,aa4,aa5,aa6,quality,confidence,lat,lng,status,geocoder)
    }
  }
  return(info)
}

simple_geocode <- function(a,service){
  source("getting_tweets/define_keys.R")
  library(RCurl)
  library(XML)
  library(jsonlite)
  
  a <- gsub(" ","+",a)
  if (service=="mapQuest") {
    url <- paste0('http://www.mapquestapi.com/geocoding/v1/address?key=',
                  mapQuestAPIKey,
                  '&location=',
                  a
    )
    txt = getURL(url)
    place <- fromJSON(txt,simplifyDataFrame = FALSE)
  }
  
  if (service=="google") {
    url <- paste0("https://maps.googleapis.com/maps/api/geocode/json?address=",a,"&key=",googleAPIKey)
    txt = getURL(url)
    place <- fromJSON(txt,simplifyDataFrame = FALSE)
  }
  return(place)
}

#p <- simple_geocode("San Luis Obispo, Cali","google")

geocode_corpus <- function(df,n=NULL) {
     places <- unique(as.character(df$location))
     if(!is.null(n)) {
         places <- sample(places,n)
       }
     places <- data.frame(location=places)
     l <- length(places$location)
     
       for (i in 1:l) {
           place_info <- try(geocode(places[i,"location"],"mapQuest"))
           if(!is.na(place_info[1])) {
             if(place_info[1] == "US" & 
                place_info[2] == "" & 
                place_info[3] == "" & 
                place_info[4] == "" &
                place_info[5] == ""){
               place_info <- try(geocode(places[i,"location"],"google"))
             }
           }
           
           places[i,"approx_country"] <- place_info[1]
           places[i,"approx_aa3"] <- place_info[2]
           places[i,"approx_aa4"] <- place_info[3]
           places[i,"approx_aa5"] <- place_info[4]
           places[i,"approx_aa6"] <- place_info[5]
           places[i,"quality"] <- place_info[6]
           places[i,"confidence"] <- place_info[7]
           places[i,"approx_lat"] <- place_info[8]
           places[i,"approx_lng"] <- place_info[9]
           places[i,"status"] <- place_info[10]
           places[i,"geocoder"] <- place_info[11]
           
         }
     
       return(places)
   }
 

corpus <- read.csv("data/corpus2.csv")

user_info <- get_user_info(corpus)

write.csv(user_info,file="data/user_info2.csv")

#corpus <- read.csv("data/corpus.csv")

#user_info <- read.csv("data/user_info.csv")

#places <- geocode_corpus(user_info)

#write.csv(places,file="data/places.csv")






