# Models built from other inputs (a weight matrix, a long table, an edge list) and handed to igraph: build_model()
# methods, tsn(), sna() and as.igraph(), against igraph and base R computations of the same definitions.
# Tolerances: a probability or a sum of a few weights is computed by one division or addition in a possibly
# different order (1e-12 absolute); a count is a whole number (0).

wide <- ref_wide(group_regulation)
states <- ref_states(wide)
counts <- ref_pairs(wide, states)
by_definition <- "independent: the same definition in base R"

test_that("a weight matrix given directly is row-normalised for a relative model", {
  given <- counts + 1
  inits <- seq_along(states)
  model <- build_model(given, type = "relative", inits = inits)
    expect_reference(model$weights, ref_rows(given), reference = by_definition,
                   covers = c("build_model()", "build_model.matrix()"), quantity = "transition probability",
                   tolerance = 1e-12)
  expect_reference(build_model(as.table(given), type = "relative")$weights, ref_rows(given),
                   reference = by_definition, covers = c("build_model()", "build_model.default()"),
                   quantity = "transition probability, from a table", tolerance = 1e-12)
  expect_reference(build_model(given, type = "frequency")$weights, given, reference = by_definition,
                   covers = c("build_model()", "build_model.matrix()"), quantity = "frequency weights kept",
                   tolerance = 0)
})

test_that("a long table of id, state and time gives the model of its sequences", {
  # Times are shuffled within a sequence so that the order must come from `time`, not from the rows.
  set.seed(42)
  small <- wide[seq_len(200L), ]
  observed <- which(!is.na(small), arr.ind = TRUE)
  long <- data.frame(id = observed[, "row"], state = small[observed], time = observed[, "col"])
  long <- long[sample.int(nrow(long)), ]
  # The class the tsn package gives such a table; tna reads only the three columns.
  class(long) <- c("tsn", class(long))
  expect_reference(tsn(long)$weights, ref_rows(ref_pairs(small, ref_states(small))),
                   reference = by_definition,
                   covers = c("tsn()", "build_model.tsn()"), quantity = "transition probability, long table",
                   tolerance = 1e-12)
})

test_that("an edge list gives the matrix of summed weights", {
  set.seed(123)
  nodes <- c("A", "B", "C", "D")
  edges <- data.frame(from = sample(nodes, 100, replace = TRUE), to = sample(nodes, 100, replace = TRUE),
                      weight = stats::rexp(100))
  summed <- tapply(edges$weight, list(factor(edges$from, nodes), factor(edges$to, nodes)), sum, default = 0)
  expected <- matrix(as.numeric(summed), 4L, dimnames = list(nodes, nodes))
  expect_reference(sna(edges)$weights, expected, reference = by_definition,
                   covers = "sna()", quantity = "summed edge weight", tolerance = 1e-12)
  means <- tapply(edges$weight, list(factor(edges$from, nodes), factor(edges$to, nodes)), mean, default = 0)
  expect_reference(sna(edges, aggregate = mean)$weights, matrix(as.numeric(means), 4L, dimnames = list(nodes, nodes)),
                   reference = by_definition, covers = "sna()",
                   quantity = "mean edge weight", tolerance = 1e-12)
})

test_that("as.igraph() hands igraph the weight matrix", {
  skip_without_reference("igraph")
  model <- tna(group_regulation)
  read_back <- as.matrix(igraph::as_adjacency_matrix(as.igraph(model), attr = "weight", sparse = FALSE))
  expect_reference(read_back[states, states], ref_rows(counts), reference = "igraph", authority = "internal",
                   covers = c("as.igraph()", "as.igraph.tna()"), quantity = "edge weight read back by igraph",
                   tolerance = 1e-12)
  matrix_back <- as.matrix(igraph::as_adjacency_matrix(as.igraph(ref_rows(counts)), attr = "weight", sparse = FALSE))
  expect_reference(matrix_back[states, states], ref_rows(counts), reference = "igraph", authority = "internal",
                   covers = c("as.igraph()", "as.igraph.matrix()"),
                   quantity = "edge weight of a matrix read back by igraph", tolerance = 1e-12)
  groups <- group_tna(group_regulation, group = rep(c("a", "b"), each = 1000))
  group_back <- as.matrix(igraph::as_adjacency_matrix(as.igraph(groups, which = "b"), attr = "weight",
                                                      sparse = FALSE))
  expect_reference(group_back[states, states], ref_rows(ref_pairs(wide[1001:2000, ], states)), reference = "igraph",
                   authority = "internal", covers = c("as.igraph()", "as.igraph.group_tna()"),
                   quantity = "edge weight of group b read back by igraph", tolerance = 1e-12)
})

# as.igraph() builds the graph with igraph's graph_from_adjacency_matrix(), so the read-backs above are declared
# authority "internal" (STANDARD decision 14). The independent check: the graph's edge list (read with igraph's
# accessors) against the non-zero cells of the weight matrix listed in base R, one edge per cell, loops included.

