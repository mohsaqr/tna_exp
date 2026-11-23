# centralities(): strength, closeness, betweenness, PageRank, diffusion and the weighted clustering coefficient
# of a transition network, a weight read as the strength of an edge (a path's length is the sum of inverse
# weights). tna computes strength, closeness, betweenness and PageRank with igraph itself (R/centralities.R), so the
# igraph rows are declared authority "internal" (STANDARD decision 14: "igraph (called by the package)"): they check
# how tna builds the graph and hands over the weights, not the measures. qgraph is a second program; the base R side
# is independent of both: Floyd-Warshall distances, shortest-path counts, a linear solve and a power iteration for
# PageRank (damping 0.85, a dangling state's rank spread evenly; Page et al. 1999), and the published definitions of
# diffusion centrality (Banerjee et al. 2013), randomised shortest-path betweenness (Kivimaki et al. 2016) and the
# weighted clustering coefficient (Zhang and Horvath 2005).
# tna's conventions, owner's ruling 2026-11-22 ("tna wins"), declared as known differences with the paper cited:
# - Diffusion is min-max rescaled to [0, 1] even with normalize = FALSE; Banerjee et al. (2013) define the raw
#   sum_{t = 1}^{T} (q W)^t 1 (tna: q = 1, T = n).
# - BetweennessRSP is rounded and shifted so that the smallest value is 1; Kivimaki et al. (2016) define the raw
#   expected number of passages.
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

#' Diffusion centrality (Banerjee et al. 2013): sum_{t = 1}^{T} (q W)^t 1, raw, with tna's q = 1 and T = n
#'
#' @param weights A square matrix without loops.
#' @return A data frame, one row per state.
ref_diffusion <- function(weights) {
  n <- nrow(weights)
  powers <- Reduce(`%*%`, rep(list(weights), n), accumulate = TRUE)
  data.frame(state = rownames(weights), Diffusion = rowSums(Reduce(`+`, powers)))
}

#' The weighted clustering coefficient (Zhang and Horvath 2005) of the symmetrised network
#'
#' @param weights A square matrix without loops.
#' @return A data frame, one row per state.
ref_clustering <- function(weights) {
  n <- nrow(weights)
  u <- weights + t(weights)
  triangles <- vapply(seq_len(n), \(i) sum(outer(u[i, ], u[, i]) * u), numeric(1))
  data.frame(state = rownames(weights), Clustering = triangles / (rowSums(u)^2 - rowSums(u^2)))
}

#' Randomised shortest-path betweenness (Kivimaki et al. 2016) from its definition, walk by walk
#'
#' For each target t the RSP walk is absorbed at t: W = P_ref * exp(-beta C) (P_ref the row-normalised weights,
#' C = 1 / w the cost of an edge) with row t set to 0, Z_t = (I - W)^-1, and the expected number of passages
#' through i of the walk from s to t is Z_t[s, i] Z_t[i, t] / Z_t[s, t]. The betweenness of i sums these over the
#' pairs s != t with t != i (the start counts as a passage, the absorption does not). This is the quantity of
#' Kivimaki et al.'s closed form (Eq. 15), computed here without it, one absorbing walk per target.
#' @param weights A square matrix without loops, strongly connected.
#' @param beta The inverse temperature (tna: 0.01).
#' @return A data frame: state, BetweennessRSP (raw).
ref_rsp_betweenness <- function(weights, beta = 0.01) {
  n <- nrow(weights)
  reference_walk <- weights / rowSums(weights)
  cost <- ifelse(weights > 0, 1 / weights, 0)
  killed <- reference_walk * exp(-beta * cost)
  passages <- lapply(seq_len(n), \(target) {
    absorbing <- killed
    absorbing[target, ] <- 0
    z <- solve(diag(n) - absorbing)
    through <- z * outer(rep(1, n), z[, target]) / z[, target]
    through[target, ] <- 0
    through[, target] <- 0
    colSums(through)
  })
  data.frame(state = rownames(weights), BetweennessRSP = Reduce(`+`, passages))
}

#' tna's presentation of a betweenness: rounded, then shifted so that the smallest value is 1
#'
#' @param table A data frame with BetweennessRSP.
#' @return The same with the values rounded and shifted.
rounded_shifted <- function(table) {
  rounded <- round(table$BetweennessRSP)
  data.frame(state = table$state, BetweennessRSP = rounded - min(rounded) + 1)
}

scale01 <- \(v) (v - min(v)) / (max(v) - min(v))

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
                   authority = "internal", covers = c("centralities()", "centralities.tna()"), quantity = "centrality",
                   tolerance = 1e-8, key = "state")
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
  expect_reference(centralities(tna(group_regulation), measures = "Clustering"),
                   ref_clustering(network), reference = by_definition,
                   covers = c("centralities()", "centralities.tna()"), quantity = "weighted clustering coefficient",
                   tolerance = 1e-10, key = "state")
})

