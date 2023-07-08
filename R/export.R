#' Zip, encode a directory and then publish it to download location
#'
#' @param dir_path
#'
#' @return
#' @export
#'
#' @examples
export <- function(dir_path = ".") {
  assertthat::is.dir(dir_path)

  dwnld_dir <- "~/sasdata1/download/"
  assertthat::is.dir(dwnld_dir)

  dir_path <- normalizePath(dir_path)
  dir_name <- basename(dir_path)

  cat(paste0("Packaging directory: ", dir_path, "\n"))

  pwd <- getwd()
  parent_dir <- stringr::str_remove(dir_path, dir_name)
  if(stringr::str_length(parent_dir) == 0) parent_dir <- "."
  setwd(parent_dir)
  withr::defer(setwd(pwd))

  csv_file <- glue::glue("{dir_name}.csv")
  dir_to_csv(dir_name, csv_file)

  cat("SUCCESS! ")
  cat(paste0(csv_file, " is now ready in ", dwnld_dir, "\n"))
  move_to_download_dir(csv_file)
}
