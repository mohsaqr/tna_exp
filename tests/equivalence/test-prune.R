# prune(), deprune() and reprune(): edges removed by a threshold, by the lowest share of the positive weights, or
# by the disparity filter of Serrano, Boguna and Vespignani (2009), and the model restored and pruned again.
# References are the definitions in base R: a threshold or a stats::quantile() cut-off, and the disparity
# significance alpha_ij = (1 - p_ij)^(k - 1) of an edge for its source (p_ij its share of the source's
# out-strength, k the source's out-degree) or its target (share of in-strength, in-degree), the edge kept when
# either is below the level. prune() keeps an edge whose removal would disconnect the network; on the inputs below
# no such edge exists, so the definition is the plain cut (a kept edge would show here as a disagreement).
# Tolerance: the kept weights are copied, 0.

model <- tna(group_regulation)
weights <- model$weights
by_definition <- "independent: the threshold, quantile cut-off and disparity filter written in base R"

#' The disparity filter of a weight matrix
#'
#' @param weights A square weight matrix.
#' @param level The significance level.
#' @return The weights with the insignificant edges (and the loops) set to 0.
ref_disparity <- function(weights, level) {
  edge <- weights > 0
  out_share <- weights / rowSums(weights)
  in_share <- t(t(weights) / colSums(weights))
  alpha_out <- (1 - out_share)^(rowSums(edge) - 1)
  alpha_in <- t(t(1 - in_share)^(colSums(edge) - 1))
  keep <- edge & (alpha_out < level | alpha_in < level)
  diag(keep) <- FALSE
  weights * keep
}

test_that("pruned weights equal the cut by threshold, by quantile and by the disparity filter", {
  expect_reference(prune(model, threshold = 0.05)$weights, weights * (weights > 0.05), reference = by_definition,
                   covers = c("prune()", "prune.tna()"), quantity = "weight after a threshold of 0.05", tolerance = 0)
  cut_off <- stats::quantile(weights[weights > 0], probs = 0.2)
  expect_reference(prune(model, method = "lowest", lowest = 0.2)$weights, weights * (weights > cut_off),
                   reference = by_definition, covers = c("prune()", "prune.tna()"),
                   quantity = "weight after removing the lowest 20%", tolerance = 0)
  expect_reference(prune(model, method = "disparity", level = 0.5)$weights, ref_disparity(weights, 0.5),
                   reference = by_definition, covers = c("prune()", "prune.tna()"),
                   quantity = "weight after the disparity filter, level 0.5", tolerance = 0)
  expect_reference(prune(model, method = "disparity", level = 0.1)$weights, ref_disparity(weights, 0.1),
                   reference = by_definition, covers = c("prune()", "prune.tna()"),
                   quantity = "weight after the disparity filter, level 0.1", tolerance = 0)
})

test_that("deprune() restores the weights and reprune() prunes them again", {
  pruned <- prune(model, threshold = 0.05)
  expect_reference(deprune(pruned)$weights, weights, reference = by_definition, covers = c("deprune()", "deprune.tna()"),
                   quantity = "weight after deprune()", tolerance = 0)
  expect_reference(reprune(deprune(pruned))$weights, weights * (weights > 0.05), reference = by_definition,
                   covers = c("reprune()", "reprune.tna()"), quantity = "weight after reprune()", tolerance = 0)
  expect_reference(class(reprune(deprune(pruned)))[[1L]], "tna", reference = by_definition,
                   covers = c("reprune()", "reprune.tna()"), quantity = "class of the model reprune() returns",
                   tolerance = 0)
})

test_that("group models are pruned, depruned and repruned group by group", {
  halves <- rep(c("first", "second"), each = 1000)
  groups <- group_tna(group_regulation, group = halves)
  wide <- ref_wide(group_regulation)
  original <- lapply(split(seq_len(2000L), halves), \(rows) ref_rows(ref_pairs(wide[rows, ])))
  cut <- lapply(original, \(cells) cells * (cells > 0.05))
  pruned <- prune(groups, threshold = 0.05)
  expect_reference(unlist(lapply(pruned, \(group) group$weights)), unlist(cut), reference = by_definition,
                   covers = c("prune()", "prune.group_tna()"), quantity = "weight per group after a threshold of 0.05",
                   tolerance = 0)
  expect_reference(unlist(lapply(deprune(pruned), \(group) group$weights)), unlist(original), reference = by_definition,
                   covers = c("deprune()", "deprune.group_tna()"), quantity = "weight per group after deprune()",
                   tolerance = 0)
  expect_reference(unlist(lapply(reprune(deprune(pruned)), \(group) group$weights)), unlist(cut),
                   reference = by_definition, covers = c("reprune()", "reprune.group_tna()"),
                   quantity = "weight per group after reprune()", tolerance = 0)
})

