#' @title Server infrastructure of the shiny app
#' @description
#' Server infrastructure of the shiny app
#' @importFrom shiny reactive renderPlot renderDataTable
#' @importFrom dplyr filter collect rename
#' @importFrom utils head
#' @importFrom ggplot2 xlab ylab theme_bw labs theme element_text
#' @noRd
#'


server <- function(input, output) {

  # using reactive function to update the selected data
  # every time the user changes its input
  get_studies = reactive({
    # filter data by keyword specified by user
    if (input$brief_title_kw != "") {
      si = input$brief_title_kw |>
        strsplit(",") |>
        unlist() |>
        trimws()
      ret = query_kwds(studies, si, "brief_title", match_all = TRUE)
    } else {
      ret = studies
    }

    # PROBLEM 3: filtering the data by sponsor type selected by user in dropdown
    if (input$source_class != 'All'){
      ret = ret|> filter(source_class %in% !!input$source_class)
    }


    # selecting at most max_num_studies observations to speed up the processing of the app
    ret |>
      head(max_num_studies) |>
      collect()

  })
  # end or reactive function, data is generated for the query


  # concurrent plot created in class
  output$concurrent_plot = renderPlot({
    get_studies() |>
      select(start_date, completion_date) |>
      get_concurrent_trials() |>
      ggplot(aes(x = date, y = count)) +
      geom_line() +
      xlab("Date") +
      ylab("Number of trials") +
      theme_bw() +
      labs(title = 'Number of active trials for each date') +
      theme(axis.title.x = element_text(size=16),
            axis.text.x  = element_text(size=13),
            axis.title.y = element_text(size=16),
            axis.text.y  = element_text(size=13),
            plot.title = element_text(size = 20))
  })


  #### PROBLEM 1: FIX PHASE HISTOGRAM ####
  # getting the list of all posible phases in the database
  phases_all <- get_all_phases(studies)

  # phase plot using new plot_phase_histogram_new function
  # detailed info in ct and description files
  output$phase_plot = renderPlot({
    get_studies() |>
      plot_phase_histogram_new(phases_all = phases_all)
  })


  #### PROBLEM 2 : CONDITIONS PLOT ####
  output$conditions_plot = renderPlot({
    # detailed info in ct and description files
    plot_conditions(get_studies(), conditions)
  })


  # rendering data table under the tabs, did in class
  output$trial_table = renderDataTable({
    get_studies() |>
      select(nct_id, brief_title, start_date, completion_date) |>
      rename(`NCT ID` = nct_id, `Brief Title` = brief_title,
             `Start Date` = start_date, `Completion Date` = completion_date)
  })


  #### PROBLEM 4: ADDING EXTRA FEATURES ####

  #### ADVERSE EVENTS FEATURE ####
  output$adverse_events_plot = renderPlot({
    plot_adverse_events(get_studies(), reported_events)
  })


  #### WORLD MAP FEATURE ####
  output$world_map_plot = renderPlot({
    plot_world_map(get_studies(), countries, world_map)
  })


  #### DETAILEDNESS FEATURE ####
  output$detailedness_plot = renderPlot({
    plot_detailedness(get_studies(), calculated_values)
  })


}
