# summary() of a model: node and edge counts, density, mean distance, strengths, degrees, degree
# centralization and reciprocity of the transition network (with its loops). Against igraph's functions on the
# graph of a base R transition matrix, and against the definitions in base R.
# Tolerance: sums and ratios of a few dozen probabilities, 1e-10 absolute.

wide <- ref_wide(group_regulation)
weights <- ref_rows(ref_pairs(wide))

#' The summary metrics of a weight matrix from their definitions
#'
#' @param weights A square weight matrix (loops kept).
#' @return A data frame: metric, value.
ref_summary <- function(weights) {
  n <- nrow(weights)
  edge <- weights > 0
  off <- edge & !diag(n)
  # mean distance: a weight read as a length, over the ordered pairs s != t that are connected
  lengths <- ifelse(off, weights, Inf)
  diag(lengths) <- 0
  distance <- ref_floyd(lengths)
  reachable <- is.finite(distance) & !diag(n)
  out_degree <- rowSums(edge)
  degree_out <- rowSums(off)
  degree_in <- colSums(off)
  data.frame(
    metric = c("Node Count", "Edge Count", "Network Density", "Mean Distance", "Mean Out-Strength",
               "SD Out-Strength", "Mean In-Strength", "SD In-Strength", "Mean Out-Degree", "SD Out-Degree",
               "Centralization (Out-Degree)", "Centralization (In-Degree)", "Reciprocity"),
    value = c(n, sum(edge), min(sum(edge) / (n * (n - 1)), 1), mean(distance[reachable]),
              mean(rowSums(weights)), stats::sd(rowSums(weights)), mean(colSums(weights)), stats::sd(colSums(weights)),
              mean(out_degree), stats::sd(out_degree),
              sum(max(degree_out) - degree_out) / (n - 1)^2, sum(max(degree_in) - degree_in) / (n - 1)^2,
              sum(off & t(off)) / sum(off)))
}

test_that("summary metrics equal igraph's", {
  skip_without_reference("igraph")
  graph <- igraph::graph_from_adjacency_matrix(weights, mode = "directed", weighted = TRUE)
  strength_out <- igraph::strength(graph, mode = "out")
  strength_in <- igraph::strength(graph, mode = "in")
  degree_out <- igraph::degree(graph, mode = "out")
  expected <- data.frame(
    metric = c("Node Count", "Edge Count", "Network Density", "Mean Distance", "Mean Out-Strength", "SD Out-Strength",
               "Mean In-Strength", "SD In-Strength", "Mean Out-Degree", "SD Out-Degree",
               "Centralization (Out-Degree)", "Centralization (In-Degree)", "Reciprocity"),
    value = c(igraph::vcount(graph), igraph::ecount(graph), min(igraph::edge_density(graph), 1), igraph::mean_distance(graph),
              mean(strength_out), stats::sd(strength_out), mean(strength_in), stats::sd(strength_in),
              mean(degree_out), stats::sd(degree_out),
              igraph::centr_degree(graph, mode = "out", loops = FALSE)$centralization,
              igraph::centr_degree(graph, mode = "in", loops = FALSE)$centralization,
              igraph::reciprocity(graph)))
  expect_reference(summary(tna(group_regulation)), expected, reference = "igraph", covers = "summary.tna()",
                   quantity = "network summary", tolerance = 1e-10, key = "metric")
})

test_that("summary metrics equal their definitions", {
  expect_reference(summary(tna(group_regulation)), ref_summary(weights),
                   reference = "independent: counts, Floyd-Warshall distances and degree sums in base R",
                   covers = "summary.tna()", quantity = "network summary", tolerance = 1e-10, key = "metric")
  halves <- rep(c("first", "second"), each = 1000)
  per_group <- lapply(split(seq_len(2000L), halves), \(rows) ref_summary(ref_rows(ref_pairs(wide[rows, ]))))
  expected <- data.frame(metric = per_group$first$metric, first = per_group$first$value,
                         second = per_group$second$value)
  expect_reference(summary(group_tna(group_regulation, group = halves)), expected,
                   reference = "independent: counts, Floyd-Warshall distances and degree sums in base R",
                   covers = "summary.group_tna()", quantity = "network summary per group", tolerance = 1e-10,
                   key = "metric")
})

test_that("summary metrics of group models equal igraph's on each group's network", {
  skip_without_reference("igraph")
  igraph_summary <- \(weights) {
    graph <- igraph::graph_from_adjacency_matrix(weights, mode = "directed", weighted = TRUE)
    strength_out <- igraph::strength(graph, mode = "out")
    strength_in <- igraph::strength(graph, mode = "in")
    degree_out <- igraph::degree(graph, mode = "out")
    c(igraph::vcount(graph), igraph::ecount(graph), min(igraph::edge_density(graph), 1), igraph::mean_distance(graph),
      mean(strength_out), stats::sd(strength_out), mean(strength_in), stats::sd(strength_in),
      mean(degree_out), stats::sd(degree_out),
      igraph::centr_degree(graph, mode = "out", loops = FALSE)$centralization,
      igraph::centr_degree(graph, mode = "in", loops = FALSE)$centralization, igraph::reciprocity(graph))
  }
  halves <- rep(c("first", "second"), each = 1000)
  per_group <- lapply(split(seq_len(2000L), halves), \(rows) igraph_summary(ref_rows(ref_pairs(wide[rows, ]))))
  expected <- data.frame(
    metric = c("Node Count", "Edge Count", "Network Density", "Mean Distance", "Mean Out-Strength", "SD Out-Strength",
               "Mean In-Strength", "SD In-Strength", "Mean Out-Degree", "SD Out-Degree",
               "Centralization (Out-Degree)", "Centralization (In-Degree)", "Reciprocity"),
    first = per_group$first, second = per_group$second)
  expect_reference(summary(group_tna(group_regulation, group = halves)), expected, reference = "igraph",
                   covers = "summary.group_tna()", quantity = "network summary per group", tolerance = 1e-10,
                   key = "metric")
})
