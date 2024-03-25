create_dir_with_perm <- function(dir_path, permissions) {
    fs::dir_create(dir_path)
    fs::file_chmod(dir_path, permissions)
}

force_remove_dir <- function(dir_path) {
  fs::file_chmod(dir_path, "700")
  fs::dir_delete(dir_path)
}

local_create_dir_with_perm <- function(dir_path,
                                       permissions,
                                       env = parent.frame()) {
  create_dir_with_perm(dir_path, permissions)
  withr::defer(force_remove_dir(dir_path), envir = env)
}

local_create_files <- function(dir_path,
                               filenames,
                               content = "some",
                               env = parent.frame()) {
  create_dir_with_perm(dir_path, "700")
  file_paths <- paste0(dir_path, "/", filenames)
  contents <- paste(content, "of", filenames)

  fs::file_touch(file_paths)
  purrr::walk2(contents, file_paths, ~ write(.x, .y))
}

