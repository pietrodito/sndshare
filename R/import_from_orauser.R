#' Import directory form base64-encoded Oracle table
#'
#' @param TABLE_NAME oracle table
#' @param dest_path destination path
#'
#' @return
#' @export
#'
#' @examples
import_from_orauser <- function(TABLE_NAME, dest_path = ".") {

  library(ROracle, quietly = TRUE)
  fs::dir_create(glue::glue(".{tempdir()}"))
  csv_tmp_path <- glue::glue(".{tempfile()}.csv")
  withr::defer(fs::file_delete(csv_tmp_path))

  oracle_2_csv_tmp_file(TABLE_NAME, csv_tmp_path)

  import_from_csv(csv_tmp_path, dest_path)
}

oracle_2_csv_tmp_file <- function(TABLE_NAME, csv_tmp_path) {
  cat("Connecting to ORACLE... \n")
 (
   "Oracle"
   %>% DBI::dbDriver()
   %>% DBI::dbConnect(dbname  = "IPIAMPR2.WORLD")
   %>% dplyr::tbl(TABLE_NAME)
   %>% dplyr::collect()
   %>% readr::write_csv(csv_tmp_path)
   %>% invisible()
 )
}

