# simulate() and random_tna(): sequences drawn from a first-order Markov chain. The draws come from inside the
# functions, so the comparison is statistical: the transition probabilities and initial probabilities estimated
# from 20000 simulated sequences of 25 states must lie near those of the chain they were drawn from (the
# group_regulation model). The estimate is computed in base R (a cross-tabulation of every time point with the
# next one), not with tna.
# Tolerance: 0.025 absolute. The least visited state of the group_regulation chain (adapt) is left about 9900 times
# in 20000 sequences of 25 states, so a transition probability has a binomial standard error of at most
# sqrt(0.25 / 9900) = 0.005; an initial probability, from 20000 first states, at most 0.0035. 0.025 is five of the
# larger one (looser than 1e-8 because the values are estimates from random draws).

model <- tna(group_regulation)
by_estimation <- "independent: transition and initial probabilities estimated in base R from the simulated sequences"

test_that("sequences simulated from a model reproduce its transition and initial probabilities", {
  simulated <- ref_wide(simulate(model, nsim = 20000, seed = 1, max_len = 25))
  states <- ref_states(simulated)
  expect_reference(model$weights, ref_rows(ref_pairs(simulated, states)), reference = by_estimation,
                   covers = c("simulate()", "simulate.tna()"), quantity = "transition probability of the simulated chain",
                   tolerance = 0.025)
  expect_reference(model$inits, ref_initial(simulated, states), reference = by_estimation,
                   covers = c("simulate()", "simulate.tna()"), quantity = "initial probability of the simulated chain",
                   tolerance = 0.025)
})

test_that("sequences generated from a given matrix reproduce it", {
  # random_tna() labels the rows and columns of the matrix with `states`, in that order; it returns the model of
  # the generated sequences, and with return_params = TRUE the sequences themselves.
  generated <- random_tna(n_states = 9, states = rownames(model$weights), trans_matrix = model$weights,
                          init_probs = model$inits, n_sequences = 20000, seq_length = 25, seed = 2,
                          return_params = TRUE)
  generated <- ref_wide(generated$sequences)
  states <- ref_states(generated)
  expect_reference(model$weights, ref_rows(ref_pairs(generated, states)), reference = by_estimation,
                   covers = "random_tna()", quantity = "transition probability of the generated chain",
                   tolerance = 0.025)
  expect_reference(model$inits, ref_initial(generated, states), reference = by_estimation,
                   covers = "random_tna()", quantity = "initial probability of the generated chain", tolerance = 0.025)
})

# The grouped generators. Tolerance for each: 5 times the largest binomial standard error of an estimated
# transition probability, sqrt(0.25 / departures), the expected departures from the least visited state computed
# from the generating chain before anything is drawn (rs_departures()); an initial probability, from n first
# states, 5 sqrt(0.25 / n).

test_that("simulate() of a grouped model draws each group from its own chain", {
  grouped <- group_model(group_regulation, group = rep(c("High", "Low"), each = 1000))
  n_seq <- 8000L
  len <- 25L
  simulated <- simulate(grouped, nsim = n_seq, max_len = len, seed = 3)
  lapply(c("High", "Low"), \(g) {
    chain <- grouped[[g]]
    part <- ref_wide(simulated[simulated$group == g, -1L])
    states <- rownames(chain$weights)
    tolerance <- 5 * sqrt(0.25 / min(rs_departures(chain$weights, chain$inits, n_seq, len)))
    expect_reference(chain$weights, ref_rows(ref_pairs(part, states)), reference = by_estimation,
                     covers = "simulate.group_tna()",
                     quantity = sprintf("Monte Carlo summary: transition probability of the simulated chain, group %s", g),
                     tolerance = tolerance)
    expect_reference(chain$inits, ref_initial(part, states), reference = by_estimation, covers = "simulate.group_tna()",
                     quantity = sprintf("Monte Carlo summary: initial probability of the simulated chain, group %s", g),
                     tolerance = 5 * sqrt(0.25 / n_seq))
  })
})

