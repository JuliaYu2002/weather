% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/precipitation_class.R
\name{precipitation}
\alias{precipitation}
\title{Precipitation class}
\usage{
precipitation(precipitation, dates, location)
}
\arguments{
\item{precipitation}{Numeric vector of precipitation inches}

\item{dates}{Numeric vector of dates}

\item{location}{Character vector containing city, state, and zip code}
}
\value{
An object of class precipitation
}
\description{
A class that contains vectors for the precipitation for a series of dates at a
particular location
}
\examples{
precipitation(0.01, Sys.Date(), c("Northampton", "MA"))
}
