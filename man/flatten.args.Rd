% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/debug.R
\name{flatten.args}
\alias{flatten.args}
\alias{.flatten.args}
\title{This helper function is used in almost all functions of the interface
to make sure only a list of un-nested elements}
\usage{
.flatten.args(...)
}
\arguments{
\item{...}{A list (possibly of lists) that the user input as arguments
to one of the functions}
}
\value{
A list of unnested elements
}
\description{
This helper function is used in almost all functions of the interface
to make sure only a list of un-nested elements
}
