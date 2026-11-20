# compare(): two transition networks compared edge by edge and as wholes: weight deviations, correlations,
# dissimilarities, similarities, and the correlation of their centralities. The correlations against
# stats::cor() and the Euclidean and Manhattan distances against stats::dist(); every other metric against its
# definition in base R (Canberra with 0/0 terms left out; Bray-Curtis; the Frobenius norm over sqrt(n / 2);
# cosine; weighted Jaccard, Dice and overlap; the RV coefficient of Escoufier (1973) on column-centred matrices;
# the distance correlation of Szekely, Rizzo and Bakirov (2007)).
# The two networks: the first and the second 1000 group_regulation sequences.
# Tolerance: sums, ratios and square roots of 81 probabilities, 1e-10 absolute.

wide <- ref_wide(group_regulation)
halves <- rep(c("first", "second"), each = 1000)
first <- ref_rows(ref_pairs(wide[1:1000, ]))
second <- ref_rows(ref_pairs(wide[1001:2000, ]))
models <- group_tna(group_regulation, group = halves)
by_definition <- "independent: the metric written from its definition in base R"
from_stats <- c("Pearson", "Spearman", "Kendall", "Euclidean", "Manhattan")

#' The summary metrics of a comparison, those computed by stats or the others
#'
#' @param found A comparison.
#' @param by_stats Keep the metrics that stats computes (TRUE) or the others (FALSE).
#' @return A data frame: category, metric, value.
metrics_of <- \(found, by_stats) subset(found$summary_metrics, (metric %in% from_stats) == by_stats)

#' The distance correlation of two vectors (Szekely, Rizzo and Bakirov 2007)
#'
#' @param x,y Numeric vectors of one length.
#' @return A number.
ref_dcor <- function(x, y) {
  centred <- \(v) {
    d <- abs(outer(v, v, `-`))
    d - outer(rowMeans(d), rep(1, length(v))) - outer(rep(1, length(v)), colMeans(d)) + mean(d)
  }
  a <- centred(x)
  b <- centred(y)
  sqrt(mean(a * b) / sqrt(mean(a^2) * mean(b^2)))
}

#' The summary metrics of two weight matrices from their definitions
#'
#' @param x,y Square matrices with the same states.
#' @return A data frame: metric, value.
ref_compare <- function(x, y) {
  a <- as.vector(x)
  b <- as.vector(y)
  d <- abs(a - b)
  both <- abs(a) + abs(b)
  xc <- scale(x, scale = FALSE)
  yc <- scale(y, scale = FALSE)
  trace <- \(m) sum(diag(m))
  rv <- trace(tcrossprod(xc) %*% tcrossprod(yc)) /
    sqrt(trace(tcrossprod(xc) %*% tcrossprod(xc)) * trace(tcrossprod(yc) %*% tcrossprod(yc)))
  data.frame(
    metric = c("Mean Abs. Diff.", "Median Abs. Diff.", "RMS Diff.", "Max Abs. Diff.", "Rel. Mean Abs. Diff.",
               "CV Ratio", "Distance", "Canberra", "Bray-Curtis", "Frobenius", "Cosine", "Jaccard", "Dice",
               "Overlap", "RV", "Rank Agreement", "Sign Agreement"),
    value = c(mean(d), stats::median(d), sqrt(mean(d^2)), max(d), mean(d) / mean(abs(b)),
              (stats::sd(a) / mean(a)) / (stats::sd(b) / mean(b)), ref_dcor(a, b),
              sum(d[both > 0] / both[both > 0]), sum(d) / sum(both), sqrt(sum(d^2)) / sqrt(nrow(x) / 2),
              sum(a * b) / sqrt(sum(a^2) * sum(b^2)), sum(pmin(abs(a), abs(b))) / sum(pmax(abs(a), abs(b))),
              2 * sum(pmin(abs(a), abs(b))) / (sum(abs(a)) + sum(abs(b))),
              sum(pmin(abs(a), abs(b))) / min(sum(abs(a)), sum(abs(b))), rv,
              # rank agreement: the signs of the differences between consecutive rows agree
              mean(sign(x[-1L, ] - x[-nrow(x), ]) == sign(y[-1L, ] - y[-nrow(y), ])), mean(sign(a) == sign(b))))
}

