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

server <- function(input, output, session) {
  collector <- reactive({
    data2018_primary %>%
      filter(Collectors == input$collector)
  })
  bindEvent(collectors(), {
    rundate_choice <- unique(collectors()$RunDate)
    updateSelectInput(session = session, "Run Date", choices = choices)
  })
  rundate <- reactive({
    filter(collector(), RunDate == input$rundate)
  })
  bindEvent(rundate(), {
    runcode_choice <- unique(rundate()$RunCode)
    updateSelectInput(session = session, "Run ", choices = choices)
  })
  
  output$table <- renderDataTable({
    datatable(data = rundate, options = list(pageLength = 10))
  })
}


shinyApp(ui = ui, server = server)
