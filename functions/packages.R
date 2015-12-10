pkgs <- c('twitteR', 
          'tm.lexicon.GeneralInquirer', 
          'tm.plugin.sentiment', 
          'dplyr', 
          'ggplot2', 
          'stringr', 
          'wordcloud', 
          'tm', 
          'rworldmap', 
          'ggmap', 
          'textcat', 
          'translateR', 
          'tidyr', 
          'lfe', 
          'maptools', 
          'rgeos', 
          'nlme',
          'knitr')

wd <- getwd()

bibfile <- paste0(strsplit(wd,"col_res_proj")[[1]][1],"col_res_proj/bib/Rpackagecitations.bib")

repmis::LoadandCite(pkgs, file = bibfile)