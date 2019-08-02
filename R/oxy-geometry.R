#' @title Convert geometry string to matrix or matrix to geometry string
#' @description Smooth transition between matrix and text representation of magick geometries
#' @param x input, vector or matrix
#' @return matrix or vector.
#' @details For single entry into `geometry_paste()`, you can also provide numeric vector with width, heigh, x_off and y_off values.
#' @examples
#' \dontrun{
#' if(interactive()){
#'  geometry_parse(c("100x200+12+14", "100x200", "+12+14", "x200+12+14"))
#'  geometry_paste(c(100,200,12,14))
#'  }
#' }
#' @rdname geometry_parse
#' @export

geometry_parse <- function(x){
  geom_pattern <- "^(?:(\\d+)?(?:x(\\d+))?)?(?:\\+?(\\-?\\d+)\\+?(\\-?\\d+))?$"
  m_lst <- lapply(regmatches(x, regexec(geom_pattern, x)), function(i) as.numeric(i[-1]))
  m <- do.call(rbind, m_lst)
  colnames(m) <- c("width", "height", "x_off", "y_off")
  m
}

#' @rdname geometry_parse
#' @export
geometry_paste <- function(x){
  if(is.null(dim(x)))
    dim(x) <- c(1,4)
  p2 <- ifelse(is.na(x[,3]) & is.na(x[,4]), "",
              paste0(sprintf("%+d", x[,3]), sprintf("%+d", x[,4])))
  p1 <- ifelse(is.na(x[,1]) & is.na(x[,2]),"",
               paste0(x[,1],"x",x[,2]))
  paste0(gsub("NA", "", p1), p2)
}


