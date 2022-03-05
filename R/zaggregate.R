


#' Group and aggregate. Zuud!
#'
#' Wrapper around dtplyr to simplify call to speedier aggregation.
#'
#' @param .data A data frame.
#' @param groups A vector of columns to group by.
#' @param ... Aggregate functions.
#'
#' @export
#' @import dtplyr
#' @importFrom dplyr group_by across summarise as_tibble
#' @importFrom magrittr %>%
#'
#' @return A tibble
zaggregate <- function(.data, groups, ...) {
  dtplyr::lazy_dt(.data) %>%
    dplyr::group_by(dplyr::across({{ groups }})) %>%
    dplyr::summarise(...) %>%
    dplyr::as_tibble()
}
