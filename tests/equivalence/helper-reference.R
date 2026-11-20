# Reference computations shared by the equivalence tests, written from the definitions in base R. Nothing
# here calls tna: each function is one side of a comparison, and the package is the other.

#' Sequences in wide format as a character matrix, one sequence per row
#'
#' An empty cell or `NA` is a missing time point, and so are TraMineR's void and missing symbols.
#' @param wide A data frame, matrix or TraMineR `stslist`, one sequence per row.
#' @param absent The cell values that mean "no state".
#' @return A character matrix.
ref_wide <- function(wide, absent = c("", "%", "*")) {
  out <- as.matrix(as.data.frame(lapply(as.data.frame(wide), as.character)))
  out[out %in% absent] <- NA_character_
  dimnames(out) <- NULL
  out
}

#' The states of a wide table, sorted
#'
#' @param wide A character matrix (see `ref_wide()`).
#' @return A character vector.
ref_states <- function(wide) sort(unique(stats::na.omit(as.vector(wide))), method = "radix")

#' Count the pairs of time points `lag` steps apart, both observed
#'
#' @param wide A character matrix, one sequence per row.
#' @param states The states, in the order of the table.
#' @param lag The distance between the two time points.
#' @param weights One weight per sequence (each of its pairs counts that much).
#' @return A numeric matrix `from` x `to` with the states as dimnames.
ref_pairs <- function(wide, states = ref_states(wide), lag = 1L, weights = rep(1, nrow(wide))) {
  p <- ncol(wide)
  from <- factor(wide[, seq_len(p - lag)], levels = states)
  to <- factor(wide[, lag + seq_len(p - lag)], levels = states)
  weight <- rep(weights, times = p - lag)
  counts <- tapply(weight, list(from, to), sum, default = 0)
  out <- matrix(as.numeric(counts), length(states), dimnames = list(states, states))
  out
}

#' Divide each row by its total; a row without counts stays zero
#'
#' @param counts A square numeric matrix.
#' @return The row-normalised matrix.
ref_rows <- function(counts) {
  totals <- rowSums(counts)
  counts / ifelse(totals > 0, totals, 1)
}

#' The relative transition network of a wide table, without loops, as centralities() uses it by default
#'
#' @param wide A character matrix.
#' @return A numeric matrix with the states as dimnames.
ref_network <- function(wide) {
  weights <- ref_rows(ref_pairs(wide))
  diag(weights) <- 0
  weights
}

#' The share of sequences that start in each state
#'
#' @param wide A character matrix.
#' @param states The states.
#' @return A named numeric vector.
ref_initial <- function(wide, states = ref_states(wide)) {
  first <- table(factor(wide[, 1L], levels = states))
  stats::setNames(as.vector(first) / sum(first), states)
}

#' Shortest-path lengths by Floyd-Warshall
#'
#' @param lengths A square matrix of edge lengths, `Inf` where there is no edge and 0 on the diagonal.
#' @return The matrix of shortest distances.
ref_floyd <- function(lengths) {
  n <- nrow(lengths)
  Reduce(\(d, k) pmin(d, outer(d[, k], d[k, ], `+`)), seq_len(n), lengths)
}

#' Edge lengths of a weighted network, a weight read as a strength (length = 1 / weight)
#'
#' @param weights A square matrix of non-negative weights.
#' @return A matrix of lengths, `Inf` for an absent edge, 0 on the diagonal.
ref_lengths <- function(weights) {
  lengths <- ifelse(weights > 0, 1 / weights, Inf)
  diag(lengths) <- 0
  lengths
}

#' Shortest distances and the number of shortest paths between every pair of nodes
#'
#' @param weights A square matrix of non-negative weights, read as strengths (length = 1 / weight).
#' @return A list: `lengths`, `distance` and `paths` (paths[s, t], 1 on the diagonal).
ref_paths <- function(weights) {
  n <- nrow(weights)
  diag(weights) <- 0
  lengths <- ref_lengths(weights)
  distance <- ref_floyd(lengths)
  # The number of shortest paths from s: a path to t extends a path to u along a "tight" edge u -> t.
  tight <- \(s) weights > 0 & ref_same(outer(distance[s, ], rep(1, n)) + lengths, outer(rep(1, n), distance[s, ]))
  paths_from <- \(s) solve(diag(n) - t(tight(s)), as.numeric(seq_len(n) == s))
  list(lengths = lengths, distance = distance, paths = t(vapply(seq_len(n), paths_from, numeric(n))))
}

#' Two distances are equal up to rounding
#'
#' @param a,b Numeric arrays.
#' @return A logical array.
ref_same <- function(a, b) abs(a - b) <= 1e-9 * pmax(abs(a), abs(b), 1)

#' Betweenness of every node: the share of the shortest s -> t paths through it, summed over s != t (Brandes 2001)
#'
#' @param weights A square matrix of non-negative weights, read as strengths.
#' @return A numeric vector, one value per node.
ref_betweenness <- function(weights) {
  n <- nrow(weights)
  found <- ref_paths(weights)
  distance <- found$distance
  paths <- found$paths
  through <- \(v) {
    on_path <- ref_same(outer(distance[, v], distance[v, ], `+`), distance) & is.finite(distance)
    share <- outer(paths[, v], paths[v, ]) / paths
    others <- outer(seq_len(n) != v, seq_len(n) != v) & !diag(n)
    sum(share[on_path & others & paths > 0])
  }
  vapply(seq_len(n), through, numeric(1))
}

#' Edge betweenness of a directed network: the share of the shortest s -> t paths using each edge, summed over s != t
#'
#' @param weights A square matrix of non-negative weights, read as strengths.
#' @return A matrix of the shape of `weights`, 0 where there is no edge and on the diagonal.
ref_edge_betweenness <- function(weights) {
  n <- nrow(weights)
  found <- ref_paths(weights)
  distance <- found$distance
  paths <- found$paths
  pairs <- outer(seq_len(n), seq_len(n), `!=`) & is.finite(distance)
  edge <- \(u, v) {
    if (u == v || !(weights[u, v] > 0)) return(0)
    uses <- ref_same(outer(distance[, u] + found$lengths[u, v], distance[v, ], `+`), distance) & pairs
    sum((outer(paths[, u], paths[v, ]) / paths)[uses])
  }
  out <- outer(seq_len(n), seq_len(n), Vectorize(edge))
  dimnames(out) <- dimnames(weights)
  out
}

#' A square matrix as one row per cell
#'
#' @param cells A matrix with dimnames.
#' @param name The name of the value column.
#' @return A data frame `from`, `to`, `<name>`.
ref_long <- function(cells, name = "value") {
  cells <- unclass(as.matrix(cells))
  out <- data.frame(from = rownames(cells)[as.vector(row(cells))], to = colnames(cells)[as.vector(col(cells))],
                    value = as.vector(cells), stringsAsFactors = FALSE)
  names(out)[[3L]] <- name
  out
}

#' The off-diagonal cells of a square matrix, named "from -> to"
#'
#' @param cells A square matrix with dimnames.
#' @return A named numeric vector.
ref_off_diagonal <- function(cells) {
  keep <- row(cells) != col(cells)
  stats::setNames(cells[keep], paste(rownames(cells)[row(cells)[keep]], "->", colnames(cells)[col(cells)[keep]]))
}

#' The diagonal of a square matrix, named by state
#'
#' @param cells A square matrix with dimnames.
#' @return A named numeric vector.
ref_diagonal <- function(cells) stats::setNames(diag(cells), rownames(cells))
