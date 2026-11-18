sequences <- as.matrix(read.csv("../data/group_regulation.csv", na.strings = ""))
states <- sort(unique(na.omit(c(sequences))))
# Co-occurrence: a sequence with n[a] visits of state a has n[a] * n[b] pairs of time
# points in states a and b, and n[a] * (n[a] - 1) ordered pairs within state a.
visits <- t(apply(sequences, 1, function(row) table(factor(row, levels = states))))
cooccurrence <- crossprod(visits) - diag(colSums(visits))
cooccurrence
# Attention: the transitions at every lag, weighted by exp(-lag) and added up.
time_points <- ncol(sequences)
at_lag <- function(lag) {
  from <- factor(sequences[, seq_len(time_points - lag)], levels = states)
  to <- factor(sequences[, lag + seq_len(time_points - lag)], levels = states)
  exp(-lag) * table(from, to)
}
attention <- Reduce(`+`, lapply(seq_len(time_points - 1), at_lag))
attention
edges <- function(model, weights) data.frame(
  quantity = sprintf("%s: %s -> %s", model, states[row(weights)], states[col(weights)]),
  value = c(weights)
)
result <- rbind(edges("ctna", cooccurrence), edges("atna", attention))
