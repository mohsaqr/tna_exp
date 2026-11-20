# communities(): the community of each state under igraph's algorithms. tna finds communities with igraph, so
# this checks which graph and weights tna hands over: the directed network with its loops for walktrap, edge
# betweenness, label propagation and infomap, and the undirected network with summed weights for fast greedy,
# leading eigenvector and spinglass. The igraph side builds those graphs from a base R transition matrix. The
# algorithms with a random start are run under the same seed on both sides (the draws are igraph's, not tna's).
# Tolerance: a membership is a label, 0.

wide <- ref_wide(group_regulation)
weights <- ref_rows(ref_pairs(wide))

#' igraph's memberships for the graphs tna uses
#'
#' @param weights A square weight matrix.
#' @param methods The algorithms.
#' @param seed The seed set before each algorithm.
#' @return A data frame: state and one column per algorithm.
igraph_memberships <- function(weights, methods, seed) {
  directed <- igraph::graph_from_adjacency_matrix(weights, mode = "directed", weighted = TRUE)
  summed <- igraph::graph_from_adjacency_matrix(weights, mode = "plus", weighted = TRUE)
  run <- list(
    walktrap = \() igraph::cluster_walktrap(directed, weights = igraph::E(directed)$weight),
    fast_greedy = \() igraph::cluster_fast_greedy(summed, weights = igraph::E(summed)$weight),
    label_prop = \() igraph::cluster_label_prop(directed, weights = igraph::E(directed)$weight),
    infomap = \() igraph::cluster_infomap(directed, e.weights = igraph::E(directed)$weight),
    edge_betweenness = \() igraph::cluster_edge_betweenness(directed, weights = igraph::E(directed)$weight),
    leading_eigen = \() igraph::cluster_leading_eigen(summed, weights = igraph::E(summed)$weight),
    spinglass = \() igraph::cluster_spinglass(summed, weights = igraph::E(summed)$weight, gamma = 1)
  )
  memberships <- lapply(methods, \(method) {
    set.seed(seed)
    as.numeric(igraph::membership(suppressWarnings(run[[method]]())))
  })
  data.frame(state = igraph::V(directed)$name, stats::setNames(memberships, methods))
}

deterministic <- c("walktrap", "fast_greedy", "edge_betweenness", "leading_eigen")
random_start <- c("label_prop", "infomap", "spinglass")

test_that("deterministic algorithms give igraph's communities", {
  skip_without_reference("igraph")
  found <- communities(tna(group_regulation), methods = deterministic)
  expect_reference(found$assignments, igraph_memberships(weights, deterministic, seed = 1L), reference = "igraph",
                   covers = c("communities()", "communities.tna()"), quantity = "community", tolerance = 0,
                   key = "state")
})

test_that("algorithms with a random start give igraph's communities under the same seed", {
  skip_without_reference("igraph")
  # tna runs the algorithms in its own order within one call, so each is called alone after the seed is set.
  found <- do.call(cbind, lapply(random_start, \(method) {
    set.seed(7L)
    communities(tna(group_regulation), methods = method)$assignments[method]
  }))
  expect_reference(data.frame(state = rownames(weights), found), igraph_memberships(weights, random_start, seed = 7L),
                   reference = "igraph", covers = c("communities()", "communities.tna()"),
                   quantity = "community, random start", tolerance = 0, key = "state")
})

test_that("group models give igraph's communities of each group", {
  skip_without_reference("igraph")
  halves <- rep(c("first", "second"), each = 1000)
  found <- communities(group_tna(group_regulation, group = halves), methods = deterministic)
  per_group <- lapply(split(seq_len(2000L), halves),
                      \(rows) igraph_memberships(ref_rows(ref_pairs(wide[rows, ])), deterministic, seed = 1L))
  with_group <- \(tables) do.call(rbind, Map(\(table, group) data.frame(group = group, table), tables, names(tables)))
  expect_reference(with_group(lapply(found, \(group) group$assignments)), with_group(per_group),
                   reference = "igraph", covers = c("communities()", "communities.group_tna()"),
                   quantity = "community per group", tolerance = 0, key = c("group", "state"))
})