test_that("random_group_tna() estimates each group's model from sequences of the matrix it was given", {
  states <- c("Engaged", "Moderate", "Disengaged")
  given <- list(
    matrix(c(0.7, 0.2, 0.1, 0.3, 0.5, 0.2, 0.1, 0.3, 0.6), 3, byrow = TRUE, dimnames = list(states, states)),
    matrix(c(0.4, 0.4, 0.2, 0.1, 0.8, 0.1, 0.25, 0.25, 0.5), 3, byrow = TRUE, dimnames = list(states, states)))
  inits <- list(c(Engaged = 0.5, Moderate = 0.3, Disengaged = 0.2), c(Engaged = 0.2, Moderate = 0.3, Disengaged = 0.5))
  n_seq <- 6000L
  len <- 20L
  grouped <- random_group_tna(n_groups = 2, n_states = 3, states = states, n_sequences = n_seq, seq_length = len,
                              per_group = list(list(trans_matrix = given[[1L]], init_probs = inits[[1L]]),
                                               list(trans_matrix = given[[2L]], init_probs = inits[[2L]])),
                              seed = 4)
  lapply(1:2, \(k) {
    tolerance <- 5 * sqrt(0.25 / min(rs_departures(given[[k]], inits[[k]], n_seq, len)))
    expect_reference(grouped[[k]]$weights, given[[k]], reference = "independent: the transition matrix supplied",
                     covers = "random_group_tna()",
                     quantity = sprintf("Monte Carlo summary: estimated transition probability, group %d", k),
                     tolerance = tolerance)
    # The inits of a grouped model come unnamed (tna() names them); they are in the order of the weights' rows.
    estimated <- stats::setNames(grouped[[k]]$inits, rownames(grouped[[k]]$weights))
    expect_reference(estimated, inits[[k]], reference = "independent: the initial probabilities supplied",
                     covers = "random_group_tna()",
                     quantity = sprintf("Monte Carlo summary: estimated initial probability, group %d", k),
                     tolerance = 5 * sqrt(0.25 / n_seq))
  })
})

test_that("random_tna_mmm() draws each cluster's sequences from the chain it reports", {
  n_seq <- 12000L
  len <- 20L
  mixture <- random_tna_mmm(n_clusters = 2, n_states = 3, n_sequences = n_seq, seq_length = len, seed = 5)
  observations <- ref_wide(mixture$observations)
  expect_reference(sum(table(mixture$most_probable_cluster)), n_seq, reference = "independent: the number of sequences asked for",
                   covers = "random_tna_mmm()", quantity = "sequences over the clusters", tolerance = 0)
  lapply(mixture$cluster_names, \(cluster) {
    part <- observations[mixture$most_probable_cluster == cluster, , drop = FALSE]
    trans <- mixture$transition_probs[[cluster]]
    states <- rownames(trans)
    tolerance <- 5 * sqrt(0.25 / min(rs_departures(trans, mixture$initial_probs[[cluster]][states], nrow(part), len)))
    expect_reference(trans, ref_rows(ref_pairs(part, states)), reference = by_estimation, covers = "random_tna_mmm()",
                     quantity = sprintf("Monte Carlo summary: transition probability, %s", cluster), tolerance = tolerance)
    expect_reference(mixture$initial_probs[[cluster]], ref_initial(part, states), reference = by_estimation,
                     covers = "random_tna_mmm()", quantity = sprintf("Monte Carlo summary: initial probability, %s", cluster),
                     tolerance = 5 * sqrt(0.25 / nrow(part)))
  })
})

# The same recoveries with the estimate made by markovchain's maximum likelihood fit (markovchainFit) of the
# simulated sequences, the established estimator of a chain; tolerances as above, fixed before the run.

#' markovchain's maximum likelihood transition matrix of a wide table of sequences
#'
#' @param wide A character matrix, one sequence per row.
#' @param states The states, in the order wanted.
#' @return A square matrix.
markovchain_fit <- function(wide, states) {
  chains <- lapply(seq_len(nrow(wide)), \(row) as.vector(stats::na.omit(wide[row, ])))
  markovchain::markovchainFit(data = chains, method = "mle")$estimate@transitionMatrix[states, states]
}

