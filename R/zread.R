#' Combine all dataframes in a folder. Zuud!
#'
#' `zread()` speedily reads and binds all files in a directory matching a regex pattern.
#'
#' Accepted filetypes are csvs, tsvs, and feather files.
#'
#' In addition, a cache of the joined result will be saved in the directory. `zread()`
#' will also check for cached results before loading, if `TRUE`.
#'
#'
#' @param dir Directory to search.
#' @param pattern Optional regex pattern to filter.
#' @param cache If `TRUE`, a cache of the joined df will be saved in the same directory
#' for future loading.
#' @param parallel If `TRUE` (and available on the machine), `zread()` will attempt to
#' use parallel processing. This may incur a small overhead cost that outweighs
#' the benefits on small datasets.
#'
#' @return A tibble.
#'
# ' @examples
# ' \dontrun {
# ' zread("path/to/allmyfiles", "^log_")
# ' }
zread <- function(dir, pattern = NULL, cache = TRUE, parallel = TRUE) {
  if (cache && cache_exists(dir, pattern)) {
    cli::cli_progress_step("Discovered cache in {.path {basename(dir)} folder}")
    read_cache(dir, pattern)
  } else {
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
    type <- get_file_type(files)
    if (type == "feather") {
      dfs <- read_fe(files, parallel)
    } else if (type == "delim") {
      dfs <- read_delim(files, parallel)
    } else {
      abort_unsupported_type()
    }
    # Read files
    cli::cli_progress_step("Reading {.val {length(files)}} file{?s} from {.path {basename(dir)}}")

    # Bind Files
    cli::cli_progress_step("Binding data frames")
    x <- zbind(dfs)
    # Save cache
    if (cache) {
      cli::cli_progress_step("Saving cache for next time")
      save_cache(x, dir, pattern)
    }
    x
  }
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

cache_exists <- function(dir, pattern) {
  cli::cli_progress_step("Searching for existing caches")
  file.exists(file.path(dir, paste0(remove_regex_symbols(pattern), ".cache")))
}


#' @import feather
read_cache <- function(dir, pattern) {
  cli::cli_progress_step("Loading cache")
  data <- feather::read_feather(
    file.path(dir, paste0(remove_regex_symbols(pattern), ".cache"))
  )
  cli::cli_alert_success("Cache loaded successfully.")
  data
}

#' @import feather
save_cache <- function(x, dir, pattern) {
  feather::write_feather(x, file.path(dir, paste0(remove_regex_symbols(pattern), ".cache")))
}