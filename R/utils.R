# Operators ---------------------------------------------------------------
#'

`%+%` <- function(a, b) {
  if (is.character(a) && is.character(b)) {
    paste0(a, b)
  } else {
    stop("%+% requires two strings")
  }
}

`%||%` <- function(a, b) ifelse(!is.null(a), a, b)

# Type Checking ---------------------------------------------------------------
#'

assert <- function(x, y) {
  if (!is.null(x)) {
    if (!inherits(x, y)) {
      stop(deparse(substitute(x)), " must be of class ",
        paste0(y, collapse = ","),
        call. = FALSE
      )
    }
  }
}


# Lists ---------------------------------------------------------------
#'

compact <- function(l) Filter(Negate(is.null), l)

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