library(tna)
model <- tna(group_regulation)
result <- data.frame(state = model$labels, initial = model$inits)
result
