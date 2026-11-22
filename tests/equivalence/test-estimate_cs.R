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

# Against bootnet's case-dropping bootstrap (Epskamp, Borsboom and Fried 2018), the established implementation:
# bootnet(type = "case") drops sequences, re-estimates the network with the estimator it is given, and corStability()
# gives the CS-coefficient. Each sequence is one row of its pair counts; the estimator builds the relative network
# without loops (as estimate_cs() uses it) of the rows it receives. bootnet draws one proportion per resample from the
# grid 0.1, ..., 0.9 (caseMin, caseMax, caseN) and keeps round((1 - p) n) sequences, n - floor(n p) for the sizes
# used here (n a multiple of 10).
# Tolerances: the mean correlation per proportion, 4 standard errors of the difference of two means, the SD of
# bootnet's own correlations at that proportion times sqrt(1/500 + 1/m), m the number of bootnet's resamples at it,
# maximum over the proportions, fixed before the run. The CS-coefficient, a step on the grid: equal (1e-12). bootnet
# counts a correlation above 0.7 and a share above 0.95 strictly, tna at or above; on continuous correlations and
# with no share within Monte Carlo error of 0.95 (the data of this file) the two rules agree.

#' bootnet's case-dropping bootstrap of in- and out-strength
#'
#' @param wide A character matrix, one sequence per row.
#' @param boots The number of resamples over all proportions.
#' @param seed The seed of bootnet's draws.
#' @return A list: `cs` (named by measure, as tna names it), `mean` and `tolerance` (per measure, the mean
#'   correlation per proportion named by the proportion, and the tolerance of the header).
bootnet_casedrop <- function(wide, boots, seed) {
  k <- length(states)
  counts <- `colnames<-`(rs_counts(wide, states), sprintf("c%02d", seq_len(k * k)))
  network <- function(data, ...) {
    w <- ref_rows(matrix(colSums(data), k, dimnames = list(states, states)))
    diag(w) <- 0
    w
  }
  estimated <- bootnet::estimateNetwork(as.data.frame(counts), fun = network, labels = states, directed = TRUE,
                                        verbose = FALSE)
  dropped <- rs_with_seed(seed, bootnet::bootnet(estimated, type = "case", nBoots = boots,
                                                 statistics = c("inStrength", "outStrength"), caseMin = 0.1,
                                                 caseMax = 0.9, caseN = 9, verbose = FALSE, nCores = 1))
  boot_table <- as.data.frame(dropped$bootTable)
  sample_table <- as.data.frame(dropped$sampleTable)
  per_measure <- lapply(c(InStrength = "inStrength", OutStrength = "outStrength"), \(statistic) {
    rows <- boot_table[boot_table$type == statistic, ]
    original <- sample_table[sample_table$type == statistic, ]
    by_boot <- split(rows, rows$name)
    correlation <- vapply(by_boot, \(b) stats::cor(b$value, original$value[match(b$node1, original$node1)]), numeric(1))
    proportion <- round(1 - vapply(by_boot, \(b) b$nPerson[[1L]], numeric(1)) / nrow(wide), 10)
    means <- tapply(correlation, proportion, mean)
    spread <- tapply(correlation, proportion, stats::sd)
    m <- tapply(correlation, proportion, length)
    list(mean = stats::setNames(as.vector(means), names(means)),
         tolerance = 4 * max(spread * sqrt(1 / iter + 1 / m)))
  })
  cs <- suppressMessages(bootnet::corStability(dropped, cor = 0.7, verbose = FALSE))
  list(cs = c(InStrength = cs[["inStrength"]], OutStrength = cs[["outStrength"]]),
       mean = lapply(per_measure, `[[`, "mean"), tolerance = lapply(per_measure, `[[`, "tolerance"))
}

