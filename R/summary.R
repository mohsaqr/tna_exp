#' Calculate Summary of Network Metrics for a Transition Network
#'
#' This function calculates a variety of network metrics for a `tna` object.
#' It computes key metrics such as node and edge counts, network density,
#' mean distance, strength measures, degree centrality, and reciprocity.
#'
#' @export
#' @family basic
#' @param object A `tna` object.
#' @param ... Ignored.
#' @details
#' The function extracts the `igraph` network  and
#' computes the following network metrics:
#'
#'   * Node count: Total number of nodes in the network.
#'   * Edge count: Total number of edges in the network.
#'   * Network density: Proportion of possible edges that
#'     are present in the network.
#'   * Mean distance: The average shortest path length between nodes.
#'   * Mean and standard deviation of out-strength and in-strength: Measures
#'     of the total weight of outgoing and incoming edges for each node.
#'   * Mean and standard deviation of out-degree: The number of outgoing
#'     edges from each node.
#'   * Centralization of out-degree and in-degree: Measures of how
#'     centralized the network is based on the degrees of nodes.
#'   * Reciprocity: The proportion of edges that are reciprocated
#'     (i.e., mutual edges between nodes).
#'
#' A summary of the metrics is printed to the console.
#'
#' @return A named `list` containing the following network metrics (invisibly):
#'
#'   * `node_count`: The total number of nodes.
#'   * `edge_count`: The total number of edges.
#'   * `network_Density`: The density of the network.
#'   * `mean_distance`: The mean shortest path length.
#'   * `mean_out_strength`: The mean out-strength of nodes.
#'   * `sd_out_strength`: The standard deviation of out-strength.
#'   * `mean_in_strength`: The mean in-strength of nodes.
#'   * `sd_in_strength`: The standard deviation of in-strength.
#'   * `mean_out_degree`: The mean out-degree of nodes.
#'   * `sd_out_degree`: The standard deviation of out-degree.
#'   * `centralization_out_degree`: The centralization of out-degree.
#'   * `centralization_in_degree`: The centralization of in-degree.
#'   * `reciprocity`: The reciprocity of the network.
#'
#' @examples
#' model <- tna(group_regulation)
#' summary(model)
#'
summary.tna <- function(object, ...) {
  check_missing(object)
  check_class(object, "tna")
  weights <- object$weights
  g <- as.igraph(object)
  in_strength <- igraph::strength(g, mode = "out")
  out_strength <- igraph::strength(g, mode = "in")
  out_degree <- igraph::degree(g, mode = "out")
  cent_out <- igraph::centr_degree(g, mode = "out", loops = FALSE)
  cent_in <- igraph::centr_degree(g, mode = "in", loops = FALSE)
  out <- c(
    node_count = nodes(object),
    edge_count = sum(weights > 0),
    network_density = min(igraph::edge_density(g), 1),
    mean_distance = igraph::mean_distance(g),
    mean_out_strength = mean(out_strength, na.rm = TRUE),
    sd_out_strength = stats::sd(out_strength, na.rm = TRUE),
    mean_in_strength = mean(in_strength, na.rm = TRUE),
    sd_in_strength = stats::sd(in_strength, na.rm = TRUE),
    mean_out_degree = mean(out_degree),
    sd_out_degree = stats::sd(out_degree),
    centralization_out_degree = cent_out$centralization,
    centralization_in_degree = cent_in$centralization,
    reciprocity = igraph::reciprocity(g)
  )
  out_names <- c(
    "Node Count",
    "Edge Count",
    "Network Density",
    "Mean Distance",
    "Mean Out-Strength",
    "SD Out-Strength",
    "Mean In-Strength",
    "SD In-Strength",
    "Mean Out-Degree",
    "SD Out-Degree",
    "Centralization (Out-Degree)",
    "Centralization (In-Degree)",
    "Reciprocity"
  )
  out <- tibble::tibble(metric = out_names, value = unname(out))
  structure(
    out,
    class = c("summary.tna", "tbl_df", "tbl", "data.frame")
  )
}

