# Read in all packages first
library(shiny) 
library(bslib)
library(tidyverse)
library(here)
library(htmltools)
library(knitr)
library(gt)
library(gtExtras)
library(htmlwidgets)
library(janitor)
library(rmarkdown)
library(quarto)
library(glue)
library(styler)
library(lintr)
library(quarto)
library(shinyalert)
library(shinyBS)

# User Interface for App
ui <- page_sidebar(
  sidebar = sidebar(
    # Creates the selection buttons on the side
    imageOutput("hex", width = "auto", height = "auto"),
    selectInput("collector", label = "Select a Collector", choices = unique(data2018_primary$Collectors)),
    checkboxGroupInput("rundate", label = "Select a Date", choices = NULL),
    checkboxGroupInput("runcode", label = "Select a Run", choices = NULL),
    checkboxGroupInput("sitecode", label = "Select a Site", choices = NULL)
  ),
  card(min_height = "220px", layout_columns(
    markdown("# PNWRD Field Data Review"),
    # Logos for Penobscot Indian Nation, Penobscot Nation Water Resources Department, and College of the Atlantic
    imageOutput("pin", width = "150", height = "150"),
    imageOutput("pnwrd", width = "150", height = "150"),
    imageOutput("coa", width = "150", height = "150")),
    max_height = "225px"),
  card(min_height = "115px", max_height = "116px", bsAlert("qc")),
  nav_panel(title = "Constituents", uiOutput("const_tables"))
)

# Server for App
server <- function(input, output, session) {
  output$hex <- renderImage({
    list(src = "~/Desktop/GitHub/Penobscot_Water/shiny/logos/hex.png",
         width = 200, 
         height = 225)
  },
  deleteFile = FALSE)
  
  output$pin <- renderImage({
    list(src = "~/Desktop/GitHub/Penobscot_Water/shiny/logos/pin_logo.png",
         width = 200, 
         height = 200)
  },
  deleteFile = FALSE)
  
  output$pnwrd <- renderImage({
    list(src = "~/Desktop/GitHub/Penobscot_Water/shiny/logos/pnwrd_logo.png",
         width = 200, 
         height = 200)
  },
  deleteFile = FALSE)
  
  output$coa <- renderImage({
    list(src = "~/Desktop/GitHub/Penobscot_Water/shiny/logos/coa_logo.png",
         width = 200, 
         height = 200)
  },
  deleteFil = FALSE)
  
  # Reactive loop allows run date, run code, and site code to be narrowed down
  collectors <- reactive({
    data2018_primary %>%
      filter(Collectors == input$collector)
  })
  
  observeEvent(collectors(), {
    rundate_choice <- unique(collectors()$RunDate)
    updateCheckboxGroupInput(session = session, "rundate", choices = sort(rundate_choice))
  })
  
  rundate <- reactive({
    filter(collectors(), RunDate %in% input$rundate)
  })
  
  observeEvent(rundate(), {
    runcode_choice <- unique(rundate()$RunCode)
    updateCheckboxGroupInput(session = session, "runcode", choices = runcode_choice)
  })
  
  runcode <- reactive({
    filter(rundate(), RunCode %in% input$runcode)
  })
  
  observeEvent(runcode(), {
    sitecode_choice <- unique(runcode()$SiteCode)
    updateCheckboxGroupInput(session = session, "sitecode", choices = sitecode_choice)
  })
  
  sitecode <- reactive({
    filter(runcode(), SiteCode %in% input$sitecode)
  })
  
  observe({
    
  })
  
  output$const_tables <- renderUI({
    
  })
  
}

# Runs the shiny app
shinyApp(ui = ui, server = server)