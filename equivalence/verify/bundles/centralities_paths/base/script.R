sequences <- as.matrix(read.csv("../data/group_regulation.csv", na.strings = ""))
states <- sort(unique(na.omit(c(sequences))))
from <- factor(sequences[, -ncol(sequences)], levels = states)
to <- factor(sequences[, -1], levels = states)
counts <- table(from, to)
weights <- unclass(prop.table(counts, 1))
diag(weights) <- 0
n <- length(states)
lengths <- ifelse(weights > 0, 1 / weights, Inf)
diag(lengths) <- 0
# Floyd-Warshall: allow one more intermediate state at a time.
shortest <- function(lengths) Reduce(function(d, k) pmin(d, outer(d[, k], d[k, ], `+`)), seq_len(n), lengths)
distance <- shortest(lengths)
undirected <- shortest(pmin(lengths, t(lengths)))
same <- function(a, b) abs(a - b) <= 1e-9 * pmax(abs(a), abs(b), 1)
# The number of shortest paths from each source: a path to `t` extends a path to any
# `u` whose edge u -> t is on a shortest path (the edge is "tight").
tight <- function(s) weights > 0 & same(outer(distance[s, ], rep(1, n)) + lengths, outer(rep(1, n), distance[s, ]))
paths_from <- function(s) solve(diag(n) - t(tight(s)), as.numeric(seq_len(n) == s))
paths <- t(vapply(seq_len(n), paths_from, numeric(n)))
# Betweenness: the share of the shortest paths s -> t that pass through v, over all s, t.
through <- function(v) {
  on_path <- same(outer(distance[, v], distance[v, ], `+`), distance)
  share <- outer(paths[, v], paths[v, ]) / paths
  others <- outer(seq_len(n) != v, seq_len(n) != v) & !diag(n)
  sum(share[on_path & others])
}
# PageRank: the stationary vector of the walk that follows an edge with probability 0.85.
pagerank <- solve(diag(n) - 0.85 * t(weights / rowSums(weights)), rep(0.15 / n, n))
result <- data.frame(
  state = states,
  OutStrength = rowSums(weights), InStrength = colSums(weights),
  ClosenessIn = 1 / colSums(distance), ClosenessOut = 1 / rowSums(distance),
  Closeness = 1 / rowSums(undirected),
  Betweenness = vapply(seq_len(n), through, numeric(1)),
  PageRank = pagerank / sum(pagerank)
)
result
