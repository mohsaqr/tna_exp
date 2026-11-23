# cluster_sequences() (an alias of cluster_data()): the dissimilarities between sequences, computed by tna's own
# implementations, and the clustering on them. Distances against stringdist on the same sequences written one
# letter per state (an unobserved time point is one more letter); the weighted Hamming distance against its
# definition; the clusters and silhouette widths against cluster::pam(), stats::hclust() and
# cluster::silhouette() on the stringdist distances.
# tna fixes the Jaro-Winkler prefix weight at 0.1, so stringdist is called with p = 0.1 (its default, 0, is the
# plain Jaro distance).
# Tolerances: an edit distance is a whole number and a q-gram, cosine, Jaccard or Jaro-Winkler distance a ratio of
# small counts (1e-12 absolute); a cluster is a label (0); a silhouette width is a mean of ratios of sums (1e-10).

measures <- c("lv", "osa", "dl", "lcs", "qgram", "cosine", "jaccard", "jw")

#' Sequences as strings, one letter per state and "#" for an unobserved time point
#'
#' @param wide A character matrix.
#' @param full Keep every column (for the Hamming distance); otherwise stop at the last observed time point.
#' @return A character vector.
ref_strings <- function(wide, full = FALSE) {
  symbols <- unique(as.vector(wide))
  symbols <- symbols[!is.na(symbols)]
  coded <- matrix(c(letters, LETTERS)[match(wide, symbols)], nrow(wide))
  coded[is.na(coded)] <- "#"
  last <- if (full) rep(ncol(wide), nrow(wide)) else apply(!is.na(wide), 1L, \(row) max(which(row)))
  vapply(seq_len(nrow(wide)), \(row) paste(coded[row, seq_len(last[row])], collapse = ""), character(1))
}

#' A distance matrix as one row per pair i < j
#'
#' @param distances A `dist` or a square matrix.
#' @param label A prefix for the key.
#' @return A named numeric vector.
ref_pairs_of <- function(distances, label) {
  cells <- as.matrix(distances)
  upper <- which(upper.tri(cells), arr.ind = TRUE)
  stats::setNames(cells[upper], sprintf("%s: %d-%d", label, upper[, "row"], upper[, "col"]))
}

#' tna's distances for every measure
#'
#' @param data The sequences.
#' @return A named numeric vector.
tna_distances <- function(data) {
  unlist(lapply(measures, \(measure) {
    ref_pairs_of(cluster_sequences(data, k = 2, dissimilarity = measure)$distance, measure)
  }))
}

#' stringdist's distances for every measure
#'
#' @param strings The sequences as strings.
#' @return A named numeric vector.
stringdist_distances <- function(strings) {
  unlist(lapply(measures, \(measure) {
    ref_pairs_of(stringdist::stringdistmatrix(strings, method = measure, q = 2, p = 0.1), measure)
  }))
}

sequences <- group_regulation[seq_len(40L), ]
wide <- ref_wide(sequences)

test_that("distances between sequences equal stringdist's", {
  skip_without_reference("stringdist")
  expect_reference(tna_distances(sequences), stringdist_distances(ref_strings(wide)), reference = "stringdist",
                   covers = c("cluster_sequences()", "cluster_data()"), quantity = "dissimilarity",
                   tolerance = 1e-12)
  expect_reference(ref_pairs_of(cluster_data(sequences, k = 2, dissimilarity = "hamming")$distance, "hamming"),
                   ref_pairs_of(stringdist::stringdistmatrix(ref_strings(wide, full = TRUE), method = "hamming"),
                                "hamming"),
                   reference = "stringdist", covers = c("cluster_sequences()", "cluster_data()"),
                   quantity = "Hamming dissimilarity", tolerance = 1e-12)
})

test_that("distances between random letter sequences equal stringdist's", {
  skip_without_reference("stringdist")
  # Moved from tests/testthat/test-clusters.R (which compared tna's internal functions pair by pair): 60 random
  # sequences of 6 to 20 letters drawn from all 26, so that most states appear rarely and many pairs share none.
  set.seed(0)
  lengths <- 5L + sample.int(15L, 60L, replace = TRUE)
  drawn <- lapply(lengths, \(n) letters[sample.int(26L, n, replace = TRUE)])
  random <- as.data.frame(do.call(rbind, lapply(drawn, \(x) c(x, rep(NA_character_, 20L - length(x))))))
  strings <- vapply(drawn, paste, character(1), collapse = "")
  expect_reference(tna_distances(random), stringdist_distances(strings), reference = "stringdist",
                   covers = c("cluster_sequences()", "cluster_data()"), quantity = "dissimilarity, random letters",
                   tolerance = 1e-12)
})

