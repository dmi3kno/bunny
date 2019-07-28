
#' @title Determine anticipated footprint of annotation
#' @description Calculate space taken by every latter in annotation
#' @param text proposed text for annotation
#' @param size text size. Default: 10
#' @param font text font to be passed to `image_annotate()`. Default: ''
#' @param style font style to be passed to `image_annotate()` (e.g. "normal", "italic", "oblique").  Default: 'normal'
#' @param weight font weight. Normal is 400, bold is 700. Default: 400
#' @param ... currently ignored
#' @return data frame with measurements for every letter and the phrase in total
#' @details The purpose of this function is to calculate kerning between letters that fonts introduce on the fly. This can be helpful in designing custom kerning.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @importFrom magick image_blank image_annotate image_trim image_info
#' @rdname image_info
#' @export

image_annotate_info <- function(text, size=10, font="", style="normal",
                              weight=400, ...){

  measure_letter <- function(ltr, size, font, style, weight){
    canvas <- magick::image_blank(size*1.5*nchar(ltr), size*1.5*nchar(ltr), "transparent")
    ltr_img <- magick::image_annotate(canvas, text=ltr, size=size, font=font,
                              style=style, weight = weight, gravity = "northwest", boxcolor = "white")
    ltr_crop <- magick::image_trim(ltr_img)
    magick::image_info(ltr_crop)
  }
  ltrs <- strsplit(text, "")[[1]]
  ltr_lst <- lapply(ltrs, measure_letter, size=size, font=font,
                    style=style, weight=weight)
  ltr_df <- do.call(rbind, ltr_lst)
  ltr_df$letter <- ltrs
  # cumulative placing of letters
  ltrs_cum <- sapply(seq_along(ltrs), function(i) paste0(ltrs[1:i], collapse=""))
  ltr_lst_cum <- lapply(ltrs_cum, measure_letter, size=size, font=font,
                        style=style, weight=weight)
  ltr_cum_df <- do.call(rbind, ltr_lst_cum)
  # reverse cumulative placing of letters
  ltrs_rum <- sapply(seq_along(ltrs), function(i) paste0(ltrs[i:length(ltrs)], collapse=""))
  ltr_lst_rum <- lapply(ltrs_rum, measure_letter, size=size, font=font,
                        style=style, weight=weight)
  ltr_rum_df <- do.call(rbind, ltr_lst_rum)
  # composing the final dataframe

  ltr_df$width_cum <- ltr_cum_df[["width"]]
  ltr_df$kerning <- c(0, diff(ltr_df[["width_cum"]]-cumsum(ltr_df[["width"]])))

  ltr_df$width_rum <- ltr_rum_df[["width"]]
  ltr_df$width_rkern <- rev(c(0, diff( rev(ltr_df[["width_rum"]])- cumsum(rev(ltr_df[["width"]])) ) ))

  if(nrow(ltr_df)>=2)
    ltr_df$kerning[1:2] <- c(abs(ltr_df$width_rkern[1:2]-ltr_df$kerning[1:2]))
  ltr_df[, c("letter", "width", "height", "kerning")]
}
