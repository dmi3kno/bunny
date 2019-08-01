#' @title Drop matte layer
#' @description Easily remove alpha/opacity/matter layer from image
#' @param image image with opacity
#' @return image without opacity layer
#'
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @rdname image_alpha
#' @importFrom magick image_info image_convert
#' @export
image_alpha_drop <- function(image){
  ii <- magick::image_info(image)
  if(ii$matte)
    image <- magick::image_convert(image, matte=FALSE)
  image
}

#' @title Copy or reset a selected channel
#' @description Copy a content of a selected channel from another image or reset a selected channel to black
#' @param image image
#' @param channel channel name
#' @return image with modified channel
#'
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @importFrom magick image_threshold
#' @rdname image_channel_set
#' @export
image_channel_reset <- function(image, channel){
 ## image_fx(image, "0 +channel", channel) # alternative (slower)
 image_threshold(image, "black", threshold = "101%", channel = channel)
#image_threshold(image, "white", threshold = "-1", channel = channel) #for "Black" channel
}

#' @param channel_image image containing channel to copy from
#' @importFrom magick image_composite
#' @rdname image_channel_set
#' @export
image_channel_copy <- function(image, channel, channel_image){
   df <- data.frame(channel = c("C", "Cyan", "M", "Magenta", "K",
                          "Black", "R", "Red", "G", "Green",
                          "B", "Blue", "A", "Alpha", "Matte",
                          "O", "Opacity", "4"),
             copy_operator = c("CopyCyan", "CopyCyan", "CopyMagenta", "CopyMagenta", "CopyBlack",
                  "CopyBlack", "CopyRed", "CopyRed", "CopyGreen", "CopyGreen",
                  "CopyBlue", "CopyBlue", "CopyOpacity", "CopyOpacity", "CopyOpacity",
                  "CopyOpacity", "CopyOpacity", "CopyOpacity"), stringsAsFactors = FALSE)

  copy_operator <- df[df$channel==channel, "copy_operator"]
  magick::image_composite(image, channel_image, operator=copy_operator)
}



#' @title Combine or separate channel images
#' @description Split image by channel, creating a stack of images or combine a stack of grayscale images into a full color image
#' @param image image stack (for `image_channel_combine()`) or individual image (for `image_channel_separate()`)
#' @param channel_index character vector with channel names (or abbreviation). Default: 'RGB'. Images in the stack will be interpreted as set of channels in the specified sequence.
#' @param canvas image to be used as canvas to start copying channels into, Default: NULL
#' @return single (flat) image with channels copied from the image stack
#'
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @importFrom magick image_info image_channel image_blank image_convert
#' @rdname image_channels
#' @export
image_channel_combine <- function(image, channel_index="RGB", canvas=NULL){
  ii <- magick::image_info(image)

  if(length(channel_index)==1) channel_index <- strsplit(channel_index, "")[[1]]

  if(length(channel_index)!=nrow(ii)){
    warning("I did not get that. Channel specification is not matching number of images you provided.")
    return(image)
    }

  if(length(unique(ii$width))!=1L || length(unique(ii$height))!=1L) {
    warning("Dimensions of images are not matching. Could you please trim them and try again?")
    return(image)
    }


  if(all(channel_index %in% c("Red", "R", "Green", "G", "Blue", "B"))){
    if (is.null(canvas))
      canvas <- magick::image_blank(ii$width[1], ii$height[1], "white")
    for(i in seq_along(channel_index))
      canvas <- image_channel_copy(canvas, channel_index[i], channel_image=image[i])
    return(canvas)
  }

  if(all(channel_index %in% c("Cyan", "C", "Magenta", "M", "Yellow", "Y", "Black", "3", "K"))){
    if (is.null(canvas))
      canvas <- magick::image_convert(magick::image_blank(ii$width[1], ii$height[1], "white"), colorspace = "CMYK")
    for(i in seq_along(channel_index))
      canvas <- image_channel_copy(canvas, channel_index[i], channel_image=image[i])
    return(canvas)
  }

  warning("Hmmm. Some of these channels look new to me. Could you please, look at them again?")
  image
}


#' @rdname image_channels
#' @importFrom magick image_info image_channel
#' @export
image_channel_separate <- function(image){
    ii <- magick::image_info(image)
    if(nrow(ii)==1L){
    df <- data.frame(colorspace = c("RGB", "scRGB", "sRGB", "CMY", "CMYK"),
          channel_index = c("RGB", "RGB", "RGB", "CMY", "CMYK"), stringsAsFactors = FALSE)
    channel_index <- df[df$colorspace == ii$colorspace, "channel_index"]
    if(is.na(channel_index)){
      warning("Can not separate image in this colorspace. Only RGB and CMYK are separatable")
      return(image)
      }
    channel_index <- strsplit(channel_index, "")[[1]]
    if(ii$matte)
      channel_index <- c(channel_index, "O")
    lst <- list()
    for(i in seq_along(channel_index))
      lst[[i]] <- magick::image_channel(image, channel=channel_index[i])
    image <- Reduce(c, lst)
    }
  image
}
