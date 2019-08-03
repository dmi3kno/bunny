#' @title Empty canvas from existing image or specified dimensions
#' @description Extends `magick::image_blank()` to allow creating blank image with or without manually specifying width and height. If specimen image is provided dimensions will be copied from it.
#' @param image existing image to copy dimensions from (content will be discarded)
#' @param color color of the blank image. Default: 'transparent'
#' @param width canvas width
#' @param height canvas width
#' @param units one of "in", "cm" or "px". Default="px".
#' @param dpi specification of density (required for any `units` other than "px"). Default = 96
#' @param pseudo_image name of the pseudo-image. Default: ""
#' @return blank image of given dimensions
#'
#' @examples
#' \dontrun{
#' if(interactive()){
#'  frink <- image_read("https://jeroen.github.io/images/frink.png")
#'  image_canvas(frink, "pink")
#'
#'  # will produce 504x360 canvas
#'  image_canvas(width=7, height=5, units="in", dpi=72, color="burlywood")
#'  # will produce 800x600 canvas
#'  image_canvas(width=800, height=600, color="cornsilk")
#'
#'  # will produce 377x566 canvas
#'  image_canvas(width=10, height=15, units="cm", dpi=96, color="aliceblue")
#'  }
#' }
#' @rdname image_info
#' @importFrom magick image_info image_blank
#' @export

image_canvas <- function(image=NULL, color="transparent", width=NULL, height=NULL, units="px", dpi=96, pseudo_image=""){
  if(!is.null(image)){
    ii <- magick::image_info(image)
    width <- ii$width
    height <- ii$height
  } else {
    a <- switch (units,
      px = 1,
      cm = dpi/2.54,
      "in" = dpi
    )
    width <- width * a
    height <- height * a

    if(is.null(width) || is.null(height)){
      suffix <- "!"
      err_message <- "Please, provide specimen image or specify canvas dimenstions"
      if (units!="px")
        suffix <- "and dpi!"
      stop(paste(err_message, suffix),call. = FALSE)
    }
  }

  magick::image_blank(width, height, color = color, pseudo_image = pseudo_image)
}
