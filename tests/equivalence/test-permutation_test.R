# permutation_test() of two edge betweenness networks: the observed differences of the edge betweenness of the
# two halves of group_regulation, and the permutation p-values. Against Nestimate's permutation() of
# net_edge_betweenness() networks, a separate implementation by an author of tna (it does not call tna). The
# observed differences are deterministic; the p-values come from two independent random streams (tna's
# permutations are drawn inside the function), so they are compared within Monte Carlo error.
# Moved from the standing script
# equivalence/tna/local/local_testing_and_equivalence/betweenness_permutation_vs_nestimate.R.
# Tolerances: the observed difference is a difference of two sums of path-count ratios (1e-10 absolute). A p-value
# from 2000 permutations has a standard error of at most sqrt(0.25 / 2000) = 0.0112, so the difference of two
# independent estimates has one of at most 0.0158; 0.07 absolute is about 4.4 of those (looser than 1e-8 because
# the two sides draw different permutations).

halves <- list(first = group_regulation[1:1000, ], second = group_regulation[1001:2000, ])
iter <- 2000L

test_that("observed differences and p-values of edge betweenness agree with Nestimate's permutation()", {
  skip_without_reference("Nestimate")
  ours_networks <- lapply(halves, \(d) betweenness_network(tna(d)))
  set.seed(1)
  ours <- permutation_test(ours_networks$first, ours_networks$second, iter = iter)
  theirs_networks <- lapply(halves, \(d) Nestimate::net_edge_betweenness(Nestimate::build_network(d, method = "relative"),
                                                                         invert = TRUE))
  theirs <- Nestimate::permutation(theirs_networks$first, theirs_networks$second, iter = iter, seed = 1)
  edges <- summary(ours, digits = 12L)
  states <- rownames(ours_networks$first$weights)
  observed <- unclass(theirs$diff)
  dimnames(observed) <- list(states, states)
  expect_reference(edges, data.frame(ref_long(observed, "diff_true")), reference = "Nestimate",
                   covers = c("permutation_test()", "permutation_test.tna()", "summary.tna_permutation()"),
                   quantity = "observed difference of edge betweenness", tolerance = 1e-10, key = c("from", "to"))
  p_values <- unclass(theirs$p_values)
  dimnames(p_values) <- list(states, states)
  expect_reference(edges, data.frame(ref_long(p_values, "p_value")), reference = "Nestimate",
                   covers = c("permutation_test()", "permutation_test.tna()", "summary.tna_permutation()"),
                   quantity = "permutation p-value, independent streams", tolerance = 0.07, key = c("from", "to"))
})

test_that("a grouped model is tested pair by pair as by a base-R permutation test", {
  # Three groups of 150 sequences: three pairs. Each pair's observed differences are deterministic; its p-values,
  # (1 + number of relabellings reaching |observed|) / (iter + 1), are compared with a permutation test written
  # in base R (helper-resampling.R, 4000 relabellings) within Monte Carlo error: 4 standard errors of the
  # difference, max over cells of sqrt(q (1 - q)) sqrt(1/1000 + 1/4000), plus 1/1001 for tna's +1, q the
  # reference's share, fixed before the run. A probe of 20 seeds passed 20 of 20 before this file was run.
  data <- group_regulation[1:450, ]
  wide <- ref_wide(data)
  states <- ref_states(wide)
  groups <- rep(c("a", "b", "c"), each = 150)
  grouped <- group_model(data, group = groups)
  tested <- rs_with_seed(41L, permutation_test(grouped, iter = 1000L))
  table <- summary(tested, digits = 12L)
  pairs <- list(c("a", "b"), c("a", "c"), c("b", "c"))
  lapply(pairs, \(pair) {
    reference <- rs_permutation(wide[groups == pair[[1L]], , drop = FALSE], wide[groups == pair[[2L]], , drop = FALSE],
                                states, draws = 4000L, seed = 42L)
    name <- paste(pair[[1L]], "vs.", pair[[2L]])
    rows <- table[table$pair == name, ]
    cells <- paste(rows$from, "->", rows$to)
    expect_reference(stats::setNames(rows$diff_true, cells), reference$observed[cells],
                     reference = "independent: difference of the two groups' relative networks, base R",
                     covers = c("permutation_test.group_tna()", "summary.group_tna_permutation()"),
                     quantity = sprintf("observed difference, %s", name), tolerance = 1e-10)
    q <- reference$exceed
    expect_reference(stats::setNames(rows$p_value, cells), ((1000 * q + 1) / 1001)[cells],
                     reference = "independent: permutation test written in base R (helper-resampling.R)",
                     covers = c("permutation_test.group_tna()", "summary.group_tna_permutation()"),
                     quantity = sprintf("Monte Carlo summary: permutation p-value, %s", name),
                     tolerance = 4 * max(sqrt(q * (1 - q))) * sqrt(1 / 1000 + 1 / 4000) + 1 / 1001)
  })
})

