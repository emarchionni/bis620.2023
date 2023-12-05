#' @title UI of the shiny app
#' @description
#' UI of the shiny app
#' @return ui of the shiny app
#' @importFrom shiny fluidPage titlePanel sidebarLayout sidebarPanel textInput selectInput fluidRow hr h3 column verbatimTextOutput mainPanel tabsetPanel tabPanel plotOutput dataTableOutput
#' @noRd

ui <- fluidPage(

  # Application title
  titlePanel("Clinical Trials Query"),

  sidebarLayout(
    sidebarPanel(
      textInput("brief_title_kw", "Brief title keywords"),
      #### PROBLEM 3: CHANGING THE CHECKBOX ONTO DROPDOWN ####
      # source: https://shiny.posit.co/r/gallery/widgets/widget-gallery/
      selectInput("source_class",
                  label = h3('Sponsor Type'),
                  # PROBLEM 3 UPDATE: in dropdown there is always something selected
                  # so we decided to put an 'all' choice which will show the data for all
                  # sponsor types, and it's convenient for the user
                  choices = list("All" = "All",
                                 "Federal" = "FED",
                                 "Individual" = "INDIV",
                                 "Industry" = "INDUSTRY",
                                 "Network" = "NETWORK",
                                 "NIH" = "NIH",
                                 "Other" = "OTHER",
                                 "Other_gov" = "OTHER_GOV",
                                 "Unknown" = "UNKNOWN"),
                  # PROBLEM 3 UPDATE: select the first dropdown option ('All') by default
                  selected = 'All'),


      hr(),
      fluidRow(column(3, verbatimTextOutput("value")))
    ),


    # adding panels for our app
    mainPanel(
      tabsetPanel(
        type = "tabs",
        tabPanel("Phase", plotOutput("phase_plot")),
        tabPanel("Concurrent", plotOutput("concurrent_plot")),
        # PROBLEM 2: ADDING ANOTHER PANEL WITH CONDITIONS
        tabPanel("Conditions", plotOutput("conditions_plot")),
        # ADVERSE EVENTS FEATURE
        tabPanel("Adverse events", plotOutput("adverse_events_plot")),
        # WORLD MAP FEATURE
        tabPanel('World Map', plotOutput("world_map_plot")),
        # DETAILEDNESS FEATURE
        tabPanel('Detailedness', plotOutput("detailedness_plot"))
      ),
      # showing selected data under the tabs
      dataTableOutput("trial_table")
    )
  )
)
