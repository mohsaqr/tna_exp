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
