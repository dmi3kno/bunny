
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bunny <img src="man/figures/logo.png" align="right" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of `bunny` is to provide useful helper functions for working
with `magick`.

## Installation

You can install the released version of bunny from
[Github](https://www.github.com) with:

``` r
#install.packages("bunny") # not yet
remotes::install_github("dmi3kno/bunny")
```

## Pixel operations

This is a basic example which shows you how to solve a common problem:

``` r
library(magick)
library(bunny)

## basic example code
frink <- image_read("https://jeroen.github.io/images/frink.png")
image_getpixel(frink, geometry_point(100,100))
#> [1] "#ffd521ff"
```

Other than extracting color from individual pixels, `bunny` can also
draw on images:

``` r
frink <- image_read("https://jeroen.github.io/images/frink.png")
image_plot(frink, geometry_area(50,35,80,150), "red")
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="20%" />

``` r
image_plot(frink, geometry_point(70,70), "red")
```

<img src="man/figures/README-unnamed-chunk-2-2.png" width="20%" />

## Hough lines operations

`bunny` can help you tidy up the Hough Lines mvg object, returned by
`magick::image_hough_txt()`. Lets detect straight lines in the `bunny`
logo.

``` r
img <- image_read("data-raw/bunny_hex.png") 

img_prep <- img %>% image_convert(type="Grayscale") %>% 
  image_threshold("black") %>% 
  image_canny() %>% 
  image_morphology("Close", "Diamond")

img_prep %>% 
  image_hough_draw(geometry="50x50+200",overlay = TRUE)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="20%" />

Hough Lines are retuned in plain text object (`mvg` format). Let’s tidy
up that text and make it more suitable for analysis.
`bunny::tidy_hough_mvg()` returns a list, which, among other things
contains data frame describing lines and another data frame describing
line intersections.

``` r
hough <- img_prep %>% 
  image_hough_txt(geometry="50x50+200") %>% 
  tidy_hough_mvg()

hough$lines_data
#>   line_id               line_bbox line_plength line_slope line_intercept
#> 1  line_1 0 298.623 1042 -302.976          598 -0.5773503        298.623
#> 2  line_2          0.5 0 0.5 1200          607        Inf           -Inf
#> 3  line_3 0 -301.821 1042 299.778          597  0.5773503       -301.821
#> 4  line_4    1040.5 0 1040.5 1200          605        Inf           -Inf
#> 5  line_5  0 1500.67 1042 899.067          598 -0.5773541       1500.670
#> 6  line_6  0 900.222 1042 1501.82          597  0.5773493        900.222
#>   line_angle
#> 1  -30.00000
#> 2   90.00000
#> 3   30.00000
#> 4   90.00000
#> 5  -30.00017
#> 6   29.99996
hough$xsect_data
#>    line_id_1 line_id_2   xsect_x   xsect_y xsect_angle
#> 1     line_1    line_2    0.5000  298.3343         NaN
#> 2     line_1    line_3  519.9997   -1.5990    60.00000
#> 9     line_2    line_6    0.5000  900.5107         NaN
#> 10    line_3    line_4 1040.5000  298.9120         NaN
#> 13    line_4    line_5 1040.5000  899.9330         NaN
#> 15    line_5    line_6  520.0019 1200.4448    60.00013
```

Stay tuned for more exciting functions…