test_that("Diffusion is Banerjee et al.'s diffusion centrality, min-max rescaled by tna's convention", {
  banerjee <- ref_diffusion(network)
  diffusion <- centralities(tna(group_regulation), measures = "Diffusion")
  expect_known_difference(diffusion, banerjee,
                          reference = "independent: Banerjee et al. (2013) diffusion centrality, raw",
                          covers = c("centralities()", "centralities.tna()"), quantity = "diffusion centrality, raw",
                          tolerance = 1e-10, key = "state",
                          reason = paste("tna min-max rescales Diffusion to [0, 1] even with normalize = FALSE (tna",
                                         "convention, owner's ruling 2026-11-22: tna wins); Banerjee et al. (2013,",
                                         "Science) define the raw sum_t (q W)^t 1, here with tna's q = 1, T = n."),
                          agrees_with = "the min-max rescale of the raw value")
  expect_reference(diffusion, data.frame(state = banerjee$state, Diffusion = scale01(banerjee$Diffusion)),
                   reference = "independent: Banerjee et al. (2013) diffusion centrality, min-max rescaled",
                   covers = c("centralities()", "centralities.tna()"), quantity = "diffusion centrality, rescaled",
                   tolerance = 1e-10, key = "state")
})

test_that("BetweennessRSP is Kivimaki et al.'s RSP betweenness, rounded and shifted by tna's convention", {
  # The rounded values differ from state to state on this network (1 to 103), so a constant would not pass.
  rsp <- ref_rsp_betweenness(network)
  found <- centralities(tna(group_regulation), measures = "BetweennessRSP")
  expect_known_difference(found, rsp, reference = "independent: Kivimaki et al. (2016) RSP betweenness, raw",
                          covers = c("centralities()", "centralities.tna()"),
                          quantity = "randomised shortest-path betweenness, raw", tolerance = 1e-8, key = "state",
                          reason = paste("tna rounds the RSP betweenness and shifts it so that the smallest value is 1",
                                         "(tna convention, owner's ruling 2026-11-22: tna wins); Kivimaki et al.",
                                         "(2016, Physica A) define the raw expected number of passages."),
                          agrees_with = "the raw value rounded and shifted to start at 1")
  # The raw values are sums of ratios of a 9 x 9 inverse (1e-8 absolute); none is within 0.03 of a half (a probe, 2026-11-23), so
  # rounding cannot turn solver noise into a different whole number.
  expect_reference(found, rounded_shifted(rsp),
                   reference = "independent: Kivimaki et al. (2016) RSP betweenness, rounded and shifted",
                   covers = c("centralities()", "centralities.tna()"),
                   quantity = "randomised shortest-path betweenness, rounded and shifted", tolerance = 0, key = "state")
  expect_reference(centralities(network, measures = "BetweennessRSP"), rounded_shifted(rsp),
                   reference = "independent: Kivimaki et al. (2016) RSP betweenness, rounded and shifted",
                   covers = c("centralities()", "centralities.matrix()"),
                   quantity = "randomised shortest-path betweenness of a weight matrix, rounded and shifted",
                   tolerance = 0, key = "state")
})

test_that("normalised, uninverted and looped centralities equal their definitions", {
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
  expect_reference(ours, by_igraph, reference = "igraph", authority = "internal",
                   covers = c("centralities()", "centralities.matrix()"),
                   quantity = "PageRank of a random network", tolerance = 1e-10)
  # The definition (Page et al. 1999): r = d r P + (d s + 1 - d) / n, s the rank held by dangling states (no
  # out-edge), iterated from the uniform vector until it no longer moves (500 steps; the contraction is 0.85^500).
  by_power <- unlist(Map(\(weights, loops, label) {
    if (!loops) diag(weights) <- 0
    n <- nrow(weights)
    out <- rowSums(weights)
    transition <- weights / ifelse(out > 0, out, 1)
    dangling <- out == 0
    rank <- Reduce(\(r, step) {
      new <- 0.85 * (as.vector(r %*% transition) + sum(r[dangling]) / n) + 0.15 / n
      new / sum(new)
    }, seq_len(500L), rep(1 / n, n))
    stats::setNames(rank, paste0(label, ": ", rownames(weights)))
  }, networks, cases$loops, labels))
  expect_reference(ours, by_power, reference = "independent: PageRank by power iteration in base R (Page et al. 1999)",
                   covers = c("centralities()", "centralities.matrix()"),
                   quantity = "PageRank of a random network, power iteration", tolerance = 1e-10)
})

test_that("centralities of a weight matrix equal qgraph's", {
  skip_without_reference("qgraph")
  found <- qgraph::centrality(network, weighted = TRUE, all.shortest.paths = FALSE)
  expected <- data.frame(state = states, OutStrength = found$OutDegree, InStrength = found$InDegree,
                         ClosenessOut = found$Closeness, Betweenness = found$Betweenness)
  expect_reference(centralities(network), expected, reference = "qgraph",
                   covers = c("centralities()", "centralities.matrix()"), quantity = "centrality of a weight matrix",
                   tolerance = 1e-8, key = "state")
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
                   reference = "igraph", authority = "internal", covers = c("centralities()", "centralities.group_tna()"),
                   quantity = "centrality per group", tolerance = 1e-8, key = c("group", "state"))
})
