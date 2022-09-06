# Load library
library(shiny)
library(data.table)
library(DT)

# read and row bind all data sets
listings <-
  rbindlist(lapply("redfin_forsale.csv", fread),
            use.names = TRUE)
recentlysold <-
  rbindlist(lapply("redfin_recentlysold.csv", fread),
            use.names = TRUE)

# UI client
ui <-
  fluidPage(titlePanel("House Hunt"),
            mainPanel(tabsetPanel(
              id = "mainPanel",
              tabPanel("Listings",
                       mainPanel(
                         "Click on any row",
                         fluidRow(DT::dataTableOutput("listings_table"))
                       )),
              tabPanel(
                "Comparables",
                mainPanel(
                  "Property Selected:",
                  htmlOutput("comparableList"),
                  DT::dataTableOutput("recentlysold_table")
                  
                ),
                sidebarPanel("Comparable Stats",
                             htmlOutput("statsList"))
              ),
              tabPanel(
                "About",
                "The data here is downloaded from Redfin.com as a CSV using search for 'Alameda County' in RedFin.com.
                The recently sold data is also downloaded from Redfin.com."
              )
              )))
# Server
server <- function(input, output, session) {
  output$listings_table = DT::renderDataTable(DT::datatable({
    listings
  }
  , options = list(pageLength = 50)   , selection = 'single'),
  server = TRUE)
  
  # await any user input and apply filters
  observeEvent(input$listings_table_rows_selected, {
    address <- listings[input$listings_table_rows_selected]$ADDRESS
    city <- listings[input$listings_table_rows_selected]$CITY
    zip <- listings[input$listings_table_rows_selected]$ZIP
    beds <- listings[input$listings_table_rows_selected]$BEDS
    baths <- listings[input$listings_table_rows_selected]$BATHS
    location <-
      listings[input$listings_table_rows_selected]$LOCATION
    hoa <- listings[input$listings_table_rows_selected]$`HOA/MONTH`
    sqft <-
      listings[input$listings_table_rows_selected]$`SQUARE FEET`
    yearbuilt <-
      listings[input$listings_table_rows_selected]$`YEAR BUILT`
    mlslisting <-
      listings[input$listings_table_rows_selected]$`MLS#`
    redfinurl <-
      listings[input$listings_table_rows_selected]$`URL (SEE http://www.redfin.com/buy-a-home/comparative-market-analysis FOR INFO ON PRICING)`
    listingprice <-
      listings[input$listings_table_rows_selected]$PRICE
    
    recentlysold <-
      recentlysold[toupper(recentlysold$CITY) == toupper(city) &
                     recentlysold$BEDS == beds &
                     recentlysold$BATHS >= baths &
                     recentlysold$`SQUARE FEET` >= (sqft - 300) &
                     recentlysold$`SQUARE FEET` <= (sqft + 300) &
                     recentlysold$`YEAR BUILT` >= (yearbuilt - 5) &
                     recentlysold$`YEAR BUILT` <= (yearbuilt + 5)]
    
    output$recentlysold_table = DT::renderDataTable(DT::datatable({
      recentlysold
    }
    , options = list(pageLength = 50)   , selection = 'single'),
    server = TRUE)
    
    # render output
    output$comparableList <- renderText({
      paste(
        "<br><b> <a target='_blank' href='",
        redfinurl,
        "'>Redfin URL</a> </b>",
        "<br>",
        "<b> <a target='_blank' href='https://www.realtor.com/realestateandhomes-search?mlslid=",
        mlslisting,
        "'>Realtor URL</a> </b>",
        "<br>",
        "<b>Listing Price:</b> ",
        listingprice,
        "<br>",
        "<b>Address:</b> ",
        address,
        ",",
        city,
        "CA ",
        zip,
        "<br>",
        "<b>Beds:</b> ",
        beds,
        "<br>",
        "<b>Baths:</b> ",
        baths,
        "<br>",
        "<b>Sqft:</b> ",
        sqft,
        "<br>",
        "<b>HOA / Month:</b> ",
        hoa,
        "<br>",
        "<b>Year Built:</b> ",
        yearbuilt,
        "<br>",
        "<b>Location:</b> ",
        location,
        "<br><br>"
      )
    })
    
    # recalcuate pricing
    avgListingPrice <-
      round(mean(recentlysold$PRICE, na.rm = TRUE), 2)
    avgDaysOnMarket <-
      round(mean(recentlysold$`DAYS ON MARKET`, na.rm = TRUE), 2)
    avgSqft <-
      round(mean(recentlysold$`SQUARE FEET`, na.rm = TRUE), 2)
    avgHOA <- round(mean(recentlysold$`HOA/MONTH`, na.rm = TRUE), 2)
    avgYearBuilt <-
      round(mean(recentlysold$`YEAR BUILT`, na.rm = TRUE), 0)
    earliestSold <- max(recentlysold$`SOLD DATE`)
    latestSold <- min(recentlysold$`SOLD DATE`)
    
    # display pricing
    output$statsList <- renderText({
      paste(
        "<br><b>Avg Sale Price:</b> ",
        avgListingPrice,
        "<br>",
        "<b>Avg Days on Market:</b> ",
        avgDaysOnMarket,
        "<br>",
        "<b>Avg. Sqft:</b> ",
        avgSqft,
        "<br>",
        "<b>Avg HOA / Month:</b> ",
        avgHOA,
        "<br>",
        "<b>Avg Year Built:</b> ",
        avgYearBuilt,
        "<br>",
        "<b>Earliest Sold:</b> ",
        earliestSold,
        "<br>",
        "<b>Latest Sold:</b> ",
        latestSold
      )
    })
    
    # update tabs
    updateTabsetPanel(session, "mainPanel", selected = "Comparables")
  })
}

# init app
shinyApp(ui, server)