test_that("markovchain's fit of simulated and generated sequences recovers the chain they were drawn from", {
  skip_without_reference("markovchain")
  states <- rownames(model$weights)
  lapply(1:3, \(seed) {
    simulated <- ref_wide(simulate(model, nsim = 20000, seed = seed + 10L, max_len = 25))
    expect_reference(model$weights, markovchain_fit(simulated, states), reference = "markovchain",
                     covers = c("simulate()", "simulate.tna()"),
                     quantity = sprintf("Monte Carlo summary: transition probability of the simulated chain, seed %d", seed),
                     tolerance = 0.025)
  })
  generated <- random_tna(n_states = 9, states = states, trans_matrix = model$weights, init_probs = model$inits,
                          n_sequences = 20000, seq_length = 25, seed = 12, return_params = TRUE)
  expect_reference(model$weights, markovchain_fit(ref_wide(generated$sequences), states), reference = "markovchain",
                   covers = "random_tna()", quantity = "Monte Carlo summary: transition probability of the generated chain",
                   tolerance = 0.025)
})

test_that("markovchain's fit of each group's or cluster's sequences recovers the chain it was drawn from", {
  skip_without_reference("markovchain")
  grouped <- group_model(group_regulation, group = rep(c("High", "Low"), each = 1000))
  n_seq <- 8000L
  len <- 25L
  simulated <- simulate(grouped, nsim = n_seq, max_len = len, seed = 13)
  lapply(c("High", "Low"), \(g) {
    chain <- grouped[[g]]
    states <- rownames(chain$weights)
    part <- ref_wide(subset(simulated, group == g, select = -group))
    expect_reference(chain$weights, markovchain_fit(part, states), reference = "markovchain",
                     covers = "simulate.group_tna()",
                     quantity = sprintf("Monte Carlo summary: transition probability of the simulated chain, group %s", g),
                     tolerance = 5 * sqrt(0.25 / min(rs_departures(chain$weights, chain$inits, n_seq, len))))
  })
  states <- c("Engaged", "Moderate", "Disengaged")
  given <- matrix(c(0.7, 0.2, 0.1, 0.3, 0.5, 0.2, 0.1, 0.3, 0.6), 3, byrow = TRUE, dimnames = list(states, states))
  inits <- c(Engaged = 0.5, Moderate = 0.3, Disengaged = 0.2)
  generated <- random_group_tna(n_groups = 2, n_states = 3, states = states, n_sequences = 6000L, seq_length = 20L,
                                per_group = list(list(trans_matrix = given, init_probs = inits),
                                                 list(trans_matrix = given, init_probs = inits)),
                                seed = 14)
  # the generated sequences are the model's data: state codes with the states as the "alphabet" attribute
  sequences <- generated[[1L]]$data
  decoded <- matrix(attr(sequences, "alphabet")[as.matrix(sequences)], nrow(sequences))
  expect_reference(given, markovchain_fit(decoded, states), reference = "markovchain",
                   covers = "random_group_tna()",
                   quantity = "Monte Carlo summary: transition probability of a generated group",
                   tolerance = 5 * sqrt(0.25 / min(rs_departures(given, inits, 6000L, 20L))))
  mixture <- random_tna_mmm(n_clusters = 2, n_states = 3, n_sequences = 12000L, seq_length = 20L, seed = 15)
  observations <- ref_wide(mixture$observations)
  lapply(mixture$cluster_names, \(cluster) {
    part <- observations[mixture$most_probable_cluster == cluster, , drop = FALSE]
    trans <- mixture$transition_probs[[cluster]]
    cluster_states <- rownames(trans)
    expect_reference(trans, markovchain_fit(part, cluster_states), reference = "markovchain", covers = "random_tna_mmm()",
                     quantity = sprintf("Monte Carlo summary: transition probability, %s", cluster),
                     tolerance = 5 * sqrt(0.25 / min(rs_departures(trans, mixture$initial_probs[[cluster]][cluster_states],
                                                                   nrow(part), len = 20L))))
  })
})
