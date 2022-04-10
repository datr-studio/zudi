
<!-- README.md is generated from README.Rmd. Please edit that file -->

# zudi

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of zudi is to provide streamlined functionality for common data
science pipeline tasks involving reading, binding, and aggregating
multiple data files.

This package is particularly designed for users who prefer to work with
tidyverse style syntax, but appreciate the speed of `data.table`. Under
the hood, `zudi` implements data.table for multi-threaded parallel
processing—however, this is currently only optimized for Mac due to
limitations with the `parallel` library on Windows.

## Installation

You can install the development version of zudi from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("datr-studio/zudi")
```

## Usage

### Reading multiple files

``` r
library(zudi)
```

`zread()` enables the speedy reading and binding of all files in a
directory that (optionally) match a certain regex pattern. The result
will be all files read and bound into a single data frame, returned as a
tibble.

``` r
zread("path/to/allmyfiles", "^log_")
```

`zread` knows how to handle `tsv` or `csv` files as well as the
brilliant `feather` files types (just use the extension `.fe` to let the
reader know it is a feather file).

### Binding data frames

`zbind()` utilizes data.table to bind a list of data.frames or lists.

This functionality is already present in tidyverse (`bind_rows()`) but
is useful if the user wants the speed advantage of parallel processing
via data.table without having to make an explicit call to data.table in
their workflow.

``` r
x <- data.frame(x = 1, y = 2)
zbind(list(x, x, x))
#> # A tibble: 3 × 3
#>      id     x     y
#>   <int> <dbl> <dbl>
#> 1     1     1     2
#> 2     2     1     2
#> 3     3     1     2
```

### Aggregating data frames

`zaggregate()` utilizes data.table to group and aggregate a data frame.

It takes a column name (or vector of column names) to group by and an
arbitrary number of aggregation functions according to tidyverse syntax.

``` r
y <- data.frame(x = rep(1:3, 3), y = 1:9)
zaggregate(y, x, z = mean(y))
#> # A tibble: 3 × 2
#>       x     z
#>   <int> <dbl>
#> 1     1     4
#> 2     2     5
#> 3     3     6
```

## About the name Zudi

Fun fact: the word “zuud” in Farsi means fast or quick, hence the name
and is a credit to my beautiful Persian wife. Zudi, roughly translated,
means `something fast`.
