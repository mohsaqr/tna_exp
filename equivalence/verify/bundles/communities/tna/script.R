library(tna)
model <- tna(group_regulation)
found <- communities(model, methods = c("walktrap", "fast_greedy", "edge_betweenness", "leading_eigen"))
found
result <- found$assignments
