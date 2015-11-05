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
  
}

