library(shiny)
library(dplyr)
library(leaflet)
library(ggplot2)
library(knitr)


#time.reaction<-read.csv("SeattleOffenses.rda")
#save(time.reaction, file="SeattleOffenses.rda")

load("SeattleOffenses.rda")

crimes <- c(levels(factor(SeattleOffenses$OffenseDescription)))
resolution <- c('1','5','12','24','48')
shinyUI(fluidPage(
  titlePanel("Time resolutions since the Offenses"),
  sidebarLayout(
    sidebarPanel(
      selectInput("Crime", label = "Offenses", choices = crimes),
      selectInput("Resolution", label = "More than (in hours)", choices = resolution),
      actionButton("scanbutton", label = "scan")
      
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Calendar", plotOutput("calendarplot")),
        tabPanel("District",plotOutput("histplot")),
        tabPanel("Map", leafletOutput("seattlemap", height=600))
        
      )
    )
  )
))
