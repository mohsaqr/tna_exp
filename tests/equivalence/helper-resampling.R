# Resampling procedures written in base R from their definitions, for the statistical comparisons of
# bootstrap(), estimate_cs(), reliability() and permutation_test() of a grouped model. Nothing here calls tna.
# Each procedure draws its own resamples on its own seeded stream: the comparison with tna (which draws inside the
# function) is of distribution summaries, within a tolerance derived from the Monte Carlo error of both sides.
#
# The relative transition network of a set of sequences is the row-normalised table of the pairs of consecutive
# observed states (ref_rows(ref_pairs()) of helper-reference.R). To resample quickly, every sequence's pair counts
# are kept as one row of a matrix, so the network of any multiset of sequences is a weighted sum of rows.

#' Evaluate an expression on a seeded stream and restore the caller's stream afterwards
rs_with_seed <- function(seed, expr) {
  old <- if (exists(".Random.seed", envir = globalenv(), inherits = FALSE)) get(".Random.seed", envir = globalenv())
  on.exit(if (is.null(old)) rm(".Random.seed", envir = globalenv()) else assign(".Random.seed", old, envir = globalenv()),
          add = TRUE, after = FALSE)
  set.seed(seed)
  expr
}

#' The pair counts of every sequence, one row per sequence, one column per cell (column-major from x to)
rs_counts <- function(wide, states) {
  t(vapply(seq_len(nrow(wide)), \(i) as.vector(ref_pairs(wide[i, , drop = FALSE], states)),
           numeric(length(states)^2)))
}

#' The relative network of the sequences counted `multiplicity` times each
rs_network <- function(counts, multiplicity, states) {
  ref_rows(matrix(as.numeric(multiplicity %*% counts), length(states), dimnames = list(states, states)))
}

#' Draws of the network: one row per draw, one column per cell, named "from -> to"
#'
#' @param counts From `rs_counts()`.
#' @param draws The number of draws.
#' @param multiplicity A function of nothing returning one multiplicity per sequence for one draw.
rs_draws <- function(counts, states, draws, multiplicity) {
  cells <- paste(rep(states, times = length(states)), "->", rep(states, each = length(states)))
  out <- t(vapply(seq_len(draws), \(i) as.vector(rs_network(counts, multiplicity(), states)), numeric(ncol(counts))))
  colnames(out) <- cells
  out
}

#' The nonparametric bootstrap of the sequences (Efron 1979): n sequences drawn with replacement
rs_bootstrap <- function(wide, states, draws, seed) {
  counts <- rs_counts(wide, states)
  n <- nrow(wide)
  rs_with_seed(seed, rs_draws(counts, states, draws, \() tabulate(sample.int(n, n, replace = TRUE), n)))
}

#' A cell matrix named "from -> to" as a named vector (the order of rs_draws())
rs_cells <- function(cells) {
  stats::setNames(as.vector(cells), paste(rep(rownames(cells), times = ncol(cells)), "->",
                                          rep(colnames(cells), each = nrow(cells))))
}

#' Case-dropping (Epskamp, Borsboom and Fried 2018): keep n - floor(n p) sequences drawn without replacement and
#' correlate the in- and out-strength (loops left out) of the subsample's network with those of the whole data
#'
#' @return A list per measure (InStrength, OutStrength) of a draws x proportions matrix of correlations.
rs_casedrop <- function(wide, states, drop_prop, draws, seed) {
  counts <- rs_counts(wide, states)
  n <- nrow(wide)
  strength <- \(w) {
    diag(w) <- 0
    list(InStrength = colSums(w), OutStrength = rowSums(w))
  }
  whole <- strength(rs_network(counts, rep(1, n), states))
  per_prop <- rs_with_seed(seed, lapply(drop_prop, \(p) {
    keep <- n - floor(n * p)
    t(vapply(seq_len(draws), \(i) {
      sub <- strength(rs_network(counts, tabulate(sample.int(n, keep), n), states))
      c(InStrength = stats::cor(sub$InStrength, whole$InStrength), OutStrength = stats::cor(sub$OutStrength, whole$OutStrength))
    }, numeric(2)))
  }))
  lapply(c(InStrength = "InStrength", OutStrength = "OutStrength"),
         \(measure) vapply(per_prop, \(m) m[, measure], numeric(draws)))
}

#' The CS-coefficient: the largest proportion dropped at which at least `certainty` of the correlations reach
#' `threshold`, 0 when none does
rs_cs <- function(correlations, drop_prop, threshold = 0.7, certainty = 0.95) {
  passing <- colMeans(correlations >= threshold) >= certainty
  if (any(passing)) max(drop_prop[passing]) else 0
}

