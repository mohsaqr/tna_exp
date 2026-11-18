library(igraph)
sequences <- as.matrix(read.csv("../data/group_regulation.csv", na.strings = ""))
states <- sort(unique(na.omit(c(sequences))))
from <- factor(sequences[, -ncol(sequences)], levels = states)
to <- factor(sequences[, -1], levels = states)
counts <- table(from, to)
weights <- unclass(prop.table(counts, 1))
diag(weights) <- 0
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