#' Summarize Bootstrap Results
#'
#' @export
#' @family validation
#' @param object A `tna_bootstrap` object.
#' @param ... Ignored.
#' @return A `summary.tna_bootstrap` object containing the weight,
#' estimated p-value and confidence interval of each edge.
#' @examples
#' model <- tna(group_regulation)
#' # Small number of iterations for CRAN
#' boot <- bootstrap(model, iter = 50)
#' summary(boot)
#'
summary.tna_bootstrap <- function(object, ...) {
  check_missing(object)
  check_class(object, "tna_bootstrap")
  structure(
    object$summary,
    class = c("summary.tna_bootstrap", "data.frame")
  )
}

#' Calculate Summary of Network Metrics for a grouped Transition Network
#'
#' This function calculates a variety of network metrics for a `tna` object.
#' It computes key metrics such as node and edge counts, network density,
#' mean distance, strength measures, degree centrality, and reciprocity.
#'
#' @export
#' @family basic
#' @param object A `group_tna` object.
#' @param combined A logical indicating whether the summary results should be
#' combined into a single data frame for all clusters (defaults to `TRUE`)
#' @param ... Ignored
#' @details
#' The function extracts the `igraph` network for each cluster and
#' computes the following network metrics:
#'
#'   * Node count: Total number of nodes in the network.
#'   * Edge count: Total number of edges in the network.
#'   * Network density: Proportion of possible edges that
#'     are present in the network.
#'   * Mean distance: The average shortest path length between nodes.
#'   * Mean and standard deviation of out-strength and in-strength: Measures
#'     of the total weight of outgoing and incoming edges for each node.
#'   * Mean and standard deviation of out-degree: The number of outgoing
#'     edges from each node.
#'   * Centralization of out-degree and in-degree: Measures of how
#'     centralized the network is based on the degrees of nodes.
#'   * Reciprocity: The proportion of edges that are reciprocated
#'     (i.e., mutual edges between nodes).
#'
#' @return A `summary.group_tna` object which is a `list` of `list`s or a
#' combined `data.frame`  containing the following network metrics:
#'
#'   * `node_count`: The total number of nodes.
#'   * `edge_count`: The total number of edges.
#'   * `network_Density`: The density of the network.
#'   * `mean_distance`: The mean shortest path length.
#'   * `mean_out_strength`: The mean out-strength of nodes.
#'   * `sd_out_strength`: The standard deviation of out-strength.
#'   * `mean_in_strength`: The mean in-strength of nodes.
#'   * `sd_in_strength`: The standard deviation of in-strength.
#'   * `mean_out_degree`: The mean out-degree of nodes.
#'   * `sd_out_degree`: The standard deviation of out-degree.
#'   * `centralization_out_degree`: The centralization of out-degree.
#'   * `centralization_in_degree`: The centralization of in-degree.
#'   * `reciprocity`: The reciprocity of the network.
#'
#' @examples
#' group <- c(rep("High", 1000), rep("Low", 1000))
#' model <- group_model(group_regulation, group = group)
#' summary(model)
#'
summary.group_tna <- function(object, combined = TRUE, ...) {
  check_missing(object)
  check_class(object, "group_tna")
  if (!combined) {
    out <- lapply(object, summary)
    out_class <- "summary.group_tna"
  } else {
    out <- dplyr::bind_rows(
      lapply(object, summary),
      .id = "group"
    ) |>
      tidyr::pivot_wider(names_from = "group", values_from = "value")
    out_class <- c("summary.group_tna", "tbl_df", "tbl", "data.frame")
  }
  structure(
    out,
    class = out_class,
    combined = combined
  )
}

#' Summarize Bootstrap Results for a Grouped Transition Network
#'
#' @export
#' @family validation
#' @param object A `group_tna_bootstrap` object.
#' @param ... Ignored.
#' @return A `summary.group_tna_bootstrap` object containing the weight,
#' estimated p-value and confidence interval of each edge for each cluster.
#' @examples
#' model <- group_tna(engagement_mmm)
#' # Small number of iterations for CRAN
#' boot <- bootstrap(model, iter = 10)
#' summary(boot)
#'
summary.group_tna_bootstrap <- function(object, ...) {
  check_missing(object)
  check_class(object, "group_tna_bootstrap")
  structure(
    dplyr::bind_rows(
      lapply(object, function(x) x$summary),
      .id = "group"
    ),
    class = c("summary.group_tna_bootstrap", "data.frame")
  )
}

