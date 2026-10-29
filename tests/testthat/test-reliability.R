test_that("reliability can be analyzed", {
  expect_error(
    reliability(mock_tna_seq, iter = 50),
    NA
  )
  expect_error(
    reliability(mock_tna_seq, types = c("relative", "frequency"), iter = 50),
    NA
  )
})

test_that("summary of reliability lists every metric with its category", {
  model <- tna(group_regulation)
  set.seed(41)
  rel <- reliability(model, iter = 10)
  tab <- summary(rel)
  expect_named(tab, c("category", "metric", "mean", "sd", "median", "min",
                      "max", "q25", "q75"))
  expect_equal(nrow(tab), 22L)
  expect_equal(tab$metric, unique(rel$metrics$metric))
  pearson <- subset(rel$metrics, metric == "Pearson")
  expect_equal(subset(tab, metric == "Pearson")$median,
               stats::median(pearson$value))
  expect_equal(subset(tab, metric == "Pearson")$category, "Correlations")
  # Several model types: one block per type, in the order given
  set.seed(42)
  both <- summary(reliability(model, types = c("relative", "frequency"),
                              iter = 5))
  expect_equal(unique(both$model_type), c("relative", "frequency"))
  expect_equal(nrow(both), 44L)
  expect_error(summary.tna_reliability(model))
})
