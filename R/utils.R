# Type Checking ---------------------------------------------------------------
#'


check_type <- function(arg, exp_type) {
  arg_name <- deparse(substitute(arg))
  if (!inherits(arg, exp_type)) {
    show_var_wrong_type_error(arg, arg_name, exp_type)
  }
}

check_exists <- function(filepath) {
  if (!file.exists(filepath)) abort_folder_not_found(file.path(getwd(), filepath))
}


# Regex ---------------------------------------------------------------
#'

strext <- function(x, y) regmatches(x, regexpr(y, x))

strepl <- function(x, y, z) gsub(y, z, x)

strem <- function(x, y) gsub(y, "", x)

strdetc <- function(x, y) grepl(y, x)

# Paths ---------------------------------------------------------------
#'

rem_ext <- function(x) {
  x <- sub("[.](gz|bz2|xz)$", "", x)
  sub("([^.]+)\\.[[:alnum:]]+$", "\\1", x)
}
