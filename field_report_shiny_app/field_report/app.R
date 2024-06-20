library(shiny)
library(bslib)
library(readr)
library(here)
library(dplyr)
library(ggplot2)
library(stringr)
library(purrr)
library(htmltools)
library(knitr)
library(gt)
library(kableExtra)
library(tidyr)
library(tidyverse)
library(haven)
library(sf)
library(dbscan)
library(magrittr)
library(htmlwidgets)
library(janitor)
library(RColorBrewer)
library(kableExtra)
library(ggthemes)
library(sass)
library(DT)

data2018_primary <- data2018 %>%
  mutate(Collectors = str_sub(Collectors, start = 1, end = 3))

collectors <- unique(data2018_primary$Collectors)
dates <- unique(data2018_primary$RunDate)
runcodes <- unique(data2018_primary$RunCode)
sitecodes <- unique(data2018_primary$SiteCode)

ui <- page_sidebar(
  sidebar = sidebar(
    selectInput("collector", label = "Select a Collector", choices = collectors),
    selectInput("rundate", label = "Select a Date", choices = dates),
    selectInput("runcode", label = "Select a Run Code", choices = runcodes),
    selectInput("sitecode", label = "Select a Site Code", choices = sitecodes)
  ),
  dataTableOutput("table")
)

server <- function(input, output, server) {
  site <- reactive({
    filter(input$collector) %>% 
      filter(input$rundate) %>% 
      filter(input$runcode) %>% 
      filter(input$sitecode)
  })
  
  output$table <- renderDataTable({
    datatable(data = site, options = list(pageLength = 10))
  })
}


shinyApp(ui = ui, server = server)
