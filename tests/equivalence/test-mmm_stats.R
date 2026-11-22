# mmm_stats(): the covariate coefficients of a mixture Markov model with their standard errors, Wald z-values,
# p-values and confidence intervals. For a seqHMM model, the estimates and standard errors against seqHMM's own
# summary() (coefficients and the square roots of the diagonal of vcov), and the z-values, p-values and intervals
# against the Wald formulas (estimate / se, 2 (1 - Phi(|z|)), estimate -/+ z_(1 - level/2) se). The same formulas
# for tna's own mixture model (engagement_mmm, an intercept per cluster).
# Tolerance: one division or one normal quantile per number, 1e-10 absolute.

#' Wald statistics of coefficients from their estimates and standard errors
#'
#' @param cluster,variable The key of each coefficient.
#' @param estimate,std_error The estimates and their standard errors.
#' @param level The significance level.
#' @return A data frame keyed by cluster and variable.
ref_wald <- function(cluster, variable, estimate, std_error, level = 0.05) {
  z <- estimate / std_error
  margin <- stats::qnorm(1 - level / 2) * std_error
  data.frame(cluster = cluster, variable = variable, estimate = estimate, std_error = std_error,
             ci_lower = estimate - margin, ci_upper = estimate + margin, z_value = z,
             p_value = 2 * stats::pnorm(-abs(z)))
}

test_that("the coefficients of a seqHMM model equal seqHMM's estimates, standard errors and the Wald formulas", {
  skip_without_reference("seqHMM")
  set.seed(3)
  covariates <- data.frame(x = stats::rnorm(300))
  initial <- seqHMM::build_mmm(engagement[seq_len(300L), ], n_clusters = 3, formula = ~ x, data = covariates)
  fit <- seqHMM::fit_model(initial)$model
  fitted <- summary(fit)
  # The first cluster is the reference; the others have one coefficient per variable.
  coefficients <- fitted$coefficients[, -1L, drop = FALSE]
  cluster <- rep(colnames(coefficients), each = nrow(coefficients))
  variable <- rep(rownames(coefficients), times = ncol(coefficients))
  estimate <- as.vector(coefficients)
  std_error <- sqrt(diag(fitted$vcov))
  expect_reference(mmm_stats(fit), data.frame(cluster = cluster, variable = variable, estimate = estimate,
                                              std_error = std_error),
                   reference = "seqHMM", covers = c("mmm_stats()", "mmm_stats.mhmm()"),
                   quantity = "coefficient", tolerance = 1e-10, key = c("cluster", "variable"))
  expect_reference(mmm_stats(fit, level = 0.1), ref_wald(cluster, variable, estimate, std_error, level = 0.1),
                   reference = "independent: Wald z, normal p-value and interval from the estimate and standard error",
                   covers = c("mmm_stats()", "mmm_stats.mhmm()"), quantity = "Wald statistics, level 0.1",
                   tolerance = 1e-10, key = c("cluster", "variable"))
})

test_that("the coefficients of tna's mixture model follow the Wald formulas", {
  coefficients <- engagement_mmm$coefficients[, -1L, drop = FALSE]
  cluster <- rep(colnames(coefficients), each = nrow(coefficients))
  variable <- rep(rownames(coefficients), times = ncol(coefficients))
  expected <- ref_wald(cluster, variable, as.vector(coefficients), sqrt(diag(engagement_mmm$vcov)))
  expect_reference(mmm_stats(engagement_mmm), expected,
                   reference = "independent: Wald z, normal p-value and interval from the estimate and standard error",
                   covers = c("mmm_stats()", "mmm_stats.tna_mmm()"), quantity = "Wald statistics",
                   tolerance = 1e-10, key = c("cluster", "variable"))
})

#' The Wald test of each coefficient alone by aod::wald.test(): chi-squared with one degree of freedom (z squared)
#' and its p-value
#'
#' @param estimate,vcov The coefficients (in the order of `vcov`) and their covariance matrix.
#' @return A data frame: position, chi2, p_value.
aod_wald <- function(estimate, vcov) {
  tests <- lapply(seq_along(estimate), \(term) aod::wald.test(Sigma = vcov, b = estimate, Terms = term)$result$chi2)
  data.frame(position = seq_along(estimate), chi2 = vapply(tests, `[[`, numeric(1), "chi2"),
             p_value = vapply(tests, `[[`, numeric(1), "P"))
}

#' mmm_stats() as z squared and p-value by position
#'
#' @param table The result of mmm_stats().
#' @return A data frame: position, chi2, p_value.
wald_of <- \(table) data.frame(position = seq_len(nrow(table)), chi2 = table$z_value^2, p_value = table$p_value)

test_that("Wald z-values and p-values equal aod's Wald tests", {
  skip_without_reference(c("aod", "seqHMM"))
  set.seed(3)
  covariates <- data.frame(x = stats::rnorm(300))
  initial <- seqHMM::build_mmm(engagement[seq_len(300L), ], n_clusters = 3, formula = ~ x, data = covariates)
  fit <- seqHMM::fit_model(initial)$model
  fitted <- summary(fit)
  estimate <- as.vector(fitted$coefficients[, -1L, drop = FALSE])
  expect_reference(wald_of(mmm_stats(fit)), aod_wald(estimate, fitted$vcov), reference = "aod",
                   covers = c("mmm_stats()", "mmm_stats.mhmm()"), quantity = "Wald chi-squared and p-value",
                   tolerance = 1e-10, key = "position")
  tna_estimate <- as.vector(engagement_mmm$coefficients[, -1L, drop = FALSE])
  expect_reference(wald_of(mmm_stats(engagement_mmm)), aod_wald(tna_estimate, engagement_mmm$vcov), reference = "aod",
                   covers = c("mmm_stats()", "mmm_stats.tna_mmm()"),
                   quantity = "Wald chi-squared and p-value of tna's mixture model", tolerance = 1e-10, key = "position")
})
