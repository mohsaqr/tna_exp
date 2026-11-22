# Models built from sequences: tna(), ftna(), ctna(), atna() and build_model() with its types, scalings and
# options, against TraMineR, markovchain and counts written from the definitions in base R.
# The bundled group_regulation sequences: 2000 sequences of up to 26 time points over nine states, a sequence
# that ends early padded with NA.
# Tolerances: a probability is a ratio of two whole counts, so every side does the same division (1e-12 absolute
# allows a different order of operations); a count is a whole number (0); a sum of thousands of exp() terms or
# of 1 / length weights is added in a different order by each side (1e-10 relative).

wide <- ref_wide(group_regulation)
states <- ref_states(wide)
counts <- ref_pairs(wide, states)
# One independent source: every model type written from its definition as counts of pairs of time points.
by_definition <- "independent: counts of the pairs of time points each model type defines, in base R"

test_that("transition probabilities equal TraMineR's seqtrate()", {
  skip_without_reference("TraMineR")
  sequences <- suppressMessages(TraMineR::seqdef(as.data.frame(group_regulation)))
  rates <- TraMineR::seqtrate(sequences)
  dimnames(rates) <- list(TraMineR::alphabet(sequences), TraMineR::alphabet(sequences))
  expect_reference(tna(group_regulation)$weights, rates, reference = "TraMineR",
                   covers = c("tna()", "build_model()", "build_model.data.frame()"),
                   quantity = "transition probability", tolerance = 1e-12)
  expect_reference(ftna(group_regulation)$weights, TraMineR::seqtrate(sequences, count = TRUE) |>
                     `dimnames<-`(list(states, states)),
                   reference = "TraMineR", covers = c("ftna()", "build_model()", "build_model.data.frame()"),
                   quantity = "transition count", tolerance = 0)
})

test_that("initial probabilities equal TraMineR's state distribution at the first time point", {
  skip_without_reference("TraMineR")
  sequences <- suppressMessages(TraMineR::seqdef(as.data.frame(group_regulation)))
  distribution <- TraMineR::seqstatd(sequences)$Frequencies
  expect_reference(tna(group_regulation)$inits, stats::setNames(distribution[, 1L], rownames(distribution)),
                   reference = "TraMineR", covers = c("tna()", "build_model()"),
                   quantity = "initial probability", tolerance = 1e-12)
})

test_that("transition probabilities equal markovchain's maximum likelihood fit", {
  skip_without_reference("markovchain")
  sequences <- lapply(seq_len(nrow(wide)), \(row) as.vector(stats::na.omit(wide[row, ])))
  fit <- markovchain::markovchainFit(data = sequences, method = "mle")
  estimate <- fit$estimate@transitionMatrix
  expect_reference(tna(group_regulation)$weights, estimate[states, states], reference = "markovchain",
                   covers = c("tna()", "build_model()"), quantity = "transition probability", tolerance = 1e-12)
})

test_that("relative, frequency and initial probabilities equal counts of adjacent time points", {
    expect_reference(tna(group_regulation)$weights, ref_rows(counts), reference = by_definition,
                   covers = c("tna()", "build_model()", "build_model.data.frame()"),
                   quantity = "transition probability", tolerance = 1e-12)
  expect_reference(ftna(group_regulation)$weights, counts, reference = by_definition,
                   covers = c("ftna()", "build_model()"), quantity = "transition count", tolerance = 0)
  expect_reference(tna(group_regulation)$inits, ref_initial(wide, states), reference = by_definition,
                   covers = c("tna()", "build_model()"), quantity = "initial probability", tolerance = 1e-12)
  expect_reference(build_model(group_regulation, type = "reverse")$weights, t(counts), reference = by_definition,
                   covers = "build_model()", quantity = "reverse: transition count, later to earlier", tolerance = 0)
})

