library(tna)
cooccurrence <- ctna(group_regulation)
attention <- atna(group_regulation)
cooccurrence
attention
edges <- rbind(
  data.frame(model = "ctna", as.data.frame(as.table(cooccurrence$weights), responseName = "value")),
  data.frame(model = "atna", as.data.frame(as.table(attention$weights), responseName = "value"))
)
result <- data.frame(quantity = sprintf("%s: %s -> %s", edges$model, edges[[2]], edges[[3]]), value = edges$value)
