#' Zip, encode a directory and then publish it to download location
#'
#' @param dir_path
#'
#' @return NULL
#' @export
#'
#' @examples
#' export()
export <- function(dir_path = ".", verbose = FALSE) {
  assertthat::is.dir(dir_path)

  dwnld_dir <- "~/sasdata1/download/"
  assertthat::is.dir(dwnld_dir)

  dir_path <- normalizePath(dir_path)
  dir_name <- basename(dir_path)

  cli::cli_h1("Export du réportoire {.emph {dir_name}}")
  cli::cli_alert_info("Prépare le répertoire : {.emph {dir_path}}")

  pwd <- getwd()
  parent_dir <- stringr::str_remove(dir_path, dir_name)
  if(stringr::str_length(parent_dir) == 0) parent_dir <- "."
  setwd(parent_dir)
  withr::defer(setwd(pwd))

  csv_file <- glue::glue("{dir_name}.csv")
  dir_to_csv(dir_name, csv_file, verbose = verbose)

  cli::cli_alert_success("Opération réussie ! ")
  cli::cli_h3(
    "{csv_file} est maintenant dans le répertoire suivant {dwnld_dir}")

  move_to_download_dir <- function(file) fs::file_move(file, dwnld_dir)

  move_to_download_dir(csv_file)
}

