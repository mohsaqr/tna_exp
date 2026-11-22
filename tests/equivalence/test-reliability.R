# reliability(): split-half reliability of a relative transition network. tna draws the halves inside the
# function, so the comparison is statistical: the mean over splits of nine comparison metrics (the textbook
# definitions over all cells: mean and RMS absolute difference, Pearson and Spearman correlation, Euclidean and
# Manhattan distance, Bray-Curtis dissimilarity, cosine and Jaccard similarity), against split halves written in
# base R (helper-resampling.R) with 2000 splits. The tolerance is 4 standard errors of the difference of the two
# means, sd_metric sqrt(1/500 + 1/2000), the SD from the reference's own splits, fixed before the run; each
# metric has its own tolerance (they live on different scales).
# A probe of 20 seeds of tna against the reference passed 20 of 20 before this file was run.

data <- group_regulation[1:300, ]
wide <- ref_wide(data)
states <- ref_states(wide)
model <- tna(data)
iter <- 500L
draws <- 2000L
reference <- rs_split_half(wide, states, draws, seed = 31L)
by_definition <- "independent: split halves written in base R (helper-resampling.R)"

test_that("the mean of each comparison metric over splits agrees with base-R split halves", {
  lapply(1:3, \(seed) {
    table <- rs_with_seed(seed, summary(reliability(model, iter = iter)))
    lapply(colnames(reference), \(metric) {
      expect_reference(table$mean[table$metric == metric], mean(reference[, metric]), reference = by_definition,
                       covers = c("reliability()", "reliability.tna()", "summary.tna_reliability()"),
                       quantity = sprintf("Monte Carlo summary: mean %s over splits, seed %d", metric, seed),
                       tolerance = 4 * stats::sd(reference[, metric]) * sqrt(1 / iter + 1 / draws))
    })
  })
})

# The comparison metrics of each split computed by established software: Pearson and Spearman by stats::cor(),
# Euclidean and Manhattan by stats::dist(), Bray-Curtis and weighted Jaccard by vegan::vegdist() (Jaccard as
# 1 - the Ruzicka dissimilarity), cosine by proxy::simil(). The random halves are drawn in base R (the procedure has
# no implementation elsewhere); tolerances as above, fixed before the run.

test_that("the mean of each comparison metric over splits agrees with stats, vegan and proxy on random halves", {
  skip_without_reference(c("vegan", "proxy"))
  counts <- rs_counts(wide, states)
  n <- nrow(wide)
  by_software <- rs_with_seed(32L, t(vapply(seq_len(draws), \(i) {
    half <- tabulate(sample.int(n, round(n * 0.5)), n)
    pair <- rbind(as.vector(rs_network(counts, half, states)), as.vector(rs_network(counts, 1 - half, states)))
    c(Pearson = stats::cor(pair[1L, ], pair[2L, ]), Spearman = stats::cor(pair[1L, ], pair[2L, ], method = "spearman"),
      Euclidean = as.vector(stats::dist(pair)), Manhattan = as.vector(stats::dist(pair, method = "manhattan")),
      "Bray-Curtis" = as.vector(vegan::vegdist(pair, method = "bray")),
      Jaccard = 1 - as.vector(vegan::vegdist(pair, method = "jaccard")),
      Cosine = as.vector(proxy::simil(pair, method = "cosine")))
  }, numeric(7))))
  package_of <- c(Pearson = "stats", Spearman = "stats", Euclidean = "stats", Manhattan = "stats",
                  "Bray-Curtis" = "vegan", Jaccard = "vegan", Cosine = "proxy")
  lapply(1:3, \(seed) {
    table <- rs_with_seed(seed + 10L, summary(reliability(model, iter = iter)))
    lapply(colnames(by_software), \(metric) {
      expect_reference(table$mean[table$metric == metric], mean(by_software[, metric]),
                       reference = package_of[[metric]],
                       covers = c("reliability()", "reliability.tna()", "summary.tna_reliability()"),
                       quantity = sprintf("Monte Carlo summary: mean %s over splits, seed %d", metric, seed),
                       tolerance = 4 * stats::sd(by_software[, metric]) * sqrt(1 / iter + 1 / draws))
    })
  })
})