test_that("co-occurrence counts every pair of time points of a sequence in both directions", {
  # A sequence with n[a] visits of state a has n[a] * n[b] pairs of time points in states a and b; counted in both
  # directions, as ctna() documents for two different states, a pair within state a is counted twice: n[a] (n[a] - 1).
  visits <- t(apply(wide, 1L, \(row) table(factor(row, levels = states))))
  expected <- crossprod(visits) - diag(colSums(visits))
  dimnames(expected) <- list(states, states)
  observed <- ctna(group_regulation)$weights
    expect_reference(ref_off_diagonal(observed), ref_off_diagonal(expected), reference = by_definition,
                   covers = c("ctna()", "build_model()"), quantity = "co-occurrence count, two states",
                   tolerance = 0)
  # Convention, not a defect (verified 2026-11-20): an unordered pair of time points is counted once; for two
  # distinct states the count lands in both mirror cells, for one state it lands once on the diagonal. tna does
  # not document the diagonal rule. Counted in both directions the diagonal is twice tna's; halved it agrees.
  expect_known_difference(ref_diagonal(observed), ref_diagonal(expected), reference = by_definition,
                          covers = c("ctna()", "build_model()"), quantity = "co-occurrence count, one state", tolerance = 0,
                          reason = "ctna() counts a pair of time points in one state once on the diagonal, where a pair of two states is entered in both mirror cells; the definition used here counts both directions",
                          agrees_with = "the same count with the diagonal halved")
  expect_reference(ref_diagonal(observed), ref_diagonal(expected) / 2, reference = by_definition,
                   covers = c("ctna()", "build_model()"), quantity = "co-occurrence count, one state, each pair once",
                   tolerance = 0)
})

test_that("attention weights are the lagged counts weighted by exp(-lag / lambda)", {
  lags <- seq_len(ncol(wide) - 1L)
  attention <- \(lambda) Reduce(`+`, lapply(lags, \(lag) exp(-lag / lambda) * ref_pairs(wide, states, lag)))
    expect_reference(atna(group_regulation)$weights, attention(1), reference = by_definition,
                   covers = c("atna()", "build_model()"), quantity = "attention weight, lambda = 1",
                   tolerance = 1e-10, measure = "relative")
  expect_reference(atna(group_regulation, params = list(lambda = 3))$weights, attention(3), reference = by_definition,
                   covers = c("atna()", "build_model()"), quantity = "attention weight, lambda = 3",
                   tolerance = 1e-10, measure = "relative")
  backward <- Reduce(`+`, lapply(lags, \(lag) exp(-lag) * t(ref_pairs(wide, states, lag))))
  expect_reference(atna(group_regulation, params = list(direction = "backward"))$weights, backward,
                   reference = by_definition, covers = c("atna()", "build_model()"),
                   quantity = "attention weight, backward", tolerance = 1e-10, measure = "relative")
})

test_that("gap and n-gram transitions equal their definitions", {
    # gap: every pair of time points at most max_gap + 1 apart, weighted by 1 / distance
  gap <- \(max_gap) Reduce(`+`, lapply(seq_len(max_gap + 1L), \(lag) ref_pairs(wide, states, lag) / lag))
  expect_reference(build_model(group_regulation, type = "gap")$weights, gap(1L), reference = by_definition,
                   covers = "build_model()", quantity = "gap weight, max_gap = 1", tolerance = 1e-10,
                   measure = "relative")
  expect_reference(build_model(group_regulation, type = "gap", params = list(max_gap = 3L))$weights, gap(3L),
                   reference = by_definition, covers = "build_model()", quantity = "gap weight, max_gap = 3",
                   tolerance = 1e-10, measure = "relative")
  # n-gram: every window of n adjacent time points contributes its n - 1 adjacent pairs
  p <- ncol(wide)
  n_gram <- 3L
  starts <- seq_len(p - n_gram + 1L)
  windowed <- Reduce(`+`, lapply(starts, \(start) ref_pairs(wide[, start + seq_len(n_gram) - 1L], states)))
  expect_reference(build_model(group_regulation, type = "n-gram", params = list(n_gram = n_gram))$weights,
                   windowed, reference = by_definition, covers = "build_model()", quantity = "3-gram transition count",
                   tolerance = 0)
})