# Against NetworkComparisonTest's NCT() (van Borkulo et al. 2022), an established permutation test of two networks:
# NCT permutes the cases between the two samples (or swaps them within pairs, paired = TRUE), re-estimates both
# networks with the estimator it is given, and reports per edge (1 + number of permutations whose absolute
# difference reaches the observed one) / (iterations + 1), the p-value tna documents. The cases are the sequences:
# each is given to NCT as one row of its pair counts (81 columns), and the estimator builds the network of the rows
# it receives. NCT tests the cells above the diagonal of a symmetric network of its columns, so the estimator
# writes the 81 directed cells into the first 81 of those positions (zeros elsewhere); the permutations, the
# re-estimation and the p-values are NCT's.
# Tolerances: the observed absolute difference is deterministic (1e-12). A p-value from tna's 2000 and NCT's 4000
# permutations differs by Monte Carlo error with a standard error of at most 0.5 sqrt(1/2000 + 1/4000) = 0.0137;
# 0.055 is 4 of those, fixed before the run (looser than 1e-8 because the two sides draw their own permutations).

nct_iter <- 4000L
tna_iter <- 2000L
nct_tolerance <- 4 * 0.5 * sqrt(1 / tna_iter + 1 / nct_iter)

#' NCT's edge p-values and observed absolute differences of two sets of sequences
#'
#' @param data_x,data_y Wide sequence tables.
#' @param network A function of a square count matrix with dimnames returning the network.
#' @param paired As in NCT().
#' @param seed The seed of NCT's permutations.
#' @return A data frame: from, to, abs_diff, p_value.
nct_edges <- function(data_x, data_y, network, paired = FALSE, seed = 1L) {
  wide_x <- ref_wide(data_x)
  wide_y <- ref_wide(data_y)
  states <- ref_states(rbind(wide_x, wide_y))
  k <- length(states)
  rows_of <- \(wide) `colnames<-`(rs_counts(wide, states), sprintf("c%02d", seq_len(k * k)))
  estimator <- function(x, ...) {
    cells <- as.vector(network(matrix(colSums(x), k, dimnames = list(states, states))))
    out <- matrix(0, k * k, k * k)
    out[upper.tri(out)] <- c(cells, rep(0, sum(upper.tri(out)) - k * k))
    out
  }
  tested <- rs_with_seed(seed, NetworkComparisonTest::NCT(
    as.data.frame(rows_of(wide_x)), as.data.frame(rows_of(wide_y)), it = nct_iter, paired = paired,
    test.edges = TRUE, edges = "all", p.adjust.methods = "none", estimator = estimator, progressbar = FALSE,
    verbose = FALSE))
  table <- tested$einv.pvals
  # the position of each tested pair among the cells above the diagonal, column by column
  upper <- which(upper.tri(matrix(0, k * k, k * k)), arr.ind = TRUE)
  position <- match(paste(as.integer(substring(table$Var1, 2L)), as.integer(substring(table$Var2, 2L))),
                    paste(upper[, "row"], upper[, "col"]))
  cells <- table[position <= k * k, ]
  cell <- position[position <= k * k]
  # einv.pvals carries the statistic rounded to 8 decimals; the unrounded observed differences are in einv.real
  observed <- tested$einv.real[upper.tri(tested$einv.real)][cell]
  data.frame(from = states[(cell - 1L) %% k + 1L], to = states[(cell - 1L) %/% k + 1L],
             abs_diff = observed, p_value = cells[["p-value"]])
}

