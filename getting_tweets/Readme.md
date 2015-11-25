We have too many places to geocode all at once.

Google allows 2500 queries per day.

refresh_places.R takes out 2500 places at random that are not currently geocoded. Then it geocodes them. Then it puts them back in.

Each machine needs a define_keys.R file, defining the secret keys that we don't want the public to see (this should not be committed).

To get your 2500 a day, get a key [here](https://developers.google.com/maps/documentation/geocoding/intro) (you need a google account).

Insert/edit this line:

```
googleAPIKey <- 'YOURNEWLYGENERATEDAPIKEY'
```

The script takes a while to run, you can run it in the background without opening Rstudio like this

```
setsid Rscript getting_tweets/refresh_places.R
```

So each day you need to pull, run the script, commit, push.

If you are set up with ssh instead of https (so that github trusts your computer and you don't need to sign in every time)
the bash script geocode.sh should do all steps for you.

Open the terminal and navigate to the getting_tweets folder and enter

```
./geocode.sh
```