test_that("the weighted Hamming distance equals its definition", {
  # Position t (from 0) counts exp(-lambda t), the weights scaled so that the largest is 1.
  coded <- wide
  coded[is.na(coded)] <- "#"
  weights <- exp(-0.5 * (seq_len(ncol(coded)) - 1))
  weighted <- outer(seq_len(nrow(coded)), seq_len(nrow(coded)),
                    Vectorize(\(i, j) sum((coded[i, ] != coded[j, ]) * weights)))
  expect_reference(ref_pairs_of(cluster_data(sequences, k = 2, weighted = TRUE, lambda = 0.5)$distance, "weighted"),
                   ref_pairs_of(weighted, "weighted"),
                   reference = "independent: sum of position weights exp(-lambda t) over the mismatched positions",
                   covers = c("cluster_sequences()", "cluster_data()"), quantity = "weighted Hamming dissimilarity",
                   tolerance = 1e-12)
})

test_that("clusters and silhouette widths equal cluster::pam() and stats::hclust() on stringdist's distances", {
  skip_without_reference(c("stringdist", "cluster"))
  distances <- stringdist::stringdistmatrix(ref_strings(wide), method = "lv")
  medoids <- cluster::pam(distances, diss = TRUE, k = 3)
  pam_tna <- cluster_sequences(sequences, k = 3, dissimilarity = "lv")
  expect_reference(pam_tna$assignments, medoids$clustering, reference = "cluster", authority = "internal",
                   covers = c("cluster_sequences()", "cluster_data()"), quantity = "cluster, pam, k = 3",
                   tolerance = 0)
  expect_reference(pam_tna$silhouette, medoids$silinfo$avg.width, reference = "cluster", authority = "internal",
                   covers = c("cluster_sequences()", "cluster_data()"), quantity = "mean silhouette width, pam, k = 3",
                   tolerance = 1e-10)
  tree <- stats::hclust(distances, method = "average")
  groups <- stats::cutree(tree, k = 3)
  hc_tna <- cluster_sequences(sequences, k = 3, dissimilarity = "lv", method = "average")
  expect_reference(hc_tna$assignments, groups, reference = "stats", authority = "internal",
                   covers = c("cluster_sequences()", "cluster_data()"), quantity = "cluster, average linkage, k = 3",
                   tolerance = 0)
  expect_reference(hc_tna$silhouette, mean(cluster::silhouette(groups, dist = distances)[, "sil_width"]),
                   reference = "cluster", authority = "internal", covers = c("cluster_sequences()", "cluster_data()"),
                   quantity = "mean silhouette width, average linkage, k = 3", tolerance = 1e-10)
})

# cluster_data() clusters with cluster::pam(), stats::hclust() and cluster::silhouette() itself (R/clusters.R), so the
# rows above are declared authority "internal" (STANDARD decision 14: "<package> (called by the package)"). The
# independent check: the mean silhouette width of the partition tna returns, from Rousseeuw's (1987) definition on
# stringdist's distances, s(i) = (b(i) - a(i)) / max(a(i), b(i)), a(i) the mean distance to the other members of
# i's cluster, b(i) the smallest mean distance to another cluster, s(i) = 0 for a cluster of one.

#' The mean silhouette width of a partition from its definition (Rousseeuw 1987)
#'
#' @param distances A "dist" object.
#' @param membership The cluster of each element.
#' @return The mean silhouette width.
ref_mean_silhouette <- function(distances, membership) {
  d <- as.matrix(distances)
  widths <- vapply(seq_along(membership), \(i) {
    own <- membership == membership[i]
    if (sum(own) == 1L) return(0)
    a <- sum(d[i, own]) / (sum(own) - 1L)
    b <- min(vapply(setdiff(unique(membership), membership[i]), \(c) mean(d[i, membership == c]), numeric(1)))
    (b - a) / max(a, b)
  }, numeric(1))
  mean(widths)
}

test_that("the silhouette width tna reports is that of its partition, by Rousseeuw's definition", {
  skip_without_reference("stringdist")
  distances <- stringdist::stringdistmatrix(ref_strings(wide), method = "lv")
  pam_tna <- cluster_sequences(sequences, k = 3, dissimilarity = "lv")
  hc_tna <- cluster_sequences(sequences, k = 3, dissimilarity = "lv", method = "average")
  by_definition <- "independent: mean silhouette width of the returned partition (Rousseeuw 1987) in base R"
  expect_reference(pam_tna$silhouette, ref_mean_silhouette(distances, pam_tna$assignments), reference = by_definition,
                   covers = c("cluster_sequences()", "cluster_data()"),
                   quantity = "mean silhouette width of the partition, pam, k = 3", tolerance = 1e-10)
  expect_reference(hc_tna$silhouette, ref_mean_silhouette(distances, hc_tna$assignments), reference = by_definition,
                   covers = c("cluster_sequences()", "cluster_data()"),
                   quantity = "mean silhouette width of the partition, average linkage, k = 3", tolerance = 1e-10)
})
