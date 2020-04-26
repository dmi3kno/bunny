#' @title Tidy up Hough Lines object
#' @description Create a list summarizing hough lines and their intersections
#' @param mvg Magick Vector Graphics object, as output by `magick::image_hough_txt(format='mvg')``
#' @param margin Allowed margin around the image for detection of line intersections. Default: 0.05
#' @return A list containing Hough Lines parameters used, number of lines and intersections detected, detailed data about lines and intersections.
#'
#' @examples
#' \dontrun{
#' if(interactive()){
#'  if(magick_config()$version > "6.8.9"){
#'    shape <- demo_image("shape_rectangle.gif")
#'    rectangle <- image_canny(shape)
#'    rectangle %>% image_hough_txt(format = 'mvg') %>% tidy_hough_mvg()
#'    }
#'  }
#' }
#' @rdname tidy_hough_mvg
#' @importFrom stats setNames
#' @importFrom utils combn
#' @export

tidy_hough_mvg <- function(mvg, margin=0.05){
  h_vec <- strsplit(mvg, "\\n")[[1]]
  txt <- h_vec[-1:-2]
  txt1 <- gsub("^line ", "",txt)
  txt2 <- gsub(",", " ", txt1)
  txt3 <- gsub("^# ", "", txt2)
  lst3 <- strsplit(txt3, "\\s+#\\s")
  lst4_nms <- strsplit(lst3[[1]], " ")
  lst4 <- lst_transpose(lst3[-1])
  lst4_2_chr <- strsplit(lst4[[2]]," ")
  lst4_2_num <- lapply(lst4_2_chr, as.numeric)
  lst4_2_df <- as.data.frame(Reduce(rbind, lst4_2_num), row.names = FALSE)
  lst4_2_dfn <- setNames(lst4_2_df, paste0("line_", lst4_nms[[2]]))
  #lst4_2_dfn$line_id <- line_id

  hough_geom <- gsub("^# Hough line transform: ", "", h_vec[1])
  view_bbox <- gsub("^viewbox ","",h_vec[2])
  view_bbm <- bbox_to_bbm(view_bbox)
  ii_width <- view_bbm[,3]-view_bbm[,1]
  ii_height <- view_bbm[,4]-view_bbm[,2]
  n_lines <- length(h_vec[-1:-2])

  line_id <- paste("line", seq_along(lst4[[1]]), sep = "_")
  line_bbox <- stats::setNames(lst4[[1]], line_id)

  #line_plength <- stats::setNames(as.numeric(lst4[[2]]), line_id)
  line_abm <- bbm_to_abm(bbox_to_bbm(lst4[[1]]))
  lines_df <- data.frame(line_id=line_id,
                         line_bbox=line_bbox,
                         line_slope=line_abm[,"slope"],
                         line_intercept=line_abm[,"intercept"],
                         stringsAsFactors = FALSE, row.names = NULL)
  lines_df <- cbind(lines_df, lst4_2_dfn)
  ##### intersections ########
  xsect_comb <- t(utils::combn(lines_df$line_id,2))

  hl_intersection <- function(m1, m2, line_id_1, line_id_2){
    t_num <- (m1[,1]-m2[,1])*(m2[,2]-m2[,4])-(m1[,2]-m2[,2])*(m2[,1]-m2[,3])
    t_denom <- (m1[,1]-m1[,3])*(m2[,2]-m2[,4])-(m1[,2]-m1[,4])*(m2[,1]-m2[,3])
    x <- m1[,1]+t_num/t_denom*(m1[,3]-m1[,1])
    y <- m1[,2]+t_num/t_denom*(m1[,4]-m1[,2])
    data.frame(line_id_1=line_id_1,
               line_id_2=line_id_2,
               xsect_x=x, xsect_y=y, stringsAsFactors = FALSE)
  }

  # this relies on character vector name subsetting
  xsect_df <- hl_intersection(bbox_to_bbm(line_bbox[ xsect_comb[,1] ]),
                              bbox_to_bbm(line_bbox[ xsect_comb[,2] ]),
                              line_id_1=xsect_comb[,1],
                              line_id_2=xsect_comb[,2])
  xsect_df$xsect_angle <- bbm_to_angle(bbox_to_bbm(line_bbox[ xsect_comb[,1] ]),
                                       bbox_to_bbm(line_bbox[ xsect_comb[,2] ]) )
  xsect_df <- with(xsect_df, xsect_df[xsect_x<=ii_width*(1+margin) &
                                      xsect_x>=-(ii_width*margin) &
                                      xsect_y<=ii_height*(1+margin) &
                                      xsect_y>=-(ii_height*margin), ])


  list(
    hough_geom=hough_geom,
    view_bbox=view_bbox,
    n_lines=n_lines,
    n_xsect=nrow(xsect_df),
    lines_data=lines_df,
    xsect_data = xsect_df
  )
}
