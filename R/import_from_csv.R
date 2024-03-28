#' Import encoded directory from csv
#'
#' @param csv_path path of csv file
#' @param dest_path path of destination directory
#' @param open_project logical.
#'
#' @return nothing
#' @export
#'
#' @examples
#' import_from_csv (csv_path, dest_path)
import_from_csv <- function(csv_path,
                            dest_path = ".",
                            project_name = NULL,
                            open_project = TRUE,
                            verbose = TRUE) {

  zip_tmp_path <- glue::glue("{dest_path}/tmp_decoded_file.zip")
  if(is.null(project_name)){
    project_name <- stringr::str_remove(basename(csv_path), "\\.csv")
  }

  if(verbose) cli::cli_h1("Import du projet {.emph {project_name}}")

  project_path <- paste0(normalizePath(dest_path), "/", project_name)

  withr::defer(fs::file_delete(zip_tmp_path))

  decode_base64_csv_file(csv_path, zip_tmp_path)
  unzip_decoded_file(zip_tmp_path, dest_path)

  if(fs::dir_exists(project_path)) {
    cli::cli_alert_success("Le projet est prêt dans {project_path}")
    fs::file_delete(csv_path)
    if(open_project) rstudioapi::openProject(project_path)
  } else {
    cli::cli_alert_danger("La procédure d'import a échoué.")
  }
}

decode_base64_csv_file <- function(csv_path, zip_tmp_path) {
  shell_command <- glue::glue(
    "base64 -d {csv_path} > {zip_tmp_path}")
  system(shell_command)
}

unzip_decoded_file <- function(zip_tmp_path, dest_path) {
  shell_command <- glue::glue(
    "cd {dest_path}; unzip -o tmp_decoded_file.zip")
  system(shell_command, intern = TRUE)
  invisible()
}
