# Group models: one model per group of sequences, from a grouping vector or column (group_tna() and its
# siblings, group_model()), from a clustering of the sequences (cluster_data()), from tna's own mixture Markov
# model and from a seqHMM mixture model. Against TraMineR's seqtrate() on each group's sequences and against
# base R counts of each group.
# Tolerances: a probability is a ratio of two whole counts (1e-12 absolute); a count is a whole number (0); a
# min-max scaled count is one subtraction and one division (1e-12).

wide <- ref_wide(group_regulation)
states <- ref_states(wide)
halves <- rep(c("first", "second"), each = 1000)
by_definition <- "independent: counts of each group's sequences in base R"

#' The weight matrices of several models as one table: group, from, to, value
#'
#' @param matrices A named list of square matrices with dimnames.
#' @return A data frame.
ref_groups_long <- function(matrices) {
  do.call(rbind, Map(\(cells, group) data.frame(group = group, ref_long(cells)), matrices, names(matrices)))
}

#' A named list of row-split wide tables, counted
#'
#' @param group The group of each row of `wide`.
#' @param count A function of one wide table.
#' @return A named list of matrices.
ref_by_group <- function(group, count) {
  rows <- split(seq_len(nrow(wide)), factor(group, levels = unique(group)))
  lapply(rows, \(r) count(wide[r, , drop = FALSE]))
}

model_weights <- \(models) ref_groups_long(lapply(models, \(model) model$weights))

test_that("group models from a grouping vector equal TraMineR's seqtrate() per group", {
  skip_without_reference("TraMineR")
  rates_of <- \(rows) {
    sequences <- suppressMessages(TraMineR::seqdef(as.data.frame(group_regulation[rows, ]),
                                                   alphabet = states))
    `dimnames<-`(TraMineR::seqtrate(sequences), list(states, states))
  }
  expected <- ref_groups_long(list(first = rates_of(1:1000), second = rates_of(1001:2000)))
  expect_reference(model_weights(group_tna(group_regulation, group = halves)), expected, reference = "TraMineR",
                   covers = c("group_tna()", "group_model()", "group_model.default()"),
                   quantity = "transition probability per group", tolerance = 1e-12,
                   key = c("group", "from", "to"))
})

test_that("group models of each type equal the counts of each group", {
  probabilities <- ref_groups_long(ref_by_group(halves, \(w) ref_rows(ref_pairs(w, states))))
  expect_reference(model_weights(group_tna(group_regulation, group = halves)), probabilities,
                   reference = by_definition, covers = c("group_tna()", "group_model.default()"),
                   quantity = "transition probability per group", tolerance = 1e-12, key = c("group", "from", "to"))
  frequencies <- ref_groups_long(ref_by_group(halves, \(w) ref_pairs(w, states)))
  expect_reference(model_weights(group_ftna(group_regulation, group = halves)), frequencies,
                   reference = by_definition, covers = c("group_ftna()", "group_model.default()"),
                   quantity = "transition count per group", tolerance = 0, key = c("group", "from", "to"))
  lags <- seq_len(ncol(wide) - 1L)
  attention <- ref_groups_long(ref_by_group(halves, \(w) Reduce(`+`, lapply(lags, \(lag) exp(-lag) * ref_pairs(w, states, lag)))))
  expect_reference(model_weights(group_atna(group_regulation, group = halves)), attention,
                   reference = by_definition, covers = c("group_atna()", "group_model.default()"),
                   quantity = "attention weight per group", tolerance = 1e-10, measure = "relative",
                   key = c("group", "from", "to"))
  cooccurrence <- \(w) {
    visits <- t(apply(w, 1L, \(row) table(factor(row, levels = states))))
    `dimnames<-`(crossprod(visits) - diag(colSums(visits)), list(states, states))
  }
  expected <- ref_by_group(halves, cooccurrence)
  observed <- lapply(group_ctna(group_regulation, group = halves), \(model) model$weights)
  expect_reference(unlist(lapply(observed, ref_off_diagonal)), unlist(lapply(expected, ref_off_diagonal)),
                   reference = by_definition, covers = c("group_ctna()", "group_model.default()"),
                   quantity = "co-occurrence count per group, two states", tolerance = 0)
  # Convention, not a defect (verified 2026-11-20): as in ctna(), a pair of time points in one state is counted once
  # on the diagonal; halved, the definition agrees.
  expect_known_difference(unlist(lapply(observed, ref_diagonal)), unlist(lapply(expected, ref_diagonal)),
                          reference = by_definition, covers = c("group_ctna()", "group_model.default()"),
                          quantity = "co-occurrence count per group, one state", tolerance = 0,
                          reason = "group_ctna() counts a pair of time points in one state once on the diagonal, where a pair of two states is entered in both mirror cells; the definition used here counts both directions",
                          agrees_with = "the same count with the diagonal halved")
  expect_reference(unlist(lapply(observed, ref_diagonal)), unlist(lapply(expected, ref_diagonal)) / 2,
                   reference = by_definition, covers = c("group_ctna()", "group_model.default()"),
                   quantity = "co-occurrence count per group, one state, each pair once", tolerance = 0)
})