test_that("scalings and the weighted frequency model equal their definitions", {
    expect_reference(ftna(group_regulation, scaling = "minmax")$weights,
                   (counts - min(counts)) / (max(counts) - min(counts)), reference = by_definition,
                   covers = c("ftna()", "build_model()"), quantity = "minmax-scaled count", tolerance = 1e-12)
  expect_reference(ftna(group_regulation, scaling = "max")$weights, counts / max(counts), reference = by_definition,
                   covers = c("ftna()", "build_model()"), quantity = "max-scaled count", tolerance = 1e-12)
  ranks <- counts
  ranks[] <- rank(counts, ties.method = "average")
  expect_reference(ftna(group_regulation, scaling = "rank")$weights, ranks, reference = by_definition,
                   covers = c("ftna()", "build_model()"), quantity = "rank of a count", tolerance = 0)
  lengths <- rowSums(!is.na(wide))
  expect_reference(ftna(group_regulation, params = list(weighted = TRUE))$weights,
                   ref_pairs(wide, states, weights = 1 / lengths),
                   reference = by_definition,
                   covers = c("ftna()", "build_model()"), quantity = "length-weighted count", tolerance = 1e-10,
                   measure = "relative")
})

test_that("begin and end states and concatenated sequences equal their definitions", {
  small <- wide[seq_len(301L), ]
    last <- apply(small, 1L, \(row) max(which(!is.na(row))))
  with_ends <- cbind("Start", small, NA_character_)
  with_ends[cbind(seq_len(nrow(small)), last + 2L)] <- "End"
  ends_states <- c("Start", states, "End")
  expect_reference(build_model(as.data.frame(small), type = "frequency", begin_state = "Start",
                               end_state = "End")$weights,
                   ref_pairs(with_ends, ends_states), reference = by_definition, covers = "build_model()",
                   quantity = "count with begin and end states", tolerance = 0)
  # concat = 2: rows 1-2, 3-4, ... joined end to end (with their padding); the odd last row stands alone
  pairs_of_rows <- split(seq_len(nrow(small)), (seq_len(nrow(small)) - 1L) %/% 2L)
  joined <- t(vapply(pairs_of_rows, \(rows) {
    cells <- as.vector(t(small[rows, , drop = FALSE]))
    c(cells, rep(NA_character_, 2L * ncol(small) - length(cells)))
  }, character(2L * ncol(small))))
  expect_reference(build_model(as.data.frame(small), type = "frequency", concat = 2L)$weights,
                   ref_pairs(joined, states), reference = by_definition, covers = "build_model()",
                   quantity = "count of concatenated sequences", tolerance = 0)
})

test_that("a TraMineR sequence object gives TraMineR's transition rates", {
  skip_without_reference("TraMineR")
  rates <- TraMineR::seqtrate(engagement)
  alphabet <- TraMineR::alphabet(engagement)
  dimnames(rates) <- list(alphabet, alphabet)
  expect_reference(build_model(engagement)$weights, rates, reference = "TraMineR",
                   covers = c("build_model()", "build_model.stslist()"),
                   quantity = "transition probability, stslist", tolerance = 1e-12)
  distribution <- TraMineR::seqstatd(engagement)$Frequencies
  expect_reference(tna(engagement)$inits, stats::setNames(distribution[, 1L], alphabet), reference = "TraMineR",
                   covers = c("tna()", "build_model.stslist()"), quantity = "initial probability, stslist",
                   tolerance = 1e-12)
})