#' Split halves: round(n split) sequences drawn without replacement against the rest; nine comparison metrics of
#' the two relative networks over all cells (the textbook definitions)
rs_split_half <- function(wide, states, draws, seed, split = 0.5) {
  counts <- rs_counts(wide, states)
  n <- nrow(wide)
  rs_with_seed(seed, t(vapply(seq_len(draws), \(i) {
    half <- tabulate(sample.int(n, round(n * split)), n)
    x <- as.vector(rs_network(counts, half, states))
    y <- as.vector(rs_network(counts, 1 - half, states))
    d <- abs(x - y)
    c("Mean Abs. Diff." = mean(d), "RMS Diff." = sqrt(mean(d^2)), Pearson = stats::cor(x, y),
      Spearman = stats::cor(rank(x), rank(y)), Euclidean = sqrt(sum(d^2)), Manhattan = sum(d),
      "Bray-Curtis" = sum(d) / sum(abs(x) + abs(y)), Cosine = sum(x * y) / sqrt(sum(x^2) * sum(y^2)),
      Jaccard = sum(pmin(abs(x), abs(y))) / sum(pmax(abs(x), abs(y))))
  }, numeric(9))))
}

#' A permutation test of two sets of sequences (unpaired): the observed difference of their relative networks,
#' and for each cell the share of `draws` random relabellings whose absolute difference reaches the observed one
#'
#' @return A list: `observed` and `exceed` (the share), each named "from -> to".
rs_permutation <- function(wide_x, wide_y, states, draws, seed) {
  counts <- rs_counts(rbind(wide_x, wide_y), states)
  n_x <- nrow(wide_x)
  n <- nrow(counts)
  in_x <- c(rep(1, n_x), rep(0, n - n_x))
  difference <- \(member) as.vector(rs_network(counts, member, states) - rs_network(counts, 1 - member, states))
  observed <- difference(in_x)
  # the same tie rule as `>=` on doubles: a cell that differs by rounding only counts as reached
  reached <- rs_with_seed(seed, vapply(seq_len(draws), \(i) {
    abs(difference(in_x[sample.int(n)])) >= abs(observed) - 1e-12
  }, logical(length(observed))))
  cells <- names(rs_cells(matrix(0, length(states), length(states), dimnames = list(states, states))))
  list(observed = stats::setNames(observed, cells), exceed = stats::setNames(rowMeans(reached), cells))
}

#' The expected number of departures from each state of a first-order chain: n_seq sequences of `len` states
#' started from `inits`; a transition probability estimated from them has a binomial standard error of at most
#' sqrt(0.25 / departures)
rs_departures <- function(trans, inits, n_seq, len) {
  occupancy <- Reduce(\(p, i) p %*% trans, seq_len(len - 2L), inits, accumulate = TRUE)
  n_seq * colSums(do.call(rbind, occupancy))
}

# Monte Carlo tolerances, one per number (audit 2026-11-23, A4): each cell is judged at 4 standard errors of ITS
# OWN difference, not at 4 times the largest standard error of the table.

#' 4 standard errors of the difference of two Monte Carlo p-values of one cell, plus tna's +1
#'
#' The reference's share `q` comes from `draws` draws, tna's from `iter`. The variance q (1 - q) is taken at the
#' point of the reference's 99.9% Clopper-Pearson interval for q closest to 1/2, so that a share that is low (or 0)
#' by chance does not shrink the tolerance below what the cell's true share allows; this also gives the floor for
#' cells whose share is 0 or 1. 1 / (iter + 1) covers the +1 of tna's (k + 1) / (iter + 1).
#'
#' @param q The reference's shares, one per cell (named).
#' @param iter The number of tna's draws.
#' @param draws The number of the reference's draws.
#' @return The tolerances, named as `q`.
rs_p_tolerance <- function(q, iter, draws) {
  k <- round(q * draws)
  lower <- ifelse(k > 0, stats::qbeta(0.0005, k, draws - k + 1), 0)
  upper <- ifelse(k < draws, stats::qbeta(0.9995, k + 1, draws - k), 1)
  at <- pmin(pmax(0.5, lower), upper)
  stats::setNames(4 * sqrt(at * (1 - at)) * sqrt(1 / iter + 1 / draws) + 1 / (iter + 1), names(q))
}

#' One comparison per cell, each at its own tolerance
#'
#' @param actual,expected Named numeric vectors with the same names (the package's and the reference's cells).
#' @param tolerance Named tolerances, one per cell of `expected`.
#' @param reference,covers As in expect_reference().
#' @param quantity The quantity; each cell is recorded as "<quantity>: <cell>".
#' @return Invisibly, NULL.
rs_expect_cells <- function(actual, expected, tolerance, reference, covers, quantity) {
  stopifnot("the package and the reference must have the same cells" = setequal(names(actual), names(expected)),
            "one tolerance per cell" = setequal(names(tolerance), names(expected)))
  invisible(lapply(names(expected), \(cell) {
    expect_reference(actual[[cell]], expected[[cell]], reference = reference, covers = covers,
                     quantity = sprintf("%s: %s", quantity, cell), tolerance = tolerance[[cell]])
  }))
}
