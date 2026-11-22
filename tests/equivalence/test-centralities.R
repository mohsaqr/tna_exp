# centralities(): strength, closeness, betweenness, PageRank, diffusion and the weighted clustering coefficient
# of a transition network, a weight read as the strength of an edge (a path's length is the sum of inverse
# weights). tna computes the path-based measures with igraph, so the igraph side checks how tna builds the graph
# and hands over the weights; qgraph is a second program; the base R side is independent of both: Floyd-Warshall
# distances, shortest-path counts, a linear solve for PageRank (damping 0.85) and the published definitions of
# diffusion centrality (Banerjee et al. 2014) and of the weighted clustering coefficient (Zhang and Horvath 2005).
# BetweennessRSP (Kivimaki et al. 2016, rounded and shifted by tna) has no reference here.
# Tolerances: 1e-8 absolute allows for PageRank, which igraph solves iteratively (PRPACK, to about 1e-10); the
# other measures are sums and inverses of a few dozen weights.

wide <- ref_wide(group_regulation)
network <- ref_network(wide)
states <- rownames(network)
by_definition <- "independent: Floyd-Warshall distances, path counts, linear solves and the published formulas in base R"

#' The centralities of a weight matrix from the definitions
#'
#' @param weights A square matrix without loops.
#' @return A data frame, one row per state.
ref_centralities <- function(weights) {
  n <- nrow(weights)
  distance <- ref_floyd(ref_lengths(weights))
  lengths <- ref_lengths(weights)
  undirected <- ref_floyd(pmin(lengths, t(lengths)))
  pagerank <- solve(diag(n) - 0.85 * t(weights / rowSums(weights)), rep(0.15 / n, n))
  data.frame(state = rownames(weights), OutStrength = rowSums(weights), InStrength = colSums(weights),
             ClosenessIn = 1 / colSums(distance), ClosenessOut = 1 / rowSums(distance),
             Closeness = 1 / rowSums(undirected), Betweenness = ref_betweenness(weights),
             PageRank = pagerank / sum(pagerank))
}

#' Diffusion (min-max scaled, as tna reports it) and the weighted clustering coefficient
#'
#' @param weights A square matrix without loops.
#' @return A data frame, one row per state.
ref_diffusion_clustering <- function(weights) {
  n <- nrow(weights)
  powers <- Reduce(`%*%`, rep(list(weights), n), accumulate = TRUE)
  diffusion <- rowSums(Reduce(`+`, powers))
  u <- weights + t(weights)
  triangles <- vapply(seq_len(n), \(i) sum(outer(u[i, ], u[, i]) * u), numeric(1))
  data.frame(state = rownames(weights),
             Diffusion = (diffusion - min(diffusion)) / (max(diffusion) - min(diffusion)),
             Clustering = triangles / (rowSums(u)^2 - rowSums(u^2)))
}

path_measures <- c("OutStrength", "InStrength", "ClosenessIn", "ClosenessOut", "Closeness", "Betweenness", "PageRank")

test_that("path centralities equal igraph's", {
  skip_without_reference("igraph")
  graph <- igraph::graph_from_adjacency_matrix(network, mode = "directed", weighted = TRUE)
  lengths <- 1 / igraph::E(graph)$weight
  expected <- data.frame(
    state = igraph::V(graph)$name,
    OutStrength = igraph::strength(graph, mode = "out"), InStrength = igraph::strength(graph, mode = "in"),
    ClosenessIn = igraph::closeness(graph, mode = "in", weights = lengths),
    ClosenessOut = igraph::closeness(graph, mode = "out", weights = lengths),
    Closeness = igraph::closeness(graph, mode = "all", weights = lengths),
    Betweenness = igraph::betweenness(graph, weights = lengths),
    PageRank = igraph::page_rank(graph)$vector)
  expect_reference(centralities(tna(group_regulation), measures = path_measures), expected, reference = "igraph",
                   covers = c("centralities()", "centralities.tna()"), quantity = "centrality", tolerance = 1e-8,
                   key = "state")
})

test_that("strength, closeness and betweenness equal qgraph's", {
  skip_without_reference("qgraph")
  found <- qgraph::centrality(network, weighted = TRUE, all.shortest.paths = FALSE)
  expected <- data.frame(state = states, OutStrength = found$OutDegree, InStrength = found$InDegree,
                         ClosenessOut = found$Closeness, Betweenness = found$Betweenness)
  expect_reference(centralities(tna(group_regulation)), expected, reference = "qgraph",
                   covers = c("centralities()", "centralities.tna()"), quantity = "centrality", tolerance = 1e-8,
                   key = "state")
})

test_that("centralities equal their definitions", {
  expect_reference(centralities(tna(group_regulation), measures = path_measures), ref_centralities(network),
                   reference = by_definition, covers = c("centralities()", "centralities.tna()"),
                   quantity = "centrality", tolerance = 1e-8, key = "state")
  expect_reference(centralities(tna(group_regulation), measures = c("Diffusion", "Clustering")),
                   ref_diffusion_clustering(network), reference = by_definition,
                   covers = c("centralities()", "centralities.tna()"), quantity = "diffusion and clustering",
                   tolerance = 1e-10, key = "state")
})

