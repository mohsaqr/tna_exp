sequences <- as.matrix(read.csv("../data/group_regulation.csv", na.strings = ""))
states <- sort(unique(na.omit(c(sequences))))
from <- factor(sequences[, -ncol(sequences)], levels = states)
to <- factor(sequences[, -1], levels = states)
counts <- table(from, to)
weights <- counts
weights
edges <- as.data.frame(as.table(weights), responseName = "value")
result <- data.frame(quantity = paste(edges[[1]], "->", edges[[2]]), value = edges$value)
