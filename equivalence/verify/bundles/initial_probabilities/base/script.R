sequences <- as.matrix(read.csv("../data/group_regulation.csv", na.strings = ""))
first <- prop.table(table(sequences[, 1]))
result <- data.frame(state = names(first), initial = as.vector(first))
result
