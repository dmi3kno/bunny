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


#' @title Make your own hex sticker
#' @description Produces canvas and border for assembling hex sticker
#' @param border_color color of the hex border. Default: 'black'
#' @param border_size border thickness. Default: 2
#' @param fill_color hex background. Default: 'azure'
#' @param outer_margin margin around the hex. May be helpful for making sure nothing gets trimmed. Default: '10x10'
#' @param scope logical. Add measurement grid to the center of the hex (similar to rifle scope).
#' @param scope_color color of the grid. Default "grey80".
#' @return image of hex canvas
#' @details Border around the sticker can be later trimmed either by the printing company or by `magick::image_trim()`. It is preferred to not choose white background or white border to prevent excessive trimming.
#' Requires `ggplot` and `ggforce` installed. `image_canvas_hexborder()` produces transparent hex with specified border color.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  image_canvas_hex()
#'  }
#' }
#' @seealso
#'  \code{\link[magick]{transform}},\code{\link[magick]{color}},\code{\link[magick]{attributes}},\code{\link[magick]{painting}}
#' @rdname image_canvas_hex
#' @export
#' @importFrom magick image_trim image_transparent image_info image_fill geometry_point
image_canvas_hex <- function(border_color="black", border_size=2, fill_color="azure", outer_margin="10x10", scope=FALSE, scope_color="grey80"){
  fill <- fill_color

  if(fill_color=="white" || fill_color=="#ffffff")
    fill <- "azure"

  hex_canvas <- plot_ggforce_hex(color=border_color, size=border_size, fill=fill, scope=scope, scope_color = scope_color)
  hex_canvas <- magick::image_trim(hex_canvas)
  hex_canvas <- magick::image_transparent(hex_canvas, "white")
  hex_canvas <- image_border(hex_canvas, color="transparent", geometry = outer_margin)

  if(fill_color=="white" || fill_color=="#ffffff"){
    ii <- magick::image_info(hex_canvas)
    hex_canvas <- magick::image_fill(hex_canvas, fill_color,
                                     magick::geometry_point(ii$width/2, ii$height/2), fuzz=10, refcolor=fill)
  }
  hex_canvas
}

#' @rdname image_canvas_hex
#' @export
#' @importFrom magick image_trim image_transparent image_info image_fill geometry_point
image_canvas_hexborder <- function(border_color="black", border_size=2, outer_margin="10x10"){
  color <- border_color
  if(border_color=="white" || border_color=="#ffffff")
    color <- "black"

  hex_border <- plot_ggforce_hex(color=border_color, size=border_size, fill="white")
  hex_border <- magick::image_trim(hex_border)
  hex_border <- magick::image_transparent(hex_border, "white", fuzz = 20)
  hex_border <- image_border(hex_border, color="transparent", geometry = outer_margin)

  if(border_color=="white" || border_color=="#ffffff"){
    ii <- magick::image_info(hex_border)
    hex_border <- magick::image_fill(hex_border, border_color,
                                     magick::geometry_point(1, ii$height/2), fuzz=0, refcolor=color)
  }
  hex_border
}


#' @title Make your own github card
#' @description Produces canvas for assembling github social media card of standard size
#' @param image completed gihub card to be complemented by border
#' @param border_color color of the border. Preferrably same as `fill_color`. Default: 'white'
#' @param fill_color background color of the card. Default: 'white'
#' @param width card width (including border). Default: 1280
#' @param height card height (including border). Default: 640
#' @param border border size (will be deducted from the canvas). Default: '80x80'
#' @return github card of specified dimensions
#' @details The card excludes borders to make sure you never have anything trimmed. Border can be added with `image_border_ghcard()`, which is just a thin wrapper over `magick::image_border()`
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname image_canvas_ghcard
#' @export
#' @importFrom magick image_blank
image_canvas_ghcard <- function(fill_color="white", width=1280, height=640, border="80x80"){
  ghcard <- magick::image_blank(width, height, color=fill_color)
  image_shave(ghcard, border)
}

#' @rdname image_canvas_ghcard
#' @export
#' @importFrom magick image_border
image_border_ghcard <- function(image, border_color="white", border="80x80"){
  magick::image_border(image, color= border_color, geometry = border)
}
