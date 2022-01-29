# Operators ---------------------------------------------------------------
#'

`%||%` <- function(a, b) ifelse(!is.null(a), a, b) # nolint

# Type Checking ---------------------------------------------------------------
#'


check_type <- function(arg, exp_type) {
  arg_name <- deparse(substitute(arg))
  if (!inherits(arg, exp_type)) {
    show_var_wrong_type_error(arg, arg_name, exp_type)
  }
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
