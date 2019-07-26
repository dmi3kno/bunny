#' @title Draw a point or a rectangle on image
#' @description Draws pixel or rectangle on top of specified {magick} image
#' @param img magick image
#' @param geometry point or area geometry
#' @param col character value of color (either name or hex value), Default: 'green'
#' @param pointsize size of point, Default: 5
#' @param ... other parameters passed to `image_draw()`
#' @return magick image with drawing on it
#' @details Function makes distinction between drawing a point or drawing a rectangle only by the geometry. Use `geometry_point()` and `geometry_area()` to prepare and format geometries.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  frink <- image_read("https://jeroen.github.io/images/frink.png")
#'  image_plot(frink, geometry_area(50,35,80,150))
#'  image_plot(frink, geometry_point(70,70))
#'  }
#' }
#' @seealso
#'  \code{\link[magick]{device}}
#' @rdname image_plot
#' @export
#' @importFrom magick image_draw
#' @importFrom grDevices dev.off
#' @importFrom graphics points rect
#' @importFrom stats na.omit
image_plot<-function(img, geometry, col="green", pointsize=5, ...){
  res <- magick::image_draw(img, pointsize = pointsize, ...)
  geom <- stats::na.omit(as.numeric(strsplit(geometry, "x|\\+")[[1]]))
  if(grepl("x", geometry)){
    graphics::rect(geom[3], geom[4], geom[3]+geom[1], geom[4]+geom[2], border=col)
  } else{
    graphics::points(geom[1], geom[2], col=col)
  }
  grDevices::dev.off()
  res
}
