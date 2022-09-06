# househunt

A ShinyR app for analyzing recently sold data from Redfin.com to find comparables of homes you maybe interested in purchasing.

# Technologies
* R, RStudio
* Libraries - Shiny, DT, data.table
* ShinyApps.io to host ShinyR app

# How To
## Use App
Once published, click on any row in the table. This will redirect you to the "Comparables" tab to find similar houses and you can get the average price among all the comparables found. 

## Run App
* Open househunt.Rproj in RStudio
* ui -> this is the tabs rendered on the page
* server -> this is the main filter logic used to update the UI

## Publish
Use your own [ShinyApps.io](https://www.shinyapps.io/) account to publish if you wish to access this app on your mobile device. My version of this is published in https://navinvarma.shinyapps.io/househunt/. 

## Update Data
* Go to [Redfin.com](https://www.redfin.com/) and search for your county of choice. This app uses Alameda County, CA for demonstration.
* See screenshot on how to download CSV to local repo

![Image from Redfin.com search results to download CSV file](/Redfin_CSV_HowTo.png)

Overwrite CSV Files are located at:
* [redfin_forsale.csv](/redfin_forsale.csv)
* [redfin_recentlysold.csv](/redfin_recentlysold.csv)

# Credits
This app uses sample data from [Redfin.com](https://www.redfin.com/) using the "Download All" to CSV from the search results. Real Estate software and licensing API is expensive, so this is a hacked together solution for local development and personal use.

# Additional Notes
This app was originally developed in 2018 around the time I was in the market to buy a home in the East Bay. It was a personal project that was lying around, and moved between PCs. In the interest of keeping this record somewhere in the cloud and for the benefit of other home buyers, I'm finally pushing this up to GitHub. Hoping you find your dream home at the right price using this app!
