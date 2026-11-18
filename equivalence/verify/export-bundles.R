# Exports tna comparison cases as bundles for Prova Verify (format:
# plan/24-verify.md in the prova repository), with Prova's R writer.
#
# Every side of a case is an R script, stored in the bundle and run there in its
# own R process: its console is the side's raw output and the table it leaves in
# `result` holds the side's values. The tna side runs the development source
# (devtools::load_all(".")) on the bundled `group_regulation` data; every other
# side reads the same data from `../data/group_regulation.csv`.
#
# Run from the project root:
#   Rscript equivalence/verify/export-bundles.R [case ...]
source(Sys.getenv("PROVA_VERIFY_R", file.path("..", "prova", "reporters", "verify.R")))

.verify_base <- file.path("equivalence", "verify")
.verify_generator <- "tna equivalence/verify/export-bundles.R"

#' The bundled `group_regulation` sequences, written to a file
#'
#' 2000 sequences of up to 26 time points over nine states; a sequence that
#' ends early is padded with empty cells (read back as `NA`).
#' @return The path of a comma-separated file named `group_regulation.csv`.
.verify_sequences <- function() {
  bundled <- new.env()
  load(file.path("data", "group_regulation.rda"), envir = bundled)
  file <- file.path(tempdir(), "group_regulation.csv")
  utils::write.csv(bundled$group_regulation, file, row.names = FALSE, na = "")
  file
}

#' A script given as one block of text, as a vector of lines
#' @param text The script.
#' @return A character vector, one line per element.
.lines <- function(text) {
  lines <- strsplit(text, "\n", fixed = TRUE) |> unlist()
  lines[nzchar(trimws(lines))]
}

.read_sequences <- "sequences <- as.matrix(read.csv(\"../data/group_regulation.csv\", na.strings = \"\"))"

.tna <- function(script, key = NULL) {
  # The development source is what runs (load = "."), so its version is read from DESCRIPTION:
  # verify_side() would otherwise record the version of the installed tna.
  verify_side("tna", package = "tna", version = unname(read.dcf("DESCRIPTION", "Version")[1L, 1L]),
              primary = TRUE, load = ".", key = key,
              script = c("library(tna)", .lines(script)))
}
.base <- function(script, key = NULL) {
  verify_side("base", name = "Base R, from the definition", version = as.character(getRversion()),
              authority = "independent", key = key, script = c(.read_sequences, .lines(script)))
}
.reference <- function(package, script, key = NULL) {
  verify_side(tolower(package), package = package, authority = "open-source", key = key,
              script = c(sprintf("library(%s)", package), .read_sequences, .lines(script)))
}

# Lines shared by the reference scripts ---------------------------------------

# First-order transition counts: a cross-tabulation of every time point with the next one.
.count_transitions <- r"(
states <- sort(unique(na.omit(c(sequences))))
from <- factor(sequences[, -ncol(sequences)], levels = states)
to <- factor(sequences[, -1], levels = states)
counts <- table(from, to)
)"

# A square state-by-state table as one row per ordered pair of states.
.as_edges <- r"(
edges <- as.data.frame(as.table(weights), responseName = "value")
result <- data.frame(quantity = paste(edges[[1]], "->", edges[[2]]), value = edges$value)
)"

# The TraMineR state sequence object; trailing empty cells are the end of a sequence.
.seqdef <- r"(
state_sequences <- seqdef(as.data.frame(sequences))
)"

# The relative transition network without loops, as tna's centralities() uses it by default.
.network <- paste0(.count_transitions, r"(
weights <- unclass(prop.table(counts, 1))
diag(weights) <- 0
)")