relative_network <- \(counts) ref_rows(counts)

test_that("edge p-values of two transition networks agree with NetworkComparisonTest's NCT()", {
  skip_without_reference("NetworkComparisonTest")
  data <- group_regulation[1:300, ]
  x <- tna(data[1:150, ])
  y <- tna(data[151:300, ])
  expected <- nct_edges(data[1:150, ], data[151:300, ], relative_network, seed = 11L)
  lapply(1:3, \(seed) {
    table <- summary(rs_with_seed(seed, permutation_test(x, y, iter = tna_iter)), digits = 12L)
    found <- data.frame(from = table$from, to = table$to, abs_diff = abs(table$diff_true), p_value = table$p_value)
    expect_reference(subset(found, select = c(from, to, abs_diff)), subset(expected, select = c(from, to, abs_diff)),
                     reference = "NetworkComparisonTest",
                     covers = c("permutation_test()", "permutation_test.tna()", "summary.tna_permutation()"),
                     quantity = sprintf("observed absolute difference, seed %d", seed), tolerance = 1e-12,
                     key = c("from", "to"))
    expect_reference(subset(found, select = c(from, to, p_value)), subset(expected, select = c(from, to, p_value)),
                     reference = "NetworkComparisonTest",
                     covers = c("permutation_test()", "permutation_test.tna()", "summary.tna_permutation()"),
                     quantity = sprintf("Monte Carlo summary: permutation p-value, seed %d", seed),
                     tolerance = nct_tolerance, key = c("from", "to"))
  })
  paired <- nct_edges(data[1:150, ], data[151:300, ], relative_network, paired = TRUE, seed = 12L)
  table <- summary(rs_with_seed(4L, permutation_test(x, y, iter = tna_iter, paired = TRUE)), digits = 12L)
  expect_reference(data.frame(from = table$from, to = table$to, p_value = table$p_value),
                   subset(paired, select = c(from, to, p_value)), reference = "NetworkComparisonTest",
                   covers = c("permutation_test()", "permutation_test.tna()", "summary.tna_permutation()"),
                   quantity = "Monte Carlo summary: paired permutation p-value", tolerance = nct_tolerance,
                   key = c("from", "to"))
})

test_that("edge p-values of two edge betweenness networks agree with NCT() re-estimating igraph's edge betweenness", {
  skip_without_reference(c("NetworkComparisonTest", "igraph"))
  data <- group_regulation[1:300, ]
  edge_betweenness <- \(counts) {
    weights <- ref_rows(counts)
    graph <- igraph::graph_from_adjacency_matrix(weights, mode = "directed", weighted = TRUE)
    igraph::E(graph)$weight <- 1 / igraph::E(graph)$weight
    out <- matrix(0, nrow(weights), ncol(weights), dimnames = dimnames(weights))
    out[igraph::as_edgelist(graph, names = FALSE)] <- igraph::edge_betweenness(graph, directed = TRUE)
    out
  }
  expected <- nct_edges(data[1:150, ], data[151:300, ], edge_betweenness, seed = 13L)
  x <- betweenness_network(tna(data[1:150, ]))
  y <- betweenness_network(tna(data[151:300, ]))
  table <- summary(rs_with_seed(5L, permutation_test(x, y, iter = tna_iter)), digits = 12L)
  found <- data.frame(from = table$from, to = table$to, abs_diff = abs(table$diff_true), p_value = table$p_value)
  expect_reference(subset(found, select = c(from, to, abs_diff)), subset(expected, select = c(from, to, abs_diff)),
                   reference = "NetworkComparisonTest",
                   covers = c("permutation_test()", "permutation_test.tna()", "summary.tna_permutation()"),
                   quantity = "observed absolute difference of edge betweenness", tolerance = 1e-10, key = c("from", "to"))
  expect_reference(subset(found, select = c(from, to, p_value)), subset(expected, select = c(from, to, p_value)),
                   reference = "NetworkComparisonTest",
                   covers = c("permutation_test()", "permutation_test.tna()", "summary.tna_permutation()"),
                   quantity = "Monte Carlo summary: permutation p-value of edge betweenness", tolerance = nct_tolerance,
                   key = c("from", "to"))
})

