#' Move file to download export directory
#'
#' @param filepath path of file
#'
#' @return nothing
#' @export
#'
#' @examples
move_to_download_dir <- function(filepath) {
  fs::file_move(filepath, "~/sasdata1/download/")
}
