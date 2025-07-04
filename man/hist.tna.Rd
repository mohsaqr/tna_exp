% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.R
\name{hist.tna}
\alias{hist.tna}
\title{Plot a Histogram of Edge Weights in the Network}
\usage{
\method{hist}{tna}(x, breaks, col = "lightblue", main, xlab, border = "white", ...)
}
\arguments{
\item{x}{a vector of values for which the histogram is desired.}

\item{breaks}{one of:
    \itemize{
      \item a vector giving the breakpoints between histogram cells,
      \item a function to compute the vector of breakpoints,
      \item a single number giving the number of cells for the histogram,
      \item a character string naming an algorithm to compute the
      number of cells (see \sQuote{Details}),
      \item a function to compute the number of cells.
    }
    In the last three cases the number is a suggestion only; as the
    breakpoints will be set to \code{\link{pretty}} values, the number
    is limited to \code{1e6} (with a warning if it was larger).  If
    \code{breaks} is a function, the \code{x} vector is supplied to it
    as the only argument (and the number of breaks is only limited by
    the amount of available memory).
  }

\item{col}{a colour to be used to fill the bars.}

\item{main}{A \code{character} string defining the title of the plot.}

\item{xlab}{A \code{character} string defining the vertical axis label.}

\item{border}{the color of the border around the bars.  The default
    is to use the standard foreground color.}

\item{...}{Additional arguments passed to \code{\link[graphics:hist]{graphics::hist()}}.}
}
\value{
A \code{histogram} object of edge weights.
}
\description{
Plot a Histogram of Edge Weights in the Network
}
\examples{
model <- tna(group_regulation)
hist(model)

}
\seealso{
Basic functions
\code{\link{build_model}()},
\code{\link{hist.group_tna}()},
\code{\link{plot.group_tna}()},
\code{\link{plot.tna}()},
\code{\link{plot_frequencies}()},
\code{\link{plot_frequencies.group_tna}()},
\code{\link{plot_mosaic}()},
\code{\link{plot_mosaic.group_tna}()},
\code{\link{plot_mosaic.tna_data}()},
\code{\link{print.group_tna}()},
\code{\link{print.summary.group_tna}()},
\code{\link{print.summary.tna}()},
\code{\link{print.tna}()},
\code{\link{summary.group_tna}()},
\code{\link{summary.tna}()},
\code{\link{tna-package}}
}
\concept{basic}
