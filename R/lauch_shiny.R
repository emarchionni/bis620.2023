#' @title Launch shiny app
#' @description
#' This function launch the shiny app, the function requires that the duckdb ctgov database is localy saved,
#' this can be done through \code{\link{download_clinicaltrials}}.
#' @param path (string) that defines where the databaset is stored, default ../ctrialsgovdb
#' @importFrom shiny shinyApp
#' @importFrom duckdb dbConnect duckdb dbListTables
#' @importFrom dplyr mutate right_join tbl
#' @importFrom ggplot2 map_data
#' @export
#'
#'

launch_shiny <- function(path = "../ctrialsgovdb"){


  # create the connection to the database ctrialsgov.duckdb in the path ../ctrialsgovdb
  con = dbConnect(
    duckdb(
      paste0(path, "/ctgov.duckdb"),
      read_only = TRUE
    )
  )



  if (length(dbListTables(con)) == 0) {
    stop("Problem reading from connection.")
  }

  # create tables from the database
  studies = tbl(con, "studies")
  conditions = tbl(con, 'conditions')  # PROBLEM 2
  countries = tbl(con, 'countries')  # WORLD MAP FEATURE
  calculated_values = tbl(con, 'calculated_values')  # DETAILEDNESS FEATURE:



  reported_events <- tbl(con, "reported_events")  # ADVERSE EVENTS FEATURE
  # for better rendering
  reported_events <- reported_events |>
    mutate(organ_system = replace(organ_system,
                                  "Neoplasms benign, malignant and unspecified (incl cysts and polyps)",
                                  "Neoplasms benign, malignant and unspecified"))


  # reading additional data for WORLD MAP FEATURE:
  # world data from package maps, to build a world map diagram!!!
  # it shows countries and corresponding geographical coordinates
  world_map <- map_data("world")
  # removing Antarctica for better visualization
  world_map <- subset(world_map, region!="Antarctica")



  shinyApp(ui = ui, server = server)

}
