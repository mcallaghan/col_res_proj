# Twitter and the European Hyperagora: What can the Twittersphere Tell us about Political Deliberation and Opinions in Europe?

This repository contains work by V Nieberg and M Callaghan.

A research proposal is written with  the file res_prop.Rmd, and output into [html](https://cdn.rawgit.com/mcallaghan/col_res_proj/e043bb1/res_prop.html) and [pdf](https://github.com/mcallaghan/col_res_proj/blob/master/res_prop.pdf) formats.

Some preliminary results are shown in file Assignment3.pdf

A presentation of our results is available [here](http://mcallaghan.github.io/col_res_proj/final_project/final_presentation/fin_pres.html).

This repository contains a submodule (GetOldTweets), which has been adapted to scrape Tweets from Twitter's internet site and save results as text files. The program is written in Java; a bash script in the module (compile_run.sh) compiles and runs the java program, taking a txt file as an argument. Each line in the text file is supplied as a search term in three periods. The data is saved to the data/GOToutput folder

The processing.R file contains functions to compile txt documents into a single corpus, saved as a rda object, as well as to gather information from the Twitter API and to geocode user-given location using mapQuest and google. These were called from a server, as processing times were often several hours long. Processed datasets are saved in the data folder

Due to rate limits, geolocation was only collected for around 15000 out of 50000 locations.

The sentimentalise.R file in the sentiments folder creates a dataframe that merges tweets with user information with geocoded places. This file was used for sentiment analysis.

Results are presented in the assignment3.pdf document.
