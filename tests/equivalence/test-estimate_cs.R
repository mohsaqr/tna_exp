# estimate_cs() and its alias estimate_centrality_stability(): case-dropping stability of in- and out-strength
# (Epskamp, Borsboom and Fried 2018). tna draws the kept sequences inside the function, so the comparison is
# statistical, against case-dropping written in base R (helper-resampling.R) with 2000 draws per proportion:
#
# - the mean correlation with the whole-data centrality at each proportion dropped (Monte Carlo summary). The
#   tolerance is 4 standard errors of the difference of two means, max over proportions of sd sqrt(1/500 + 1/2000),
#   the SD taken from the reference's own draws, fixed before the run;
# - the CS-coefficient (the largest proportion at which at least 95% of the correlations reach 0.7). It is a
#   step on the 0.1 grid; the data (150 sequences) were chosen so that no proportion's share is within Monte Carlo
#   error of 0.95, and the two coefficients must be equal.
#   A probe of 20 seeds of tna against the reference passed 20 of 20 for both before this file was run.

data <- group_regulation[1:150, ]
wide <- ref_wide(data)
states <- ref_states(wide)
model <- tna(data)
drop_prop <- seq(0.1, 0.9, by = 0.1)
iter <- 500L
draws <- 2000L
reference <- rs_casedrop(wide, states, drop_prop, draws, seed = 21L)
by_definition <- "independent: case-dropping written in base R (helper-resampling.R)"
tolerance_of <- \(correlations) 4 * max(apply(correlations, 2L, stats::sd)) * sqrt(1 / iter + 1 / draws)
measures <- c("InStrength", "OutStrength")

test_that("mean correlations per proportion dropped agree with base-R case-dropping", {
  lapply(1:3, \(seed) {
    stability <- rs_with_seed(seed, estimate_cs(model, measures = measures, iter = iter, drop_prop = drop_prop))
    lapply(measures, \(measure) {
      expect_reference(stats::setNames(colMeans(stability[[measure]]$correlations), drop_prop),
                       stats::setNames(colMeans(reference[[measure]]), drop_prop), reference = by_definition,
                       covers = c("estimate_cs()", "estimate_cs.tna()"),
                       quantity = sprintf("Monte Carlo summary: mean correlation, %s, seed %d", measure, seed),
                       tolerance = tolerance_of(reference[[measure]]))
    })
    expect_reference(summary(stability), data.frame(measure = measures,
                                                    cs_coefficient = vapply(reference, rs_cs, numeric(1), drop_prop)),
                     reference = by_definition, covers = c("estimate_cs()", "estimate_cs.tna()", "summary.tna_stability()"),
                     quantity = sprintf("Monte Carlo summary: CS-coefficient, seed %d", seed), tolerance = 1e-12,
                     key = "measure")
  })
})

test_that("estimate_centrality_stability() is the same procedure", {
  stability <- rs_with_seed(7L, estimate_centrality_stability(model, measures = measures, iter = iter, drop_prop = drop_prop))
  expect_reference(stats::setNames(colMeans(stability$InStrength$correlations), drop_prop),
                   stats::setNames(colMeans(reference$InStrength), drop_prop), reference = by_definition,
                   covers = c("estimate_centrality_stability()", "estimate_centrality_stability.tna()"),
                   quantity = "Monte Carlo summary: mean correlation, InStrength, alias", tolerance = tolerance_of(reference$InStrength))
})

test_that("a grouped model is case-dropped group by group", {
  groups <- rep(c("a", "b"), each = 75)
  grouped <- group_model(data, group = groups)
  stability <- rs_with_seed(8L, estimate_cs(grouped, measures = "InStrength", iter = iter, drop_prop = drop_prop))
  alias <- rs_with_seed(9L, estimate_centrality_stability(grouped, measures = "InStrength", iter = iter, drop_prop = drop_prop))
  per_group <- lapply(c(a = "a", b = "b"),
                      \(g) rs_casedrop(wide[groups == g, , drop = FALSE], states, drop_prop, draws, seed = 22L)$InStrength)
  lapply(c("a", "b"), \(g) {
    expect_reference(stats::setNames(colMeans(stability[[g]]$InStrength$correlations), drop_prop),
                     stats::setNames(colMeans(per_group[[g]]), drop_prop), reference = by_definition,
                     covers = "estimate_cs.group_tna()",
                     quantity = sprintf("Monte Carlo summary: mean correlation, InStrength, group %s", g),
                     tolerance = tolerance_of(per_group[[g]]))
    expect_reference(stats::setNames(colMeans(alias[[g]]$InStrength$correlations), drop_prop),
                     stats::setNames(colMeans(per_group[[g]]), drop_prop), reference = by_definition,
                     covers = "estimate_centrality_stability.group_tna()",
                     quantity = sprintf("Monte Carlo summary: mean correlation, InStrength, alias, group %s", g),
                     tolerance = tolerance_of(per_group[[g]]))
  })
  expect_reference(summary(stability), data.frame(group = c("a", "b"), measure = "InStrength",
                                                  cs_coefficient = vapply(per_group, rs_cs, numeric(1), drop_prop)),
                   reference = by_definition, covers = "summary.group_tna_stability()",
                   quantity = "Monte Carlo summary: CS-coefficient per group", tolerance = 1e-12, key = c("group", "measure"))
})
