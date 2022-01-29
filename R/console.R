# Errors and Abortions ---------------------------------------------------------------
#'
#' @import cli
abort <- function(msg) {
  cli::cli_div(theme = list(.alert = list(color = "red")))
  cli::cli_alert_danger(msg)
  cli::cli_end()
  stop_quietly()
}

show_var_wrong_type_error <- function(x, var_name, exp_type) {
  cli::cli_div(theme = list(.alert = list(color = "red")))
  cli::cli_alert_danger("Error: {.var {var_name}} must be a {exp_type}")
  cli::cli_end()
  cli::cli_text("You've supplied a {.cls {class(x)}} type.")
}

stop_quietly <- function() {
  options(show.error.messages = FALSE)
  on.exit(options(show.error.messages = TRUE))
  stop()
}

#' @import cli
abort_no_files <- function(dir) {
  msg <- "Error: no files in {.path {dir}} match that pattern."
  abort(msg)
}

abort_empty_dir <- function(dir) {
  msg <- "Error: {.path {dir}} is empty."
  abort(msg)
}

abort_no_cache <- function(dir) {
  msg <- "Error: no caches in {.path {dir}} match that pattern."
  abort(msg)
}

abort_mixed_types <- function() {
  msg <- "Error: Ambiguous pattern with more than one file type."
  abort(msg)
}

abort_unsupported_type <- function() {
  msg <- "Error: The file type matching that pattern is not supported by zread."
  abort(msg)
}

# Progress ---------------------------------------------------------------
#'

show_msg_loading_from_cache <- function(dir) {
  cli::cli_alert_success("Found cache in {.path {dir}}")
}