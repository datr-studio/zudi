.onLoad <- function(libname, pkgname) { # nolint
  cores <<- parallel::detectCores() - 1
  data.table::setDTthreads(cores - 1)
}

cores <- NULL