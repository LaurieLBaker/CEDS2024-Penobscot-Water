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
library(gtExtras)
library(tidyr)
library(tidyverse)
library(haven)
library(sf)
library(dbscan)
library(magrittr)
library(htmlwidgets)
library(janitor)
library(RColorBrewer)
library(ggthemes)
library(sass)
library(rmarkdown)
library(quarto)
library(shinydashboard)

ui <- page_sidebar(
  sidebar = sidebar(
    selectInput("collector", label = "Select a Collector", choices = data2018_primary$Collectors),
    checkboxGroupInput("rundate", label = "Select a Date", NULL),
    selectInput("runcode", label = "Select a Run", NULL),
    checkboxGroupInput("sitecode", label = "Select a Site", NULL)
  ),
  navset_tab(
    nav_panel(title = "Site Info", gt_output("si_table"))
    # nav_panel(title = "Site Info", gt_output("si_table"), gt_output("af_table"), gt_output("note_table")),
    # nav_panel(title = "Samples", gt_output("sample_table"), gt_output("filter_table")),
    # nav_panel(title = "Measurements", gt_output("msmt"), gt_output("ph"))
  )
)

server <- function(input, output, session) {
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
    updateSelectInput(session = session, "runcode", choices = runcode_choice)
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

  output$si_table <- render_gt({
    sitecode() %>%
      select(RunCode, SiteCode, WaterBody, SiteVisitStartTime, SiteDepth) %>%
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

  # output$af_table <- render_gt({
  #   sitecode() %>%
  #     select(SiteCode, Weather, SamplingAirTemp, RivCond, WaterLevel, FoamRank, FoamSource) %>%
  #     rename("Air Temp" = "SamplingAirTemp",
  #            "River Cond" = "RivCond",
  #            "Water Level" = "WaterLevel",
  #            "Foam Rank" = "FoamRank",
  #            "Foam Source" = "FoamSource",
  #            "Site" = "SiteCode") %>%
  #     distinct() %>%
  #     gt() %>%
  #     cols_align(align = "center") %>%
  #     tab_header(title = "Abiotic Factors") %>%
  #     tab_style(
  #       style = cell_borders(
  #         sides = c("all"),
  #         color = "black",
  #         weight = px(1),
  #         style = "solid"),
  #       locations = list(cells_body(), cells_column_labels()))
  # })
  # 
  # output$note_table <- render_gt({
  #   sitecode() %>%
  #     select(SiteCode, SiteVisitComment) %>%
  #     rename("Site Visit Notes" = "SiteVisitComment",
  #            "Site" = "SiteCode") %>%
  #     distinct() %>%
  #     gt() %>%
  #     cols_align(align = "center") %>%
  #     tab_header(title = "Site Visit Notes") %>%
  #     tab_style(
  #       style = cell_borders(
  #         sides = c("all"),
  #         color = "black",
  #         weight = px(1),
  #         style = "solid"),
  #       locations = list(cells_body(), cells_column_labels()))
  # })
  # 
  # output$sample_table <- render_gt({
  #   sitecode() %>%
  #     select(SiteCode, SampleName, ProjectCode, CntrType, QCType, CollMethod, SampleDepth, LabAbbrev) %>%
  #     rename("Sample Name" = "SampleName",
  #            "Project" = "ProjectCode",
  #            "Container" = "CntrType",
  #            "QC" = "QCType",
  #            "Method" = "CollMethod",
  #            "Depth" = "SampleDepth",
  #            "Site" = "SiteCode") %>%
  #     group_by(LabAbbrev) %>%
  #     distinct() %>%
  #     gt() %>%
  #     tab_header(title = "Samples") %>%
  #     tab_style(
  #       style = cell_fill(color = "#B3E0A6"),
  #       locations = cells_body(columns = c(Depth),
  #                              rows = Method == "GS" & Depth == 0)) %>%
  #     tab_style(
  #       style = cell_fill(color = "#F5725E"),
  #       locations = cells_body(columns = c(Depth),
  #                              rows = Method == "CO-E" & Depth == 0)) %>%
  #     tab_style(
  #       style = cell_fill(color = "#F5725E"),
  #       locations = cells_body(columns = c(Depth),
  #                              rows = Method == "GS" & Depth != 0)) %>%
  #     cols_align(align = "center") %>%
  #     opt_interactive(use_sorting = TRUE, use_filters = TRUE, use_page_size_select = TRUE, page_size_default = 5, page_size_values = c(5, 10, 25, 50, 100)) %>%
  #     tab_style(
  #       style = cell_borders(
  #         sides = c("all"),
  #         color = "black",
  #         weight = px(1),
  #         style = "solid"),
  #       locations = list(cells_body()))
  # })
  # 
  # output$filter_table <- render_gt({
  #   sitecode() %>%
  #     select(SiteCode, FilterName) %>%
  #     filter(FilterName != "NA") %>%
  #     rename("Filter Name" = "FilterName",
  #            "Site" = "SiteCode") %>%
  #     distinct() %>%
  #     gt() %>%
  #     tab_header(title = "Filters") %>%
  #     cols_align(align = "center") %>%
  #     tab_style(
  #       style = cell_borders(
  #         sides = c("all"),
  #         color = "black",
  #         weight = px(1),
  #         style = "solid"),
  #       locations = list(cells_body(), cells_column_labels()))
  # })
  # 
  # 
  # output$msmt <- render_gt({
  #   sitecode() %>%
  #     select(SiteCode, QCType, ProfileDepth, Const, Result, SiteVisitID) %>%
  #     filter(Const %in% c("Dissolved Oxygen", "water temperature")) %>%
  #     pivot_wider(names_from = c(Const, QCType),
  #                 values_from = Result,
  #                 values_fn = list(Result = list)) %>%
  #     mutate(across(ends_with("_regular"), ~replace_na(as.character(.), "-")),
  #            across(ends_with("_duplicate"), ~replace_na(as.character(.), "-"))) %>%
  #     select(SiteCode, ProfileDepth, SiteVisitID, contains("_")) %>%
  #     rename_with(~ str_replace_all(., "_", " "), contains("_")) %>%
  #     rename_with(~ str_to_title(., locale = "en"), contains(" ")) %>%
  #     gt() %>%
  #     tab_header(title = "Measurements") %>%
  #     opt_row_striping() %>%
  #     opt_interactive(use_sorting = TRUE, use_filters = TRUE, use_page_size_select = TRUE, page_size_default = 10, page_size_values = c(10, 25, 50, 100)) %>%
  #     tab_style(
  #       style = cell_borders(
  #         sides = c("all"),
  #         color = "black",
  #         weight = px(1),
  #         style = "solid"),
  #       locations = list(cells_body()))
  # })
  # 
  # output$ph <- render_gt({
  #   sitecode() %>%
  #     select(SiteCode, Const, Result, QCType, Time, SiteVisitID ) %>%
  #     filter(Const %in% c("Secchi","pH")) %>%
  #     pivot_wider(names_from = c(Const, QCType),
  #                 values_from = Result,
  #                 values_fn = list(Result = list)) %>%
  #     mutate(across(ends_with("_regular"), ~replace_na(as.character(.), "-")),
  #            across(ends_with("_duplicate"), ~replace_na(as.character(.), "-"))) %>%
  #     select(SiteCode, Time, SiteVisitID, contains("_")) %>%
  #     rename_with(~ str_replace_all(., "_", " "), contains("_")) %>%
  #     rename_with(~ str_to_title(., locale = "en"), contains(" ")) %>%
  #     rename_with(~ str_replace_all(., "Ph", "pH"), contains("Ph")) %>%
  #     gt() %>%
  #     tab_header(title = "pH and Secchi") %>%
  #     opt_row_striping() %>%
  #     opt_interactive(use_sorting = TRUE, use_filters = TRUE, use_page_size_select = TRUE, page_size_default = 10, page_size_values = c(10, 25, 50, 100)) %>%
  #     tab_style(
  #       style = cell_borders(
  #         sides = c("all"),
  #         color = "black",
  #         weight = px(1),
  #         style = "solid"),
  #       locations = list(cells_body()))
  # })

}

shinyApp(ui = ui, server = server)
