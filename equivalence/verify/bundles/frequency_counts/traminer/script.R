library(TraMineR)
sequences <- as.matrix(read.csv("../data/group_regulation.csv", na.strings = ""))
state_sequences <- seqdef(as.data.frame(sequences))
weights <- seqtrate(state_sequences, count = TRUE)
dimnames(weights) <- list(alphabet(state_sequences), alphabet(state_sequences))
weights
edges <- as.data.frame(as.table(weights), responseName = "value")
result <- data.frame(quantity = paste(edges[[1]], "->", edges[[2]]), value = edges$value)
