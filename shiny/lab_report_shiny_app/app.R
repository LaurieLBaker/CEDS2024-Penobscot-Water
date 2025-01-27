# Read in all packages first
library(shiny) 
library(lubridate)
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
    selectInput("consts", label = "Select a Constituent", choices = unique(transp_all$Constituent)),
    checkboxGroupInput("runyear", label = "Select a Year", choices = NULL),
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
  const <- reactive({
    transp_all %>%
      filter(Constituent == input$consts)
  })
  
  observeEvent(const(), {
    runyear_choice <- unique(const()$RunYear)
    updateCheckboxGroupInput(session = session, "runyear", choices = sort(runyear_choice))
  })
  
  runyear <- reactive({
    filter(const(), RunYear %in% input$runyear)
  })
  
  observeEvent(runyear(), {
    runcode_choice <- unique(runyear()$RunCode)
    updateCheckboxGroupInput(session = session, "runcode", choices = runcode_choice)
  })
  
  runcode <- reactive({
    filter(runyear(), RunCode %in% input$runcode)
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
  
  output$const_tables <- renderUI ({
    const_data <- sitecode()
    
    table_by_const <- lapply(split(const_data, const_data$Constituent), function(const_df) {
      const <- unique(const_df$Constituent)
      
      constituents <- const_data %>% 
        mutate(HoldTimeMins = as.numeric(difftime(LabAnalysisDatetime, SampleDatetime, units = "mins"))) %>%
        mutate(HoldTimeMins = round(HoldTimeMins)) %>% 
        mutate(HoldTime = minutes(HoldTimeMins)) %>%
        mutate(HoldTimeViol = case_when(
          Constituents == "Cond" ~ HoldTimeMins - 40320,
          Constituents == "Turb" ~ HoldTimeMins - 1440,
          Constituents == "ColA" ~ HoldTimeMins - 2880,
          Constituents == "TSS" ~ HoldTimeMins - 10080,
          Constituents == "EcoliIQT" ~ HoldTimeMins - 360,
          Constituents == "BOD" ~ HoldTimeMins - 360,
          Constituents == "TotP" ~ HoldTimeMins - 40320,
          Constituents == "Alk" ~ HoldTimeMins - 20160,
          Constituents == "ColT" ~ HoldTimeMins - 2880,
          Constituents == "ColiformIQT" ~ HoldTimeMins - 360,
          TRUE ~ NA_real_
        )) %>%
        select(SiteCode, SampleDatetime, ResultValue, QCType, Constituents, ResultFlag_ID, IncubationLength, LabAnalysisDatetime, HoldTime, HoldTimeViol) %>%
        distinct() %>%
        rename(
          "QC Type" = "QCType",
          "Qualifier Flag" = "ResultFlag_ID",
          "Incubation Time" = "IncubationLength",
          "Analysis Time" = "LabAnalysisDatetime",
          "Hold Time" = "HoldTime",
          "Site Code" = "SiteCode",
          "Sample Date/Time" = "SampleDatetime",
          "Result" = "ResultValue"
        ) %>%
        gt() %>%
        opt_interactive(use_sorting = TRUE, use_filters = TRUE, use_page_size_select = TRUE, page_size_default = 10, page_size_values = c(5, 10, 25, 50, 100)) %>%
        tab_style(
          style = cell_fill(color = "#B3E0A6"),
          locations = cells_body(columns = c(HoldTimeViol), rows = HoldTimeViol < 0)
        ) %>%
        tab_style(
          style = cell_fill(color = "#F5725E"),
          locations = cells_body(columns = c(HoldTimeViol), rows = HoldTimeViol >= 0)
        ) %>%
        cols_align(align = "center") %>%
        tab_style(
          style = cell_borders(sides = c("all"), color = "black", weight = px(1), style = "solid"),
          locations = list(cells_body())
        )
    })
  })
  
}

# Runs the shiny app
shinyApp(ui = ui, server = server)