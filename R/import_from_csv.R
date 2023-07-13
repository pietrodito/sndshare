#' Import encoded directory from csv
#'
#' @param csv_path path of csv file
#' @param dest_path path of destination directory
#'
#' @return nothing
#' @export
#'
#' @examples
import_from_csv <- function(csv_path,
                            dest_path = ".",
                            project_name = NULL,
                            open_project = TRUE ) {

  zip_tmp_path <- glue::glue("{dest_path}/tmp_decoded_file.zip")
  withr::defer(fs::file_delete(zip_tmp_path))
  withr::defer(fs::file_delete("./tmp/"))

  decode_base64_csv_file(csv_path, zip_tmp_path)

  if(is.null(project_name)){
    project_name <- stringr::str_remove(basename(csv_path), "\\.csv")
  }
  project_path <- paste0(normalizePath(dest_path), "/", project_name)

  unzip_decoded_file(zip_tmp_path, dest_path)
  if(fs::dir_exists(project_path)) {
    cat("Directory is ready in ", project_path, "\n")
    fs::file_delete(csv_path)
    if(open_project) rstudioapi::openProject(project_path)
  } else {
    warning("Import has failed!")
  }
}

remove_csv_header <- function(csv_path, csv_without_header_path) {
  shell_command <- glue::glue(
    "tail -n +2 {csv_path} > {csv_without_header_path}")
  system(shell_command, intern = TRUE)
}

decode_base64_csv_file <- function(csv_path, zip_tmp_path) {

  shell_command <- glue::glue("base64 -d {csv_path} > {zip_tmp_path}")
  system(shell_command)
}

unzip_decoded_file <- function(zip_tmp_path, dest_path) {
  shell_command <- glue::glue("cd {dest_path}; unzip -o {zip_tmp_path}")
  system(shell_command, intern = TRUE)
  invisible()
}