#' The edge metrics of two weight matrices from their definitions
#'
#' @param x,y Square matrices with the same states.
#' @return A data frame: source, target and one column per metric.
ref_edges <- function(x, y) {
  a <- as.vector(x)
  b <- as.vector(y)
  data.frame(source = rownames(x)[as.vector(row(x))], target = colnames(x)[as.vector(col(x))],
             weight_x = a, weight_y = b, raw_difference = a - b, absolute_difference = abs(a - b),
             squared_difference = (a - b)^2, logarithmic_ratio = log1p(a) - log1p(b),
             standardized_weight_x = (a - mean(a)) / stats::sd(a), standardized_weight_y = (b - mean(b)) / stats::sd(b))
}

test_that("correlations and distances equal stats::cor() and stats::dist()", {
  a <- as.vector(first)
  b <- as.vector(second)
  expected <- data.frame(
    metric = c("Pearson", "Spearman", "Kendall", "Euclidean", "Manhattan"),
    value = c(stats::cor(a, b), stats::cor(a, b, method = "spearman"), stats::cor(a, b, method = "kendall"),
              as.vector(stats::dist(rbind(a, b))), as.vector(stats::dist(rbind(a, b), method = "manhattan"))))
  found <- compare(models[["first"]], models[["second"]])
  expect_reference(metrics_of(found, by_stats = TRUE), expected, reference = "stats", covers = c("compare()", "compare.tna()"),
                   quantity = "comparison metric", tolerance = 1e-10, key = "metric")
})

test_that("comparison metrics equal their definitions", {
  found <- compare(models[["first"]], models[["second"]])
  expect_reference(metrics_of(found, by_stats = FALSE), ref_compare(first, second), reference = by_definition,
                   covers = c("compare()", "compare.tna()"), quantity = "comparison metric", tolerance = 1e-10,
                   key = "metric")
  expect_reference(found$edge_metrics, ref_edges(first, second), reference = by_definition,
                   covers = c("compare()", "compare.tna()"), quantity = "edge metric", tolerance = 1e-10,
                   key = c("source", "target"))
  expect_reference(metrics_of(compare(first, second), by_stats = FALSE), ref_compare(first, second), reference = by_definition,
                   covers = c("compare()", "compare.matrix()"), quantity = "comparison metric of two matrices",
                   tolerance = 1e-10, key = "metric")
  expect_reference(metrics_of(compare(models, i = 1L, j = 2L), by_stats = FALSE), ref_compare(first, second),
                   reference = by_definition, covers = c("compare()", "compare.group_tna()"),
                   quantity = "comparison metric of two groups", tolerance = 1e-10, key = "metric")
  scale01 <- \(m) (m - min(m)) / (max(m) - min(m))
  expect_reference(metrics_of(compare(models[["first"]], models[["second"]], scaling = "minmax"), by_stats = FALSE),
                   ref_compare(scale01(first), scale01(second)), reference = by_definition,
                   covers = c("compare()", "compare.tna()"), quantity = "comparison metric after min-max scaling",
                   tolerance = 1e-10, key = "metric")
})

test_that("centrality differences and correlations equal those of the two networks' strengths", {
  without_loops <- \(m) `diag<-`(m, 0)
  x <- without_loops(first)
  y <- without_loops(second)
  found <- compare(models[["first"]], models[["second"]], measures = c("InStrength", "OutStrength"))
  expected_differences <- data.frame(state = rep(rownames(x), each = 2L), centrality = c("InStrength", "OutStrength"),
                                     x = as.vector(rbind(colSums(x), rowSums(x))),
                                     y = as.vector(rbind(colSums(y), rowSums(y))))
  expected_differences$difference <- expected_differences$x - expected_differences$y
  expect_reference(found$centrality_differences, expected_differences, reference = by_definition,
                   covers = c("compare()", "compare.tna()"), quantity = "centrality difference", tolerance = 1e-10,
                   key = c("state", "centrality"))
  expect_reference(found$centrality_correlations,
                   data.frame(centrality = c("InStrength", "OutStrength"),
                              correlation = c(stats::cor(colSums(x), colSums(y)), stats::cor(rowSums(x), rowSums(y)))),
                   reference = "stats", covers = c("compare()", "compare.tna()"), quantity = "centrality correlation",
                   tolerance = 1e-10, key = "centrality")
})
