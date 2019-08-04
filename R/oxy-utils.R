lst_transpose <- function(l){
  lapply(seq_along(l[[1]]),
         function (i) sapply(l, "[", i))
}

bbox_to_bbm <- function(bbox){
  bb_lst <- lapply(strsplit(bbox, ",\\s?|\\s+"), as.numeric)
  do.call(rbind, bb_lst)
}

bbm_to_abm <- function(m){
  slope <- (m[,4]-m[,2])/(m[,3]-m[,1])
  intercept <- m[,2]-slope*m[,1]
  cbind(slope=slope,
        intercept=intercept)
}

bbm_to_angle <- function(m, m2=NULL){
  slope <- (m[,4]-m[,2])/(m[,3]-m[,1])
  if(is.null(m2)) return(atan(slope)*180/pi)
  slope2 <- (m2[,4]-m2[,2])/(m2[,3]-m2[,1])
  atan(abs((slope2-slope)/(1+slope*slope2)))*180/pi
}

# used for image_canvas_hex and image_canvas_hexborder
plot_ggforce_hex <- function(color, size, fill){
  p <- ggplot2::ggplot() +
    ggforce::geom_regon(ggplot2::aes(x0 = 100, y0 = 100, sides = 6,
                            angle = pi/2, r = 100),
                        color=color, fill=fill, size=size) +
    ggplot2::coord_fixed()+
    ggplot2::theme_void()

  hex_temp_file <- tempfile()

  ggplot2::ggsave(hex_temp_file, p, device="png", width=7, height = 7, dpi=300)

  hex_image <- magick::image_read(hex_temp_file)
  unlink(hex_temp_file)

  hex_image
}
