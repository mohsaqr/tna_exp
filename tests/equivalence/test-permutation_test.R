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