#' Every case: its words, its tolerance and the script of each side
#'
#' A script's paths are relative to its own folder inside the bundle. A script
#' leaves a data frame `result`: long (`quantity`, `value`) or, with a key, one
#' row per state and one column per measure.
#'
#' The tolerances were fixed before the cases were first run:
#' * probabilities are ratios of two integer counts, so every side does the
#'   same division: 1e-12 absolute allows for a different order of operations;
#' * counts are whole numbers: no difference is allowed (0);
#' * attention weights are sums of thousands of exp() terms of size up to 1e4,
#'   added in a different order by each side: 1e-10 relative;
#' * centralities include PageRank, which igraph solves iteratively (PRPACK,
#'   to about 1e-10): 1e-8 absolute;
#' * community memberships are labels: 0;
#' * sequence distances are edit counts or ratios of counts: 1e-12 absolute.
#' @return A named list of cases.
.verify_cases <- function() {
  list(
    transition_probabilities = list(
      title = "Transition probabilities of a relative model",
      description = "The 9 x 9 matrix of first-order transition probabilities of the bundled group_regulation sequences (2000 sequences, up to 26 time points): tna() against TraMineR's seqtrate() and against a cross-tabulation of every time point with the next one, divided by its row totals.",
      covers = c("tna()", "build_model()"),
      needs = "TraMineR", tolerance = 1e-12, measure = "absolute",
      sides = list(
        .tna(r"(
model <- tna(group_regulation)
model
edges <- as.data.frame(as.table(model$weights), responseName = "value")
result <- data.frame(quantity = paste(edges[[1]], "->", edges[[2]]), value = edges$value)
)"),
        .reference("TraMineR", paste0(.seqdef, r"(
weights <- seqtrate(state_sequences)
dimnames(weights) <- list(alphabet(state_sequences), alphabet(state_sequences))
round(weights, 4)
)", .as_edges)),
        .base(paste0(.count_transitions, r"(
weights <- prop.table(counts, 1)
round(weights, 4)
)", .as_edges)))),

    initial_probabilities = list(
      title = "Initial state probabilities",
      description = "The share of sequences that start in each state: the initial probabilities of tna() against TraMineR's state distribution at the first time point (seqstatd()) and against a tabulation of the first column.",
      covers = c("tna()", "build_model()"),
      needs = "TraMineR", tolerance = 1e-12, measure = "absolute",
      sides = list(
        .tna(key = "state", r"(
model <- tna(group_regulation)
result <- data.frame(state = model$labels, initial = model$inits)
result
)"),
        .reference("TraMineR", key = "state", paste0(.seqdef, r"(
distribution <- seqstatd(state_sequences)$Frequencies
result <- data.frame(state = rownames(distribution), initial = distribution[, 1])
result
)")),
        .base(key = "state", r"(
first <- prop.table(table(sequences[, 1]))
result <- data.frame(state = names(first), initial = as.vector(first))
result
)"))),

    frequency_counts = list(
      title = "Transition counts of a frequency model",
      description = "The 9 x 9 matrix of first-order transition counts: ftna() against TraMineR's seqtrate(count = TRUE) and against a cross-tabulation of every time point with the next one.",
      covers = c("ftna()", "build_model()"),
      needs = "TraMineR", tolerance = 0, measure = "absolute",
      sides = list(
        .tna(r"(
model <- ftna(group_regulation)
model
edges <- as.data.frame(as.table(model$weights), responseName = "value")
result <- data.frame(quantity = paste(edges[[1]], "->", edges[[2]]), value = edges$value)
)"),
        .reference("TraMineR", paste0(.seqdef, r"(
weights <- seqtrate(state_sequences, count = TRUE)
dimnames(weights) <- list(alphabet(state_sequences), alphabet(state_sequences))
weights
)", .as_edges)),
        .base(paste0(.count_transitions, r"(
weights <- counts
weights
)", .as_edges)))),

    cooccurrence_attention = list(
      title = "Co-occurrence and attention models",
      description = "ctna() counts, for every pair of time points of a sequence, the two states in both directions; atna() counts every earlier-to-later pair of time points weighted by exp(-lag). Both against base R computations written from those definitions: per-sequence state counts n give the co-occurrences as the sum of n n' - diag(n), and lagged cross-tabulations weighted by exp(-lag) give the attention weights. Known result: the nine diagonal cells of the co-occurrence matrix disagree by a factor of two. tna counts a pair of time points in the same state once, n (n - 1) / 2, where counting both directions as for two different states gives n (n - 1); every off-diagonal cell agrees.",
      covers = c("ctna()", "atna()", "build_model()"),
      tolerance = 1e-10, measure = "relative",
      sides = list(
        .tna(r"(
cooccurrence <- ctna(group_regulation)
attention <- atna(group_regulation)
cooccurrence
attention
edges <- rbind(
  data.frame(model = "ctna", as.data.frame(as.table(cooccurrence$weights), responseName = "value")),
  data.frame(model = "atna", as.data.frame(as.table(attention$weights), responseName = "value"))
)
result <- data.frame(quantity = sprintf("%s: %s -> %s", edges$model, edges[[2]], edges[[3]]), value = edges$value)
)"),
        .base(r"(
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
)"))),

    centralities_paths = list(
      title = "Strength, closeness, betweenness and PageRank",
      description = "Seven centralities of the relative transition network without loops, a weight read as the strength of an edge (a path's length is the sum of inverse weights). tna computes these with igraph, so the igraph side checks how tna builds the graph and passes the weights; the base R side is independent of both: Floyd-Warshall distances, shortest-path counts and a linear solve for PageRank (damping 0.85).",
      covers = "centralities()",
      needs = "igraph", tolerance = 1e-8, measure = "absolute",
      sides = list(
        .tna(key = "state", r"(
model <- tna(group_regulation)
result <- centralities(model, measures = c("OutStrength", "InStrength", "ClosenessIn", "ClosenessOut",
                                           "Closeness", "Betweenness", "PageRank"))
as.data.frame(result)
)"),
        .reference("igraph", key = "state", paste0(.network, r"(
graph <- graph_from_adjacency_matrix(weights, mode = "directed", weighted = TRUE)
lengths <- 1 / E(graph)$weight
result <- data.frame(
  state = V(graph)$name,
  OutStrength = strength(graph, mode = "out"), InStrength = strength(graph, mode = "in"),
  ClosenessIn = closeness(graph, mode = "in", weights = lengths),
  ClosenessOut = closeness(graph, mode = "out", weights = lengths),
  Closeness = closeness(graph, mode = "all", weights = lengths),
  Betweenness = betweenness(graph, weights = lengths),
  PageRank = page_rank(graph)$vector
)
result
)")),
        .base(key = "state", paste0(.network, r"(
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
)")))),

    centralities_diffusion_clustering = list(
      title = "Diffusion centrality and the weighted clustering coefficient",
      description = "Two centralities tna implements itself, on the relative transition network without loops, against base R computations written from the published definitions: diffusion centrality (Banerjee et al., 2014) as the row sums of W + W^2 + ... + W^n, min-max scaled as tna always reports it; and the weighted clustering coefficient of Zhang and Horvath (2005) on the symmetrised network W + W'.",
      covers = "centralities()",
      tolerance = 1e-10, measure = "absolute",
      sides = list(
        .tna(key = "state", r"(
model <- tna(group_regulation)
result <- centralities(model, measures = c("Diffusion", "Clustering"))
as.data.frame(result)
)"),
        .base(key = "state", paste0(.network, r"(
n <- length(states)
# Diffusion: expected number of visits started from a state over walks of 1 to n steps.
powers <- Reduce(`%*%`, rep(list(weights), n), accumulate = TRUE)
diffusion <- rowSums(Reduce(`+`, powers))
# Clustering: sum over j, k of u[i, j] u[j, k] u[k, i], over
# (sum of u[i, ])^2 - sum of u[i, ]^2, with u the symmetrised weights.
u <- weights + t(weights)
triangles <- vapply(seq_len(n), function(i) sum(outer(u[i, ], u[, i]) * u), numeric(1))
result <- data.frame(
  state = states,
  Diffusion = (diffusion - min(diffusion)) / (max(diffusion) - min(diffusion)),
  Clustering = triangles / (rowSums(u)^2 - rowSums(u^2))
)
result
)")))),

    communities = list(
      title = "Communities of the transition network",
      description = "The community of each state under the four deterministic algorithms tna offers. tna finds communities with igraph, so this case checks which graph and weights tna hands over: the directed network with its loops for walktrap and edge betweenness, and the undirected network with summed weights for fast greedy and leading eigenvector. The igraph side builds those graphs from a base R transition matrix. The algorithms with a random start (label propagation, infomap, spinglass) are left out.",
      covers = "communities()",
      needs = "igraph", tolerance = 0, measure = "absolute",
      sides = list(
        .tna(key = "state", r"(
model <- tna(group_regulation)
found <- communities(model, methods = c("walktrap", "fast_greedy", "edge_betweenness", "leading_eigen"))
found
result <- found$assignments
)"),
        .reference("igraph", key = "state", paste0(.count_transitions, r"(
weights <- unclass(prop.table(counts, 1))
directed <- graph_from_adjacency_matrix(weights, mode = "directed", weighted = TRUE)
summed <- graph_from_adjacency_matrix(weights, mode = "plus", weighted = TRUE)
result <- data.frame(
  state = V(directed)$name,
  walktrap = as.numeric(membership(cluster_walktrap(directed, weights = E(directed)$weight))),
  fast_greedy = as.numeric(membership(cluster_fast_greedy(summed, weights = E(summed)$weight))),
  edge_betweenness = as.numeric(membership(cluster_edge_betweenness(directed, weights = E(directed)$weight))),
  leading_eigen = as.numeric(membership(cluster_leading_eigen(summed, weights = E(summed)$weight)))
)
result
)")))),

    sequence_distances = list(
      title = "Distances between sequences",
      description = "The pairwise dissimilarities of the first 15 group_regulation sequences that cluster_sequences() clusters on, computed by tna's own implementations, against stringdist's on the same sequences written with one letter per state: Levenshtein, optimal string alignment, Damerau-Levenshtein, longest common subsequence, and the 2-gram, cosine and Jaccard distances and Jaro-Winkler. tna's Jaro-Winkler uses the prefix weight 0.1, so stringdist is called with p = 0.1 (its default, 0, is the plain Jaro distance and differs for pairs that share a first state).",
      covers = c("cluster_sequences()", "cluster_data()"),
      needs = "stringdist", tolerance = 1e-12, measure = "absolute",
      sides = list(
        .tna(r"(
sequences <- head(group_regulation, 15)
measures <- c("lv", "osa", "dl", "lcs", "qgram", "cosine", "jaccard", "jw")
distances <- lapply(measures, function(measure) {
  clustering <- cluster_sequences(sequences, k = 2, dissimilarity = measure)
  pairs <- as.data.frame(as.table(as.matrix(clustering$distance)), responseName = "value")
  pairs <- subset(pairs, as.integer(Var1) < as.integer(Var2))
  data.frame(quantity = sprintf("%s: %s-%s", measure, pairs$Var1, pairs$Var2), value = pairs$value)
})
result <- do.call(rbind, distances)
head(result)
)"),
        .reference("stringdist", r"(
sequences <- head(sequences, 15)
states <- sort(unique(na.omit(c(sequences))))
letter <- matrix(letters[match(sequences, states)], nrow = nrow(sequences))
strings <- apply(letter, 1, function(row) paste(na.omit(row), collapse = ""))
strings
measures <- c("lv", "osa", "dl", "lcs", "qgram", "cosine", "jaccard", "jw")
distances <- lapply(measures, function(measure) {
  # p is the Jaro-Winkler prefix weight: tna fixes it at 0.1, stringdist's default is 0 (plain Jaro).
  d <- as.matrix(stringdistmatrix(strings, method = measure, q = 2, p = 0.1))
  dimnames(d) <- list(seq_along(strings), seq_along(strings))
  pairs <- as.data.frame(as.table(d), responseName = "value")
  pairs <- subset(pairs, as.integer(Var1) < as.integer(Var2))
  data.frame(quantity = sprintf("%s: %s-%s", measure, pairs$Var1, pairs$Var2), value = pairs$value)
})
result <- do.call(rbind, distances)
head(result)
)")))
  )
}

#' Export one case
#'
#' A case whose reference package is not installed is not exported: a
#' `tna_verify_skipped` message says which package is missing.
#' @param name The case's name.
#' @param data The shared data file.
#' @return One row: the bundle, its sides and how its compared values came out;
#'   `NULL` for a skipped case.
export_case <- function(name, data = .verify_sequences()) {
  cases <- .verify_cases()
  stopifnot("`name` must be one exported case" = length(name) == 1L && name %in% names(cases))
  case <- cases[[name]]
  # Prova's verify_run() drops repeated lines from the copy of a script it runs (setdiff()), so a
  # script with two identical lines would run as something other than what the bundle shows.
  repeated <- vapply(case$sides, function(side) anyDuplicated(side$.script) > 0L, logical(1))
  if (any(repeated)) {
    stop(errorCondition(sprintf("Case `%s` has a script with a repeated line.", name),
                        class = "tna_verify_repeated_line", call = NULL))
  }
  absent <- Filter(function(package) !requireNamespace(package, quietly = TRUE), case$needs %||% character())
  if (length(absent) > 0L) {
    message(messageCondition(sprintf("Case `%s` skipped: %s is not installed.\n", name, toString(absent)),
                             class = "tna_verify_skipped", call = NULL))
    return(NULL)
  }
  out <- verify_export(bundle = file.path(.verify_base, "bundles", name), title = case$title,
                       description = case$description, sides = case$sides,
                       data = c(`group_regulation sequences` = data),
                       tolerance = case$tolerance, measure = case$measure, covers = case$covers,
                       generator = .verify_generator)
  data.frame(case = name, out[c("sides", "compared", "agree", "disagree", "missing")])
}

requested <- commandArgs(trailingOnly = TRUE)
if (length(requested) == 0L) requested <- names(.verify_cases())
print(do.call(rbind, lapply(requested, export_case)), row.names = FALSE)
