#' @title Combine two images together using operators, gravity and offset
#' @description Extends `image_composite()` to include `gravity` argument which allows targeted placement of images
#' @param image original image which will remain in the background (also known as "destination" image)
#' @param composite_image image place on top of it (aslo known as "source" image)
#' @param operator magick operator. See more at [ImageMagick compose](https://www.imagemagick.org/Usage/compose/) page. Default: 'atop'
#' @param gravity one of `magick::gravity_types()`.  Default: 'NorthWest'
#' @param offset geometry point specification of offset. Affected by choice of `gravity`. Default: '+0+0'
#' @param compose_args other parameters required by operator. Default: ''
#' @return combined image
#'
#' @examples
#' \dontrun{
#' if(interactive()){
#'  frink <- image_read("https://jeroen.github.io/images/frink.png")
#'  image_compose(frink, magick::rose, gravity="North")
#'  }
#' }
#' @seealso
#'  \code{\link[magick]{attributes}},\code{\link[magick]{composite}}
#'  \code{\link[bunny]{geometry_parse}}
#' @rdname image_compose
#' @importFrom magick image_info image_composite
#' @export
image_compose <- function(image, composite_image, operator = "atop",
                          gravity="NorthWest", offset = "+0+0", compose_args = ""){
  ii <- magick::image_info(image)
  iic <- magick::image_info(composite_image)
  geom <- bunny::geometry_parse(offset)[1,]
  gravity_df <- data.frame(gravity=c("center", "east", "west",
                       "north", "northeast", "northwest",
                       "south", "southeast", "southwest"),
             x_adj=c(0.5,  1,  0,0.5, 1, 0,0.5, 1, 0),
             x_sign=c(1,  -1,  1,  1,-1, 1, 1,-1, 1),
             y_adj=c(0.5,0.5,0.5,  0, 0, 0, 1, 1, 1),
             y_sign=c(1,   1,  1,  1, 1, 1,-1,-1,-1),
             stringsAsFactors = FALSE)
gravity_values <- gravity_df[gravity_df$gravity==tolower(gravity), ]

x_adj <- gravity_values$x_adj
x_sign <- gravity_values$x_sign
y_adj <- gravity_values$y_adj
y_sign <- gravity_values$y_sign

off_x <- (ii$width * x_adj - iic$width * x_adj)+x_sign*geom[3]
off_y <- ii$height * y_adj - iic$height * y_adj+y_sign*geom[4]

offset <- bunny::geometry_paste(c(NA, NA, off_x, off_y))

magick::image_composite(image=image, composite_image=composite_image,
                operator = operator, offset=offset, compose_args = compose_args)
}

