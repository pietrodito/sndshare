#'@export
download_directory_content <- function(with_heading = TRUE) {
  if(with_heading) {
    cli::cli_h1("Contenu du répertoire {.emph download}")
  }
  download_dir <- "~/sasdata1/download/"
  files <- list.files("~/sasdata1/download/")
  n_files <- length(files)
  filenames_to_return <- NULL
  if(n_files == 0) {
    cli::cli_alert_warning("Le répertoire {.emph download} est vide.")
  } else {
    (
      download_dir
      |> fs::dir_info()
      |> dplyr::mutate(path = basename(path))
      |> dplyr::select(c(1, 3, 5))
      |> as.data.frame()
    ) -> file_info
    print(file_info)
    filenames_to_return <- dplyr::pull(file_info, path)
  }
  invisible(filenames_to_return)
}
