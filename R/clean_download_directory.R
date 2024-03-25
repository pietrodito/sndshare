#'@export
clean_download_directory <- function() {
  cli::cli_h1("Nettoyage du répertoire {.emph download}")
  download_dir <- "~/sasdata1/download/"
  files <- list.files("~/sasdata1/download/")
  n_files <- length(files)
  if(n_files == 0) {
    cli::cli_alert_warning("Le répertoire {.emph download} est vide.")
  } else {
    cli::cli_alert_warning("{n_files} fichier{?s} à supprimer : ")
    print(files)
    cli::cli_alert_danger("Voulez-vous poursuivre ? ")
    askYesNo("> ", default = FALSE)
    file.remove(paste0(download_dir, files))
    cli::cli_alert_success("{n_files} fichier{?s} supprimé{?s}")
  }
}

