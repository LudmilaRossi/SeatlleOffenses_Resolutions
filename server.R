library(shiny)
library(dplyr)
library(wordcloud)
library(leaflet)
library(tm)
library(leaflet.extras)
library(scales)
library(tidyr)

load("SeattleOffenses.rda")

#CALENDAR

shinyServer(function(input, output){
  output$calendarplot <- renderPlot({
    
    crime_label <- eventReactive(input$scanbutton, {
      input$Crime
      
    })
    resolution_label <- eventReactive(input$scanbutton, {
      input$Resolution
      
    })
    
    crime = crime_label()
    resolution = resolution_label()
    
    
    dfs <- subset(SeattleOffenses, OffenseDescription == crime & SeattleOffenses$timereaction > as.numeric(resolution))
    
    
    require(RColorBrewer)
    source("http://blog.revolutionanalytics.com/downloads/calendarHeat.R")
    
    green_color_ramp = brewer.pal(9, "Greens")
    calendarHeat(dfs$ReportDate, dfs$timereaction, varname= "Crimes per District", color="r2b")
    
    
  })
  

#DISTRICT--------------------------------------------
 
  output$histplot <- renderPlot({
    
    crime_label <- eventReactive(input$scanbutton, {
      input$Crime
      
    })
    resolution_label <- eventReactive(input$scanbutton, {
      input$Resolution
      
    })
    
    crime = crime_label()
    resolution = resolution_label()
    
    Seattle.crimes <- subset(SeattleOffenses, OffenseDescription == crime & timereaction>=resolution)
    Seattle.crimes %>% 
      ggplot(aes(x=District)) + labs(x="Offenses per District", y="Sum") +
      geom_histogram(stat="count",fill="purple")   
    
    
  })
  
#MAP--------------------------------------------------------------------  
  
  output$seattlemap <- renderLeaflet({
    
    crime_label <- eventReactive(input$scanbutton, {
      input$Crime
    })
    resolution_label <- eventReactive(input$scanbutton, {
      input$Resolution
      
    })
    
    crime = crime_label()
    resolution = resolution_label()
    
    Seattle.crimes <- subset(SeattleOffenses, OffenseDescription == crime & timereaction>=resolution)
    points <- cbind(Seattle.crimes$Longitude,Seattle.crimes$Latitude) 
    

    leaflet() %>% 
      addProviderTiles('OpenStreetMap.Mapnik',
                       options = providerTileOptions(noWrap = TRUE)) %>%
      addMarkers(data = points,
                 popup = paste0("<strong>Offenses: </strong>",
                                Seattle.crimes$OffenseType,                 
                                "<br><strong>Address: </strong>", 
                                Seattle.crimes$Block, 
                                "<br><strong>Report date: </strong>", 
                                Seattle.crimes$ReportDate, 
                                "<br><strong>District: </strong>", 
                                Seattle.crimes$District,
                                "<br><strong>Reaction (in hours): </strong>",
                                Seattle.crimes$timereaction),
                 clusterOptions = markerClusterOptions())
  })
})