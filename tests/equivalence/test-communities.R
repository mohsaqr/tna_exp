# communities(): the community of each state under igraph's algorithms. tna finds communities with igraph, so
# this checks which graph and weights tna hands over: the directed network with its loops for walktrap, edge
# betweenness, label propagation and infomap, and the undirected network with summed weights for fast greedy,
# leading eigenvector and spinglass. The igraph side builds those graphs from a base R transition matrix. The
# algorithms with a random start are run under the same seed on both sides (the draws are igraph's, not tna's).
# igraph is the routine tna itself calls (R/communities.R), so these rows are declared authority "internal" (STANDARD
# decision 14: "igraph (called by the package)"): they show how tna calls igraph, not that the communities are right.
# The independent evidence is fast greedy: the agglomerative modularity maximisation of Clauset, Newman and Moore
# (2004) written in base R on the summed undirected network (A = W + t(W), a loop counted twice, as an undirected
# loop is), with Newman's (2006) modularity Q = sum_c (e_cc - a_c^2). The other algorithms have only the internal
# evidence.
# Tolerance: a membership is a label, 0. Labels are compared after renumbering both sides by first appearance
# (a partition does not depend on the names of its blocks).

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

#' Fast greedy modularity maximisation (Clauset, Newman and Moore 2004) of an undirected weight matrix
#'
#' Starting from singletons, merge at each step the two joined communities whose merge raises the modularity most
#' (Delta Q = 2 (e_ab - a_a a_b)); keep the partition of the largest modularity met along the way.
#' @param adjacency A symmetric weight matrix (a loop's weight on the diagonal counted twice).
#' @return The membership, numbered by first appearance.
ref_fast_greedy <- function(adjacency) {
  n <- nrow(adjacency)
  e <- adjacency / sum(adjacency)
  modularity <- \(membership) sum(vapply(unique(membership), \(c) {
    inside <- membership == c
    sum(e[inside, inside]) - sum(e[inside, ])^2
  }, numeric(1)))
  merges <- Reduce(\(membership, step) {
    blocks <- unique(membership)
    between <- outer(blocks, blocks, Vectorize(\(a, b) sum(e[membership == a, membership == b])))
    share <- rowSums(between)
    gain <- 2 * (between - outer(share, share))
    gain[between <= 0 | diag(length(blocks)) > 0] <- -Inf
    best <- which(gain == max(gain), arr.ind = TRUE)[1L, ]
    replace(membership, membership == blocks[best[[2L]]], blocks[best[[1L]]])
  }, seq_len(n - 1L), seq_len(n), accumulate = TRUE)
  best <- merges[[which.max(vapply(merges, modularity, numeric(1)))]]
  match(best, unique(best))
}

#' Renumber a membership by first appearance
#'
#' @param membership A vector of labels.
#' @return Integer labels 1, 2, ... in the order the blocks first appear.
first_appearance <- \(membership) match(membership, unique(membership))

deterministic <- c("walktrap", "fast_greedy", "edge_betweenness", "leading_eigen")
random_start <- c("label_prop", "infomap", "spinglass")

test_that("deterministic algorithms give igraph's communities", {
  skip_without_reference("igraph")
  found <- communities(tna(group_regulation), methods = deterministic)
  expect_reference(found$assignments, igraph_memberships(weights, deterministic, seed = 1L), reference = "igraph",
                   authority = "internal", covers = c("communities()", "communities.tna()"), quantity = "community",
                   tolerance = 0, key = "state")
})

test_that("algorithms with a random start give igraph's communities under the same seed", {
  skip_without_reference("igraph")
  # tna runs the algorithms in its own order within one call, so each is called alone after the seed is set.
  found <- do.call(cbind, lapply(random_start, \(method) {
    set.seed(7L)
    communities(tna(group_regulation), methods = method)$assignments[method]
  }))
  expect_reference(data.frame(state = rownames(weights), found), igraph_memberships(weights, random_start, seed = 7L),
                   reference = "igraph", authority = "internal", covers = c("communities()", "communities.tna()"),
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
                   reference = "igraph", authority = "internal", covers = c("communities()", "communities.group_tna()"),
                   quantity = "community per group", tolerance = 0, key = c("group", "state"))
})

fast_greedy_by_definition <- "independent: fast greedy modularity maximisation (Clauset, Newman and Moore 2004) in base R"

test_that("fast greedy communities equal the Clauset-Newman-Moore merges written in base R", {
  found <- communities(tna(group_regulation), methods = "fast_greedy")$assignments
  expect_reference(stats::setNames(first_appearance(found$fast_greedy), found$state),
                   stats::setNames(ref_fast_greedy(weights + t(weights)), rownames(weights)),
                   reference = fast_greedy_by_definition, covers = c("communities()", "communities.tna()"),
                   quantity = "fast greedy community", tolerance = 0)
  halves <- rep(c("first", "second"), each = 1000)
  per_group <- communities(group_tna(group_regulation, group = halves), methods = "fast_greedy")
  ours <- unlist(lapply(names(per_group), \(g) {
    table <- per_group[[g]]$assignments
    stats::setNames(first_appearance(table$fast_greedy), paste(g, table$state, sep = ": "))
  }))
  expected <- unlist(lapply(split(seq_len(2000L), halves), \(rows) {
    group_weights <- ref_rows(ref_pairs(wide[rows, ], rownames(weights)))
    ref_fast_greedy(group_weights + t(group_weights))
  }))
  expect_reference(ours, stats::setNames(expected, paste(rep(c("first", "second"), each = nrow(weights)),
                                                         rownames(weights), sep = ": ")),
                   reference = fast_greedy_by_definition, covers = c("communities()", "communities.group_tna()"),
                   quantity = "fast greedy community per group", tolerance = 0)
})
