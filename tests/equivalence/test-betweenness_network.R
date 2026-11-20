# betweenness_network(): the edge betweenness of every edge of a transition network, as a new network.
# Against igraph's edge_betweenness() (which tna calls, so this checks the graph and weights tna hands over and
# how it maps the edges back to the matrix) and, for the directed network, against an independent count of the
# shortest paths through each edge in base R.
# (Moved from tests/testthat/test-betweenness.R, where the class, the record of the source model and the
# resampling rules are still tested.)
# Tolerance: edge betweenness is a sum of ratios of whole path counts, 1e-10 absolute.

model <- tna(group_regulation)

#' igraph's edge betweenness of a weight matrix, written back into a matrix edge by edge
#'
#' @param weights A square matrix.
#' @param directed,invert As in betweenness_network().
#' @return A matrix of the shape of `weights`.
igraph_edge_betweenness <- function(weights, directed, invert) {
  graph <- igraph::graph_from_adjacency_matrix(weights, mode = "directed", weighted = TRUE)
  weight <- igraph::E(graph)$weight
  igraph::E(graph)$weight <- if (invert) 1 / weight else weight
  ends <- igraph::as_edgelist(graph, names = FALSE)
  out <- matrix(0, nrow(weights), ncol(weights), dimnames = dimnames(weights))
  out[ends] <- igraph::edge_betweenness(graph, directed = directed)
  out
}

test_that("edge betweenness equals igraph's, edge by edge", {
  skip_without_reference("igraph")
  expect_reference(betweenness_network(model)$weights, igraph_edge_betweenness(model$weights, TRUE, TRUE),
                   reference = "igraph", covers = c("betweenness_network()", "betweenness_network.tna()"),
                   quantity = "edge betweenness, directed, weights inverted", tolerance = 1e-10)
  expect_reference(betweenness_network(model, directed = FALSE, invert = FALSE)$weights,
                   igraph_edge_betweenness(model$weights, FALSE, FALSE),
                   reference = "igraph", covers = c("betweenness_network()", "betweenness_network.tna()"),
                   quantity = "edge betweenness, undirected, weights as lengths", tolerance = 1e-10)
})

test_that("directed edge betweenness equals the count of shortest paths through each edge", {
  expect_reference(betweenness_network(model)$weights, ref_edge_betweenness(model$weights),
                   reference = "independent: shortest paths counted in base R (Floyd-Warshall, path counts)",
                   covers = c("betweenness_network()", "betweenness_network.tna()"),
                   quantity = "edge betweenness, directed, weights inverted", tolerance = 1e-10)
})

test_that("edge betweenness of group models equals that of each group's network", {
  halves <- rep(c("first", "second"), each = 1000)
  groups <- betweenness_network(group_tna(group_regulation, group = halves))
  wide <- ref_wide(group_regulation)
  expected <- lapply(split(seq_len(2000L), halves), \(rows) ref_edge_betweenness(ref_rows(ref_pairs(wide[rows, ]))))
  expect_reference(unlist(lapply(groups, \(g) g$weights)), unlist(expected),
                   reference = "independent: shortest paths counted in base R (Floyd-Warshall, path counts)",
                   covers = c("betweenness_network()", "betweenness_network.group_tna()"),
                   quantity = "edge betweenness per group", tolerance = 1e-10)
})