test_that("normalised, uninverted and looped centralities equal their definitions", {
  scale01 <- \(v) (v - min(v)) / (max(v) - min(v))
  plain <- ref_centralities(network)
  normalised <- data.frame(state = plain$state, lapply(plain[path_measures], scale01))
  expect_reference(centralities(tna(group_regulation), measures = path_measures, normalize = TRUE), normalised,
                   reference = by_definition, covers = c("centralities()", "centralities.tna()"),
                   quantity = "min-max normalised centrality", tolerance = 1e-8, key = "state")
  # invert = FALSE: a weight is read as the length of an edge
  lengths <- ifelse(network > 0, network, Inf)
  diag(lengths) <- 0
  distance <- ref_floyd(lengths)
  expect_reference(centralities(tna(group_regulation), measures = c("ClosenessIn", "ClosenessOut"), invert = FALSE),
                   data.frame(state = states, ClosenessIn = 1 / colSums(distance),
                              ClosenessOut = 1 / rowSums(distance)),
                   reference = by_definition, covers = c("centralities()", "centralities.tna()"),
                   quantity = "closeness, weights read as lengths", tolerance = 1e-10, key = "state")
  # loops = TRUE: the self-transitions stay in the strengths
  looped <- ref_rows(ref_pairs(wide))
  expect_reference(centralities(tna(group_regulation), measures = c("OutStrength", "InStrength"), loops = TRUE),
                   data.frame(state = states, OutStrength = rowSums(looped), InStrength = colSums(looped)),
                   reference = by_definition, covers = c("centralities()", "centralities.tna()"),
                   quantity = "strength with loops", tolerance = 1e-12, key = "state")
})

test_that("PageRank of random weighted networks equals igraph's and the linear solve", {
  skip_without_reference("igraph")
  # Moved from tests/testthat/test-centralities.R: random directed networks of 2 to 10 states, some edges absent,
  # with and without loops.
  set.seed(265)
  cases <- expand.grid(n = 2:10, draw = 1:5, loops = c(FALSE, TRUE))
  networks <- lapply(seq_len(nrow(cases) / 2L), \(i) {
    n <- cases$n[i]
    weights <- matrix(stats::runif(n * n), n, n)
    weights[stats::runif(n * n) < 0.45] <- 0
    dimnames(weights) <- list(paste0("s", seq_len(n)), paste0("s", seq_len(n)))
    weights
  })
  networks <- c(networks, networks)
  labels <- sprintf("n = %d, draw %d, loops = %s", cases$n, cases$draw, cases$loops)
  ours <- unlist(Map(\(weights, loops, label) {
    found <- centralities(weights, loops = loops, measures = "PageRank")$PageRank
    stats::setNames(found, paste0(label, ": ", rownames(weights)))
  }, networks, cases$loops, labels))
  by_igraph <- unlist(Map(\(weights, loops, label) {
    if (!loops) diag(weights) <- 0
    graph <- igraph::graph_from_adjacency_matrix(weights, mode = "directed", weighted = TRUE)
    found <- igraph::page_rank(graph, directed = TRUE, weights = igraph::E(graph)$weight)$vector
    stats::setNames(found, paste0(label, ": ", rownames(weights)))
  }, networks, cases$loops, labels))
  expect_reference(ours, by_igraph, reference = "igraph", covers = c("centralities()", "centralities.matrix()"),
                   quantity = "PageRank of a random network", tolerance = 1e-10)
})

test_that("centralities of group models equal those of each group's network", {
  halves <- rep(c("first", "second"), each = 1000)
  per_group <- lapply(split(seq_len(2000L), halves), \(rows) ref_centralities(ref_network(wide[rows, ])))
  expected <- do.call(rbind, Map(\(table, group) data.frame(group = group, table), per_group, names(per_group)))
  expect_reference(centralities(group_tna(group_regulation, group = halves), measures = path_measures), expected, reference = by_definition,
                   covers = c("centralities()", "centralities.group_tna()"), quantity = "centrality per group",
                   tolerance = 1e-8, key = c("group", "state"))
})

test_that("centralities of group models equal igraph's on each group's network", {
  skip_without_reference("igraph")
  halves <- rep(c("first", "second"), each = 1000)
  igraph_centralities <- \(weights) {
    graph <- igraph::graph_from_adjacency_matrix(weights, mode = "directed", weighted = TRUE)
    lengths <- 1 / igraph::E(graph)$weight
    data.frame(state = igraph::V(graph)$name,
               OutStrength = igraph::strength(graph, mode = "out"), InStrength = igraph::strength(graph, mode = "in"),
               ClosenessIn = igraph::closeness(graph, mode = "in", weights = lengths),
               ClosenessOut = igraph::closeness(graph, mode = "out", weights = lengths),
               Closeness = igraph::closeness(graph, mode = "all", weights = lengths),
               Betweenness = igraph::betweenness(graph, weights = lengths),
               PageRank = igraph::page_rank(graph)$vector)
  }
  per_group <- lapply(split(seq_len(2000L), halves), \(rows) igraph_centralities(ref_network(wide[rows, ])))
  expected <- do.call(rbind, Map(\(table, group) data.frame(group = group, table), per_group, names(per_group)))
  expect_reference(centralities(group_tna(group_regulation, group = halves), measures = path_measures), expected,
                   reference = "igraph", covers = c("centralities()", "centralities.group_tna()"),
                   quantity = "centrality per group", tolerance = 1e-8, key = c("group", "state"))
})
