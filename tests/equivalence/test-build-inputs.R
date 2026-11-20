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
  expect_reference(read_back[states, states], ref_rows(counts), reference = "igraph",
                   covers = c("as.igraph()", "as.igraph.tna()"), quantity = "edge weight read back by igraph",
                   tolerance = 1e-12)
  matrix_back <- as.matrix(igraph::as_adjacency_matrix(as.igraph(ref_rows(counts)), attr = "weight", sparse = FALSE))
  expect_reference(matrix_back[states, states], ref_rows(counts), reference = "igraph",
                   covers = c("as.igraph()", "as.igraph.matrix()"),
                   quantity = "edge weight of a matrix read back by igraph", tolerance = 1e-12)
  groups <- group_tna(group_regulation, group = rep(c("a", "b"), each = 1000))
  group_back <- as.matrix(igraph::as_adjacency_matrix(as.igraph(groups, which = "b"), attr = "weight",
                                                      sparse = FALSE))
  expect_reference(group_back[states, states], ref_rows(ref_pairs(wide[1001:2000, ], states)), reference = "igraph",
                   covers = c("as.igraph()", "as.igraph.group_tna()"),
                   quantity = "edge weight of group b read back by igraph", tolerance = 1e-12)
})
