
#' @title Download Clinical trials database
#' @description
#' This function install first the library ctrialsgov that can be found on github at the link presagia-analytics/ctrialsgov and then
#' download the duckdb database ctgov in a folder called ctrialsgovdb in ../current_directory.
#' This database is needed to run the shiny app
#' Disclaimer: ctrialsgov package is not on Cran and the author of this package cannot be considered reponsible for its content
#' Warning: ctgov is heavy
#' @param path (string) that defines where the databaset has to be downloaded, default ../ctrialsgovdb
#' @param install_ctrialsgov (boolean) boolean value for installing ctrialsgov library from github,
#' set to F if already installed. If already installed and set to T, force re-installation.
#' @importFrom devtools install_github
#' @export
#'

download_clinicaltrials <- function(path = "../ctrialsgovdb", install_ctrialsgov = T) {

  if(install_ctrialsgov)
    devtools::install_github("presagia-analytics/ctrialsgov", force = install_ctrialsgov)

  library(ctrialsgov)
  ctrialsgov::ctgov_get_latest_snapshot(
    db_path = paste0("../ctrialsgovdb","ctgov.duckdb"),
    db_derived_path = paste0("../ctrialsgovdb","ctgov-derived.duckdb"))

}
