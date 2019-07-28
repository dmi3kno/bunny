#' @title Empty canvas from existing image
#' @description Allows creating blank image without manually specifying width and height. These dimensions will be copied from the image passed as first argument.
#' @param img existing image to copy dimensions from (content will be discarded)
#' @param color color of the blank image. Default: 'transparent'
#' @param pseudo_image name of the pseudo-image. Default: ''
#' @return blank image of given dimensions
#'
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname image_info
#' @importFrom magick image_info image_blank
#' @export

image_canvas <- function(img, color="transparent", pseudo_image=""){
  ii <- magick::image_info(img)
  magick::image_blank(ii$width, ii$height, color = color, pseudo_image = pseudo_image)
}
