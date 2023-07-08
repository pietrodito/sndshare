dir_to_txt <- function(dir_path,
                       txt_file_path,
                       encoding_scheme = c("base64", "xxd"),
                       exclude_dot_R = TRUE,
                       return_zip_output = FALSE) {

  check_args(dir_path, txt_file_path, encoding_scheme)

  tmp_zip_filename <- glue::glue("./{tempfile()}.zip")
  tmp_dir <- glue::glue("./{tempdir()}")
  fs::dir_create(tmp_dir)
  withr::defer(fs::dir_delete("./tmp/"))

  zip_output <- silent_zip_dir(tmp_zip_filename, dir_path, exclude_dot_R)
  encode_zip_file(encoding_scheme, tmp_zip_filename, txt_file_path)
  if(return_zip_output) zip_output else invisible()
}


check_args <- function(dir_path,
                       txt_file_path,
                       encoding_scheme = c("base64", "xxd")) {
  assertthat::on_failure(is_available_encoding_scheme) <-
    function(call, env) {
      scheme <- get(rlang::expr_deparse(call$encoding_scheme), env)
      paste0("'encoding_scheme' is \"",
             scheme,
             "\" and must be equal to \"base64\" or \"xxd\"")
    }

  assertthat::assert_that(assertthat::is.readable(fs::path(dir_path)))

  dir_name <- dirname(txt_file_path)
  assertthat::assert_that(assertthat::is.writeable(dir_name))

  encoding_scheme <- encoding_scheme[1]
  assertthat::assert_that(is_available_encoding_scheme(encoding_scheme))
  encoding_scheme <<- encoding_scheme
}

is_available_encoding_scheme <- function(encoding_scheme) {
  available_encoding_schemes <- c("base64", "xxd")
  encoding_scheme %in% available_encoding_schemes
}

silent_zip_dir <- function(zipfile, dir, exclude_dot_R, verbose = FALSE) {

  silent <- ! verbose
  exclude_dot_R_command <- " -x \"*/.R*\" \".R*\""

  if(! exclude_dot_R) exclude_dot_R_command <- ""

  shell_command <- glue::glue("zip -r {zipfile} {dir} {exclude_dot_R_command}")
  system(shell_command, intern = silent)
}

encode_zip_file <- function(encoding_scheme, tmp_zip_filename, txt_file_path) {
    shell_command <-
      glue::glue("{encoding_scheme} {tmp_zip_filename} > {txt_file_path}")
    system(shell_command, intern = TRUE)
  }
