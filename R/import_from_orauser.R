#' Import directory form base64-encoded Oracle table
#'
#' @param TABLE_NAME oracle table name with one base64-encoded column
#' @param dest_path path of destination directory
#'
#' @return nothing
#' @export
#'
#' @examples
import_from_orauser <- function(TABLE_NAME,
                                dest_path = ".",
                                remove_table_oracle = TRUE) {
  library(ROracle, quietly = TRUE)
  fs::dir_create(glue::glue(".{tempdir()}"))
  csv_tmp_path <- glue::glue(".{tempfile()}.csv")

  oracle <- oracle_connection()
  project_name <- stringr::str_to_lower(TABLE_NAME)

  oracle_2_csv_tmp_file(TABLE_NAME, csv_tmp_path, oracle)

  import_has_failed <- F
  tryCatch(
    import_from_csv(
      csv_tmp_path,
      dest_path,
      project_name,
      open_project = FALSE
    ),
    warning = function(w)
      import_has_failed <<- T
  )
  if (!import_has_failed) {
    if(remove_table_oracle) {
      remove_oracle_table(TABLE_NAME, oracle)
    }
    project_path <- paste0(dest_path, "/", project_name)
    rstudioapi::openProject(project_path)
  }
}

oracle_connection <- function() {
  (
    "Oracle"
    %>% DBI::dbDriver()
    %>% DBI::dbConnect(dbname  = "IPIAMPR2.WORLD")
  )
}

oracle_2_csv_tmp_file <- function(TABLE_NAME, csv_tmp_path, oracle) {
  cat("Connecting to ORACLE... \n")
  (
    oracle
    %>% dplyr::tbl(TABLE_NAME)
    %>% dplyr::collect()
    %>% readr::write_csv(csv_tmp_path, col_names = FALSE)
    %>% invisible()
  )
}

remove_oracle_table <- function(TABLE_NAME, oracle) {
  DBI::dbRemoveTable(oracle, TABLE_NAME)
}
