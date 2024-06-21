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

ui <- page_sidebar(
  sidebar = sidebar(
    selectInput("collector", label = "Select a Collector", choices = data2018_primary$Collectors),
    selectInput("rundate", label = "Select a Date", NULL),
    selectInput("runcode", label = "Select a Run", NULL),
    selectInput("sitecode", label = "Select a Site", NULL)
    # selectInput("rundate", label = "Select a Date", choices = sort(unique(data2018_primary$RunDate))),
    # selectInput("runcode", label = "Select a Run Code", choices = data2018_primary$RunCode),
    # selectInput("sitecode", label = "Select a Site Code", choices = data2018_primary$SiteCode)
  ),
  dataTableOutput("table")
)

server <- function(input, output, session) {
  collectors <- reactive({
    data2018_primary %>%
      filter(Collectors == input$collector)
  })
  observeEvent(collectors(), {
    rundate_choice <- unique(collectors()$RunDate)
    updateSelectInput(session = session, "rundate", choices = rundate_choice)
  })
  rundate <- reactive({
    filter(collectors(), RunDate == input$rundate)
  })
  observeEvent(rundate(), {
    runcode_choice <- unique(rundate()$RunCode)
    updateSelectInput(session = session, "runcode", choices = runcode_choice)
  })
  runcode <- reactive({
    filter(rundate(), RunCode == input$runcode)
  })
  observeEvent(runcode(), {
    sitecode_choice <- unique(runcode()$SiteCode)
    updateSelectInput(session = session, "sitecode", choices = sitecode_choice)
  })
  
  output$table <- renderDataTable({
    datatable(data = runcode(), options = list(pageLength = 10))
  })
}


shinyApp(ui = ui, server = server)
