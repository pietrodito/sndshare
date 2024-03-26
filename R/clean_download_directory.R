#'@export
clean_download_directory <- function() {
  cli::cli_h1("Nettoyage du répertoire {.emph download}")
  download_dir <- "~/sasdata1/download/"
  files <- download_directory_content(with_heading = FALSE)

  if(! is.null(files)) {
    n_files <- length(files)
    cli::cli_alert_warning("{n_files} fichier{?s} à supprimer : ")
    cli::cli_alert_danger("Voulez-vous poursuivre ? ")
    if(askYesNo("> ", default = FALSE)) {
      file.remove(paste0(download_dir, files))
      cli::cli_alert_success("{n_files} fichier{?s} supprimé{?s}")
    }
  }
}