# The lagged models against TraMineR: seqtrate(lag = k, count = TRUE) counts the pairs of observed states k time
# points apart, so attention, co-occurrence and gap weights are sums of TraMineR's lagged count tables.
# Tolerance: sums of some 25 tables of whole counts weighted by exp() or 1 / lag, 1e-10 relative; plain sums of
# whole counts, 0.

#' TraMineR's lagged transition counts of the bundled sequences, one table per lag
#'
#' @param data A wide sequence table.
#' @return A list of count matrices with the states as dimnames, lag 1 first.
traminer_lags <- function(data) {
  sequences <- suppressMessages(TraMineR::seqdef(as.data.frame(data)))
  alphabet <- TraMineR::alphabet(sequences)
  lapply(seq_len(ncol(data) - 1L), \(lag) {
    `dimnames<-`(suppressMessages(TraMineR::seqtrate(sequences, lag = lag, count = TRUE)), list(alphabet, alphabet))
  })
}

test_that("attention, co-occurrence and gap weights equal sums of TraMineR's lagged transition counts", {
  skip_without_reference("TraMineR")
  lagged <- traminer_lags(group_regulation)
  lags <- seq_along(lagged)
  weighted_sum <- \(weight) Reduce(`+`, Map(\(counts, lag) weight(lag) * counts, lagged, lags))
  expect_reference(atna(group_regulation)$weights, weighted_sum(\(lag) exp(-lag)), reference = "TraMineR",
                   covers = c("atna()", "build_model()"), quantity = "attention weight, lambda = 1, from lagged counts",
                   tolerance = 1e-10, measure = "relative")
  expect_reference(atna(group_regulation, params = list(lambda = 3))$weights, weighted_sum(\(lag) exp(-lag / 3)),
                   reference = "TraMineR", covers = c("atna()", "build_model()"),
                   quantity = "attention weight, lambda = 3, from lagged counts", tolerance = 1e-10, measure = "relative")
  expect_reference(atna(group_regulation, params = list(direction = "backward"))$weights, t(weighted_sum(\(lag) exp(-lag))),
                   reference = "TraMineR", covers = c("atna()", "build_model()"),
                   quantity = "attention weight, backward, from lagged counts", tolerance = 1e-10, measure = "relative")
  # Co-occurrence: every pair of time points, both directions off the diagonal and each pair once on it (ctna()'s
  # convention, see the known difference above).
  both <- Reduce(`+`, lapply(lagged, \(counts) counts + t(counts)))
  diag(both) <- diag(both) / 2
  expect_reference(ctna(group_regulation)$weights, both, reference = "TraMineR", covers = c("ctna()", "build_model()"),
                   quantity = "co-occurrence count from lagged counts", tolerance = 0)
  gap <- Reduce(`+`, Map(\(counts, lag) counts / lag, lagged[1:4], 1:4))
  expect_reference(build_model(group_regulation, type = "gap", params = list(max_gap = 3L))$weights, gap,
                   reference = "TraMineR", covers = "build_model()", quantity = "gap weight, max_gap = 3, from lagged counts",
                   tolerance = 1e-10, measure = "relative")
  expect_reference(build_model(group_regulation, type = "reverse")$weights, t(lagged[[1L]]), reference = "TraMineR",
                   covers = "build_model()", quantity = "reverse: transition count from TraMineR", tolerance = 0)
})

