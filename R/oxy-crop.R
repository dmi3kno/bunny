#' @title Remove border from image
#' @description Reverse operation to `magick::image_border()` removing area aroud the image specified by area geometry
#' @param image original image
#' @param geometry geometry specified by area format, for example "10x10".
#' @return "shaved" image
#'
#' @examples
#' \dontrun{
#' if(interactive()){
#'  magick::rose %>%
#'  image_border() %>%
#'  image_shave("10x10")
#'  }
#' }
#' @seealso
#'  \code{\link[magick]{attributes}},\code{\link[magick]{transform}}
#' @rdname image_crop
#' @export
#' @importFrom magick image_info image_crop geometry_area
image_shave <- function(image, geometry){
  ii <- magick::image_info(image)
  pg <- geometry_parse(geometry)[1,]
  magick::image_crop(image, magick::geometry_area(ii$width-2*pg[1], ii$height-2*pg[2], pg[1], pg[2]))
}
