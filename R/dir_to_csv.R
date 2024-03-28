#' Zip and base64-encode a directory to a csv file
#'
#' @param dir_path directory to encode
#' @param csv_file_path csv output file path
#' @param exclude_dot_R TRUE to exclude .Rproj.user and others
#' @param return_zip_output TRUE to return vector with zip-file names
#'
#' @return nothing or vector with zip-file names
#'
#' @examples
#' dir_to_csv(dir_path, csv_file_path)
dir_to_csv <- function(dir_path,
                       csv_file_path,
                       exclude_dot_R = TRUE,
                       return_zip_output = FALSE,
                       verbose = FALSE) {

  check_args(dir_path, csv_file_path)

  tmp_zip_filename <- glue::glue("./{tempfile()}.zip")
  tmp_dir <- glue::glue("./{tempdir()}")
  fs::dir_create(tmp_dir)
  withr::defer(fs::dir_delete("./tmp/"))

  cli::cli_alert_info("Compression des fichiers au format {.emph zip}...\n")
    zip_output <- silent_zip_dir(tmp_zip_filename, dir_path,
                                 exclude_dot_R, verbose = verbose)
  cli::cli_alert_info("Le fichier zip est encodé en {.emph base64}.\n")
  encode_zip_file(tmp_zip_filename, csv_file_path)

  if(return_zip_output) zip_output else invisible()
}

check_args <- function(dir_path, csv_file_path) {
  assertthat::assert_that(assertthat::is.readable(fs::path(dir_path)))

  dir_name <- dirname(csv_file_path)
  assertthat::assert_that(assertthat::is.writeable(dir_name))

}

silent_zip_dir <- function(zipfile, dir, exclude_dot_R, verbose = FALSE) {

  silent <- ! verbose


  .exclude_data <- ' */data_NOT_EXPORTED/* '
  .exclude_dot_R <- ' "*/.R*" ".R*" '
  .exclude_dot_temp <- ' */.temp/* '

  if(! exclude_dot_R) .exclude_dot_R <- ""

  exclude_command <-
    glue::glue(" -x {.exclude_data} {.exclude_dot_R} {.exclude_dot_temp}")

  shell_command <- glue::glue("zip -r {zipfile} {dir} {exclude_command}")
  system(shell_command, intern = silent)
}

encode_zip_file <- function(tmp_zip_filename, csv_file_path) {
    shell_command <-
      glue::glue("base64 -w 76 {tmp_zip_filename} > {csv_file_path}")
    system(shell_command, intern = TRUE)
  }
