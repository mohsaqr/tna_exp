library(TraMineR)
sequences <- as.matrix(read.csv("../data/group_regulation.csv", na.strings = ""))
state_sequences <- seqdef(as.data.frame(sequences))
distribution <- seqstatd(state_sequences)$Frequencies
result <- data.frame(state = rownames(distribution), initial = distribution[, 1])
result
