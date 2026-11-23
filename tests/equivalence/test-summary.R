# summary() of a model: node and edge counts, density, mean distance, strengths, degrees, degree
# centralization and reciprocity of the transition network (with its loops).
#
# - igraph: summary.tna() computes these with igraph itself (R/summary.R), so the igraph rows that repeat its calls
#   are declared authority "internal" (STANDARD decision 14: "igraph (called by the package)").
# - Base R: tna's conventions written out (ref_summary()): an independent check that the numbers are what tna's
#   code means, including its two departures from the usual definitions below.
# - The literature (audit 2026-11-23, A2; owner decision pending): tna's "Network Density" counts the self-loops
#   among the edges over n (n - 1) ordered pairs and caps the ratio at 1, and its "Mean Distance" reads a
#   transition probability as the LENGTH of an edge. The density of a directed graph is L / (n (n - 1)) over the
#   edges between distinct nodes (Wasserman and Faust 1994, ch. 4), and on a weighted network where a weight is a
#   strength the length of an edge is 1 / w (Opsahl, Agneessens and Skvoretz 2010; tna's own centralities() reads
#   weights so). Both are compared, by igraph with those arguments and by base R, and declared as a defect pending
#   the owner's decision: they disagree until tna changes or the owner rules the convention deliberate.
# Tolerance: sums and ratios of a few dozen probabilities, 1e-10 absolute.

wide <- ref_wide(group_regulation)
weights <- ref_rows(ref_pairs(wide))

#' The summary metrics of a weight matrix, tna's conventions written out
#'
#' Density counts the loops and is capped at 1; a weight is read as a length in the mean distance.
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
  expect_reference(summary(tna(group_regulation)), expected, reference = "igraph", authority = "internal",
                   covers = "summary.tna()", quantity = "network summary", tolerance = 1e-10, key = "metric")
})

test_that("summary metrics equal their definitions", {
  expect_reference(summary(tna(group_regulation)), ref_summary(weights),
                   reference = "independent: tna's summary conventions in base R (counts, Floyd-Warshall, degree sums)",
                   covers = "summary.tna()", quantity = "network summary", tolerance = 1e-10, key = "metric")
  halves <- rep(c("first", "second"), each = 1000)
  per_group <- lapply(split(seq_len(2000L), halves), \(rows) ref_summary(ref_rows(ref_pairs(wide[rows, ]))))
  expected <- data.frame(metric = per_group$first$metric, first = per_group$first$value,
                         second = per_group$second$value)
  expect_reference(summary(group_tna(group_regulation, group = halves)), expected,
                   reference = "independent: tna's summary conventions in base R (counts, Floyd-Warshall, degree sums)",
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
                   authority = "internal", covers = "summary.group_tna()", quantity = "network summary per group", tolerance = 1e-10,
                   key = "metric")
})

#' Density and mean distance by the literature's definitions
#'
#' @param weights A square weight matrix (loops kept).
#' @return A data frame: metric, value (loop-free density L / (n (n - 1)); mean distance over the connected ordered
#'   pairs with 1 / w as the length of an edge).
literature_summary <- function(weights) {
  n <- nrow(weights)
  off <- weights > 0 & !diag(n)
  distance <- ref_floyd(ref_lengths(weights))
  data.frame(metric = c("Network Density", "Mean Distance"),
             value = c(sum(off) / (n * (n - 1)), mean(distance[is.finite(distance) & !diag(n)])))
}

#' Density and mean distance by the literature's definitions, by igraph
#'
#' @param weights A square weight matrix (loops kept).
#' @return A data frame: metric, value.
igraph_literature_summary <- function(weights) {
  graph <- igraph::graph_from_adjacency_matrix(weights, mode = "directed", weighted = TRUE)
  loop_free <- igraph::simplify(graph, remove.multiple = FALSE, remove.loops = TRUE)
  data.frame(metric = c("Network Density", "Mean Distance"),
             value = c(igraph::edge_density(loop_free, loops = FALSE),
                       igraph::mean_distance(graph, weights = 1 / igraph::E(graph)$weight)))
}

density_distance <- \(table) subset(table, metric %in% c("Network Density", "Mean Distance"))
literature_defect <- paste("summary(): Network Density counts self-loops and is capped at 1 (literature: L / (n (n - 1))",
                           "over edges between distinct nodes, Wasserman and Faust 1994), and Mean Distance reads",
                           "transition probabilities as edge lengths (literature: 1 / w, Opsahl et al. 2010);",
                           "owner decision pending, FINDINGS.md")
literature_reference <- "independent: loop-free density and 1/w distances (Wasserman and Faust 1994; Opsahl et al. 2010)"

test_that("density and mean distance against the literature's definitions (owner decision pending)", {
  skip_without_reference("igraph")
  model <- tna(group_regulation)
  pruned <- prune(model, threshold = 0.1)
  expect_reference(density_distance(summary(model)), literature_summary(model$weights),
                   reference = literature_reference, covers = "summary.tna()",
                   quantity = "density and mean distance, literature", tolerance = 1e-10, key = "metric",
                   defect = literature_defect)
  expect_reference(density_distance(summary(model)), igraph_literature_summary(model$weights),
                   reference = "igraph", covers = "summary.tna()",
                   quantity = "density and mean distance, literature", tolerance = 1e-10, key = "metric",
                   defect = literature_defect)
  expect_reference(density_distance(summary(pruned)), literature_summary(pruned$weights),
                   reference = literature_reference, covers = "summary.tna()",
                   quantity = "density and mean distance of a pruned model, literature", tolerance = 1e-10,
                   key = "metric", defect = literature_defect)
  expect_reference(density_distance(summary(pruned)), igraph_literature_summary(pruned$weights),
                   reference = "igraph", covers = "summary.tna()",
                   quantity = "density and mean distance of a pruned model, literature", tolerance = 1e-10,
                   key = "metric", defect = literature_defect)
  halves <- rep(c("first", "second"), each = 1000)
  per_group <- lapply(split(seq_len(2000L), halves), \(rows) literature_summary(ref_rows(ref_pairs(wide[rows, ]))))
  expect_reference(density_distance(summary(group_tna(group_regulation, group = halves))),
                   data.frame(metric = per_group$first$metric, first = per_group$first$value,
                              second = per_group$second$value),
                   reference = literature_reference, covers = "summary.group_tna()",
                   quantity = "density and mean distance per group, literature", tolerance = 1e-10, key = "metric",
                   defect = literature_defect)
})
