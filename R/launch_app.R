#' Launch the Shiny app
#'
#' @return No return value; launches the Shiny app.
#' @export
launch_app <- function() {
  app_dir <- system.file("app", package = utils::packageName())
  if (app_dir == "") stop("App not found. Was the package installed correctly?", call. = FALSE)
  shiny::runApp(app_dir, display.mode = "normal")
}
