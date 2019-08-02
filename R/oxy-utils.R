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
