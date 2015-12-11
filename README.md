# Twitter and the European Hyperagora: What can the Twittersphere Tell us about Political Deliberation and Opinions in Europe?

This repository contains work by V Niberg and M Callaghan.

A research proposal is written with  the file res_prop.Rmd, and output into [html](https://cdn.rawgit.com/mcallaghan/col_res_proj/e043bb1/res_prop.html) and [pdf](https://github.com/mcallaghan/col_res_proj/blob/master/res_prop.pdf) formats.

Some preliminary results are shown in file Assignment3.pdf

A presentation of our results is available [here](http://mcallaghan.github.io/col_res_proj/final_project/final_presentation/fin_pres.html).

Our final paper is available [here](https://github.com/mcallaghan/col_res_proj/blob/master/final_project/final_paper/fin_paper.pdf)

A website allowing an interactive exploration of our dataset is available [here](http://mcallaghan.github.io/col_res_proj/)

This repository contains a submodule (GetOldTweets), which has been adapted to scrape Tweets from Twitter's internet site and save results as text files. The program is written in Java; a bash script in the module (compile_run.sh) compiles and runs the java program, taking a txt file as an argument. Each line in the text file is supplied as a search term in three periods. The data is saved to the data/GOToutput folder

The getting tweets folder contains code and instructions used to assemble a corpus of tweets and get further information about them.

The sentimentalise.R file in the sentiments folder conducts sentiment analysis.
