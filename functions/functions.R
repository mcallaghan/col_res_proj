#the following is a code copied from someone else which puts plots into grids
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

timegraph <- function(corpus,p) {
  corpus_daily <- corpus %>%
    filter(period==p) %>%
    group_by(day,query,period) %>%
    summarise(
      n = length(day)
    )
  
  ggplot(filter(corpus_daily), aes(day,n,colour=query)) + geom_line() +
    labs(
      x = "Time",
      y = "Frequency"
    )
}

sentiment_map <- function(df,p,q=NULL,v="sentiment") {
  if(!is.null(q)) {
    data <- by_country_by_year_by_query %>%
      filter(query==q)
  } else {
    data <- total_summary
  }
  df <- df %>%
    left_join(
      rename(
        data,
        CNTR_ID = approx_country
      )
    )
  if(v=="sentiment"){
    cscale <- scale_fill_gradientn(colours=c("#f46d43","#ffffbf", "#74add1"),limits=c(-2,2),na.value="grey")
    label <- "Sentiment"
  } else {
    cscale <- scale_fill_gradientn(colours=c("#ffffbf","#74add1"),limits=c(0,4),na.value="grey")
    label <- "Sentiment \nVariance"
  }
  
  ggplot(filter(df,period==p)) +
    aes_string("long","lat",group="group",fill=v) +
    cscale +
    geom_polygon() +
    geom_path(color="grey",size=0.1) +
    #theme_bw() +
    #theme_nothing() +
    theme(
      panel.background = element_rect(fill="white"),
      axis.text = element_blank(),
      line = element_blank(),
      axis.text = element_blank()
    ) +
    xlim(c(-12,35)) +
    ylim(c(32,72)) +
    labs(fill=label,x="",y="") + 
    coord_equal()
}

prepare_sentiment_map_data <- function() {
  
  countries <- readShapeSpatial("../../data/geographic_data/CNTR_2014_60M_SH/Data/CNTR_RG_60M_2014.shp")
  
  countries.points <- fortify(countries)
  countries.points <- left_join(
    countries.points,
    data.frame(
      id = unique(countries.points$id),
      CNTR_ID = unique(countries@data$CNTR_ID)
    )
  )
  countries.df <- countries.points %>%
    left_join(countries@data,by="CNTR_ID")
  
  countries.df$CNTR_ID <- as.character(countries.df$CNTR_ID)
  
  countries.df[countries.df$CNTR_ID=="UK","CNTR_ID"] <- "GB"
  countries.df[countries.df$CNTR_ID=="EL","CNTR_ID"] <- "GR"
  return(countries.df)
}

sentiment_time <- function(df,p,q=NULL,clist=NULL) {
  df <- filter(df,period==p)
  if(!is.null(q)) {
    df <- filter(df,query==q)
  }
  if(!is.null(clist)){
    df <- filter(df,approx_country %in% clist)
  }
  ggplot(df) + 
    geom_line(aes(day,sentiment,colour=approx_country)) +
    geom_ribbon(aes(
      day,
      ymin=sentiment-(sqrt(sentiment_variance)/2),
      ymax=sentiment+(sqrt(sentiment_variance)/2),
      fill=approx_country),alpha=0.2) +
    labs(
      x = "Time",
      y = "Sentiment",
      legend = "Country",
      colour = "Country",
      fill = "Country"
    )
}