#' Summarize Permutation Test Results
#'
#' Returns the edge-level results of a permutation test as a tidy table.
#' The results for the centrality measures are shown by [print()].
#'
#' @export
#' @family validation
#' @param object A `tna_permutation` or a `group_tna_permutation` object.
#' @param digits An `integer`, the number of decimals of `diff_true` and
#'   `effect_size`. The p-values are not rounded. The default is 2.
#' @param ... Ignored.
#' @return A `data.frame` with one row per edge (and per pair of groups, in
#'   the first column `pair`, for a `group_tna_permutation` object) and the
#'   columns `from`, `to`, `diff_true` (the observed difference in the edge
#'   weight), `effect_size` (the difference divided by the standard deviation
#'   of the permuted differences, `NA` when they do not vary), and `p_value`.
#' @examples
#' model <- group_model(engagement_mmm)
#' # Small number of iterations for CRAN
#' perm <- permutation_test(model, iter = 20)
#' summary(perm)
#'
summary.tna_permutation <- function(object, digits = 2L, ...) {
  check_missing(object)
  check_class(object, "tna_permutation")
  check_values(digits)
  diffs <- object$edges$diffs_true
  stats <- object$edges$stats
  # The edges are in column-major order of the weight matrix
  data.frame(
    from = rep(rownames(diffs), times = ncol(diffs)),
    to = rep(colnames(diffs), each = nrow(diffs)),
    diff_true = round(stats$diff_true, digits),
    effect_size = round(stats$effect_size, digits),
    p_value = stats$p_value
  )
}

#' @export
#' @rdname summary.tna_permutation
summary.group_tna_permutation <- function(object, digits = 2L, ...) {
  check_missing(object)
  check_class(object, "group_tna_permutation")
  tables <- Map(
    function(y, pair) {
      data.frame(pair = pair, summary.tna_permutation(y, digits = digits))
    },
    object,
    names(object)
  )
  out <- do.call(rbind, unname(tables))
  rownames(out) <- NULL
  out
}

#' Summarize Case-Dropping Stability Results
#'
#' @export
#' @family validation
#' @param object A `tna_stability` or a `group_tna_stability` object.
#' @param ... Ignored.
#' @return A `data.frame` with one row per centrality measure (and `Edges`,
#'   when the edge weights were assessed), and per group in the first column
#'   `group` for a `group_tna_stability` object, with the columns `measure`
#'   and `cs_coefficient`.
#' @examples
#' # A small subset and few iterations
#' small <- estimate_cs(
#'   tna(group_regulation[1:200, ]),
#'   drop_prop = c(0.3, 0.6),
#'   measures = "InStrength",
#'   iter = 5,
#'   edges = TRUE
#' )
#' summary(small)
#' \donttest{
#' model <- tna(group_regulation)
#' # Small number of iterations and drop proportions for CRAN
#' stability <- estimate_cs(
#'   model,
#'   drop_prop = seq(0.3, 0.9, by = 0.2),
#'   measures = "InStrength",
#'   iter = 10,
#'   edges = TRUE
#' )
#' summary(stability)
#' }
#'
summary.tna_stability <- function(object, ...) {
  check_missing(object)
  check_class(object, "tna_stability")
  # as.character() keeps the column when nothing was estimated
  data.frame(
    measure = as.character(names(object)),
    cs_coefficient = vapply(object, "[[", numeric(1L), "cs_coefficient"),
    row.names = NULL
  )
}

#' @export
#' @rdname summary.tna_stability
summary.group_tna_stability <- function(object, ...) {
  check_missing(object)
  check_class(object, "group_tna_stability")
  tables <- Map(
    function(y, group) {
      table <- summary.tna_stability(y)
      data.frame(group = rep(group, nrow(table)), table)
    },
    object,
    names(object)
  )
  out <- do.call(rbind, unname(tables))
  rownames(out) <- NULL
  out
}
