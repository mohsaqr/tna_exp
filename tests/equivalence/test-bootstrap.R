# bootstrap() and bootstrap_cliques(): the nonparametric bootstrap of the sequences (Efron 1979) of a relative
# transition network. tna draws its resamples inside the function, so the evidence is of two kinds:
#
# - what does not depend on the draws, from its definition: the original weights (the row-normalised counts of
#   consecutive pairs), the consistency range (0.75 and 1.25 times the weight), a clique's weight (the mean of its
#   block of weights);
# - Monte Carlo summaries against a bootstrap written in base R (helper-resampling.R) with its own 4000 resamples:
#   the bootstrap mean and SD of each weight and the "stability" p-value, (1 + number of resamples outside the
#   consistency range) / (iter + 1). Tolerances, derived before the run from the reference's own spread, for
#   tna's iter = 1000 against the reference's B = 4000 draws, 4 standard errors of the difference:
#     mean: 4 max_e sd_e sqrt(1/1000 + 1/4000);
#     SD: 4 max_e sqrt((m4_e - sd_e^4) / (4 sd_e^2)) sqrt(1/1000 + 1/4000), the large-sample SE of a sample SD;
#     p-value: 4 max_e sqrt(q_e (1 - q_e)) sqrt(1/1000 + 1/4000) + 1/1001, q_e the reference's share outside the
#     range (the 1/1001 covers the +1 of tna's p-value).
#   A probe of 20 seeds of tna against one reference run passed 20 of 20 for each summary before this file was run.

data <- group_regulation[1:300, ]
wide <- ref_wide(data)
states <- ref_states(wide)
model <- tna(data)
iter <- 1000L
draws <- 4000L
reference <- rs_bootstrap(wide, states, draws, seed = 11L)
weights <- ref_rows(ref_pairs(wide, states))
by_definition <- "independent: the bootstrap of the sequences written in base R (helper-resampling.R)"
exact <- 1e-12

#' The Monte Carlo tolerances of the header, from a draws x cells matrix and the observed weights
boot_tolerances <- function(draws_matrix, observed) {
  spread <- apply(draws_matrix, 2L, stats::sd)
  centred <- sweep(draws_matrix, 2L, colMeans(draws_matrix))
  m4 <- colMeans(centred^4)
  se_sd <- ifelse(spread > 0, sqrt(pmax(m4 - spread^4, 0) / (4 * spread^2)), 0)
  outside <- colMeans(sweep(draws_matrix, 2L, 0.75 * observed, "<=") | sweep(draws_matrix, 2L, 1.25 * observed, ">="))
  scale <- sqrt(1 / iter + 1 / nrow(draws_matrix))
  list(mean = 4 * max(spread) * scale, sd = 4 * max(se_sd) * scale,
       p = 4 * max(sqrt(outside * (1 - outside))) * scale + 1 / (iter + 1),
       outside = outside, mean_of = colMeans(draws_matrix), sd_of = spread)
}
summaries <- boot_tolerances(reference, rs_cells(weights))
expected_p <- (iter * summaries$outside + 1) / (iter + 1)

test_that("the original weights and the consistency range follow their definitions", {
  boot <- bootstrap(model, iter = 10, seed = 1)
  expect_reference(boot$weights_orig, weights, reference = "independent: row-normalised counts of consecutive pairs",
                   covers = c("bootstrap()", "bootstrap.tna()"), quantity = "original weight", tolerance = exact)
  expect_reference(boot$cr_lower, 0.75 * weights, reference = "independent: 0.75 times the weight",
                   covers = c("bootstrap()", "bootstrap.tna()"), quantity = "lower end of the consistency range",
                   tolerance = exact)
  expect_reference(summary(boot), data.frame(ref_long(weights, "weight"), cr_upper = as.vector(1.25 * weights))[
                     as.vector(weights) > 0, ], reference = "independent: 1.25 times the weight",
                   covers = "summary.tna_bootstrap()", quantity = "summary weight and upper end of the range",
                   tolerance = exact, key = c("from", "to"))
})