test_that("mean correlations and CS-coefficients agree with bootnet's case-dropping bootstrap", {
  skip_without_reference("bootnet")
  by_bootnet <- bootnet_casedrop(wide, boots = 18000L, seed = 23L)
  lapply(1:3, \(seed) {
    stability <- rs_with_seed(seed + 10L, estimate_cs(model, measures = measures, iter = iter, drop_prop = drop_prop))
    lapply(measures, \(measure) {
      expect_reference(stats::setNames(colMeans(stability[[measure]]$correlations), drop_prop),
                       by_bootnet$mean[[measure]], reference = "bootnet",
                       covers = c("estimate_cs()", "estimate_cs.tna()"),
                       quantity = sprintf("Monte Carlo summary: mean correlation, %s, seed %d", measure, seed),
                       tolerance = by_bootnet$tolerance[[measure]])
    })
    expect_reference(summary(stability), data.frame(measure = measures, cs_coefficient = by_bootnet$cs[measures]),
                     reference = "bootnet", covers = c("estimate_cs()", "estimate_cs.tna()", "summary.tna_stability()"),
                     quantity = sprintf("Monte Carlo summary: CS-coefficient, seed %d", seed), tolerance = 1e-12,
                     key = "measure")
  })
  alias <- rs_with_seed(17L, estimate_centrality_stability(model, measures = measures, iter = iter, drop_prop = drop_prop))
  expect_reference(stats::setNames(colMeans(alias$OutStrength$correlations), drop_prop), by_bootnet$mean$OutStrength,
                   reference = "bootnet", covers = c("estimate_centrality_stability()", "estimate_centrality_stability.tna()"),
                   quantity = "Monte Carlo summary: mean correlation, OutStrength, alias",
                   tolerance = by_bootnet$tolerance$OutStrength)
})

test_that("a grouped model is case-dropped group by group as bootnet drops each group", {
  skip_without_reference("bootnet")
  more <- group_regulation[1:200, ]
  more_wide <- ref_wide(more)
  groups <- rep(c("a", "b"), each = 100)
  grouped <- group_model(more, group = groups)
  stability <- rs_with_seed(18L, estimate_cs(grouped, measures = "InStrength", iter = iter, drop_prop = drop_prop))
  alias <- rs_with_seed(19L, estimate_centrality_stability(grouped, measures = "InStrength", iter = iter, drop_prop = drop_prop))
  per_group <- lapply(c(a = "a", b = "b"), \(g) bootnet_casedrop(more_wide[groups == g, , drop = FALSE], boots = 9000L,
                                                                 seed = 24L))
  lapply(c("a", "b"), \(g) {
    expect_reference(stats::setNames(colMeans(stability[[g]]$InStrength$correlations), drop_prop),
                     per_group[[g]]$mean$InStrength, reference = "bootnet",
                     covers = "estimate_cs.group_tna()",
                     quantity = sprintf("Monte Carlo summary: mean correlation, InStrength, group %s", g),
                     tolerance = per_group[[g]]$tolerance$InStrength)
    expect_reference(stats::setNames(colMeans(alias[[g]]$InStrength$correlations), drop_prop),
                     per_group[[g]]$mean$InStrength, reference = "bootnet",
                     covers = "estimate_centrality_stability.group_tna()",
                     quantity = sprintf("Monte Carlo summary: mean correlation, InStrength, alias, group %s", g),
                     tolerance = per_group[[g]]$tolerance$InStrength)
  })
  # bootnet's share of correlations at or above 0.7 is at least 0.99 at every proportion in both groups (a probe of
  # bootnet alone, before tna was compared), far outside Monte Carlo error of 0.95: the coefficients must be equal.
  expect_reference(summary(stability),
                   data.frame(group = c("a", "b"), measure = "InStrength",
                              cs_coefficient = vapply(per_group, \(found) found$cs[["InStrength"]], numeric(1))),
                   reference = "bootnet", covers = c("estimate_cs.group_tna()", "summary.group_tna_stability()"),
                   quantity = "Monte Carlo summary: CS-coefficient per group", tolerance = 1e-12,
                   key = c("group", "measure"))
})
