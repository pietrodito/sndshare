zero_perm_dir <- test_path("tmp_zero_perm_dir")
readable_dir  <- test_path("tmp_readable_dir" )
writeable_dir <- test_path("tmp_writeable_dir")

local_create_dir_with_perm(zero_perm_dir, "000")
local_create_dir_with_perm(readable_dir , "400")
local_create_dir_with_perm(writeable_dir, "200")

zero_perm_file <- paste0(zero_perm_dir, "/file.txt")
writeable_file <- paste0(writeable_dir, "/file.txt")

test_that("error if not readable path", {

  expect_error(dir_to_txt(dir_path = zero_perm_dir,
                          txt_file_path = zero_perm_file,
                          encoding_scheme = "xxd"),
               "not readable")
})

test_that("error if not writeable text file", {

  expect_error(dir_to_txt(dir_path = readable_dir,
                          txt_file_path = zero_perm_file,
                          encoding_scheme = "xxd"),
               "not writeable")
})

test_that("error if wrong encoding scheme", {
  expect_error(dir_to_txt(dir_path = readable_dir,
                          txt_file_path = writeable_file,
                          encoding_scheme = "wrong scheme"),
               "scheme")
})

test_that("encoding has worked", {

  tmp_dir <- glue::glue(".{testthat::test_path(tempdir())}")
  fs::dir_create(tmp_dir)

  dir_to_zip <- glue::glue("{tmp_dir}/dir_to_zip")
  txt_file   <- testthat::test_path("txt_file.txt")
  withr::defer(fs::file_delete(txt_file))

  local_create_files(dir_to_zip, filenames = letters)

  dir_to_txt(dir_path = dir_to_zip,
             txt_file_path = txt_file)

  expected_size <- 7020L
  actual_size <- fs::file_size(txt_file) %>% as.integer()

  expect_equal(actual_size, expected_size)
})