test_that("bootstrap means, SDs and p-values agree with a base-R bootstrap within Monte Carlo error", {
  lapply(1:3, \(seed) {
    boot <- bootstrap(model, iter = iter, seed = seed)
    expect_reference(rs_cells(boot$weights_mean), summaries$mean_of, reference = by_definition,
                     covers = c("bootstrap()", "bootstrap.tna()"),
                     quantity = sprintf("Monte Carlo summary: bootstrap mean of the weight, seed %d", seed),
                     tolerance = summaries$mean)
    expect_reference(rs_cells(boot$weights_sd), summaries$sd_of, reference = by_definition,
                     covers = c("bootstrap()", "bootstrap.tna()"),
                     quantity = sprintf("Monte Carlo summary: bootstrap SD of the weight, seed %d", seed),
                     tolerance = summaries$sd)
    expect_reference(rs_cells(boot$p_values), expected_p, reference = by_definition,
                     covers = c("bootstrap()", "bootstrap.tna()"),
                     quantity = sprintf("Monte Carlo summary: stability p-value, seed %d", seed), tolerance = summaries$p)
    table <- summary(boot)
    expect_reference(stats::setNames(table$p_value, paste(table$from, "->", table$to)),
                     expected_p[paste(table$from, "->", table$to)], reference = by_definition,
                     covers = "summary.tna_bootstrap()",
                     quantity = sprintf("Monte Carlo summary: summary p-value, seed %d", seed), tolerance = summaries$p)
  })
})

test_that("a grouped model bootstraps each group as its own data", {
  groups <- rep(c("a", "b"), each = 150)
  grouped <- group_model(data, group = groups)
  boot <- bootstrap(grouped, iter = iter, seed = 4)
  table <- summary(boot)
  lapply(c("a", "b"), \(g) {
    part <- wide[groups == g, , drop = FALSE]
    observed <- ref_rows(ref_pairs(part, states))
    tolerances <- boot_tolerances(rs_bootstrap(part, states, draws, seed = 12L), rs_cells(observed))
    expect_reference(rs_cells(boot[[g]]$weights_mean), tolerances$mean_of, reference = by_definition,
                     covers = "bootstrap.group_tna()",
                     quantity = sprintf("Monte Carlo summary: bootstrap mean of the weight, group %s", g),
                     tolerance = tolerances$mean)
    rows <- table[table$group == g, ]
    expect_reference(stats::setNames(rows$p_value, paste(rows$from, "->", rows$to)),
                     ((iter * tolerances$outside + 1) / (iter + 1))[paste(rows$from, "->", rows$to)],
                     reference = by_definition, covers = "summary.group_tna_bootstrap()",
                     quantity = sprintf("Monte Carlo summary: stability p-value, group %s", g), tolerance = tolerances$p)
    expect_reference(stats::setNames(rows$weight, paste(rows$from, "->", rows$to)),
                     rs_cells(observed)[paste(rows$from, "->", rows$to)],
                     reference = "independent: row-normalised counts of consecutive pairs",
                     covers = "summary.group_tna_bootstrap()", quantity = sprintf("summary weight, group %s", g),
                     tolerance = exact)
  })
})

test_that("bootstrap_cliques() weights follow their definition and p-values agree within Monte Carlo error", {
  boot <- bootstrap_cliques(model, size = 2, iter = iter, seed = 5)
  pairs <- strsplit(boot$clique, "-", fixed = TRUE)
  clique_mean <- \(w) vapply(pairs, \(p) mean(w[p, p]), numeric(1))
  expect_reference(stats::setNames(boot$mean_weight, boot$clique), stats::setNames(clique_mean(weights), boot$clique),
                   reference = "independent: the mean of the clique's block of weights",
                   covers = c("bootstrap_cliques()", "bootstrap_cliques.tna()"), quantity = "clique weight",
                   tolerance = exact)
  per_draw <- t(apply(reference, 1L, \(cells) clique_mean(matrix(cells, length(states), dimnames = list(states, states)))))
  observed <- clique_mean(weights)
  outside <- colMeans(sweep(per_draw, 2L, 0.75 * observed, "<=") | sweep(per_draw, 2L, 1.25 * observed, ">="))
  tolerance <- 4 * max(sqrt(outside * (1 - outside))) * sqrt(1 / iter + 1 / draws) + 1 / (iter + 1)
  expect_reference(stats::setNames(boot$p_values, boot$clique), stats::setNames((iter * outside + 1) / (iter + 1), boot$clique),
                   reference = by_definition, covers = c("bootstrap_cliques()", "bootstrap_cliques.tna()"),
                   quantity = "Monte Carlo summary: clique stability p-value", tolerance = tolerance)
})

# Against boot::boot() (Canty and Ripley; Davison and Hinkley 1997), the established implementation of the
# nonparametric bootstrap: boot() resamples the sequences (rows of their pair counts) with replacement and the
# statistic builds the relative network of the rows it is given. The summaries and their Monte Carlo tolerances
# are those of the header (boot_tolerances(), 4 standard errors of the difference for tna's 1000 against boot's
# 4000 resamples), fixed before the run.

