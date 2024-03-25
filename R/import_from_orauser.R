#' Import directory form base64-encoded Oracle table
#'
#' @param TABLE_NAME oracle table name with one base64-encoded column
#' @param dest_path path of destination directory
#' @param open_project logical.
#'
#' @return nothing
#' @export
#'
#' @examples
#'import_from_orauser(PACKAGE_TABLE_NAME)
import_from_orauser <- function(TABLE_NAME,
                                dest_path = ".",
                                open_project = TRUE) {

  library(ROracle, quietly = TRUE)

  fs::dir_create(glue::glue(".{tempdir()}"))
  csv_tmp_path <- glue::glue(".{tempfile()}.csv")
  project_name <- stringr::str_to_lower(TABLE_NAME)
  project_path <- paste0(dest_path, "/", project_name)
  withr::defer(fs::dir_delete("./tmp/"))

  oracle <- oracle_connection()
  oracle_2_csv_tmp_file(TABLE_NAME, csv_tmp_path, oracle)

  import_success <- TRUE
  tryCatch(
    import_from_csv(
      csv_tmp_path,
      dest_path,
      project_name,
      open_project = FALSE
    ),
    warning = function(w)
      import_success <<- FALSE
  )

  if (import_success) {
    DBI::dbRemoveTable(oracle, TABLE_NAME)
    cli::cli_alert_success("La table ORAUSER.{TABLE_NAME}, a été supprimée.")
    if (open_project) {
      rstudioapi::openProject(project_path)
    }
  }
}

oracle_connection <- function() {
  DBI::dbConnect(DBI::dbDriver("Oracle"),
                 dbname  = "IPIAMPR2.WORLD")
}

oracle_2_csv_tmp_file <- function(TABLE_NAME, csv_tmp_path, oracle) {
  cli::cli_alert_info("Connexion à ORACLE... \n")
  (
    oracle
    %>% dplyr::tbl(TABLE_NAME)
    %>% dplyr::collect()
    %>% readr::write_csv(csv_tmp_path, col_names = FALSE)
    %>% invisible()
  )
}
