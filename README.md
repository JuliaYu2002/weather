
<!-- README.md is generated from README.Rmd. Please edit that file -->

# weather

<!-- badges: start -->

[![R-CMD-check](https://github.com/JuliaYu2002/weather/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/JuliaYu2002/weather/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The weather package retrieves weather data (highest temperature, lowest
temperature, precipitation, windspeed) from websites and data sets,
providing users with useful functions for data manipulation and
visualization.

## Installation

You can install the development version of weather from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("JuliaYu2002/weather")
```

## Usage

At any date, you can get weather data of Northampton, MA for the next 14
days from weather.com.

This package also has function that retrieves the highest and lowest
temperature or the precipitation data for the past 30 days at a specific
location.

``` r
library(weather)

noho_forecast <- weather_noho()
print(noho_forecast)
#>       Day       Date           Status High Low Precipitation Type
#> 1   Today 2024-04-29 AM Clouds/PM Sun   73  51               Rain
#> 2  Tue 30 2024-04-30       AM Showers   62  46               Rain
#> 3  Wed 01 2024-05-01           Cloudy   64  47               Rain
#> 4  Thu 02 2024-05-02    Mostly Cloudy   71  48               Rain
#> 5  Fri 03 2024-05-03           Cloudy   68  45               Rain
#> 6  Sat 04 2024-05-04    Mostly Cloudy   68  45               Rain
#> 7  Sun 05 2024-05-05          Showers   66  49               Rain
#> 8  Mon 06 2024-05-06    Partly Cloudy   73  51               Rain
#> 9  Tue 07 2024-05-07    Partly Cloudy   72  49               Rain
#> 10 Wed 08 2024-05-08    Partly Cloudy   69  46               Rain
#> 11 Thu 09 2024-05-09          Showers   65  49               Rain
#> 12 Fri 10 2024-05-10    Mostly Cloudy   67  47               Rain
#> 13 Sat 11 2024-05-11    Partly Cloudy   68  48               Rain
#> 14 Sun 12 2024-05-12          Showers   67  46               Rain
#> 15 Mon 13 2024-05-13          Showers   66  47               Rain
#>    Precipitation Chance Wind Direction Wind Speed        City         State
#> 1                     4            NNE          8 Northampton Massachusetts
#> 2                    57             SE          8 Northampton Massachusetts
#> 3                    24            ENE          5 Northampton Massachusetts
#> 4                    16            SSW          7 Northampton Massachusetts
#> 5                    12            ENE          8 Northampton Massachusetts
#> 6                    13             SE          8 Northampton Massachusetts
#> 7                    51              S          9 Northampton Massachusetts
#> 8                    20            WSW         10 Northampton Massachusetts
#> 9                    24              W         11 Northampton Massachusetts
#> 10                   20             NW         10 Northampton Massachusetts
#> 11                   52             NW         10 Northampton Massachusetts
#> 12                   24            WNW          9 Northampton Massachusetts
#> 13                   24             NW         10 Northampton Massachusetts
#> 14                   51             NW         10 Northampton Massachusetts
#> 15                   51             NW         10 Northampton Massachusetts

noho_past <- past_days(city = "northampton", 
                       state ="massachusetts", 
                       zip = "01060")
print(noho_past)
#>           City State  High   Low       Date Precipitation
#> 1  Northampton    MA 33.80 33.62 2024-04-04         0.000
#> 2  Northampton    MA 44.06 29.84 2024-04-05         0.002
#> 3  Northampton    MA 46.94 35.42 2024-04-06         0.000
#> 4  Northampton    MA 53.06 31.10 2024-04-07         0.000
#> 5  Northampton    MA 66.20 27.14 2024-04-08         0.000
#> 6  Northampton    MA 73.40 35.60 2024-04-09         0.000
#> 7  Northampton    MA 66.92 42.80 2024-04-10         0.024
#> 8  Northampton    MA 60.80 46.94 2024-04-11         0.130
#> 9  Northampton    MA 63.50 52.88 2024-04-12         0.530
#> 10 Northampton    MA 52.88 44.42 2024-04-13         0.016
#> 11 Northampton    MA 59.00 42.44 2024-04-14         0.046
#> 12 Northampton    MA 71.96 37.40 2024-04-15         0.000
#> 13 Northampton    MA 67.46 34.70 2024-04-16         0.000
#> 14 Northampton    MA 62.06 35.78 2024-04-17         0.001
#> 15 Northampton    MA 46.40 42.98 2024-04-18         0.262
#> 16 Northampton    MA 62.06 43.34 2024-04-19         0.000
#> 17 Northampton    MA 62.78 43.70 2024-04-20         0.182
#> 18 Northampton    MA 50.00 32.36 2024-04-21         0.000
#> 19 Northampton    MA 57.02 30.74 2024-04-22         0.000
#> 20 Northampton    MA 65.66 28.22 2024-04-23         0.000
#> 21 Northampton    MA 62.96 39.02 2024-04-24         0.003
#> 22 Northampton    MA 56.66 31.10 2024-04-25         0.000
#> 23 Northampton    MA 60.80 28.22 2024-04-26         0.000
#> 24 Northampton    MA 64.76 33.26 2024-04-27         0.013
#> 25 Northampton    MA 67.46 42.80 2024-04-28         0.311
#> 26 Northampton    MA 60.80 51.80 2024-04-29         0.000
```

You can also plot the precipitation or the high/low temperatures using
functions from this package:

``` r
hi_lo_past <-  to_hi_lo_temp(weather_data(noho_past))

plot(hi_lo_past)
```

<img src="man/figures/README-weather-1.png" width="100%" />
