#' Bind data. Zuud!
#'
#' Speedily binds a list of rows or dataframes into one.
#'
#' @param x A dataframe..
#'
#' @export
#' @importFrom dplyr as_tibble
#' @import data.table
#'
#' @return A tibble
#' @examples
#'
#' zbind(list(mtcars, mtcars, mtcars))
#'
#' x <- list(a = 1, b = 1:5)
#' zbind(list(x, x, x))
zbind <- function(x) {
  dplyr::as_tibble((x <- data.table::setDF(
    data.table::rbindlist(x, use.names = TRUE, fill = TRUE, idcol = "id")
  )
  ))
}