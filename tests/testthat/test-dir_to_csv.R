zero_perm_dir <- test_path("tmp_zero_perm_dir")
readable_dir  <- test_path("tmp_readable_dir")
writeable_dir <- test_path("tmp_writeable_dir")

local_create_dir_with_perm(zero_perm_dir, "000")
local_create_dir_with_perm(readable_dir , "400")
local_create_dir_with_perm(writeable_dir, "200")

zero_perm_file <- paste0(zero_perm_dir, "/file.csv")
writeable_file <- paste0(writeable_dir, "/file.csv")

test_that("error if not readable path", {
  expect_error(
    dir_to_csv(
      dir_path = zero_perm_dir,
      csv = zero_perm_file
    ),
    "not readable"
  )
})

test_that("error if not writeable text file", {
  expect_error(
    dir_to_csv(
      dir_path = readable_dir,
      csv_file_path = zero_perm_file
    ),
    "not writeable"
  )
})

test_that("do not incldue .R* files works", {
  tmp_dir <- glue::glue("./{testthat::test_path(tempdir())}")

  dir_to_zip <- glue::glue("{tmp_dir}/dir_to_zip")
  sub_dir_to_zip <- paste0(dir_to_zip, "/sub_dir")
  fs::dir_create(sub_dir_to_zip)

  csv_file   <- testthat::test_path("csv_file.csv")
  withr::defer(fs::file_delete(csv_file))

  local_create_files(dir_to_zip, filenames = letters)
  local_create_files(dir_to_zip, filenames = ".R_do_not_include")
  local_create_files(sub_dir_to_zip, filenames = ".R_do_not_include")

  zip_output <- dir_to_csv(
    dir_path = dir_to_zip,
    csv_file_path = csv_file,
    return_zip_output = TRUE
  )

  has_zipped_do_not_include_files <-
    any(stringr::str_detect(zip_output, "_do_not_include"))

  expect_false(has_zipped_do_not_include_files)

  expected_size <- 7360L
  actual_size <- fs::file_size(csv_file) %>% as.integer()

  expect_equal(actual_size, expected_size)
})

test_that("inclue .R* files works", {
  tmp_dir <- glue::glue("./{testthat::test_path(tempdir())}")

  dir_to_zip <- glue::glue("{tmp_dir}/dir_to_zip")
  sub_dir_to_zip <- paste0(dir_to_zip, "/sub_dir")
  fs::dir_create(sub_dir_to_zip)
  csv_file  <- testthat::test_path("csv_file.csv")
  withr::defer(fs::file_delete(csv_file))

  local_create_files(dir_to_zip, filenames = letters)
  local_create_files(dir_to_zip, filenames = ".R_do_include")
  local_create_files(sub_dir_to_zip, filenames = ".R_do_include")

  zip_output <- dir_to_csv(
    dir_path = dir_to_zip,
    csv_file_path = csv_file,
    exclude_dot_R = FALSE,
    return_zip_output = TRUE
  )

  has_zipped_do_include_files <-
    any(stringr::str_detect(zip_output, "_do_include"))

  expect_true(has_zipped_do_include_files)

  expected_size <- 8000L
  actual_size <- fs::file_size(csv_file) %>% as.integer()

  expect_equal(actual_size, expected_size)
})
