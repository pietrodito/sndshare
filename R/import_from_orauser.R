# library(magrittr)
#
# import_from_orauser <- function(NOM_TABLE, dir_path = ".") {
#
#   library(ROracle)
#   fs::dir_create(glue::glue(".{tempdir()}"))
#   csv_tmp_path <- glue::glue(".{tempfile()}.csv")
#
#   zip_tmp_file <- glue::glue("{dir_path}/tmp_decoded_file.zip")
#
#   oracle_2_csv_tmp_file(NOM_TABLE, csv_tmp_path)
#
#   decode_base64_csv_file(csv_tmp_path, zip_tmp_file)
#
#   unzip_decoded_file(zip_tmp_file, dir_path)
# }
#
# oracle_2_csv_tmp_file <- function(NOM_TABLE, csv_tmp_path) {
#   cat("Connecting to ORACLE... \n")
#  (
#    "Oracle"
#    %>% DBI::dbDriver()
#    %>% DBI::dbConnect(dbname  = "IPIAMPR2.WORLD")
#    %>% dplyr::tbl(NOM_TABLE)
#    %>% dplyr::collect()
#    %>% readr::write_csv(csv_tmp_path, col_names = FALSE)
#    %>% invisible()
#  )
#   cat(glue::glue("csv file written to {csv_tmp_path}\n"))
# }
#
# decode_base64_csv_file <- function(csv_tmp_path, zip_tmp_file) {
#   shell_command <- glue::glue("base64 -d {csv_tmp_path} > {zip_tmp_file}")
#   system(shell_command)
# }
#
# unzip_decoded_file <- function(zip_tmp_file, dir_path) {
#   browser()
#   shell_command <- glue::glue("cd {dir_path}; unzip -o {zip_tmp_file}")
#   print(shell_command)
#   system(shell_command, intern = TRUE)
#   invisible()
# }
#
# import_from_orauser("SNDSHARE", "~/sasdata1/sasuser/tmp/")
#
