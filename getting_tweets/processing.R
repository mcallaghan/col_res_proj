read_tweets <- function() {
  files <- list.files("data/GOToutput")
  corpus <- data.frame()
  for (file in files) {
    df <- read.delim(paste0("data/GOToutput/",file),
                     quote="")
    query <- strsplit(file,"_")[[1]][1]
    period <- paste0(strsplit(file,"_")[[1]][2],"-",strsplit(file,"_")[[1]][3])
    df$query <- query
    df$period <- period
    corpus <- rbind(corpus,df)
  }
  write.csv(corpus,file="data/corpus.csv")
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

  rm(list="ACCESS_TOKEN","ACCESS_TOKEN_SECRET","CONSUMER_KEY","CONSUMER_SECRET")
  return(u_info)
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

minicorpus <- corpus[sample(nrow(corpus),200),]

user_info <- get_user_info(corpus)

write.csv(user_info,file="data/user_info.csv")

