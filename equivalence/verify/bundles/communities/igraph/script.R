library(igraph)
sequences <- as.matrix(read.csv("../data/group_regulation.csv", na.strings = ""))
states <- sort(unique(na.omit(c(sequences))))
from <- factor(sequences[, -ncol(sequences)], levels = states)
to <- factor(sequences[, -1], levels = states)
counts <- table(from, to)
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