test_that("observed differences and p-values of two transition networks agree with a base-R permutation test", {
  # The formula route beside NCT: helper-resampling.R's rs_permutation() with 4000 relabellings; tolerance as for
  # the grouped model above, fixed before the run.
  data <- group_regulation[1:300, ]
  wide <- ref_wide(data)
  states <- ref_states(wide)
  reference <- rs_permutation(wide[1:150, ], wide[151:300, ], states, draws = 4000L, seed = 43L)
  table <- summary(rs_with_seed(6L, permutation_test(tna(data[1:150, ]), tna(data[151:300, ]), iter = 1000L)),
                   digits = 12L)
  cells <- paste(table$from, "->", table$to)
  expect_reference(stats::setNames(table$diff_true, cells), reference$observed[cells],
                   reference = "independent: difference of the two groups' relative networks, base R",
                   covers = c("permutation_test()", "permutation_test.tna()", "summary.tna_permutation()"),
                   quantity = "observed difference of two models", tolerance = 1e-10)
  q <- reference$exceed
  expect_reference(stats::setNames(table$p_value, cells), ((1000 * q + 1) / 1001)[cells],
                   reference = "independent: permutation test written in base R (helper-resampling.R)",
                   covers = c("permutation_test()", "permutation_test.tna()", "summary.tna_permutation()"),
                   quantity = "Monte Carlo summary: permutation p-value of two models",
                   tolerance = 4 * max(sqrt(q * (1 - q))) * sqrt(1 / 1000 + 1 / 4000) + 1 / 1001)
})

test_that("a grouped model is tested pair by pair as NCT() tests each pair of groups", {
  skip_without_reference("NetworkComparisonTest")
  data <- group_regulation[1:450, ]
  groups <- rep(c("a", "b", "c"), each = 150)
  table <- summary(rs_with_seed(44L, permutation_test(group_model(data, group = groups), iter = tna_iter)), digits = 12L)
  pairs <- list(c("a", "b"), c("a", "c"), c("b", "c"))
  lapply(seq_along(pairs), \(i) {
    two <- pairs[[i]]
    expected <- nct_edges(data[groups == two[[1L]], ], data[groups == two[[2L]], ], relative_network, seed = 20L + i)
    name <- paste(two[[1L]], "vs.", two[[2L]])
    rows <- subset(table, pair == name)
    expect_reference(data.frame(from = rows$from, to = rows$to, abs_diff = abs(rows$diff_true)),
                     subset(expected, select = c(from, to, abs_diff)), reference = "NetworkComparisonTest",
                     covers = c("permutation_test.group_tna()", "summary.group_tna_permutation()"),
                     quantity = sprintf("observed absolute difference, %s", name), tolerance = 1e-12,
                     key = c("from", "to"))
    expect_reference(data.frame(from = rows$from, to = rows$to, p_value = rows$p_value),
                     subset(expected, select = c(from, to, p_value)), reference = "NetworkComparisonTest",
                     covers = c("permutation_test.group_tna()", "summary.group_tna_permutation()"),
                     quantity = sprintf("Monte Carlo summary: permutation p-value, %s", name),
                     tolerance = nct_tolerance, key = c("from", "to"))
  })
})
