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
library(DescTools)

# User Interface for app
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
  navset_tab(
    # Creates the tabs and UI output for the tables
    nav_panel(title = "Site Info", uiOutput("site_tables")),
    nav_panel(title = "Samples", uiOutput("sample_tables")),
    nav_panel(title = "Measurements", uiOutput("msmt_tables"))
  )
)

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
    qc1 <- sitecode() %>% filter(CollMethod == "CO-E", SampleDepth == 0 | 0.0)
    qc2 <- sitecode() %>% filter(CollMethod == "GS", SampleDepth != 0 | 0.0)
    
    qc1_error <- if(nrow(qc1) > 0) {
      qc1 %>% select(RunDate, RunCode, SiteCode) %>% mutate_all(as.character) %>% paste(collapse = ", ")
    } else {
      NULL
    }
    
    qc2_error <- if(nrow(qc2) > 0) {
      qc2 %>% select(RunDate, RunCode, SiteCode) %>% mutate_all(as.character) %>% paste(collapse = ", ")
    } else {
      NULL
    }
    
    if(is.null(qc1_error) & is.null(qc2_error)) {
      createAlert(session, "qc", "qcAlert", title = "Congratulations!", 
                  content = "You do not have any quality control alerts at this time.", style = "success", dismiss = FALSE, append = FALSE)
    } else if(!is.null(qc1_error) & is.null(qc2_error)) {
      createAlert(session, "qc", "qcAlert", title = "Attention!", 
                  content = paste("You have QC errors at the following sites: ", qc1_error), style = "danger", dismiss = FALSE, append = FALSE)
    } else if(is.null(qc1_error) & !is.null(qc2_error)) {
      createAlert(session, "qc", "qcAlert", title = "Attention!", 
                  content = paste("You have QC errors at the following sites: ", qc2_error), style = "danger", dismiss = FALSE, append = FALSE)
    } else {
      createAlert(session, "qc", "qcAlert", title = "Attention!", 
                  content = paste("You have QC errors at the following sites: ", qc1_error, qc2_error), style = "danger", dismiss = FALSE, append = FALSE)
    }
  })
  
  
  output$site_tables <- renderUI({
    # UI for first tab, includes information tables
    site_data <- sitecode()
    
    # Reactivity to split the tables by run date, run code, and site code
    tables_by_date <- lapply(split(site_data, site_data$RunDate), function(date_df) {
      date <- unique(date_df$RunDate)
      date_tables <- lapply(split(date_df, date_df$RunCode), function(run_df) {
        run_code <- unique(run_df$RunCode)
        run_tables <- lapply(split(run_df, run_df$SiteCode), function(site_df) {
          site_code <- unique(site_df$SiteCode)
          
          # Site Info Table
          si_table <- site_df %>%
            dplyr::select(RunCode, SiteCode, WaterBody, SiteVisitStartTime, SiteDepth) %>% # It's really important to specify that select is from the dplyr package, otherwise it won't work
            rename(
              "Water Body" = "WaterBody",
              "Site" = "SiteCode",
              "Run Code" = "RunCode",
              "Time" = "SiteVisitStartTime",
              "Depth" = "SiteDepth"
            ) %>%
            distinct() %>%
            gt() %>%
            cols_align(align = "center") %>%
            tab_header(title = glue("Site Information: {site_code}")) %>%
            tab_style(
              style = cell_borders(
                sides = c("all"),
                color = "black",
                weight = px(1),
                style = "solid"
              ),
              locations = list(cells_body(), cells_column_labels())
            )
          
          # Abiotic Factors Table
          af_table <- site_df %>%
            dplyr::select(SiteCode, Weather, SamplingAirTemp, RivCond, WaterLevel, FoamRank, FoamSource) %>%
            rename(
              "Air Temp" = "SamplingAirTemp",
              "River Cond" = "RivCond",
              "Water Level" = "WaterLevel",
              "Foam Rank" = "FoamRank",
              "Foam Source" = "FoamSource",
              "Site" = "SiteCode"
            ) %>%
            distinct() %>%
            gt() %>%
            cols_align(align = "center") %>%
            tab_header(title = glue("Abiotic Factors: {site_code}")) %>%
            tab_style(
              style = cell_borders(
                sides = c("all"),
                color = "black",
                weight = px(1),
                style = "solid"
              ),
              locations = list(cells_body(), cells_column_labels())
            )
          
          # Notes Table
          notes_table <- site_df %>%
            dplyr::select(SiteCode, SiteVisitComment) %>%
            rename(
              "Site Visit Notes" = "SiteVisitComment",
              "Site" = "SiteCode"
            ) %>%
            distinct() %>%
            gt() %>%
            cols_align(align = "center") %>%
            tab_header(title = glue("Site Visit Notes: {site_code}")) %>%
            tab_style(
              style = cell_borders(
                sides = c("all"),
                color = "black",
                weight = px(1),
                style = "solid"
              ),
              locations = list(cells_body(), cells_column_labels())
            )
          
          tagList(
            div(style = "margin-bottom: 20px;", si_table, af_table, notes_table)
          )
        })
        # Creates run code heading
        tagList(
          h3(glue("Run Code: {run_code}")),
          run_tables
        )
      })
      # Creates date heading
      tagList(
        h2(glue("Date: {date}")),
        date_tables
      )
    })
    
    tagList(tables_by_date)
  })
  
  output$sample_tables <- renderUI({
    # UI for second tab
    site_data <- sitecode()
    
    # Splits tables
    tables_by_date <- lapply(split(site_data, site_data$RunDate), function(date_df) {
      date <- unique(date_df$RunDate)
      date_tables <- lapply(split(date_df, date_df$RunCode), function(run_df) {
        run_code <- unique(run_df$RunCode)
        run_tables <- lapply(split(run_df, run_df$SiteCode), function(site_df) {
          site_code <- unique(site_df$SiteCode)
          
          # Sample Table
          samples <- site_df %>%
            dplyr::select(SiteCode, SampleName, ProjectCode, CntrType, QCType, CollMethod, SampleDepth, LabAbbrev) %>%
            rename(
              "Sample Name" = "SampleName",
              "Project" = "ProjectCode",
              "Container" = "CntrType",
              "QC" = "QCType",
              "Method" = "CollMethod",
              "Depth" = "SampleDepth",
              "Site" = "SiteCode"
            ) %>%
            group_by(LabAbbrev) %>%
            distinct() %>%
            gt() %>%
            tab_header(title = glue("Samples: {site_code}")) %>%
            tab_style(
              style = cell_fill(color = "#B3E0A6"),
              locations = cells_body(
                columns = c(Depth),
                rows = Method == "GS" & Depth == 0
              )
            ) %>%
            tab_style(
              style = cell_fill(color = "#F5725E"),
              locations = cells_body(
                columns = c(Depth),
                rows = Method == "CO-E" & Depth == 0
              )
            ) %>%
            tab_style(
              style = cell_fill(color = "#F5725E"),
              locations = cells_body(
                columns = c(Depth),
                rows = Method == "GS" & Depth != 0
              )
            ) %>%
            cols_align(align = "center") %>%
            opt_interactive(use_sorting = TRUE, use_filters = TRUE, use_page_size_select = TRUE, page_size_default = 5, page_size_values = c(5, 10, 25, 50, 100)) %>%
            tab_style(
              style = cell_borders(
                sides = c("all"),
                color = "black",
                weight = px(1),
                style = "solid"
              ),
              locations = list(cells_body())
            )
          
          # Filter Table
          filters <- site_df %>%
            dplyr::select(SiteCode, FilterName) %>%
            filter(FilterName != "NA") %>%
            rename(
              "Filter Name" = "FilterName",
              "Site" = "SiteCode"
            ) %>%
            distinct() %>%
            gt() %>%
            tab_header(title = glue("Filters: {site_code}")) %>%
            cols_align(align = "center") %>%
            tab_style(
              style = cell_borders(
                sides = c("all"),
                color = "black",
                weight = px(1),
                style = "solid"
              ),
              locations = list(cells_body(), cells_column_labels())
            )
          
          tagList(
            div(style = "margin-bottom: 20px;", samples, filters)
          )
        })
        # Run code header
        tagList(
          h3(glue("Run Code: {run_code}")),
          run_tables
        )
      })
      # Run date header
      tagList(
        h2(glue("Date: {date}")),
        date_tables
      )
    })
    
    tagList(tables_by_date)
  })
  
  output$msmt_tables <- renderUI({
    # UI for third tab
    site_data <- sitecode()
    
    # Splits tables
    tables_by_date <- lapply(split(site_data, site_data$RunDate), function(date_df) {
      date <- unique(date_df$RunDate)
      date_tables <- lapply(split(date_df, date_df$RunCode), function(run_df) {
        run_code <- unique(run_df$RunCode)
        run_tables <- lapply(split(run_df, run_df$SiteCode), function(site_df) {
          site_code <- unique(site_df$SiteCode)
          
          # Profile Measurements Table
          msmt <- site_df %>%
            dplyr::select(SiteCode, QCType, ProfileDepth, Const, Result) %>%
            filter(Const %in% c("Dissolved Oxygen", "water temperature")) %>%
            pivot_wider(
              names_from = c(Const, QCType),
              values_from = Result,
              values_fn = list(Result = list)
            ) %>%
            mutate(
              across(ends_with("_regular"), ~ replace_na(as.character(.), "-")),
              across(ends_with("_duplicate"), ~ replace_na(as.character(.), "-"))
            ) %>%
            dplyr::select(SiteCode, ProfileDepth, contains("_")) %>%
            rename_with(~ str_replace_all(., "_", " "), contains("_")) %>%
            rename_with(~ str_to_title(., locale = "en"), contains(" ")) %>%
            gt() %>%
            tab_header(title = glue("Profile Measurements: {site_code}")) %>%
            opt_row_striping() %>%
            opt_interactive(use_sorting = TRUE, use_filters = TRUE, use_page_size_select = TRUE, page_size_default = 10, page_size_values = c(10, 25, 50, 100)) %>%
            tab_style(
              style = cell_borders(
                sides = c("all"),
                color = "black",
                weight = px(1),
                style = "solid"
              ),
              locations = list(cells_body())
            )
          
          # Non-Profile Measurements Table
          pH <- site_df %>%
            dplyr::select(SiteCode, Constituents, Const, Result, QCType, Time) %>%
            filter(Const %in% c("Secchi", "pH", "Cond")) %>%
            mutate(Conductivity = str_extract(Constituents, "Cond")) %>%
            pivot_wider(
              names_from = c(Const, QCType),
              values_from = Result,
              values_fn = list(Result = list)
            ) %>%
            mutate(
              across(ends_with("_regular"), ~ replace_na(as.character(.), "-")),
              across(ends_with("_duplicate"), ~ replace_na(as.character(.), "-"))
            ) %>%
            dplyr::select(SiteCode, Conductivity, Time, contains("_")) %>%
            rename_with(~ str_replace_all(., "_", " "), contains("_")) %>%
            rename_with(~ str_to_title(., locale = "en"), contains(" ")) %>%
            rename_with(~ str_replace_all(., "Ph", "pH"), contains("Ph")) %>%
            gt() %>%
            tab_header(title = glue("Non-Profile Measurements: {site_code}")) %>%
            opt_row_striping() %>%
            opt_interactive(use_sorting = TRUE, use_filters = TRUE, use_page_size_select = TRUE, page_size_default = 10, page_size_values = c(10, 25, 50, 100)) %>%
            tab_style(
              style = cell_borders(
                sides = c("all"),
                color = "black",
                weight = px(1),
                style = "solid"
              ),
              locations = list(cells_body())
            )
          
          tagList(
            div(style = "margin-bottom: 20px;", msmt, pH)
          )
        })
        # Run Code header
        tagList(
          h3(glue("Run Code: {run_code}")),
          run_tables
        )
      })
      # Run Date Header
      tagList(
        h2(glue("Date: {date}")),
        date_tables
      )
    })
    
    tagList(tables_by_date)
  })
  
}

# Runs the shiny app
shinyApp(ui = ui, server = server)
