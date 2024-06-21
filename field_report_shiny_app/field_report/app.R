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

data2018_primary$SampleDatetime <- as.POSIXct(data2018_primary$SampleDatetime, format = "%m/%d/%Y %H:%M:%S")

data2018_primary$Date <- as.Date(data2018_primary$SampleDatetime)
data2018_primary$Time <- format(data2018_primary$SampleDatetime, format = "%H:%M:%S")

ui <- page_sidebar(
  sidebar = sidebar(
    selectInput("collector", label = "Select a Collector", choices = data2018_primary$Collectors),
    selectInput("rundate", label = "Select a Date", NULL),
    selectInput("runcode", label = "Select a Run", NULL),
    selectInput("sitecode", label = "Select a Site", NULL)
  ),
  navset_tab(
    nav_panel(title = "Site Info", gt_output("si_table"), gt_output("af_table"), gt_output("note_table")),
    nav_panel(title = "Samples", gt_output("sample_table"), gt_output("filter_table")),
    nav_panel(title = "Measurements", gt_output("msmt_table"), gt_output("ph_table"))
  )
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
    filter(collectors(), RunDate %in% input$rundate)
  })
  observeEvent(rundate(), {
    runcode_choice <- unique(rundate()$RunCode)
    updateSelectInput(session = session, "runcode", choices = runcode_choice)
  })
  runcode <- reactive({
    filter(rundate(), RunCode %in% input$runcode)
  })
  observeEvent(runcode(), {
    sitecode_choice <- unique(runcode()$SiteCode)
    updateSelectInput(session = session, "sitecode", choices = sitecode_choice)
  })
  sitecode <- reactive({
    filter(runcode(), SiteCode %in% input$sitecode)
  })
  
  output$si_table <- render_gt({
    sitecode() %>% 
      select(RunCode, WaterBody, SiteCode, SiteVisitStartTime, SiteDepth) %>%
      rename("Water Body" = "WaterBody",
             "Site" = "SiteCode",
             "Run Code" = "RunCode",
             "Time" = "SiteVisitStartTime",
             "Depth" = "SiteDepth") %>%
      distinct() %>% 
      gt() %>%
      cols_align(align = "center") %>% 
      tab_header(title = "Site information") %>%
      tab_style(
        style = cell_borders(
          sides = c("all"),
          color = "black",
          weight = px(1),
          style = "solid"),
        locations = list(cells_body(), cells_column_labels()))
  })
  
  output$af_table <- render_gt({
    sitecode() %>% 
      select(Weather, SamplingAirTemp, RivCond, WaterLevel, FoamRank, FoamSource) %>% 
      rename("Air Temp" = "SamplingAirTemp",
             "River Cond" = "RivCond", 
             "Water Level" = "WaterLevel",
             "Foam Rank" = "FoamRank",
             "Foam Source" = "FoamSource") %>%
      distinct() %>% 
      gt() %>%
      cols_align(align = "center") %>%
      tab_header(title = "Abiotic Factors") %>%
      tab_style(
        style = cell_borders(
          sides = c("all"),
          color = "black",
          weight = px(1),
          style = "solid"),
        locations = list(cells_body(), cells_column_labels()))
  })
  
  output$note_table <- render_gt({
    sitecode() %>% 
      select(SiteVisitComment) %>% 
      rename("Site Visit Notes" = "SiteVisitComment") %>%
      distinct() %>% 
      gt() %>%
      cols_align(align = "center") %>%
      tab_style(
        style = cell_borders(
          sides = c("all"),
          color = "black",
          weight = px(1),
          style = "solid"),
        locations = list(cells_body(), cells_column_labels()))
  })
  
  output$sample_table <- render_gt({
    sitecode() %>% 
      select(SampleName, ProjectCode, CntrType, QCType, CollMethod, SampleDepth, LabAbbrev) %>%
      rename("Sample Name" = "SampleName", 
             "Project" = "ProjectCode", 
             "Container" = "CntrType", 
             "QC" = "QCType",
             "Method" = "CollMethod",
             "Depth" = "SampleDepth") %>%
      group_by(LabAbbrev) %>%
      distinct() %>% 
      gt() %>%
      tab_style(
        style = cell_fill(color = "#B3E0A6"),
        locations = cells_body(columns = c(Depth),
                               rows = Method == "GS" & Depth == 0)) %>%
      tab_style(
        style = cell_fill(color = "#F5725E"),
        locations = cells_body(columns = c(Depth),
                               rows = Method == "CO-E" & Depth == 0)) %>%
      tab_style(
        style = cell_fill(color = "#F5725E"),
        locations = cells_body(columns = c(Depth),
                               rows = Method == "GS" & Depth != 0)) %>%
      cols_align(align = "center") %>%
      opt_interactive(use_sorting = TRUE, use_filters = TRUE, use_page_size_select = TRUE, page_size_default = 5, page_size_values = c(5, 10, 25, 50, 100)) %>%
      tab_style(
        style = cell_borders(
          sides = c("all"),
          color = "black",
          weight = px(1),
          style = "solid"),
        locations = list(cells_body()))
  })
  
  output$filter_table <- render_gt({
    sitecode() %>% 
      select(FilterName) %>%
      filter(FilterName != "NA") %>% 
      rename("Filter Name" = "FilterName") %>%
      distinct() %>%
      gt() %>%
      cols_align(align = "center") %>%
      tab_style(
        style = cell_borders(
          sides = c("all"),
          color = "black",
          weight = px(1),
          style = "solid"),
        locations = list(cells_body(), cells_column_labels()))
  })
  
  output$msmt_table <- render_gt({
    sitecode() %>% 
      select(QCType, ProfileDepth,Const, Result, SiteVisitID) %>% 
      filter(Const %in% c("Dissolved Oxygen", "water temperature")) %>% 
      pivot_wider(names_from = c(Const, QCType),
                  values_from = Result,
                  values_fn = list(Result = list)) %>%  # Keep all values
      rename("Water Temperature Regular" = "water temperature_Regular",
             "Water Temperature Duplicate" = "water temperature_Duplicate",
             "DO Regular" = "Dissolved Oxygen_Regular",
             "DO Duplicate" = "Dissolved Oxygen_Duplicate") %>%
      mutate(across(ends_with("_regular"), ~replace_na(as.character(.), "-")),
             across(ends_with("_duplicate"), ~replace_na(as.character(.), "-"))) %>% 
      select(ProfileDepth ,"Water Temperature Regular", "Water Temperature Duplicate", "DO Regular", "DO Duplicate") %>% 
      gt() %>% 
      opt_row_striping() %>%
      opt_interactive(use_sorting = TRUE, use_filters = TRUE, use_page_size_select = TRUE, page_size_default = 10, page_size_values = c(10, 25, 50, 100)) %>%
      tab_style(
        style = cell_borders(
          sides = c("all"),
          color = "black",
          weight = px(1),
          style = "solid"),
        locations = list(cells_body()))
  })
  
  output$ph_table <- render_gt({
    sitecode() %>% 
      select(Const, Result, QCType, Time, SiteVisitID ) %>% 
      filter(Const %in% c("Secchi","pH")) %>% 
      pivot_wider(names_from = c(Const, QCType),
                  values_from = Result) %>%
      mutate(pH_Duplicate = as.character(pH_Duplicate),
             pH_Duplicate = replace_na(pH_Duplicate, "-"),
             Secchi_Duplicate = as.character(Secchi_Duplicate),
             Secchi_Duplicate = replace_na(Secchi_Duplicate, "-"),
             Secchi_Regular = as.character(Secchi_Regular),
             Secchi_Regular = replace_na(Secchi_Regular, "-"),
             pH_Regular = as.character(pH_Regular),
             pH_Regular = replace_na(pH_Regular, "-")) %>% 
      select(!SiteVisitID) %>% 
      rename("pH Regular" = "pH_Regular",
             "pH Duplicate" = "pH_Duplicate",
             "Secchi Regular" = "Secchi_Regular",
             "Secchi Duplicate" = "Secchi_Duplicate") %>%
      gt() %>% 
      cols_move(
        columns = "pH Duplicate",
        after = "pH Regular"
      ) %>% 
      opt_row_striping() %>%
      opt_interactive(use_sorting = TRUE, use_filters = TRUE, use_page_size_select = TRUE, page_size_default = 10, page_size_values = c(10, 25, 50, 100)) %>%
      tab_style(
        style = cell_borders(
          sides = c("all"),
          color = "black",
          weight = px(1),
          style = "solid"),
        locations = list(cells_body()))
  })

}


shinyApp(ui = ui, server = server)
