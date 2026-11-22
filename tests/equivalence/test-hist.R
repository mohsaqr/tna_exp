# hist() of a model: the histogram of its edge weights, drawn and returned (a "histogram": breaks, counts,
# density, mids). Against graphics::hist(plot = FALSE) of the weights (all cells, zeros included) on the breaks
# hist.tna() documents (20 equal breaks from 0 to 1 for a relative model, from 0 to the largest weight otherwise),
# and against the counts of the weights per bin written in base R.
# Tolerance: counts are whole numbers (0); breaks, densities and midpoints are one division each (1e-12).

#' A histogram as one row per bin
#'
#' @param h A "histogram".
#' @return A data frame: bin, lower, upper, count, density, mid.
histogram_table <- function(h) {
  data.frame(bin = seq_along(h$counts), lower = utils::head(h$breaks, -1L), upper = h$breaks[-1L],
             count = h$counts, density = h$density, mid = h$mids)
}

#' Draw on a null device and return the value
#'
#' @param expr The drawing call.
#' @return Its value.
quietly_drawn <- function(expr) {
  grDevices::pdf(NULL)
  on.exit(grDevices::dev.off(), add = TRUE, after = FALSE)
  expr
}

test_that("the histogram of the edge weights equals graphics::hist() and the counts per bin", {
  model <- tna(group_regulation)
  counts_model <- ftna(group_regulation)
  relative_breaks <- seq(0, 1, length.out = 20)
  frequency_breaks <- seq(0, max(counts_model$weights), length.out = 20)
  expect_reference(histogram_table(quietly_drawn(hist(model))),
                   histogram_table(graphics::hist(as.vector(model$weights), breaks = relative_breaks, plot = FALSE)),
                   reference = "graphics", covers = "hist.tna()", quantity = "histogram of transition probabilities",
                   tolerance = 1e-12, key = "bin")
  expect_reference(histogram_table(quietly_drawn(hist(counts_model))),
                   histogram_table(graphics::hist(as.vector(counts_model$weights), breaks = frequency_breaks,
                                                  plot = FALSE)),
                   reference = "graphics", covers = "hist.tna()", quantity = "histogram of transition counts",
                   tolerance = 1e-12, key = "bin")
  # by definition: a weight in (b[i], b[i + 1]], the first bin closed on the left
  weights <- as.vector(model$weights)
  bin <- pmax(findInterval(weights, relative_breaks, left.open = TRUE), 1L)
  expect_reference(quietly_drawn(hist(model))$counts, tabulate(bin, length(relative_breaks) - 1L),
                   reference = "independent: weights counted per right-closed bin in base R", covers = "hist.tna()",
                   quantity = "count per bin", tolerance = 0)
})

test_that("the histograms of a group model equal graphics::hist() of each group's weights", {
  halves <- rep(c("first", "second"), each = 1000)
  groups <- group_tna(group_regulation, group = halves)
  found <- quietly_drawn(hist(groups))
  breaks <- seq(0, 1, length.out = 20)
  tables <- \(histograms) do.call(rbind, Map(\(h, g) data.frame(group = g, histogram_table(h)), histograms, names(histograms)))
  expected <- lapply(groups, \(group) graphics::hist(as.vector(group$weights), breaks = breaks, plot = FALSE))
  expect_reference(tables(found), tables(expected), reference = "graphics", covers = "hist.group_tna()",
                   quantity = "histogram of transition probabilities per group", tolerance = 1e-12,
                   key = c("group", "bin"))
})
