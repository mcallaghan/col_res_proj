#!/bin/bash
git pull
setsid Rscript getting_tweets/refresh_places.R
git add -A
git commit -m "geocoded daily limit of 2500 places"
git push
