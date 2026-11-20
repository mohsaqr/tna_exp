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
