library(tna)
model <- ftna(group_regulation)
model
edges <- as.data.frame(as.table(model$weights), responseName = "value")
result <- data.frame(quantity = paste(edges[[1]], "->", edges[[2]]), value = edges$value)
