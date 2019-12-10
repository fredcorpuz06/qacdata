
<!-- README.md is generated from README.Rmd. Please edit that file -->

# qacdata

<!-- badges: start -->

<!-- badges: end -->

## Overview

`qacdata` is an R data package for datasets used by students of [Passion
Driven Statistics](https://passiondrivenstatistics.com/). This package
allows for the concise searching and downloading of relevant data from
the following sources:

  - [Federal Reserve Economic Data
    (FRED)](https://fred.stlouisfed.org/): economic time-series data
  - [World Development Indicators
    (WDI)](https://datacatalog.worldbank.org/dataset/world-development-indicators):
    collection of development indicators, compiled from
    officially-recognized international
    sources
  - [addhealth](https://www.cpc.unc.edu/projects/addhealth/documentation/publicdata):
    developmental and health trajectories across the life course of
    adolescence into young adulthood (Wave 4)
  - marscrater: global database for Mars that contains 378,540 craters
    statistically complete for diameters D ≥ 1
    km
  - [cttraffic](https://data.ct.gov/Public-Safety/Racial-Profiling-Prohibition-Project-Traffic-Stop-/g7s9-f7az):
    racial profiling prohibition project traffic stop data

## Installation

You can install the development version from
[GitHub](https://github.com/fredcorpuz06/qacdata) with:

``` r
# install.packages("devtools")
devtools::install_github("fredcorpuz06/qacdata")
```

## Usage

``` r
library(qacdata)

data_search("education", c("FRED", "WDI"))
#> # A tibble: 3,611 x 4
#>    dataset col_id      description                               notes     
#>    <chr>   <chr>       <chr>                                     <list>    
#>  1 FRED    LNU04027662 Unemployment Rate: College Graduates: Ba~ <tibble [~
#>  2 FRED    LNS14027662 Unemployment Rate: College Graduates: Ba~ <tibble [~
#>  3 FRED    LNS14027660 Unemployment Rate: High School Graduates~ <tibble [~
#>  4 FRED    LNU04027660 Unemployment Rate: High School Graduates~ <tibble [~
#>  5 FRED    LNS14027659 Unemployment Rate: Less than a High Scho~ <tibble [~
#>  6 FRED    LNU04027659 Unemployment Rate: Less than a High Scho~ <tibble [~
#>  7 FRED    GCT1502US   People 25 Years and Over Who Have Comple~ <tibble [~
#>  8 FRED    G160291A02~ Government current expenditures: Educati~ <tibble [~
#>  9 FRED    CES6562000~ All Employees: Education and Health Serv~ <tibble [~
#> 10 FRED    CGMD25O     Unemployment Rate - College Graduates - ~ <tibble [~
#> # ... with 3,601 more rows

data_download("AddHealth", "H4TR10", "H4CJ5")
#> # A tibble: 5,114 x 2
#>    H4TR10 H4CJ5
#>     <dbl> <dbl>
#>  1      4   997
#>  2     97   997
#>  3     97     1
#>  4     97   997
#>  5      1   997
#>  6      1   997
#>  7      3   997
#>  8      1   997
#>  9      2   997
#> 10      2   997
#> # ... with 5,104 more rows
```

## Getting help

If you encounter a clear bug, please file a minimal reproducible example
on [github](https://github.com/fredcorpuz06/qacdata/issues).