test_that("a grouping column, initial probabilities and joint scaling equal the counts of each group", {
  frame <- data.frame(group_regulation, half = halves)
  expected <- ref_groups_long(ref_by_group(halves, \(w) ref_rows(ref_pairs(w, states))))
  expect_reference(model_weights(group_model(frame, group = "half")), expected, reference = by_definition,
                   covers = c("group_model()", "group_model.default()"),
                   quantity = "transition probability per group, grouping column", tolerance = 1e-12,
                   key = c("group", "from", "to"))
  initial <- ref_by_group(halves, \(w) ref_initial(w, states))
  observed_initial <- lapply(group_tna(group_regulation, group = halves), \(model) model$inits)
  # The group models' initial probabilities carry no state names (tna() names them): read in the states' order.
  expect_reference(unname(unlist(observed_initial)), unlist(initial), reference = by_definition,
                   covers = c("group_tna()", "group_model.default()"), quantity = "initial probability per group",
                   tolerance = 1e-12)
  # Without groupwise scaling, min-max runs over the counts of all groups together.
  counts <- ref_by_group(halves, \(w) ref_pairs(w, states))
  low <- min(unlist(counts))
  high <- max(unlist(counts))
  joint <- ref_groups_long(lapply(counts, \(cells) (cells - low) / (high - low)))
  expect_reference(model_weights(group_ftna(group_regulation, group = halves, scaling = "minmax")), joint,
                   reference = by_definition, covers = c("group_ftna()", "group_model.default()"),
                   quantity = "count min-max scaled over all groups", tolerance = 1e-12,
                   key = c("group", "from", "to"))
  each <- ref_groups_long(lapply(counts, \(cells) (cells - min(cells)) / (max(cells) - min(cells))))
  expect_reference(model_weights(group_ftna(group_regulation, group = halves, scaling = "minmax", groupwise = TRUE)),
                   each, reference = by_definition, covers = c("group_ftna()", "group_model.default()"),
                   quantity = "count min-max scaled per group", tolerance = 1e-12, key = c("group", "from", "to"))
})

test_that("a clustering and tna's mixture model give the models of their clusters", {
  sequences <- group_regulation[seq_len(200L), ]
  clustering <- cluster_data(sequences, k = 3)
  assignment <- clustering$assignments
  small <- wide[seq_len(200L), ]
  expected <- lapply(split(seq_len(200L), paste("Group", assignment)),
                     \(rows) ref_rows(ref_pairs(small[rows, , drop = FALSE], states)))
  expect_reference(model_weights(group_model(clustering)), ref_groups_long(expected), reference = by_definition,
                   covers = c("group_model()", "group_model.tna_clustering()"),
                   quantity = "transition probability per cluster of cluster_data()", tolerance = 1e-12,
                   key = c("group", "from", "to"))
  mixture_wide <- ref_wide(engagement_mmm$observations)
  mixture_states <- ref_states(mixture_wide)
  clusters <- as.character(engagement_mmm$most_probable_cluster)
  by_cluster <- lapply(split(seq_len(nrow(mixture_wide)), clusters),
                       \(rows) ref_rows(ref_pairs(mixture_wide[rows, , drop = FALSE], mixture_states)))
  expect_reference(model_weights(group_model(engagement_mmm)), ref_groups_long(by_cluster), reference = by_definition,
                   covers = c("group_model()", "group_model.tna_mmm()"),
                   quantity = "transition probability per cluster of a tna_mmm", tolerance = 1e-12,
                   key = c("group", "from", "to"))
})

