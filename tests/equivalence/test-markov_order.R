# markov_order(): the log-likelihood, AIC and BIC of Markov chains of order 0 to 3, and the G-squared test of
# each order against the one below (Anderson and Goodman 1957): the next state against the state k steps back,
# conditional on the k - 1 states between them, with its degrees of freedom and asymptotic chi-squared p-value.
# Against the definitions in base R. The permutation p-values are drawn inside the function and are not compared.
# The likelihood of order j: the first state from the state frequencies, the states at positions 2..j from the
# chains of order 1..j-1, the rest from the chain of order j; each chain of order m estimated by maximum
# likelihood from every position after the m-th. Degrees of freedom ("observed"): the observed states less one,
# plus, per order, the observed (context, next state) pairs less the observed contexts.
# Tolerance: sums of some 25000 logarithms, 1e-8 relative.

wide <- ref_wide(group_regulation)

# The observed states of each sequence, in order (every sequence here ends with its padding)
all_chains <- lapply(seq_len(nrow(wide)), \(row) as.vector(stats::na.omit(wide[row, ])))

#' Every position of every chain with the states before it
#'
#' @param chains A list of character vectors.
#' @param lag How many earlier states to keep.
#' @return A data frame: position, state and lag_1 .. lag_<lag> (the state 1 .. lag steps back), for the positions
#'   that have `lag` states before them.
ref_positions <- function(chains, lag) {
  rows <- lapply(chains, \(chain) {
    t <- seq_along(chain)[seq_along(chain) > lag]
    before <- lapply(seq_len(lag), \(l) chain[t - l])
    data.frame(position = t, state = chain[t], stats::setNames(before, paste0("lag_", seq_len(lag))))
  })
  do.call(rbind, rows)
}

#' The log-probabilities of the next state under the order-m chain, keyed by context and state
#'
#' @param chains A list of character vectors.
#' @param m The order.
#' @return A function of a data frame of positions: the log-probability of each.
ref_chain <- function(chains, m) {
  fit <- ref_positions(chains, m)
  context_of <- \(frame) do.call(paste, c(list(""), frame[paste0("lag_", seq_len(m))]))
  pair <- table(paste(context_of(fit), fit$state, sep = "|"))
  context <- table(context_of(fit))
  \(frame) log(as.vector(pair[paste(context_of(frame), frame$state, sep = "|")]) /
                 as.vector(context[context_of(frame)]))
}

#' The log-likelihood of order j
#'
#' @param chains A list of character vectors.
#' @param j The order.
#' @return A number.
ref_loglik <- function(chains, j) {
  all_states <- unlist(chains)
  marginal <- table(all_states) / length(all_states)
  log_initial <- sum(log(as.vector(marginal[vapply(chains, `[`, character(1), 1L)])))
  early <- vapply(seq_len(max(j - 1L, 0L)), \(m) {
    at <- ref_positions(chains, m)
    sum(ref_chain(chains, m)(at[at$position == m + 1L, ]))
  }, numeric(1))
  later <- if (j == 0L) sum(log(as.vector(marginal[all_states]))) - log_initial else
    sum(ref_chain(chains, j)(ref_positions(chains, j)))
  log_initial + sum(early) + later
}

#' The free parameters added by order m
#'
#' @param chains A list of character vectors.
#' @param m The order.
#' @return A number.
ref_dof <- function(chains, m) {
  at <- ref_positions(chains, m)
  context <- do.call(paste, at[paste0("lag_", seq_len(m))])
  length(unique(paste(context, at$state))) - length(unique(context))
}

#' The G-squared test of order k against order k - 1
#'
#' @param chains A list of character vectors.
#' @param k The order.
#' @return A data frame: g2, df, p_asymptotic.
ref_g2 <- function(chains, k) {
  at <- ref_positions(chains, k)
  # the context: the k - 1 states between; order 1 has one context for every position
  w <- if (k == 1L) rep("any", nrow(at)) else do.call(paste, at[paste0("lag_", seq_len(k - 1L))])
  x <- at[[paste0("lag_", k)]]
  s <- at$state
  n_wxs <- table(paste(w, x, s, sep = "|"))
  key_w <- sub("\\|.*$", "", names(n_wxs))
  key_x <- vapply(strsplit(names(n_wxs), "|", fixed = TRUE), `[`, character(1), 2L)
  key_s <- vapply(strsplit(names(n_wxs), "|", fixed = TRUE), `[`, character(1), 3L)
  n_w <- table(w)
  n_wx <- table(paste(w, x, sep = "|"))
  n_ws <- table(paste(w, s, sep = "|"))
  g2 <- 2 * sum(as.vector(n_wxs) * log(as.vector(n_wxs) * as.vector(n_w[key_w]) /
                                         (as.vector(n_wx[paste(key_w, key_x, sep = "|")]) *
                                            as.vector(n_ws[paste(key_w, key_s, sep = "|")]))))
  r_w <- tapply(x, w, \(v) length(unique(v)))
  c_w <- tapply(s, w, \(v) length(unique(v)))
  df <- sum((r_w - 1) * (c_w - 1))
  data.frame(g2 = g2, df = df, p_asymptotic = stats::pchisq(g2, df, lower.tail = FALSE))
}

