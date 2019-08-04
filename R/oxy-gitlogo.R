#' Example Images
#'
#' Example images included with `bunny`:
#'
#'  - `github`: Github Logo, b/w, 512x500
#'  - `gitlab`: Gitlab Logo, b/w, 512x474
#'  - `bitbucket` : Bitbucket Logo, b/w, 512x512
#'
#' @rdname git_logo
#' @name git_logo
#' @aliases github gitlab bitbucket
#' @export github gitlab bitbucket
delayedAssign('github', magick::image_read(system.file("extdata", "github.png", package="bunny")))
delayedAssign('gitlab', magick::image_read(system.file("extdata", "gitlab.png", package="bunny")))
delayedAssign('bitbucket', magick::image_read(system.file("extdata", "bitbucket.png", package="bunny")))
