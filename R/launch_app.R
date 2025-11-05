#' Launch the Shiny app
#'
#' Opens the interactive explorer for the bundled corpus.
#'
#' @details
#' This function launches the Shiny app located under \code{inst/app/}.
#' The app reads the packaged dataset (e.g., \code{corpus_docs}) and does
#' not read external files.
#'
#' @return No return value; called for side effects.
#' @examples
#' \dontrun{
#'   launch_app()
#' }
#' @export
launch_app <- function() {
  # Resolve the app directory inside the installed package
  app_dir <- system.file("app", package = utils::packageName())
  if (identical(app_dir, "") || !dir.exists(app_dir)) {
    stop("App not found. Check that 'inst/app/app.R' exists and the package is installed.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