test_that("log-likelihoods, information criteria and G-squared tests equal their definitions", {
  chains <- all_chains
  all_states <- unlist(chains)
  loglik <- vapply(0:3, \(j) ref_loglik(chains, j), numeric(1))
  cum_dof <- cumsum(c(length(unique(all_states)) - 1, vapply(1:3, \(m) ref_dof(chains, m), numeric(1))))
  tests <- do.call(rbind, lapply(1:3, \(k) ref_g2(chains, k)))
  expected <- data.frame(order = 0:3, loglik = loglik, aic = 2 * cum_dof - 2 * loglik,
                         bic = log(length(all_states)) * cum_dof - 2 * loglik,
                         g2 = c(NA, tests$g2), df = c(NA, tests$df), p_asymptotic = c(NA, tests$p_asymptotic))
  set.seed(1)
  found <- markov_order(tna(group_regulation), max_order = 3L, iter = 99L, dof = "observed")
  by_definition <- "independent: maximum likelihood chains and the G-squared statistic written in base R"
  expect_reference(found$stats, expected, reference = by_definition, covers = c("markov_order()", "markov_order.tna()"),
                   quantity = "order statistics", tolerance = 1e-8, measure = "relative", key = "order")
  # summary() rounds; with digits = 10 the rounding is far inside the tolerance
  expect_reference(summary(found, digits = 10L), expected[c("order", "loglik", "aic", "bic", "g2", "df")],
                   reference = by_definition, covers = "summary.tna_markov_order()",
                   quantity = "order statistics, summary()", tolerance = 1e-8, measure = "relative", key = "order")
})

test_that("the tests of group models equal the definitions on each group's sequences", {
  halves <- rep(c("first", "second"), each = 1000)
  set.seed(1)
  found <- markov_order(group_tna(group_regulation, group = halves), max_order = 2L, iter = 99L, dof = "observed")
  per_group <- lapply(split(seq_len(2000L), halves), \(rows) {
    tests <- do.call(rbind, lapply(1:2, \(k) ref_g2(all_chains[rows], k)))
    data.frame(order = 0:2, g2 = c(NA, tests$g2), df = c(NA, tests$df), p_asymptotic = c(NA, tests$p_asymptotic))
  })
  with_group <- \(tables) do.call(rbind, Map(\(table, group) data.frame(group = group, table), tables, names(tables)))
  expect_reference(with_group(lapply(found, \(group) group$stats)), with_group(per_group),
                   reference = "independent: maximum likelihood chains and the G-squared statistic written in base R",
                   covers = c("markov_order()", "markov_order.group_tna()"), quantity = "G-squared test per group",
                   tolerance = 1e-8, measure = "relative", key = c("group", "order"))
  expect_reference(summary(found, digits = 10L), with_group(lapply(per_group, \(table) table[c("order", "g2", "df")])),
                   reference = "independent: maximum likelihood chains and the G-squared statistic written in base R",
                   covers = "summary.group_tna_markov_order()", quantity = "G-squared test per group, summary()",
                   tolerance = 1e-8, measure = "relative", key = c("group", "order"))
})

test_that("the order statistics equal Nestimate's markov_order_test()", {
  skip_without_reference("Nestimate")
  # Nestimate is a separate implementation by an author of tna (it does not call tna). Moved from the standing
  # script equivalence/tna/local/local_testing_and_equivalence/markov_order_vs_nestimate.R, whose permutation
  # p-values (different random streams) stay there.
  set.seed(1)
  found <- markov_order(tna(group_regulation), max_order = 3L, iter = 99L)
  theirs <- Nestimate::markov_order_test(group_regulation, max_order = 3L, n_perm = 99L, seed = 1)$test_table
  expected <- data.frame(order = theirs$order, loglik = theirs$loglik, aic = theirs$AIC, bic = theirs$BIC,
                         g2 = theirs$g2, df = as.numeric(theirs$df), p_asymptotic = theirs$p_asymptotic)
  expect_reference(found$stats, expected, reference = "Nestimate", covers = c("markov_order()", "markov_order.tna()"),
                   quantity = "order statistics, path degrees of freedom", tolerance = 1e-8, measure = "relative",
                   key = "order")
  set.seed(1)
  engaged <- markov_order(tna(engagement), max_order = 3L, iter = 99L)
  # TraMineR's void symbol "%" (a sequence that has ended) is written as NA for Nestimate, which would read it as a
  # fourth state.
  theirs <- Nestimate::markov_order_test(as.data.frame(ref_wide(engagement)), max_order = 3L, n_perm = 99L,
                                         seed = 1)$test_table
  expect_reference(engaged$stats,
                   data.frame(order = theirs$order, loglik = theirs$loglik, aic = theirs$AIC, bic = theirs$BIC,
                              g2 = theirs$g2, df = as.numeric(theirs$df), p_asymptotic = theirs$p_asymptotic),
                   reference = "Nestimate", covers = c("markov_order()", "markov_order.tna()"),
                   quantity = "order statistics of engagement", tolerance = 1e-8, measure = "relative", key = "order")
})
