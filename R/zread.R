#' Combine all dataframes in a folder. Zuud!
#'
#' `zread()` speedily reads and binds all files in a directory matching a regex pattern.
#'
#' Accepted filetypes are csvs, tsvs, and feather files.
#'
#'
#' @param dir Directory to search.
#' @param pattern Optional regex pattern to filter.
#' @param parallel If `TRUE` (and available on the machine), `zread()` will attempt to
#' use parallel processing. This may incur a small overhead cost that outweighs
#' the benefits on small datasets.
#'
#' @export
#' @import cli
#'
#'
#' @return A tibble.
#'
# ' @examples
# ' \dontrun {
# ' zread("path/to/allmyfiles", "^log_")
# ' }
zread <- function(dir, pattern = NULL, parallel = TRUE) {
  # Get Files
  if (!is.null(pattern)) {
    files <- list.files(dir, pattern = pattern, full.names = T)
  } else {
    files <- list.files(dir, full.names = TRUE)
  }
  if (length(files) == 0) {
    if (!is.null(pattern)) {
      abort_no_files(dir)
    } else {
      abort_empty_dir(dir)
    }
  }
  # Read files
  type <- get_file_type(files)
  cli::cli_progress_step("Reading {.val {length(files)}} file{?s} from {.path {basename(dir)}}")
  if (type == "feather") {
    dfs <- read_fe(files, parallel)
  } else if (type == "delim") {
    dfs <- read_delim(files, parallel)
  } else {
    abort_unsupported_type()
  }


  # Bind Files
  cli::cli_progress_step("Binding data frames")
  zbind(dfs)
}

get_file_type <- function(files) {
  ext <- unique(get_file_ext(files))
  if (length(ext) > 1L) abort_mixed_types()
  type <- switch(ext,
    "fe" = "feather",
    "tsv" = "delim",
    "csv" = "delim",
    ""
  )
  if (type == "") {
    tryCatch(
      {
        feather::feather_metadata(files[[1]])
        type <- "feather"
      },
      error = function(e) {
        abort_unsupported_type()
      }
    )
  }
  type
}


get_file_ext <- function(x) {
  pos <- regexpr("\\.([[:alnum:]]+)$", x)
  ifelse(pos > -1L, substring(x, pos + 1L), "")
}

read_fe <- function(files, parallel) {
  if (parallel) {
    dfs <- parallel::mclapply(files, feather::read_feather, mc.cores = cores)
  } else {
    dfs <- lapply(files, feather::read_feather)
  }
}

read_delim <- function(files, parallel) {
  if (parallel) {
    dfs <- parallel::mclapply(files, data.table::fread, mc.cores = cores)
  } else {
    dfs <- lapply(files, data.table::fread)
  }
}


remove_regex_symbols <- function(x) {
  regex_symbols <- c("\\d", "^", "|", "$", ".", "+", "\\", "[", "]", "(", ")")
  regexified_regex_symbols <- paste0("\\", regex_symbols)
  strem(x, paste0(regexified_regex_symbols, collapse = "|"))
}