#' The edges of a graph as a named vector of weights, "from -> to"
#'
#' @param graph An igraph graph.
#' @return Named weights.
graph_edges <- function(graph) {
  ends <- igraph::as_edgelist(graph, names = TRUE)
  stats::setNames(igraph::E(graph)$weight, paste(ends[, 1L], "->", ends[, 2L]))
}

#' The non-zero cells of a weight matrix as a named vector, "from -> to"
#'
#' @param weights A square matrix with dimnames.
#' @return Named weights.
matrix_edges <- function(weights) {
  cells <- which(weights != 0, arr.ind = TRUE)
  stats::setNames(weights[cells], paste(rownames(weights)[cells[, 1L]], "->", colnames(weights)[cells[, 2L]]))
}

test_that("as.igraph() has one edge per non-zero cell of the weight matrix, with its weight", {
  skip_without_reference("igraph")
  by_cells <- "independent: the non-zero cells of the weight matrix listed in base R"
  expect_reference(graph_edges(as.igraph(tna(group_regulation))), matrix_edges(ref_rows(counts)), reference = by_cells,
                   covers = c("as.igraph()", "as.igraph.tna()"), quantity = "edge list of a model", tolerance = 1e-12)
  expect_reference(graph_edges(as.igraph(ref_rows(counts))), matrix_edges(ref_rows(counts)), reference = by_cells,
                   covers = c("as.igraph()", "as.igraph.matrix()"), quantity = "edge list of a matrix", tolerance = 1e-12)
  groups <- group_tna(group_regulation, group = rep(c("a", "b"), each = 1000))
  expect_reference(graph_edges(as.igraph(groups, which = "b")),
                   matrix_edges(ref_rows(ref_pairs(wide[1001:2000, ], states))), reference = by_cells,
                   covers = c("as.igraph()", "as.igraph.group_tna()"), quantity = "edge list of group b",
                   tolerance = 1e-12)
})

test_that("a count matrix or table from TraMineR gives TraMineR's transition rates", {
  skip_without_reference("TraMineR")
  sequences <- suppressMessages(TraMineR::seqdef(as.data.frame(group_regulation)))
  alphabet <- TraMineR::alphabet(sequences)
  tramine <- \(count) `dimnames<-`(suppressMessages(TraMineR::seqtrate(sequences, count = count)), list(alphabet, alphabet))
  expect_reference(build_model(tramine(TRUE), type = "relative")$weights, tramine(FALSE), reference = "TraMineR",
                   covers = c("build_model()", "build_model.matrix()"),
                   quantity = "transition probability from TraMineR's count matrix", tolerance = 1e-12)
  expect_reference(build_model(as.table(tramine(TRUE)), type = "relative")$weights, tramine(FALSE),
                   reference = "TraMineR", covers = c("build_model()", "build_model.default()"),
                   quantity = "transition probability from TraMineR's count table", tolerance = 1e-12)
  expect_reference(build_model(tramine(TRUE), type = "frequency")$weights, tramine(TRUE), reference = "TraMineR",
                   covers = c("build_model()", "build_model.matrix()"),
                   quantity = "frequency weights of TraMineR's count matrix kept", tolerance = 0)
})

test_that("a long table gives markovchain's maximum likelihood chain of its sequences", {
  skip_without_reference("markovchain")
  set.seed(42)
  small <- wide[seq_len(200L), ]
  observed <- which(!is.na(small), arr.ind = TRUE)
  long <- data.frame(id = observed[, "row"], state = small[observed], time = observed[, "col"])
  long <- long[sample.int(nrow(long)), ]
  class(long) <- c("tsn", class(long))
  # markovchain reads each sequence in time order, split from the long table in base R
  by_id <- split(as.data.frame(long), long$id)
  chains <- lapply(by_id, \(rows) rows$state[order(rows$time)])
  fit <- markovchain::markovchainFit(data = unname(chains), method = "mle")$estimate@transitionMatrix
  small_states <- ref_states(small)
  expect_reference(tsn(long)$weights, fit[small_states, small_states], reference = "markovchain",
                   covers = c("tsn()", "build_model.tsn()"), quantity = "transition probability, long table",
                   tolerance = 1e-12)
})

test_that("an edge list gives igraph's matrix of combined edge weights", {
  skip_without_reference("igraph")
  set.seed(123)
  nodes <- c("A", "B", "C", "D")
  edges <- data.frame(from = sample(nodes, 100, replace = TRUE), to = sample(nodes, 100, replace = TRUE),
                      weight = stats::rexp(100))
  combined <- \(how) {
    graph <- igraph::graph_from_data_frame(edges, directed = TRUE, vertices = data.frame(name = nodes))
    graph <- igraph::simplify(graph, remove.multiple = TRUE, remove.loops = FALSE, edge.attr.comb = list(weight = how))
    as.matrix(igraph::as_adjacency_matrix(graph, attr = "weight", sparse = FALSE))[nodes, nodes]
  }
  expect_reference(sna(edges)$weights, combined("sum"), reference = "igraph", covers = "sna()",
                   quantity = "summed edge weight", tolerance = 1e-12)
  expect_reference(sna(edges, aggregate = mean)$weights, combined("mean"), reference = "igraph", covers = "sna()",
                   quantity = "mean edge weight", tolerance = 1e-12)
})