#' boot()'s draws of the relative network of a set of sequences
#'
#' @param wide A character matrix, one sequence per row.
#' @param seed The seed of boot()'s resampling.
#' @return A draws x cells matrix (cells column-major, named as rs_cells()).
boot_draws <- function(wide, seed) {
  counts <- rs_counts(wide, states)
  k <- length(states)
  network <- \(rows, index) as.vector(ref_rows(matrix(colSums(rows[index, , drop = FALSE]), k)))
  draws_matrix <- rs_with_seed(seed, boot::boot(counts, statistic = network, R = draws)$t)
  colnames(draws_matrix) <- names(rs_cells(weights))
  draws_matrix
}

test_that("bootstrap means, SDs and p-values agree with boot::boot() within Monte Carlo error", {
  skip_without_reference("boot")
  booted <- boot_draws(wide, seed = 13L)
  by_boot <- boot_tolerances(booted, rs_cells(weights))
  boot_p <- (iter * by_boot$outside + 1) / (iter + 1)
  lapply(1:3, \(seed) {
    boot <- bootstrap(model, iter = iter, seed = seed + 10L)
    expect_reference(rs_cells(boot$weights_mean), by_boot$mean_of, reference = "boot",
                     covers = c("bootstrap()", "bootstrap.tna()"),
                     quantity = sprintf("Monte Carlo summary: bootstrap mean of the weight, seed %d", seed),
                     tolerance = by_boot$mean)
    expect_reference(rs_cells(boot$weights_sd), by_boot$sd_of, reference = "boot",
                     covers = c("bootstrap()", "bootstrap.tna()"),
                     quantity = sprintf("Monte Carlo summary: bootstrap SD of the weight, seed %d", seed),
                     tolerance = by_boot$sd)
    table <- summary(boot)
    edges <- paste(table$from, "->", table$to)
    expect_reference(stats::setNames(table$p_value, edges), boot_p[edges], reference = "boot",
                     covers = c("bootstrap()", "bootstrap.tna()", "summary.tna_bootstrap()"),
                     quantity = sprintf("Monte Carlo summary: stability p-value, seed %d", seed), tolerance = by_boot$p)
  })
})

test_that("a grouped model and clique bootstraps agree with boot::boot() within Monte Carlo error", {
  skip_without_reference("boot")
  groups <- rep(c("a", "b"), each = 150)
  boot <- bootstrap(group_model(data, group = groups), iter = iter, seed = 14)
  table <- summary(boot)
  lapply(c("a", "b"), \(g) {
    part <- wide[groups == g, , drop = FALSE]
    observed <- ref_rows(ref_pairs(part, states))
    by_boot <- boot_tolerances(boot_draws(part, seed = 15L), rs_cells(observed))
    expect_reference(rs_cells(boot[[g]]$weights_mean), by_boot$mean_of, reference = "boot",
                     covers = "bootstrap.group_tna()",
                     quantity = sprintf("Monte Carlo summary: bootstrap mean of the weight, group %s", g),
                     tolerance = by_boot$mean)
    expect_reference(rs_cells(boot[[g]]$weights_sd), by_boot$sd_of, reference = "boot",
                     covers = "bootstrap.group_tna()",
                     quantity = sprintf("Monte Carlo summary: bootstrap SD of the weight, group %s", g),
                     tolerance = by_boot$sd)
    rows <- table[table$group == g, ]
    edges <- paste(rows$from, "->", rows$to)
    expect_reference(stats::setNames(rows$p_value, edges), ((iter * by_boot$outside + 1) / (iter + 1))[edges],
                     reference = "boot", covers = c("bootstrap.group_tna()", "summary.group_tna_bootstrap()"),
                     quantity = sprintf("Monte Carlo summary: stability p-value, group %s", g), tolerance = by_boot$p)
  })
  cliques_boot <- bootstrap_cliques(model, size = 2, iter = iter, seed = 16)
  pairs <- strsplit(cliques_boot$clique, "-", fixed = TRUE)
  clique_mean <- \(w) vapply(pairs, \(p) mean(w[p, p]), numeric(1))
  per_draw <- t(apply(boot_draws(wide, seed = 17L), 1L,
                      \(cells) clique_mean(matrix(cells, length(states), dimnames = list(states, states)))))
  observed <- clique_mean(weights)
  outside <- colMeans(sweep(per_draw, 2L, 0.75 * observed, "<=") | sweep(per_draw, 2L, 1.25 * observed, ">="))
  tolerance <- 4 * max(sqrt(outside * (1 - outside))) * sqrt(1 / iter + 1 / draws) + 1 / (iter + 1)
  expect_reference(stats::setNames(cliques_boot$p_values, cliques_boot$clique),
                   stats::setNames((iter * outside + 1) / (iter + 1), cliques_boot$clique), reference = "boot",
                   covers = c("bootstrap_cliques()", "bootstrap_cliques.tna()"),
                   quantity = "Monte Carlo summary: clique stability p-value", tolerance = tolerance)
})