test_that("sequences with missing time points inside give TraMineR's and markovchain's estimates", {
  skip_without_reference(c("TraMineR", "markovchain"))
  # 300 sequences with 20 time points blanked in each of columns 3 to 8: a transition is counted only between two
  # observed adjacent time points.
  gappy <- as.data.frame(group_regulation[seq_len(300L), ])
  blanks <- rs_with_seed(5L, lapply(3:8, \(column) sample.int(300L, 20L)))
  gappy[3:8] <- Map(\(column, rows) `[<-`(column, rows, NA), gappy[3:8], blanks)
  sequences <- suppressMessages(TraMineR::seqdef(gappy))
  alphabet <- TraMineR::alphabet(sequences)
  rates <- `dimnames<-`(suppressMessages(TraMineR::seqtrate(sequences)), list(alphabet, alphabet))
  expect_reference(tna(gappy)$weights, rates, reference = "TraMineR", covers = c("tna()", "build_model()"),
                   quantity = "transition probability, missing time points inside", tolerance = 1e-12)
  expect_reference(ftna(gappy)$weights, ref_pairs(ref_wide(gappy), alphabet), reference = by_definition,
                   covers = c("ftna()", "build_model()"), quantity = "transition count, missing time points inside",
                   tolerance = 0)
})

# Parameter recovery: sequences drawn by simulab::simulate_markov() from a known chain, fitted by tna() and,
# for the same data, by markovchain. simulab stores the generating transition matrix and initial probabilities with
# the data (as.data.frame(x, what = "transitions" / "initial_probabilities")).
# Tolerance for the recovery: 4 binomial standard errors of an estimated probability, 4 sqrt(0.25 / departures)
# with the expected departures from the least visited state of the chain (rs_departures(), computed from the
# parameters before anything is drawn); for an initial probability 4 sqrt(0.25 / n). For tna against markovchain
# on the same data the ratio of two whole counts, 1e-12.

recovery_chain <- matrix(c(0.60, 0.30, 0.10, 0.00,
                           0.20, 0.50, 0.20, 0.10,
                           0.25, 0.25, 0.40, 0.10,
                           0.10, 0.10, 0.30, 0.50), 4, byrow = TRUE,
                         dimnames = list(c("A", "B", "C", "D"), c("A", "B", "C", "D")))
recovery_inits <- c(A = 0.4, B = 0.3, C = 0.2, D = 0.1)

test_that("tna() recovers the transition and initial probabilities of simulab's Markov chains", {
  skip_without_reference("markovchain")
  n_seq <- 4000L
  len <- 15L
  lapply(1:3, \(seed) {
    simulated <- simulab::simulate_markov(n = n_seq, transition = recovery_chain, chain_length = len,
                                          initial = recovery_inits, states = rownames(recovery_chain), seed = seed)
    wide <- subset(as.data.frame(simulated, what = "wide"), select = -id)
    truth <- as.data.frame(simulated, what = "transitions")
    true_weights <- tapply(truth$probability, list(factor(truth$from, rownames(recovery_chain)),
                                                   factor(truth$to, rownames(recovery_chain))), sum)
    true_inits <- as.data.frame(simulated, what = "initial_probabilities")
    model <- tna(wide)
    tolerance <- 4 * sqrt(0.25 / min(rs_departures(recovery_chain, recovery_inits, n_seq, len)))
    expect_reference(model$weights, unclass(true_weights),
                     reference = "independent: recovery of the parameters of simulab simulate_markov()",
                     covers = c("tna()", "build_model()"),
                     quantity = sprintf("Monte Carlo summary: recovered transition probability, seed %d", seed),
                     tolerance = tolerance)
    expect_reference(model$inits, stats::setNames(true_inits$probability, true_inits$state),
                     reference = "independent: recovery of the parameters of simulab simulate_markov()",
                     covers = c("tna()", "build_model()"),
                     quantity = sprintf("Monte Carlo summary: recovered initial probability, seed %d", seed),
                     tolerance = 4 * sqrt(0.25 / n_seq))
    fit <- markovchain::markovchainFit(data = lapply(seq_len(nrow(wide)), \(row) unlist(wide[row, ], use.names = FALSE)),
                                       method = "mle")$estimate@transitionMatrix
    states <- rownames(model$weights)
    expect_reference(model$weights, fit[states, states], reference = "markovchain", covers = c("tna()", "build_model()"),
                     quantity = sprintf("transition probability of simulab sequences, seed %d", seed), tolerance = 1e-12)
  })
})
