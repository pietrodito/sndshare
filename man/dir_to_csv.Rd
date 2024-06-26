% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dir_to_csv.R
\name{dir_to_csv}
\alias{dir_to_csv}
\title{Zip and base64-encode a directory to a csv file}
\usage{
dir_to_csv(
  dir_path,
  csv_file_path,
  exclude_dot_R = TRUE,
  return_zip_output = FALSE
)
}
\arguments{
\item{dir_path}{directory to encode}

\item{csv_file_path}{csv output file path}

\item{exclude_dot_R}{TRUE to exclude .Rproj.user and others}

\item{return_zip_output}{TRUE to return vector with zip-file names}
}
\value{
nothing or vector with zip-file names
}
\description{
Zip and base64-encode a directory to a csv file
}
\examples{
dir_to_csv(dir_path, csv_file_path)
}
