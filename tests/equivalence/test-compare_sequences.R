# compare_sequences(): the subsequences (patterns of 1 to 5 adjacent states) of two groups, their counts and
# their shares among the patterns of the same length in each group. With test = FALSE (the permutation test draws
# its permutations inside the function and is not compared here) against the definition in base R: every window
# of adjacent observed time points, counted per group, patterns kept when both groups have at least min_freq.
# Tolerance: one for counts and shares, 1e-12 absolute (a count is a whole number; a share is one division).

wide <- ref_wide(group_regulation)
halves <- rep(c("first", "second"), each = 1000)

#' Pattern counts and shares per group
#'
#' @param wide A character matrix.
#' @param group The group of each row.
#' @param lengths The pattern lengths.
#' @param min_freq The smallest count, in every group, of a pattern kept.
#' @return A data frame: pattern, freq_<group>, prop_<group>.
ref_patterns <- function(wide, group, lengths, min_freq) {
  p <- ncol(wide)
  groups <- unique(group)
  per_length <- lapply(lengths, \(len) {
    windows <- lapply(seq_len(p - len + 1L), \(start) {
      cells <- wide[, start + seq_len(len) - 1L, drop = FALSE]
      complete <- rowSums(is.na(cells)) == 0L
      data.frame(pattern = apply(cells[complete, , drop = FALSE], 1L, paste, collapse = "->"), group = group[complete])
    })
    found <- do.call(rbind, windows)
    counts <- table(factor(found$pattern), factor(found$group, levels = groups))
    freq <- matrix(as.numeric(counts), nrow(counts), dimnames = list(rownames(counts), groups))
    prop <- t(t(freq) / colSums(freq))
    data.frame(pattern = rownames(freq), stats::setNames(as.data.frame(freq), paste0("freq_", groups)),
               stats::setNames(as.data.frame(prop), paste0("prop_", groups)))
  })
  out <- do.call(rbind, per_length)
  keep <- apply(out[paste0("freq_", groups)], 1L, min) >= min_freq
  out[keep, ]
}

test_that("pattern counts and shares equal the counts of every window of adjacent states", {
  expected <- ref_patterns(wide, halves, lengths = 1:5, min_freq = 5)
  expect_reference(compare_sequences(group_regulation, group = halves, test = FALSE), expected,
                   reference = "independent: windows of adjacent observed states counted per group in base R",
                   covers = c("compare_sequences()", "compare_sequences.default()"),
                   quantity = "pattern", tolerance = 1e-12, key = "pattern")
  expect_reference(compare_sequences(group_tna(group_regulation, group = halves), sub = 2:3, min_freq = 20,
                                     test = FALSE),
                   ref_patterns(wide, halves, lengths = 2:3, min_freq = 20),
                   reference = "independent: windows of adjacent observed states counted per group in base R",
                   covers = c("compare_sequences()", "compare_sequences.group_tna()"),
                   quantity = "pattern of length 2 or 3, at least 20 per group", tolerance = 1e-12, key = "pattern")
})
