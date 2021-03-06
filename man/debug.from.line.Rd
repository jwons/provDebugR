% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/debugFromLine.R
\name{debug.from.line}
\alias{debug.from.line}
\title{State of variables given lines}
\usage{
debug.from.line(..., state = F, script.num = 0)
}
\arguments{
\item{...}{Line(s) to examine. Can be single lines or vectors/lines.}

\item{state}{If FALSE, returns the refereneces to variables on
inputed line(s). If TRUE, returns the state of all variables up to
that point in execution.}

\item{script.num}{If 0, only examine variables from the main script.
If 1 or higher, examine variables from further nested source scripts.}
}
\value{
A list of one data frame per line, containing information about
the variables on that line. If no parameters were passed, returns a
data frame containing the state of all variables at the end of execution.
}
\description{
This function will either return all references to variables on
a given line, or the state of all variables up to that point in
execution.
}
\examples{
\dontrun{
debug.from.line(4, state = F)
debug.from.line(4, 5:8, 10, state = T)
debug.from.line()
}
}