test_that("a seqHMM mixture Markov model gives the TraMineR rates of its most probable clusters", {
  skip_without_reference(c("seqHMM", "TraMineR"))
  set.seed(3)
  covariates <- data.frame(x = stats::rnorm(300))
  initial <- seqHMM::build_mmm(engagement[seq_len(300L), ], n_clusters = 2, formula = ~ x, data = covariates)
  fit <- seqHMM::fit_model(initial)$model
  cluster <- summary(fit)$most_probable_cluster
  alphabet <- TraMineR::alphabet(engagement)
  rates <- lapply(split(seq_len(300L), cluster), \(rows) {
    `dimnames<-`(TraMineR::seqtrate(engagement[rows, ]), list(alphabet, alphabet))
  })
  expect_reference(model_weights(group_model(fit)), ref_groups_long(rates), reference = "TraMineR",
                   covers = c("group_model()", "group_model.mhmm()"),
                   quantity = "transition probability per most probable cluster of seqHMM", tolerance = 1e-12,
                   key = c("group", "from", "to"))
})

#' TraMineR's lagged transition counts of a set of rows of a sequence table, one table per lag
#'
#' @param data A wide sequence table.
#' @param alphabet The states.
#' @param lags The lags.
#' @return A list of count matrices.
traminer_group_lags <- function(data, alphabet, lags) {
  sequences <- suppressMessages(TraMineR::seqdef(as.data.frame(data), alphabet = alphabet))
  lapply(lags, \(lag) `dimnames<-`(suppressMessages(TraMineR::seqtrate(sequences, lag = lag, count = TRUE)),
                                   list(alphabet, alphabet)))
}

test_that("group models of each type equal TraMineR's (lagged) transition counts per group", {
  skip_without_reference("TraMineR")
  lags <- seq_len(ncol(group_regulation) - 1L)
  per_group <- list(first = traminer_group_lags(group_regulation[1:1000, ], states, lags),
                    second = traminer_group_lags(group_regulation[1001:2000, ], states, lags))
  expect_reference(model_weights(group_ftna(group_regulation, group = halves)),
                   ref_groups_long(lapply(per_group, `[[`, 1L)), reference = "TraMineR",
                   covers = c("group_ftna()", "group_model.default()"), quantity = "transition count per group",
                   tolerance = 0, key = c("group", "from", "to"))
  attention <- lapply(per_group, \(tables) Reduce(`+`, Map(\(counts, lag) exp(-lag) * counts, tables, lags)))
  expect_reference(model_weights(group_atna(group_regulation, group = halves)), ref_groups_long(attention),
                   reference = "TraMineR", covers = c("group_atna()", "group_model.default()"),
                   quantity = "attention weight per group, from lagged counts", tolerance = 1e-10, measure = "relative",
                   key = c("group", "from", "to"))
  cooccurrence <- lapply(per_group, \(tables) {
    both <- Reduce(`+`, lapply(tables, \(counts) counts + t(counts)))
    `diag<-`(both, diag(both) / 2)
  })
  expect_reference(model_weights(group_ctna(group_regulation, group = halves)), ref_groups_long(cooccurrence),
                   reference = "TraMineR", covers = c("group_ctna()", "group_model.default()"),
                   quantity = "co-occurrence count per group, from lagged counts (each same-state pair once)",
                   tolerance = 0, key = c("group", "from", "to"))
})

test_that("a clustering and tna's mixture model give TraMineR's rates of their clusters", {
  skip_without_reference("TraMineR")
  sequences <- group_regulation[seq_len(200L), ]
  clustering <- cluster_data(sequences, k = 3)
  rates_of <- \(data, alphabet) {
    `dimnames<-`(suppressMessages(TraMineR::seqtrate(suppressMessages(TraMineR::seqdef(as.data.frame(data),
                                                                                         alphabet = alphabet)))),
                 list(alphabet, alphabet))
  }
  by_cluster <- lapply(split(seq_len(200L), paste("Group", clustering$assignments)),
                       \(rows) rates_of(sequences[rows, ], states))
  expect_reference(model_weights(group_model(clustering)), ref_groups_long(by_cluster), reference = "TraMineR",
                   covers = c("group_model()", "group_model.tna_clustering()"),
                   quantity = "transition probability per cluster of cluster_data()", tolerance = 1e-12,
                   key = c("group", "from", "to"))
  observations <- engagement_mmm$observations
  mixture_states <- ref_states(ref_wide(observations))
  clusters <- as.character(engagement_mmm$most_probable_cluster)
  mixture_rates <- lapply(split(seq_len(nrow(observations)), clusters),
                          \(rows) rates_of(observations[rows, ], mixture_states))
  expect_reference(model_weights(group_model(engagement_mmm)), ref_groups_long(mixture_rates), reference = "TraMineR",
                   covers = c("group_model()", "group_model.tna_mmm()"),
                   quantity = "transition probability per cluster of a tna_mmm", tolerance = 1e-12,
                   key = c("group", "from", "to"))
})

