
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bunny <img src="man/figures/logo.png" align="right" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of **`bunny`** is to provide useful functions for working with
`{magick}` package.

## Installation

You can install the released version of bunny from
[Github](https://www.github.com) with:

``` r
#install.packages("bunny") # not yet
remotes::install_github("dmi3kno/bunny")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(bunny)
library(magick)
#> Linking to ImageMagick 6.9.7.4
#> Enabled features: fontconfig, freetype, fftw, lcms, pango, x11
#> Disabled features: cairo, ghostscript, rsvg, webp
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

Stay tuned for more exciting functions…
