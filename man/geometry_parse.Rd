% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/oxy-geometry.R
\name{geometry_parse}
\alias{geometry_parse}
\alias{geometry_paste}
\title{Convert geometry string to matrix or matrix to geometry string}
\usage{
geometry_parse(x)

geometry_paste(x)
}
\arguments{
\item{x}{input, vector or matrix}
}
\value{
matrix or vector.
}
\description{
Smooth transition between matrix and text representation of magick geometries
}
\details{
For single entry into `geometry_paste()`, you can also provide numeric vector with width, heigh, x_off and y_off values.
}
\examples{
\dontrun{
if(interactive()){
 geometry_parse(c("100x200+12+14", "100x200", "+12+14", "x200+12+14"))
 geometry_paste(c(100,200,12,14))
 }
}
}