test_that("rename_groups() changes the names and keeps every weight", {
  skip_without_reference("TraMineR")
  renamed <- rename_groups(group_tna(group_regulation, group = halves), c("early", "late"))
  rates_of <- \(rows) {
    sequences <- suppressMessages(TraMineR::seqdef(as.data.frame(group_regulation[rows, ]), alphabet = states))
    `dimnames<-`(TraMineR::seqtrate(sequences), list(states, states))
  }
  expect_reference(model_weights(renamed), ref_groups_long(list(early = rates_of(1:1000), late = rates_of(1001:2000))),
                   reference = "TraMineR", covers = "rename_groups()",
                   quantity = "transition probability per renamed group", tolerance = 1e-12,
                   key = c("group", "from", "to"))
})

# Recovery: two groups of sequences drawn by simulab::simulate_group_sequences() from their own chains (simulab
# keeps each group's matrix with the data), fitted by group_tna(), and the same groups by TraMineR.
# Tolerance for the recovery: 4 binomial standard errors at the least visited state of each chain (rs_departures(),
# from the parameters, before the draws; the first state of each sequence is drawn from simulab's uniform start
# when no initial probabilities are given, which rs_departures() is given too).

test_that("group_tna() recovers the chains of simulab's grouped sequences and equals TraMineR on them", {
  skip_without_reference("TraMineR")
  group_states <- c("Plan", "Learn", "Reflect")
  given <- list(
    matrix(c(0.6, 0.3, 0.1, 0.2, 0.6, 0.2, 0.3, 0.3, 0.4), 3, byrow = TRUE, dimnames = list(group_states, group_states)),
    matrix(c(0.2, 0.5, 0.3, 0.4, 0.2, 0.4, 0.1, 0.1, 0.8), 3, byrow = TRUE, dimnames = list(group_states, group_states)))
  start <- c(Plan = 1, Learn = 1, Reflect = 1) / 3
  n_seq <- 3000L
  len <- 15L
  lapply(1:3, \(seed) {
    simulated <- simulab::simulate_group_sequences(groups = 2L, actors = n_seq, transitions = given, chain_length = len,
                                                   initial = start, states = group_states, seed = seed)
    wide <- as.data.frame(simulated, what = "wide")
    truth <- as.data.frame(simulated, what = "transitions")
    sequences <- subset(wide, select = -c(id, group))
    model <- group_tna(sequences, group = wide$group)
    lapply(unique(wide$group), \(g) {
      cells <- subset(truth, group == g)
      true_weights <- tapply(cells$probability, list(factor(cells$from, group_states), factor(cells$to, group_states)), sum)
      chain <- unclass(true_weights)
      found <- model[[g]]$weights
      expect_reference(found, chain[rownames(found), colnames(found)],
                       reference = "independent: recovery of the parameters of simulab simulate_group_sequences()",
                       covers = c("group_tna()", "group_model.default()"),
                       quantity = sprintf("Monte Carlo summary: recovered transition probability, %s, seed %d", g, seed),
                       tolerance = 4 * sqrt(0.25 / min(rs_departures(chain, start[rownames(chain)], n_seq, len))))
      rows <- wide$group == g
      alphabet <- rownames(found)
      rates <- suppressMessages(TraMineR::seqtrate(suppressMessages(TraMineR::seqdef(sequences[rows, ], alphabet = alphabet))))
      expect_reference(found, `dimnames<-`(rates, list(alphabet, alphabet)), reference = "TraMineR",
                       covers = c("group_tna()", "group_model.default()"),
                       quantity = sprintf("transition probability of simulab's sequences, %s, seed %d", g, seed),
                       tolerance = 1e-12)
    })
  })
})