#' The weight matrix of TraMineR's transition rates of a set of sequences
#'
#' @param data A wide sequence table.
#' @return A square matrix with the states as dimnames.
traminer_rates <- function(data) {
  sequences <- suppressMessages(TraMineR::seqdef(as.data.frame(data)))
  alphabet <- TraMineR::alphabet(sequences)
  `dimnames<-`(suppressMessages(TraMineR::seqtrate(sequences)), list(alphabet, alphabet))
}

#' igraph's graph of a weight matrix with the edges at or below a cut-off deleted, read back as a matrix
#'
#' @param weights A square weight matrix.
#' @param cut_off Edges with a weight at most this are deleted.
#' @return A square matrix.
igraph_cut <- function(weights, cut_off) {
  graph <- igraph::graph_from_adjacency_matrix(weights, mode = "directed", weighted = TRUE, diag = TRUE)
  kept <- igraph::delete_edges(graph, igraph::E(graph)[igraph::E(graph)$weight <= cut_off])
  states <- rownames(weights)
  as.matrix(igraph::as_adjacency_matrix(kept, attr = "weight", sparse = FALSE))[states, states]
}

test_that("pruning, depruning and repruning equal igraph's cut of TraMineR's rates", {
  skip_without_reference(c("TraMineR", "igraph"))
  rates <- traminer_rates(group_regulation)
  pruned <- prune(model, threshold = 0.05)
  expect_reference(pruned$weights, igraph_cut(rates, 0.05), reference = "igraph", covers = c("prune()", "prune.tna()"),
                   quantity = "weight after a threshold of 0.05", tolerance = 1e-12)
  cut_off <- stats::quantile(rates[rates > 0], probs = 0.2)
  expect_reference(prune(model, method = "lowest", lowest = 0.2)$weights, igraph_cut(rates, cut_off), reference = "igraph",
                   covers = c("prune()", "prune.tna()"), quantity = "weight after removing the lowest 20%",
                   tolerance = 1e-12)
  expect_reference(deprune(pruned)$weights, rates, reference = "TraMineR", covers = c("deprune()", "deprune.tna()"),
                   quantity = "weight after deprune()", tolerance = 1e-12)
  removed <- ref_long(rates, "weight")
  removed <- removed[removed$weight > 0 & removed$weight <= 0.05, ]
  expect_reference(pruning_details(pruned), removed, reference = "TraMineR",
                   covers = c("pruning_details()", "pruning_details.tna()"),
                   quantity = "removed edge and its weight, threshold 0.05", tolerance = 1e-12, key = c("from", "to"))
})

test_that("group models are pruned and restored as igraph and TraMineR give each group", {
  skip_without_reference(c("TraMineR", "igraph"))
  halves <- rep(c("first", "second"), each = 1000)
  groups <- group_tna(group_regulation, group = halves)
  rates <- list(first = traminer_rates(group_regulation[1:1000, ]), second = traminer_rates(group_regulation[1001:2000, ]))
  pruned <- prune(groups, threshold = 0.05)
  expect_reference(unlist(lapply(pruned, \(group) group$weights)), unlist(lapply(rates, igraph_cut, 0.05)),
                   reference = "igraph", covers = c("prune()", "prune.group_tna()"),
                   quantity = "weight per group after a threshold of 0.05", tolerance = 1e-12)
  expect_reference(unlist(lapply(deprune(pruned), \(group) group$weights)), unlist(rates), reference = "TraMineR",
                   covers = c("deprune()", "deprune.group_tna()"), quantity = "weight per group after deprune()",
                   tolerance = 1e-12)
  expect_reference(unlist(lapply(reprune(deprune(pruned)), \(group) group$weights)), unlist(lapply(rates, igraph_cut, 0.05)),
                   reference = "igraph", covers = c("reprune()", "reprune.group_tna()"),
                   quantity = "weight per group after reprune()", tolerance = 1e-12)
  # pruning_details() of a group model returns one table of removed edges per group
  details <- do.call(rbind, Map(\(table, group) data.frame(group = group, table), pruning_details(pruned), names(rates)))
  removed <- do.call(rbind, Map(\(cells, group) {
    long <- ref_long(cells, "weight")
    data.frame(group = group, long[long$weight > 0 & long$weight <= 0.05, ])
  }, rates, names(rates)))
  expect_reference(details, removed, reference = "TraMineR", covers = c("pruning_details()", "pruning_details.group_tna()"),
                   quantity = "removed edge and its weight per group, threshold 0.05", tolerance = 1e-12,
                   key = c("group", "from", "to"))
})
