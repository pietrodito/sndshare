# import_from_orauser <- function(NOM_TABLE, dir_path = ".") {
#   csv_tmp_path <- glue::glue("./{tempfile()}.csv")
#   oracle_2_csv_tmp_file(NOM_TABLE, csv_tmp_path)
# }
#
# oracle_2_csv_tmp_file <- function(NOM_TABLE, csv_tmp_path) {
#  (
#    "Oracle"
#    %>% DBI::dbDriver()
#    %>% DBI::dbConnect(dbname  = "IPIAMPR2.WORLD")
#    %>% dplyr::tbl(NOM_TABLE)
#    %>% collect()
#    %>% readr::write_csv(csv_tmp_path)
#  )
# }
#
# import_from_orauser("OUT")
