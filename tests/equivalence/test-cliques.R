# cliques(): the sets of `size` states in which every ordered pair is joined by an edge of at least `threshold`
# (or, with sum_weights = TRUE, every pair's two weights add up to at least `threshold`). Against igraph's
# cliques() on the graph of the pairs that qualify, and against an enumeration of every set of states in base R.
# A clique is named by its states; the value compared is the sum of the weights inside it.
# Tolerance: a sum of a few probabilities, 1e-12 absolute.

model <- tna(group_regulation)
weights <- model$weights
states <- rownames(weights)
by_enumeration <- "independent: every set of states checked pair by pair in base R"

#' Cliques as a table: one row per clique, its states and the sum of its weights
#'
#' @param sets A list of integer vectors of state positions.
#' @return A data frame: clique, total_weight.
ref_clique_table <- function(sets) {
  data.frame(clique = vapply(sets, \(set) paste(states[sort(set)], collapse = ", "), character(1)),
             total_weight = vapply(sets, \(set) sum(weights[set, set]), numeric(1)))
}

#' The cliques by enumeration of all sets of states
#'
#' @param qualifies A logical matrix: the pair (i, j) qualifies.
#' @param size The size of a clique.
#' @return A list of integer vectors.
ref_enumerate <- function(qualifies, size) {
  sets <- utils::combn(length(states), size, simplify = FALSE)
  Filter(\(set) all(qualifies[set, set][upper.tri(diag(size))]), sets)
}

#' The cliques that igraph finds on the graph of qualifying pairs
#'
#' @param qualifies A logical matrix, symmetric.
#' @param size The size of a clique.
#' @return A list of integer vectors.
igraph_cliques <- function(qualifies, size) {
  graph <- igraph::graph_from_adjacency_matrix(1 * qualifies, mode = "undirected", diag = FALSE)
  lapply(igraph::cliques(graph, min = size, max = size), as.integer)
}

mutual <- \(threshold) weights >= threshold & t(weights) >= threshold & weights > 0 & t(weights) > 0
summed <- \(threshold) (weights + t(weights)) >= threshold & (weights > 0 | t(weights) > 0)

test_that("cliques equal igraph's cliques of the qualifying pairs", {
  skip_without_reference("igraph")
  expect_reference(ref_clique_table(cliques(model, size = 2, threshold = 0.1)$indices),
                   ref_clique_table(igraph_cliques(mutual(0.1), 2L)), reference = "igraph",
                   covers = c("cliques()", "cliques.tna()"), quantity = "dyad, threshold 0.1", tolerance = 1e-12,
                   key = "clique")
  expect_reference(ref_clique_table(cliques(model, size = 3, threshold = 0.05)$indices),
                   ref_clique_table(igraph_cliques(mutual(0.05), 3L)), reference = "igraph",
                   covers = c("cliques()", "cliques.tna()"), quantity = "triad, threshold 0.05", tolerance = 1e-12,
                   key = "clique")
  expect_reference(ref_clique_table(cliques(model, size = 3, threshold = 0.15, sum_weights = TRUE)$indices),
                   ref_clique_table(igraph_cliques(summed(0.15), 3L)), reference = "igraph",
                   covers = c("cliques()", "cliques.tna()"), quantity = "triad of summed weights, threshold 0.15",
                   tolerance = 1e-12, key = "clique")
})

test_that("cliques equal the enumeration of every set of states", {
  expect_reference(ref_clique_table(cliques(model, size = 2, threshold = 0.1)$indices),
                   ref_clique_table(ref_enumerate(mutual(0.1), 2L)), reference = by_enumeration,
                   covers = c("cliques()", "cliques.tna()"), quantity = "dyad, threshold 0.1", tolerance = 1e-12,
                   key = "clique")
  expect_reference(ref_clique_table(cliques(model, size = 3, threshold = 0.05)$indices),
                   ref_clique_table(ref_enumerate(mutual(0.05), 3L)), reference = by_enumeration,
                   covers = c("cliques()", "cliques.tna()"), quantity = "triad, threshold 0.05", tolerance = 1e-12,
                   key = "clique")
  expect_reference(ref_clique_table(cliques(model, size = 4, threshold = 0.02)$indices),
                   ref_clique_table(ref_enumerate(mutual(0.02), 4L)), reference = by_enumeration,
                   covers = c("cliques()", "cliques.tna()"), quantity = "4-clique, threshold 0.02", tolerance = 1e-12,
                   key = "clique")
  expect_reference(ref_clique_table(cliques(model, size = 3, threshold = 0.15, sum_weights = TRUE)$indices),
                   ref_clique_table(ref_enumerate(summed(0.15), 3L)), reference = by_enumeration,
                   covers = c("cliques()", "cliques.tna()"), quantity = "triad of summed weights, threshold 0.15",
                   tolerance = 1e-12, key = "clique")
})

test_that("cliques of group models equal the enumeration for each group", {
  halves <- rep(c("first", "second"), each = 1000)
  wide <- ref_wide(group_regulation)
  found <- cliques(group_tna(group_regulation, group = halves), size = 3, threshold = 0.05)
  per_group <- lapply(split(seq_len(2000L), halves), \(rows) {
    group_weights <- ref_rows(ref_pairs(wide[rows, ]))
    qualifies <- group_weights >= 0.05 & t(group_weights) >= 0.05
    sets <- ref_enumerate(qualifies, 3L)
    data.frame(clique = vapply(sets, \(set) paste(states[sort(set)], collapse = ", "), character(1)),
               total_weight = vapply(sets, \(set) sum(group_weights[set, set]), numeric(1)))
  })
  ours <- Map(\(group, name) {
    data.frame(clique = vapply(group$indices, \(set) paste(states[sort(set)], collapse = ", "), character(1)),
               total_weight = vapply(group$weights, sum, numeric(1)))
  }, found, names(found))
  with_group <- \(tables) do.call(rbind, Map(\(table, group) data.frame(group = rep(group, nrow(table)), table),
                                             tables, names(tables)))
  expect_reference(with_group(ours), with_group(per_group), reference = by_enumeration,
                   covers = c("cliques()", "cliques.group_tna()"), quantity = "triad per group, threshold 0.05",
                   tolerance = 1e-12, key = c("group", "clique"))
})
